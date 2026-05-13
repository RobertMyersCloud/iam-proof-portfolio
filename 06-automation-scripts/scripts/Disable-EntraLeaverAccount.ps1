<#
.SYNOPSIS
    Automates the Microsoft Entra ID leaver workflow with audit-ready logging,
    WhatIf safety, protected account guardrails, session revocation, group
    removal, role assignment removal, and post-execution validation.

.DESCRIPTION
    Executes the leaver phase of the Joiner-Mover-Leaver identity lifecycle for
    one or more Microsoft Entra ID users.

    Workflow:
    1. Validate protected account guardrails
    2. Disable account
    3. Validate account disabled state
    4. Revoke sign-in sessions
    5. Remove group memberships
    6. Remove direct directory role assignments
    7. Perform residual access validation
    8. Export CSV and JSON audit evidence

    Designed for IAM governance operations, AC-2 offboarding evidence,
    CMMC / NIST-aligned lifecycle control validation, and ticket-based
    audit traceability.

    Always run with -WhatIf before live execution.

.PARAMETER UserPrincipalName
    One or more user principal names to offboard.

.PARAMETER TicketReference
    Optional change ticket, incident, or service request reference.

.PARAMETER ProtectedAccounts
    UPNs that must never be offboarded, such as break-glass accounts.

.PARAMETER ProtectedRoles
    Directory roles that trigger a protected-user warning if assigned.

.PARAMETER SkipGroupRemoval
    Skip group membership removal while still disabling account and revoking sessions.

.PARAMETER OutputPath
    Path where CSV and JSON execution logs will be written.

.EXAMPLE
    .\Disable-EntraLeaverAccount.ps1 -UserPrincipalName "user@domain.com" -WhatIf

.EXAMPLE
    .\Disable-EntraLeaverAccount.ps1 `
        -UserPrincipalName "user@domain.com" `
        -TicketReference "CHG-2026-0342" `
        -ProtectedAccounts @("breakglass@domain.com")

.NOTES
    Required modules:
        Microsoft.Graph.Users
        Microsoft.Graph.Groups
        Microsoft.Graph.Identity.Governance

    Required permissions:
        User.ReadWrite.All
        GroupMember.ReadWrite.All
        RoleManagement.ReadWrite.Directory

    Author: Robert J. Myers
    Version: 1.2
    Date: 2026-03-24
    Control Mapping: AC-2, AC-2(2), IA-2, AU-2
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param (
    [Parameter(Mandatory = $true)]
    [string[]]$UserPrincipalName,

    [Parameter(Mandatory = $false)]
    [string]$TicketReference = "N/A",

    [Parameter(Mandatory = $false)]
    [string[]]$ProtectedAccounts = @(),

    [Parameter(Mandatory = $false)]
    [string[]]$ProtectedRoles = @(
        "Global Administrator",
        "Privileged Role Administrator",
        "Security Administrator"
    ),

    [Parameter(Mandatory = $false)]
    [switch]$SkipGroupRemoval,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "."
)

# ── Prerequisites ─────────────────────────────────────────────────────────────

$requiredModules = @(
    "Microsoft.Graph.Users",
    "Microsoft.Graph.Groups",
    "Microsoft.Graph.Identity.Governance"
)

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Error "Required module not found: $module. Run: Install-Module $module -Scope CurrentUser"
        exit 1
    }
}

# ── Output Path Validation ────────────────────────────────────────────────────

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

# ── Execution Metadata ────────────────────────────────────────────────────────

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$executionId = [guid]::NewGuid().ToString()
$executionMode = if ($WhatIfPreference) { "Simulation (WhatIf)" } else { "Live Execution" }
$scriptStartTime = Get-Date
$logEntries = @()

Write-Host "`n[EXECUTION ID] $executionId" -ForegroundColor Cyan
Write-Host "[MODE] $executionMode" -ForegroundColor Yellow

if ($WhatIfPreference) {
    Write-Host "[WHATIF] No changes will be made. Review output before live execution.`n" -ForegroundColor Yellow
}

# ── Logging Function ──────────────────────────────────────────────────────────

function Write-Log {
    param(
        [string]$UPN,
        [string]$Action,
        [string]$Status,
        [string]$Severity = "Info",
        [string]$ErrorCode = "",
        [string]$Detail = ""
    )

    $entry = [PSCustomObject]@{
        ExecutionId       = $executionId
        Timestamp         = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        UserPrincipalName = $UPN
        Action            = $Action
        Status            = $Status
        Severity          = $Severity
        ErrorCode         = $ErrorCode
        Detail            = $Detail
        TicketReference   = $TicketReference
        ExecutionMode     = $executionMode
    }

    $script:logEntries += $entry

    $color = switch ($Status) {
        "Success" { "Green" }
        "WhatIf"  { "Yellow" }
        "Skipped" { "Cyan" }
        "Warning" { "Magenta" }
        default   { "Red" }
    }

    Write-Host "  [$Status][$Severity] $Action — $UPN$(if ($Detail) { " — $Detail" })" -ForegroundColor $color
}

# ── Connect to Microsoft Graph ────────────────────────────────────────────────

Write-Host "[INFO] Connecting to Microsoft Graph..." -ForegroundColor Cyan

try {
    Connect-MgGraph -Scopes `
        "User.ReadWrite.All",
        "GroupMember.ReadWrite.All",
        "RoleManagement.ReadWrite.Directory" `
        -NoWelcome

    Write-Host "[INFO] Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# ── Helper: Get Role Assignments ──────────────────────────────────────────────

function Get-UserDirectoryRoleAssignments {
    param(
        [string]$UserId
    )

    try {
        return Get-MgRoleManagementDirectoryRoleAssignment `
            -Filter "principalId eq '$UserId'" `
            -All
    }
    catch {
        return @()
    }
}

# ── Process Users ─────────────────────────────────────────────────────────────

foreach ($upn in $UserPrincipalName) {

    $userStartTime = Get-Date

    Write-Host "`n[INFO] Processing leaver: $upn" -ForegroundColor Cyan
    Write-Host "  Ticket reference : $TicketReference"
    Write-Host "  Execution mode   : $executionMode"

    # Protected UPN guardrail
    if ($ProtectedAccounts -contains $upn) {
        Write-Log `
            -UPN $upn `
            -Action "Protected Account Check" `
            -Status "Skipped" `
            -Severity "Warning" `
            -ErrorCode "PROTECTED_ACCOUNT" `
            -Detail "Protected account — no action taken."

        continue
    }

    # Get user
    try {
        $user = Get-MgUser `
            -UserId $upn `
            -Property "id,displayName,userPrincipalName,accountEnabled" `
            -ErrorAction Stop
    }
    catch {
        Write-Log `
            -UPN $upn `
            -Action "Get User" `
            -Status "Failed" `
            -Severity "Critical" `
            -ErrorCode "USER_NOT_FOUND" `
            -Detail "$_"

        continue
    }

    # Protected role detection
    $roleAssignments = Get-UserDirectoryRoleAssignments -UserId $user.Id

    if ($roleAssignments.Count -gt 0) {
        Write-Log `
            -UPN $upn `
            -Action "Role Assignment Pre-Check" `
            -Status "Warning" `
            -Severity "Warning" `
            -ErrorCode "ROLE_ASSIGNMENTS_DETECTED" `
            -Detail "$($roleAssignments.Count) direct role assignment(s) detected. Review before live execution."
    }

    if (-not $user.AccountEnabled) {
        Write-Log `
            -UPN $upn `
            -Action "Pre-Check" `
            -Status "Skipped" `
            -Severity "Info" `
            -ErrorCode "ACCOUNT_ALREADY_DISABLED" `
            -Detail "Account already disabled — continuing session, group, and role cleanup."
    }

    # Step 1: Disable Account
    if ($PSCmdlet.ShouldProcess($upn, "Disable Entra ID account")) {
        try {
            Update-MgUser -UserId $user.Id -AccountEnabled:$false

            Write-Log `
                -UPN $upn `
                -Action "Disable Account" `
                -Status "Success" `
                -Severity "Info" `
                -Detail "Account disabled — authentication blocked."
        }
        catch {
            Write-Log `
                -UPN $upn `
                -Action "Disable Account" `
                -Status "Failed" `
                -Severity "Critical" `
                -ErrorCode "DISABLE_ACCOUNT_FAILED" `
                -Detail "$_"
        }
    }
    else {
        Write-Log `
            -UPN $upn `
            -Action "Disable Account" `
            -Status "WhatIf" `
            -Severity "Info" `
            -Detail "Would disable account and block authentication."
    }

    # Step 1a: Validate Disabled State
    if (-not $WhatIfPreference) {
        try {
            $updatedUser = Get-MgUser -UserId $user.Id -Property "accountEnabled"

            if (-not $updatedUser.AccountEnabled) {
                Write-Log `
                    -UPN $upn `
                    -Action "Validate Disabled State" `
                    -Status "Success" `
                    -Severity "Info" `
                    -Detail "Account confirmed disabled."
            }
            else {
                Write-Log `
                    -UPN $upn `
                    -Action "Validate Disabled State" `
                    -Status "Failed" `
                    -Severity "Critical" `
                    -ErrorCode "ACCOUNT_STILL_ENABLED" `
                    -Detail "Account still enabled after disable attempt."
            }
        }
        catch {
            Write-Log `
                -UPN $upn `
                -Action "Validate Disabled State" `
                -Status "Failed" `
                -Severity "Critical" `
                -ErrorCode "VALIDATION_FAILED" `
                -Detail "$_"
        }
    }

    # Step 2: Revoke Sessions
    if ($PSCmdlet.ShouldProcess($upn, "Revoke all sign-in sessions")) {
        try {
            Revoke-MgUserSignInSession -UserId $user.Id

            Write-Log `
                -UPN $upn `
                -Action "Revoke Sessions" `
                -Status "Success" `
                -Severity "Info" `
                -Detail "All sign-in sessions and refresh tokens revoked."
        }
        catch {
            Write-Log `
                -UPN $upn `
                -Action "Revoke Sessions" `
                -Status "Failed" `
                -Severity "Critical" `
                -ErrorCode "SESSION_REVOCATION_FAILED" `
                -Detail "$_"
        }
    }
    else {
        Write-Log `
            -UPN $upn `
            -Action "Revoke Sessions" `
            -Status "WhatIf" `
            -Severity "Info" `
            -Detail "Would revoke all sign-in sessions and refresh tokens."
    }

    # Step 3: Remove Group Memberships
    if (-not $SkipGroupRemoval) {
        try {
            $memberships = Get-MgUserMemberOf -UserId $user.Id -All |
                Where-Object { $_."@odata.type" -eq "#microsoft.graph.group" }

            if ($memberships.Count -eq 0) {
                Write-Log `
                    -UPN $upn `
                    -Action "Group Removal" `
                    -Status "Skipped" `
                    -Severity "Info" `
                    -Detail "No group memberships found."
            }
            else {
                foreach ($group in $memberships) {
                    $groupName = $group.AdditionalProperties["displayName"]

                    if ($PSCmdlet.ShouldProcess($upn, "Remove from group: $groupName")) {
                        try {
                            Remove-MgGroupMemberByRef `
                                -GroupId $group.Id `
                                -DirectoryObjectId $user.Id

                            Write-Log `
                                -UPN $upn `
                                -Action "Remove Group" `
                                -Status "Success" `
                                -Severity "Info" `
                                -Detail "Removed from group: $groupName"
                        }
                        catch {
                            Write-Log `
                                -UPN $upn `
                                -Action "Remove Group" `
                                -Status "Failed" `
                                -Severity "Warning" `
                                -ErrorCode "GROUP_REMOVE_FAILED" `
                                -Detail "Group: $groupName — $_"
                        }
                    }
                    else {
                        Write-Log `
                            -UPN $upn `
                            -Action "Remove Group" `
                            -Status "WhatIf" `
                            -Severity "Info" `
                            -Detail "Would remove from group: $groupName"
                    }
                }
            }
        }
        catch {
            Write-Log `
                -UPN $upn `
                -Action "Get Groups" `
                -Status "Failed" `
                -Severity "Warning" `
                -ErrorCode "GET_GROUPS_FAILED" `
                -Detail "$_"
        }
    }
    else {
        Write-Log `
            -UPN $upn `
            -Action "Group Removal" `
            -Status "Skipped" `
            -Severity "Info" `
            -Detail "-SkipGroupRemoval specified."
    }

    # Step 4: Remove Direct Role Assignments
    try {
        $roleAssignments = Get-UserDirectoryRoleAssignments -UserId $user.Id

        if ($roleAssignments.Count -eq 0) {
            Write-Log `
                -UPN $upn `
                -Action "Role Assignment Removal" `
                -Status "Skipped" `
                -Severity "Info" `
                -Detail "No direct role assignments found."
        }
        else {
            foreach ($role in $roleAssignments) {
                $roleId = $role.RoleDefinitionId

                if ($PSCmdlet.ShouldProcess($upn, "Remove role assignment: $roleId")) {
                    try {
                        Remove-MgRoleManagementDirectoryRoleAssignment `
                            -UnifiedRoleAssignmentId $role.Id

                        Write-Log `
                            -UPN $upn `
                            -Action "Remove Role Assignment" `
                            -Status "Success" `
                            -Severity "Info" `
                            -Detail "Removed role assignment: $roleId"
                    }
                    catch {
                        Write-Log `
                            -UPN $upn `
                            -Action "Remove Role Assignment" `
                            -Status "Failed" `
                            -Severity "Warning" `
                            -ErrorCode "ROLE_REMOVE_FAILED" `
                            -Detail "Role: $roleId — $_"
                    }
                }
                else {
                    Write-Log `
                        -UPN $upn `
                        -Action "Remove Role Assignment" `
                        -Status "WhatIf" `
                        -Severity "Info" `
                        -Detail "Would remove role assignment: $roleId"
                }
            }
        }
    }
    catch {
        Write-Log `
            -UPN $upn `
            -Action "Get Role Assignments" `
            -Status "Failed" `
            -Severity "Warning" `
            -ErrorCode "GET_ROLE_ASSIGNMENTS_FAILED" `
            -Detail "$_"
    }

    # Step 5: Post-Execution Residual Access Validation
    if (-not $WhatIfPreference) {
        try {
            $remainingGroups = Get-MgUserMemberOf -UserId $user.Id -All |
                Where-Object { $_."@odata.type" -eq "#microsoft.graph.group" }

            $remainingRoles = Get-UserDirectoryRoleAssignments -UserId $user.Id

            $residualAccess = ($remainingGroups.Count -gt 0 -or $remainingRoles.Count -gt 0)

            if ($residualAccess) {
                Write-Log `
                    -UPN $upn `
                    -Action "Residual Access Validation" `
                    -Status "Warning" `
                    -Severity "Warning" `
                    -ErrorCode "RESIDUAL_ACCESS_REMAINS" `
                    -Detail "Remaining groups: $($remainingGroups.Count); remaining role assignments: $($remainingRoles.Count)"
            }
            else {
                Write-Log `
                    -UPN $upn `
                    -Action "Residual Access Validation" `
                    -Status "Success" `
                    -Severity "Info" `
                    -Detail "No remaining group memberships or direct role assignments detected."
            }
        }
        catch {
            Write-Log `
                -UPN $upn `
                -Action "Residual Access Validation" `
                -Status "Failed" `
                -Severity "Warning" `
                -ErrorCode "RESIDUAL_VALIDATION_FAILED" `
                -Detail "$_"
        }
    }

    $userDuration = [math]::Round(((Get-Date) - $userStartTime).TotalSeconds, 2)

    Write-Log `
        -UPN $upn `
        -Action "User Workflow Complete" `
        -Status "Success" `
        -Severity "Info" `
        -Detail "Workflow completed in $userDuration seconds."

    Write-Host "  [COMPLETE] Leaver workflow finished for: $upn" -ForegroundColor Cyan
}

# ── Export Logs ───────────────────────────────────────────────────────────────

$logFile = Join-Path $OutputPath "leaver-execution-log-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "leaver-execution-log-$timestamp.json"

$logEntries | Export-Csv -Path $logFile -NoTypeInformation -Encoding UTF8
$logEntries | ConvertTo-Json -Depth 5 | Out-File $jsonFile -Encoding UTF8

# ── Summary Metrics ──────────────────────────────────────────────────────────

$successCount = ($logEntries | Where-Object { $_.Status -eq "Success" }).Count
$failedCount = ($logEntries | Where-Object { $_.Status -eq "Failed" }).Count
$skippedCount = ($logEntries | Where-Object { $_.Status -eq "Skipped" }).Count
$warningCount = ($logEntries | Where-Object { $_.Status -eq "Warning" }).Count
$whatIfCount = ($logEntries | Where-Object { $_.Status -eq "WhatIf" }).Count
$totalDuration = [math]::Round(((Get-Date) - $scriptStartTime).TotalSeconds, 2)

Write-Host "`n[SUMMARY] Leaver Workflow Execution" -ForegroundColor Yellow
Write-Host "  Execution ID    : $executionId"
Write-Host "  Execution mode  : $executionMode"
Write-Host "  Users processed : $($UserPrincipalName.Count)"
Write-Host "  Actions success : $successCount" -ForegroundColor Green
Write-Host "  Actions skipped : $skippedCount" -ForegroundColor Cyan
Write-Host "  Actions warning : $warningCount" -ForegroundColor Magenta
Write-Host "  Actions failed  : $failedCount" -ForegroundColor Red
Write-Host "  WhatIf previewed: $whatIfCount" -ForegroundColor Yellow
Write-Host "  Ticket ref      : $TicketReference"
Write-Host "  Duration sec    : $totalDuration"
Write-Host "`n[INFO] CSV log : $logFile" -ForegroundColor Green
Write-Host "[INFO] JSON log: $jsonFile" -ForegroundColor Green

if ($failedCount -gt 0) {
    Write-Host "`n[WARNING] Failed actions detected — review logs before closing ticket." -ForegroundColor Red
}

if ($WhatIfPreference) {
    Write-Host "`n[WHATIF] Simulation complete. No changes were made." -ForegroundColor Yellow
    Write-Host "[WHATIF] Re-run without -WhatIf to execute." -ForegroundColor Yellow
}

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
