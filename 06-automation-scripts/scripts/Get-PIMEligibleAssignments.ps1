<#
.SYNOPSIS
    Exports and analyzes Privileged Identity Management (PIM) eligible role
    assignments from Microsoft Entra ID.

.DESCRIPTION
    Retrieves all eligible role assignments from Microsoft Entra ID PIM,
    classifies risk based on role sensitivity and assignment permanence,
    detects users with multiple privileged role eligibilities, and measures
    eligibility duration. Exports results to CSV and JSON for privileged
    access audits, standing-access posture assessments, and compliance evidence.

    Output is designed for direct use as AC-6(5) / IA-2 privileged access
    audit evidence and supports PIM governance review workflows.

.PARAMETER OutputPath
    Path for output files. Defaults to current directory. Created if not exists.

.PARAMETER RoleName
    Filter results to a specific role name. If omitted, exports all assignments.

.PARAMETER PermanentOnly
    Switch to return only permanent (no expiration) eligible assignments.

.EXAMPLE
    # Export all PIM eligible assignments
    .\Get-PIMEligibleAssignments.ps1

    # Export eligible assignments for a specific role
    .\Get-PIMEligibleAssignments.ps1 -RoleName "Security Reader"

    # Export only permanent eligible assignments
    .\Get-PIMEligibleAssignments.ps1 -PermanentOnly

.NOTES
    Required modules: Microsoft.Graph.Identity.Governance
    Required permissions: RoleEligibilitySchedule.Read.Directory,
                          RoleManagement.Read.Directory, User.Read.All
    Author: Robert J. Myers
    Version: 1.1
    Date: 2026-03-24
    Control mapping: AC-2, AC-6, AC-6(5), IA-2
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

$requiredModules = @("Microsoft.Graph.Identity.Governance")
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Error "Required module not found: $module. Run: Install-Module $module"
        exit 1
    }
}

# ── Output Path Validation ────────────────────────────────────────────────────

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
    Write-Host "[INFO] Created output directory: $OutputPath" -ForegroundColor Cyan
}

# ── Connect ───────────────────────────────────────────────────────────────────

Write-Host "[INFO] Connecting to Microsoft Graph..." -ForegroundColor Cyan
try {
    Connect-MgGraph -Scopes "RoleEligibilitySchedule.Read.Directory", "RoleManagement.Read.Directory", "User.Read.All" -NoWelcome
    Write-Host "[INFO] Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# ── Get PIM Eligible Assignments ──────────────────────────────────────────────

Write-Host "[INFO] Retrieving PIM eligible role assignments..." -ForegroundColor Cyan

$timestamp    = Get-Date -Format "yyyyMMdd-HHmmss"
$results      = @()
$highRiskRoles = @(
    "Global Administrator",
    "Privileged Role Administrator",
    "Security Administrator",
    "User Administrator",
    "Application Administrator"
)

try {
    $assignments = Get-MgRoleManagementDirectoryRoleEligibilitySchedule -All `
        -ExpandProperty "principal,roleDefinition"

    Write-Host "[INFO] Retrieved $($assignments.Count) eligible assignments." -ForegroundColor Cyan

    foreach ($assignment in $assignments) {

        # Apply role name filter
        if ($RoleName -and $assignment.RoleDefinition.DisplayName -ne $RoleName) { continue }

        # ── Assignment Duration ───────────────────────────────────────────────
        $isPermanent = $null -eq $assignment.ScheduleInfo.Expiration.EndDateTime
        $expiresOn   = if ($isPermanent) { "Permanent" } else { $assignment.ScheduleInfo.Expiration.EndDateTime }

        # Apply permanent filter
        if ($PermanentOnly -and -not $isPermanent) { continue }

        # ── Eligibility Age ───────────────────────────────────────────────────
        $daysEligible = $null
        if ($assignment.ScheduleInfo.StartDateTime) {
            $daysEligible = [int]((Get-Date) - $assignment.ScheduleInfo.StartDateTime).TotalDays
        }

        # ── Principal Details ─────────────────────────────────────────────────
        $principalType = $assignment.Principal.AdditionalProperties["@odata.type"]
        $principalName = $assignment.Principal.AdditionalProperties["displayName"]

        if ($principalType -eq "#microsoft.graph.user") {
            $principalUPN = $assignment.Principal.AdditionalProperties["userPrincipalName"]
        }
        else {
            $principalUPN = "N/A"
        }

        # ── Risk Classification ───────────────────────────────────────────────
        $riskLevel = "Standard"
        if ($assignment.RoleDefinition.DisplayName -in $highRiskRoles -and $isPermanent) {
            $riskLevel = "Critical"
        }
        elseif ($assignment.RoleDefinition.DisplayName -in $highRiskRoles) {
            $riskLevel = "High"
        }
        elseif ($isPermanent) {
            $riskLevel = "Elevated"
        }

        # ── Activation Model ──────────────────────────────────────────────────
        $activationModel = if ($isPermanent) { "Standing Eligible" } else { "Time-Bound Eligible" }

        $results += [PSCustomObject]@{
            PrincipalName     = $principalName
            PrincipalUPN      = $principalUPN
            PrincipalType     = $principalType
            RoleName          = $assignment.RoleDefinition.DisplayName
            RoleId            = $assignment.RoleDefinitionId
            AssignmentType    = "Eligible"
            ActivationModel   = $activationModel
            IsPermanent       = $isPermanent
            StartDateTime     = $assignment.ScheduleInfo.StartDateTime
            ExpiresOn         = $expiresOn
            DaysEligible      = $daysEligible
            DirectoryScopeId  = $assignment.DirectoryScopeId
            RiskLevel         = $riskLevel
            MultiRoleEligible = $false
            ExportDate        = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        }
    }
}
catch {
    Write-Error "Error retrieving PIM assignments: $_"
    Disconnect-MgGraph | Out-Null
    exit 1
}

# ── Multi-Role Detection ──────────────────────────────────────────────────────

$multiRoleUsers = $results | Group-Object PrincipalUPN | Where-Object { $_.Count -gt 1 }

foreach ($group in $multiRoleUsers) {
    foreach ($entry in $results | Where-Object { $_.PrincipalUPN -eq $group.Name }) {
        $entry.MultiRoleEligible = $true
    }
}

# ── Sort by Risk Priority ─────────────────────────────────────────────────────

$results = $results | Sort-Object `
    @{Expression = {
        switch ($_.RiskLevel) {
            "Critical" { 1 }
            "High"     { 2 }
            "Elevated" { 3 }
            default    { 4 }
        }
    }},
    DaysEligible -Descending

# ── Export ────────────────────────────────────────────────────────────────────

$csvFile  = Join-Path $OutputPath "pim-eligible-assignments-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "pim-eligible-assignments-$timestamp.json"

$results | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$results | ConvertTo-Json -Depth 3 | Out-File $jsonFile -Encoding UTF8

# ── Summary ───────────────────────────────────────────────────────────────────

$criticalCount    = ($results | Where-Object { $_.RiskLevel -eq "Critical" }).Count
$highCount        = ($results | Where-Object { $_.RiskLevel -eq "High" }).Count
$elevatedCount    = ($results | Where-Object { $_.RiskLevel -eq "Elevated" }).Count
$permanentCount   = ($results | Where-Object { $_.IsPermanent -eq $true }).Count
$multiRoleCount   = ($results | Where-Object { $_.MultiRoleEligible -eq $true } | Select-Object -Unique PrincipalUPN).Count
$totalCount       = $results.Count

$roleSummary = $results | Group-Object RoleName | Select-Object Name, Count | Sort-Object Count -Descending

Write-Host "`n[SUMMARY] PIM Eligible Assignment Analysis:" -ForegroundColor Yellow
Write-Host "  Total eligible assignments  : $totalCount"
Write-Host "  Permanent assignments       : $permanentCount"   -ForegroundColor Red
Write-Host "  Critical risk               : $criticalCount"    -ForegroundColor Red
Write-Host "  High risk                   : $highCount"        -ForegroundColor Red
Write-Host "  Elevated risk               : $elevatedCount"    -ForegroundColor Yellow
Write-Host "  Multi-role eligible users   : $multiRoleCount"   -ForegroundColor Yellow

Write-Host "`n[SUMMARY] Assignments by Role:" -ForegroundColor Yellow
$roleSummary | Format-Table -AutoSize

Write-Host "[INFO] CSV export:  $csvFile" -ForegroundColor Green
Write-Host "[INFO] JSON export: $jsonFile" -ForegroundColor Green

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
