<#
.SYNOPSIS
    Automates the Entra ID leaver workflow — disabling accounts, revoking
    sessions, removing group memberships, and removing role assignments for
    offboarding users.

.DESCRIPTION
    Executes the leaver phase of the JML identity lifecycle for one or more
    users in Microsoft Entra ID. Performs account disablement, sign-in session
    revocation, group membership removal, and role assignment removal in a
    controlled, logged sequence with post-action validation.

    Supports WhatIf mode for safe pre-execution review, protected account
    guardrails to prevent accidental offboarding of break-glass or admin
    accounts, optional ticket/reference field for audit traceability, and
    produces a detailed timestamped execution log.

    Output is designed for direct use as AC-2 leaver lifecycle evidence and
    supports JML offboarding audit workflows.

    ⚠️  DESTRUCTIVE OPERATION — always run with -WhatIf first.

.PARAMETER UserPrincipalName
    UPN of the user to offboard. Accepts single value or array.

.PARAMETER TicketReference
    Optional change ticket or incident reference number for audit logging.

.PARAMETER ProtectedAccounts
    Array of UPNs that must never be offboarded (break-glass, emergency admins).
    Script will skip and log these accounts without taking action.

.PARAMETER WhatIf
    Simulates all actions without making changes. Always run this first.

.PARAMETER SkipGroupRemoval
    Switch to skip group membership removal. Other steps still execute.

.PARAMETER OutputPath
    Path for execution log. Defaults to current directory.

.EXAMPLE
    # ALWAYS run WhatIf first
    .\Disable-EntraLeaverAccount.ps1 -UserPrincipalName "jml.test@rjmyers.cloud" -WhatIf

    # Execute with ticket reference
    .\Disable-EntraLeaverAccount.ps1 -UserPrincipalName "jml.test@rjmyers.cloud" -TicketReference "CHG-2026-0342"

    # Offboard multiple users with protected account guardrail
    .\Disable-EntraLeaverAccount.ps1 `
        -UserPrincipalName @("user1@domain.com","user2@domain.com") `
        -TicketReference "CHG-2026-0343" `
        -ProtectedAccounts @("breakglass@domain.com")

.NOTES
    Required modules: Microsoft.Graph.Users, Microsoft.Graph.Groups,
                      Microsoft.Graph.Identity.Governance
    Required permissions: User.ReadWrite.All, GroupMember.ReadWrite.All,
                          RoleManagement.ReadWrite.Directory
    Author: Robert J. Myers
    Version: 1.1
    Date: 2026-03-24
    Control mapping: AC-2, AC-2(2), IA-2
    ⚠️  Run with -WhatIf before executing in production.
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
        Write-Error "Required module not found: $module. Run: Install-Module $module"
        exit 1
    }
}

# ── Output Path Validation ────────────────────────────────────────────────────

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

# ── Execution Mode ────────────────────────────────────────────────────────────

$executionMode = if ($WhatIfPreference) { "Simulation (WhatIf)" } else { "Live Execution" }
Write-Host "`n[MODE] $executionMode" -ForegroundColor Yellow

if ($WhatIfPreference) {
    Write-Host "[WHATIF] No changes will be made. Review output then re-run without -WhatIf.`n" -ForegroundColor Yellow
}

# ── Connect ───────────────────────────────────────────────────────────────────

Write-Host "[INFO] Connecting to Microsoft Graph..." -ForegroundColor Cyan
try {
    Connect-MgGraph -Scopes "User.ReadWrite.All", "GroupMember.ReadWrite.All", "RoleManagement.ReadWrite.Directory" -NoWelcome
    Write-Host "[INFO] Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# ── Execution Log ─────────────────────────────────────────────────────────────

$timestamp  = Get-Date -Format "yyyyMMdd-HHmmss"
$logEntries = @()

function Write-Log {
    param($UPN, $Action, $Status, $Detail = "")
    $entry = [PSCustomObject]@{
        Timestamp         = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        UserPrincipalName = $UPN
        Action            = $Action
        Status            = $Status
        Detail            = $Detail
        TicketReference   = $TicketReference
        ExecutionMode     = $executionMode
    }
    $script:logEntries += $entry
    $color = switch ($Status) {
        "Success" { "Green" }
        "WhatIf"  { "Yellow" }
        "Skipped" { "Cyan" }
        default   { "Red" }
    }
    Write-Host "  [$Status] $Action — $UPN$(if ($Detail) { " — $Detail" })" -ForegroundColor $color
}

# ── Process Each User ─────────────────────────────────────────────────────────

foreach ($upn in $UserPrincipalName) {

    Write-Host "`n[INFO] Processing leaver: $upn" -ForegroundColor Cyan
    Write-Host "  Ticket reference : $TicketReference"
    Write-Host "  Execution mode   : $executionMode"

    # ── Protected Account Check ───────────────────────────────────────────────
    if ($ProtectedAccounts -contains $upn) {
        Write-Log -UPN $upn -Action "Pre-check" -Status "Skipped" `
            -Detail "Protected account — no action taken. Remove from ProtectedAccounts if offboarding is intentional."
        continue
    }

    # ── Get User ──────────────────────────────────────────────────────────────
    try {
        $user = Get-MgUser -UserId $upn `
            -Property "id,displayName,userPrincipalName,accountEnabled" `
            -ErrorAction Stop
    }
    catch {
        Write-Log -UPN $upn -Action "Get User" -Status "Failed" -Detail "User not found: $_"
        continue
    }

    if (-not $user.AccountEnabled) {
        Write-Log -UPN $upn -Action "Pre-check" -Status "Skipped" -Detail "Account already disabled — sessions and groups will still be processed"
    }

    # ── Step 1: Disable Account ───────────────────────────────────────────────
    if ($PSCmdlet.ShouldProcess($upn, "Disable Entra ID account")) {
        try {
            Update-MgUser -UserId $user.Id -AccountEnabled $false
            Write-Log -UPN $upn -Action "Disable Account" -Status "Success" `
                -Detail "Account disabled — authentication blocked"
        }
        catch {
            Write-Log -UPN $upn -Action "Disable Account" -Status "Failed" -Detail $_
        }
    }
    else {
        Write-Log -UPN $upn -Action "Disable Account" -Status "WhatIf" `
            -Detail "Would disable account and block all authentication"
    }

    # ── Step 1a: Validate Account State ──────────────────────────────────────
    if (-not $WhatIfPreference) {
        try {
            $updatedUser = Get-MgUser -UserId $user.Id -Property "accountEnabled"
            if (-not $updatedUser.AccountEnabled) {
                Write-Log -UPN $upn -Action "Validation" -Status "Success" `
                    -Detail "Account confirmed disabled"
            }
            else {
                Write-Log -UPN $upn -Action "Validation" -Status "Failed" `
                    -Detail "Account still enabled after disable attempt — investigate immediately"
            }
        }
        catch {
            Write-Log -UPN $upn -Action "Validation" -Status "Failed" -Detail $_
        }
    }

    # ── Step 2: Revoke Sessions ───────────────────────────────────────────────
    if ($PSCmdlet.ShouldProcess($upn, "Revoke all sign-in sessions")) {
        try {
            Revoke-MgUserSignInSession -UserId $user.Id
            Write-Log -UPN $upn -Action "Revoke Sessions" -Status "Success" `
                -Detail "All sign-in sessions and refresh tokens revoked"
        }
        catch {
            Write-Log -UPN $upn -Action "Revoke Sessions" -Status "Failed" -Detail $_
        }
    }
    else {
        Write-Log -UPN $upn -Action "Revoke Sessions" -Status "WhatIf" `
            -Detail "Would revoke all sign-in sessions and refresh tokens"
    }

    # ── Step 3: Remove Group Memberships ──────────────────────────────────────
    if (-not $SkipGroupRemoval) {
        try {
            $memberships = Get-MgUserMemberOf -UserId $user.Id -All |
                Where-Object { $_."@odata.type" -eq "#microsoft.graph.group" }

            if ($memberships.Count -eq 0) {
                Write-Log -UPN $upn -Action "Group Removal" -Status "Skipped" `
                    -Detail "No group memberships found"
            }
            else {
                foreach ($group in $memberships) {
                    $groupName = $group.AdditionalProperties["displayName"]
                    if ($PSCmdlet.ShouldProcess($upn, "Remove from group: $groupName")) {
                        try {
                            Remove-MgGroupMemberByRef -GroupId $group.Id -DirectoryObjectId $user.Id
                            Write-Log -UPN $upn -Action "Remove Group" -Status "Success" `
                                -Detail "Removed from: $groupName"
                        }
                        catch {
                            Write-Log -UPN $upn -Action "Remove Group" -Status "Failed" `
                                -Detail "Group: $groupName — $_"
                        }
                    }
                    else {
                        Write-Log -UPN $upn -Action "Remove Group" -Status "WhatIf" `
                            -Detail "Would remove from: $groupName"
                    }
                }
            }
        }
        catch {
            Write-Log -UPN $upn -Action "Get Groups" -Status "Failed" -Detail $_
        }
    }
    else {
        Write-Log -UPN $upn -Action "Group Removal" -Status "Skipped" `
            -Detail "-SkipGroupRemoval specified"
    }

    # ── Step 4: Remove Role Assignments ──────────────────────────────────────
    try {
        $roleAssignments = Get-MgRoleManagementDirectoryRoleAssignment `
            -Filter "principalId eq '$($user.Id)'" -All

        if ($roleAssignments.Count -eq 0) {
            Write-Log -UPN $upn -Action "Role Assignment Removal" -Status "Skipped" `
                -Detail "No direct role assignments found"
        }
        else {
            foreach ($role in $roleAssignments) {
                $roleName = $role.RoleDefinitionId
                if ($PSCmdlet.ShouldProcess($upn, "Remove role assignment: $roleName")) {
                    try {
                        Remove-MgRoleManagementDirectoryRoleAssignment `
                            -UnifiedRoleAssignmentId $role.Id
                        Write-Log -UPN $upn -Action "Remove Role Assignment" -Status "Success" `
                            -Detail "Removed role: $roleName"
                    }
                    catch {
                        Write-Log -UPN $upn -Action "Remove Role Assignment" -Status "Failed" `
                            -Detail "Role: $roleName — $_"
                    }
                }
                else {
                    Write-Log -UPN $upn -Action "Remove Role Assignment" -Status "WhatIf" `
                        -Detail "Would remove role: $roleName"
                }
            }
        }
    }
    catch {
        Write-Log -UPN $upn -Action "Get Role Assignments" -Status "Failed" -Detail $_
    }

    Write-Host "  [COMPLETE] Leaver workflow finished for: $upn" -ForegroundColor Cyan
}

# ── Export Log ────────────────────────────────────────────────────────────────

$logFile  = Join-Path $OutputPath "leaver-execution-log-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "leaver-execution-log-$timestamp.json"

$logEntries | Export-Csv -Path $logFile -NoTypeInformation -Encoding UTF8
$logEntries | ConvertTo-Json -Depth 3 | Out-File $jsonFile -Encoding UTF8

# ── Summary ───────────────────────────────────────────────────────────────────

$successCount = ($logEntries | Where-Object { $_.Status -eq "Success" }).Count
$failedCount  = ($logEntries | Where-Object { $_.Status -eq "Failed" }).Count
$skippedCount = ($logEntries | Where-Object { $_.Status -eq "Skipped" }).Count
$whatifCount  = ($logEntries | Where-Object { $_.Status -eq "WhatIf" }).Count

Write-Host "`n[SUMMARY] Leaver Workflow Execution:" -ForegroundColor Yellow
Write-Host "  Execution mode  : $executionMode"
Write-Host "  Users processed : $($UserPrincipalName.Count)"
Write-Host "  Actions success : $successCount" -ForegroundColor Green
Write-Host "  Actions skipped : $skippedCount" -ForegroundColor Cyan
Write-Host "  Actions failed  : $failedCount"  -ForegroundColor Red
if ($whatifCount -gt 0) {
    Write-Host "  WhatIf previewed: $whatifCount (no changes made)" -ForegroundColor Yellow
}
Write-Host "  Ticket ref      : $TicketReference"
Write-Host "`n[INFO] Execution log: $logFile"  -ForegroundColor Green
Write-Host "[INFO] JSON log:       $jsonFile"  -ForegroundColor Green

if ($failedCount -gt 0) {
    Write-Host "`n[WARNING] $failedCount action(s) failed — review log before closing ticket." -ForegroundColor Red
}

if ($WhatIfPreference) {
    Write-Host "`n[WHATIF] Simulation complete. No changes were made." -ForegroundColor Yellow
    Write-Host "[WHATIF] Re-run without -WhatIf to execute." -ForegroundColor Yellow
}

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
