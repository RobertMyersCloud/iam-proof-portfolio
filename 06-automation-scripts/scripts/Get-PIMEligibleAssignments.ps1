<#
.SYNOPSIS
    Exports and analyzes Microsoft Entra ID Privileged Identity Management (PIM)
    eligible role assignments for privileged access governance, least privilege
    validation, and audit-ready evidence production.

.DESCRIPTION
    Retrieves PIM eligible role assignments from Microsoft Entra ID and exports
    role eligibility details to CSV and JSON.

    Supports:
    - privileged role eligibility reporting
    - permanent eligibility detection
    - high-risk role classification
    - multi-role privilege aggregation detection
    - assignment age analysis
    - governance risk scoring
    - review-required flagging
    - execution ID for audit correlation

    Output supports AC-2, AC-6, AC-6(5), IA-2, AU-2, privileged access reviews,
    CMMC / NIST-aligned governance workflows, and PIM posture assessment.

.PARAMETER OutputPath
    Path for output files. Defaults to current directory.

.PARAMETER RoleName
    Optional role name filter. If omitted, all eligible assignments are exported.

.PARAMETER PermanentOnly
    Returns only permanent eligible assignments with no expiration.

.EXAMPLE
    .\Get-PIMEligibleAssignments.ps1

.EXAMPLE
    .\Get-PIMEligibleAssignments.ps1 -RoleName "Security Reader"

.EXAMPLE
    .\Get-PIMEligibleAssignments.ps1 -PermanentOnly

.EXAMPLE
    .\Get-PIMEligibleAssignments.ps1 -OutputPath "C:\AuditEvidence"

.NOTES
    Required modules:
        Microsoft.Graph.Identity.Governance

    Required permissions:
        RoleEligibilitySchedule.Read.Directory
        RoleManagement.Read.Directory
        User.Read.All

    Author: Robert J. Myers
    Version: 1.2
    Date: 2026-03-24
    Control Mapping: AC-2, AC-6, AC-6(5), IA-2, AU-2
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ".",

    [Parameter(Mandatory = $false)]
    [string]$RoleName,

    [Parameter(Mandatory = $false)]
    [switch]$PermanentOnly
)

# ── Prerequisites ─────────────────────────────────────────────────────────────

$requiredModules = @(
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
    Write-Host "[INFO] Created output directory: $OutputPath" -ForegroundColor Cyan
}

# ── Execution Metadata ────────────────────────────────────────────────────────

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$executionId = [guid]::NewGuid().ToString()
$scriptStartTime = Get-Date
$results = @()

Write-Host "`n[EXECUTION ID] $executionId" -ForegroundColor Cyan
Write-Host "[INFO] PIM eligible assignment governance export started." -ForegroundColor Cyan

# ── Connect to Microsoft Graph ────────────────────────────────────────────────

Write-Host "[INFO] Connecting to Microsoft Graph..." -ForegroundColor Cyan

try {
    Connect-MgGraph -Scopes `
        "RoleEligibilitySchedule.Read.Directory",
        "RoleManagement.Read.Directory",
        "User.Read.All" `
        -NoWelcome

    Write-Host "[INFO] Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# ── Governance Reference Data ─────────────────────────────────────────────────

$criticalRoles = @(
    "Global Administrator",
    "Privileged Role Administrator",
    "Security Administrator",
    "Conditional Access Administrator"
)

$highRiskRoles = @(
    "User Administrator",
    "Application Administrator",
    "Cloud Application Administrator",
    "Exchange Administrator",
    "SharePoint Administrator",
    "Intune Administrator",
    "Authentication Administrator",
    "Privileged Authentication Administrator",
    "Helpdesk Administrator"
)

$standardPrivilegedRoles = @(
    "Security Reader",
    "Reports Reader",
    "Global Reader"
)

# ── Helper Functions ──────────────────────────────────────────────────────────

function Convert-ToSafeString {
    param(
        [object]$Value,
        [string]$Default = "None"
    )

    if ($null -eq $Value) {
        return $Default
    }

    if ([string]::IsNullOrWhiteSpace([string]$Value)) {
        return $Default
    }

    return [string]$Value
}

function Get-GovernanceRisk {
    param(
        [string]$RoleName,
        [bool]$IsPermanent,
        [int]$DaysEligible
    )

    if ($RoleName -in $criticalRoles -and $IsPermanent) {
        return "Critical"
    }

    if ($RoleName -in $criticalRoles) {
        return "High"
    }

    if ($RoleName -in $highRiskRoles -and $IsPermanent) {
        return "High"
    }

    if ($RoleName -in $highRiskRoles) {
        return "Medium"
    }

    if ($IsPermanent) {
        return "Medium"
    }

    if ($DaysEligible -ge 180) {
        return "Medium"
    }

    return "Low"
}

function Get-ReviewReason {
    param(
        [string]$GovernanceRisk,
        [string]$RoleName,
        [bool]$IsPermanent,
        [bool]$MultiRoleEligible,
        [int]$DaysEligible
    )

    $reasons = @()

    if ($GovernanceRisk -eq "Critical") {
        $reasons += "Critical privileged role with permanent eligibility"
    }

    if ($RoleName -in $criticalRoles) {
        $reasons += "Critical administrative role"
    }

    if ($RoleName -in $highRiskRoles) {
        $reasons += "High-risk administrative role"
    }

    if ($IsPermanent) {
        $reasons += "Permanent eligible assignment"
    }

    if ($MultiRoleEligible) {
        $reasons += "Principal has multiple eligible privileged roles"
    }

    if ($DaysEligible -ge 180) {
        $reasons += "Long-running eligibility assignment"
    }

    if ($reasons.Count -eq 0) {
        return "Standard eligible assignment"
    }

    return ($reasons -join "; ")
}

# ── Retrieve PIM Eligible Assignments ─────────────────────────────────────────

Write-Host "[INFO] Retrieving PIM eligible role assignments..." -ForegroundColor Cyan

try {
    $assignments = Get-MgRoleManagementDirectoryRoleEligibilitySchedule `
        -All `
        -ExpandProperty "principal,roleDefinition"

    Write-Host "[INFO] Retrieved $($assignments.Count) eligible assignments." -ForegroundColor Cyan

    foreach ($assignment in $assignments) {

        $assignmentRoleName = Convert-ToSafeString $assignment.RoleDefinition.DisplayName "Unknown Role"

        if ($RoleName -and $assignmentRoleName -ne $RoleName) {
            continue
        }

        $expiration = $assignment.ScheduleInfo.Expiration
        $isPermanent = $true

        if ($expiration -and $expiration.EndDateTime) {
            $isPermanent = $false
        }

        if ($PermanentOnly -and -not $isPermanent) {
            continue
        }

        $startDate = $assignment.ScheduleInfo.StartDateTime
        $daysEligible = 0

        if ($startDate) {
            $daysEligible = [int]((Get-Date) - $startDate).TotalDays
        }

        $expiresOn = if ($isPermanent) {
            "Permanent"
        }
        else {
            $expiration.EndDateTime
        }

        $principalType = Convert-ToSafeString $assignment.Principal.AdditionalProperties["@odata.type"] "Unknown"
        $principalName = Convert-ToSafeString $assignment.Principal.AdditionalProperties["displayName"] "Unknown Principal"

        if ($principalType -eq "#microsoft.graph.user") {
            $principalUPN = Convert-ToSafeString $assignment.Principal.AdditionalProperties["userPrincipalName"] "UnknownUPN"
        }
        else {
            $principalUPN = "N/A"
        }

        $governanceRisk = Get-GovernanceRisk `
            -RoleName $assignmentRoleName `
            -IsPermanent $isPermanent `
            -DaysEligible $daysEligible

        $reviewRequired = if ($governanceRisk -in @("Critical", "High", "Medium")) {
            $true
        }
        else {
            $false
        }

        $activationModel = if ($isPermanent) {
            "Standing Eligible"
        }
        else {
            "Time-Bound Eligible"
        }

        $results += [PSCustomObject]@{
            ExecutionId        = $executionId
            ExportDate         = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            PrincipalName      = $principalName
            PrincipalUPN       = $principalUPN
            PrincipalType      = $principalType
            RoleName           = $assignmentRoleName
            RoleId             = $assignment.RoleDefinitionId
            AssignmentId       = $assignment.Id
            AssignmentType     = "Eligible"
            ActivationModel    = $activationModel
            IsPermanent        = $isPermanent
            StartDateTime      = $startDate
            ExpiresOn          = $expiresOn
            DaysEligible       = $daysEligible
            DirectoryScopeId   = $assignment.DirectoryScopeId
            GovernanceRisk     = $governanceRisk
            ReviewRequired     = $reviewRequired
            ReviewReason       = ""
            MultiRoleEligible  = $false
            EvidenceUse        = "AC-6(5) privileged access governance evidence"
        }
    }
}
catch {
    Write-Error "Error retrieving PIM assignments: $_"
    Disconnect-MgGraph | Out-Null
    exit 1
}

# ── Multi-Role Privilege Aggregation Detection ────────────────────────────────

$multiRolePrincipals = $results |
    Where-Object { $_.PrincipalUPN -ne "N/A" } |
    Group-Object PrincipalUPN |
    Where-Object { $_.Count -gt 1 }

foreach ($principalGroup in $multiRolePrincipals) {
    foreach ($entry in $results | Where-Object { $_.PrincipalUPN -eq $principalGroup.Name }) {
        $entry.MultiRoleEligible = $true

        if ($entry.GovernanceRisk -eq "Low") {
            $entry.GovernanceRisk = "Medium"
            $entry.ReviewRequired = $true
        }
    }
}

# ── Populate Review Reasons After Multi-Role Analysis ────────────────────────

foreach ($entry in $results) {
    $entry.ReviewReason = Get-ReviewReason `
        -GovernanceRisk $entry.GovernanceRisk `
        -RoleName $entry.RoleName `
        -IsPermanent $entry.IsPermanent `
        -MultiRoleEligible $entry.MultiRoleEligible `
        -DaysEligible $entry.DaysEligible
}

# ── Sort by Governance Risk ──────────────────────────────────────────────────

$results = $results | Sort-Object `
    @{ Expression = {
        switch ($_.GovernanceRisk) {
            "Critical" { 1 }
            "High"     { 2 }
            "Medium"   { 3 }
            "Low"      { 4 }
            default    { 5 }
        }
    }},
    DaysEligible -Descending,
    RoleName,
    PrincipalName

# ── Export Results ────────────────────────────────────────────────────────────

$csvFile = Join-Path $OutputPath "pim-eligible-assignments-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "pim-eligible-assignments-$timestamp.json"

$results | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$results | ConvertTo-Json -Depth 6 | Out-File $jsonFile -Encoding UTF8

# ── Summary Metrics ──────────────────────────────────────────────────────────

$totalCount = $results.Count
$criticalCount = ($results | Where-Object { $_.GovernanceRisk -eq "Critical" }).Count
$highCount = ($results | Where-Object { $_.GovernanceRisk -eq "High" }).Count
$mediumCount = ($results | Where-Object { $_.GovernanceRisk -eq "Medium" }).Count
$lowCount = ($results | Where-Object { $_.GovernanceRisk -eq "Low" }).Count
$permanentCount = ($results | Where-Object { $_.IsPermanent -eq $true }).Count
$reviewCount = ($results | Where-Object { $_.ReviewRequired -eq $true }).Count
$multiRoleCount = ($results | Where-Object { $_.MultiRoleEligible -eq $true } | Select-Object -Unique PrincipalUPN).Count
$totalDuration = [math]::Round(((Get-Date) - $scriptStartTime).TotalSeconds, 2)

$roleSummary = $results |
    Group-Object RoleName |
    Select-Object Name, Count |
    Sort-Object Count -Descending

Write-Host "`n[SUMMARY] PIM Eligible Assignment Governance Export" -ForegroundColor Yellow
Write-Host "  Execution ID           : $executionId"
Write-Host "  Total assignments      : $totalCount"
Write-Host "  Permanent assignments  : $permanentCount" -ForegroundColor Red
Write-Host "  Critical risk          : $criticalCount" -ForegroundColor Red
Write-Host "  High governance risk   : $highCount" -ForegroundColor Red
Write-Host "  Medium governance risk : $mediumCount" -ForegroundColor Yellow
Write-Host "  Low governance risk    : $lowCount" -ForegroundColor Green
Write-Host "  Review required        : $reviewCount" -ForegroundColor Yellow
Write-Host "  Multi-role principals  : $multiRoleCount" -ForegroundColor Yellow
Write-Host "  Duration seconds       : $totalDuration"

if ($reviewCount -gt 0) {
    Write-Host "`n[REVIEW REQUIRED] PIM assignments requiring governance review:" -ForegroundColor Yellow

    $results |
        Where-Object { $_.ReviewRequired -eq $true } |
        Select-Object PrincipalName, PrincipalUPN, RoleName, GovernanceRisk, IsPermanent, DaysEligible, MultiRoleEligible, ReviewReason |
        Format-Table -AutoSize
}

Write-Host "`n[SUMMARY] Assignments by Role:" -ForegroundColor Yellow
$roleSummary | Format-Table -AutoSize

Write-Host "`n[INFO] CSV export : $csvFile" -ForegroundColor Green
Write-Host "[INFO] JSON export: $jsonFile" -ForegroundColor Green

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
