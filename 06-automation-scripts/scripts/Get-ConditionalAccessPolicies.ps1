<#
.SYNOPSIS
    Exports and analyzes Microsoft Entra ID Conditional Access policies for
    IAM governance review, Zero Trust validation, compliance evidence, and
    enforcement baseline reporting.

.DESCRIPTION
    Retrieves Conditional Access policies from Microsoft Entra ID and exports
    configuration details including assignments, conditions, grant controls,
    session controls, policy state, MFA enforcement, location controls, and
    report-only posture.

    Produces CSV and JSON outputs suitable for IAM governance evidence,
    Conditional Access review, NIST 800-53 / CMMC evidence support, and
    Zero Trust posture validation.

.PARAMETER OutputPath
    Path for CSV and JSON output files. Defaults to current directory.

.PARAMETER State
    Filter by Conditional Access policy state:
    All, Enabled, Disabled, enabledForReportingButNotEnforced.

.EXAMPLE
    .\Get-ConditionalAccessPolicies.ps1

.EXAMPLE
    .\Get-ConditionalAccessPolicies.ps1 -State Enabled

.EXAMPLE
    .\Get-ConditionalAccessPolicies.ps1 -OutputPath "C:\AuditEvidence"

.NOTES
    Required module:
        Microsoft.Graph.Identity.SignIns

    Required permission:
        Policy.Read.All

    Author: Robert J. Myers
    Version: 1.2
    Date: 2026-03-24
    Control Mapping: AC-3, AC-17, IA-2, CA-7, SI-4
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("All", "Enabled", "Disabled", "enabledForReportingButNotEnforced")]
    [string]$State = "All",

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "."
)

# ── Prerequisites ─────────────────────────────────────────────────────────────

$requiredModules = @(
    "Microsoft.Graph.Identity.SignIns"
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
Write-Host "[INFO] Conditional Access governance export started." -ForegroundColor Cyan

# ── Connect to Microsoft Graph ────────────────────────────────────────────────

Write-Host "[INFO] Connecting to Microsoft Graph..." -ForegroundColor Cyan

try {
    Connect-MgGraph -Scopes "Policy.Read.All" -NoWelcome
    Write-Host "[INFO] Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# ── Helper Functions ──────────────────────────────────────────────────────────

function Convert-ToSafeString {
    param(
        [object]$Value,
        [string]$Default = "None"
    )

    if ($null -eq $Value) {
        return $Default
    }

    if ($Value -is [array]) {
        if ($Value.Count -eq 0) {
            return $Default
        }

        return ($Value -join ", ")
    }

    if ([string]::IsNullOrWhiteSpace([string]$Value)) {
        return $Default
    }

    return [string]$Value
}

function Get-EnforcementStatus {
    param([string]$PolicyState)

    switch ($PolicyState) {
        "enabled" {
            return "Enforcing"
        }
        "disabled" {
            return "Inactive"
        }
        "enabledForReportingButNotEnforced" {
            return "Report-only"
        }
        default {
            return "Unknown"
        }
    }
}

function Get-PolicyStrength {
    param(
        [bool]$RequiresMFA,
        [string]$EnforcementStatus,
        [bool]$BlocksAccess,
        [bool]$HasLocationControl
    )

    if ($EnforcementStatus -eq "Inactive") {
        return "Inactive"
    }

    if ($EnforcementStatus -eq "Report-only") {
        return "Testing"
    }

    if ($EnforcementStatus -eq "Enforcing" -and ($RequiresMFA -or $BlocksAccess -or $HasLocationControl)) {
        return "Strong"
    }

    return "Weak"
}

function Get-CoverageNote {
    param(
        [string]$PolicyState,
        [bool]$RequiresMFA,
        [bool]$BlocksAccess,
        [string]$EnforcementStatus
    )

    if ($PolicyState -eq "enabledForReportingButNotEnforced") {
        return "Policy in Report-only — evaluating but not enforcing"
    }

    if ($PolicyState -eq "disabled") {
        return "Policy disabled — not active"
    }

    if ($EnforcementStatus -eq "Enforcing" -and (-not $RequiresMFA) -and (-not $BlocksAccess)) {
        return "Enforcing without MFA or block control — verify intent"
    }

    return ""
}

# ── Retrieve Conditional Access Policies ──────────────────────────────────────

Write-Host "[INFO] Retrieving Conditional Access policies..." -ForegroundColor Cyan

try {
    $policies = Get-MgIdentityConditionalAccessPolicy -All

    if ($State -ne "All") {
        $stateMap = @{
            "Enabled"  = "enabled"
            "Disabled" = "disabled"
            "enabledForReportingButNotEnforced" = "enabledForReportingButNotEnforced"
        }

        $targetState = $stateMap[$State]
        $policies = $policies | Where-Object { $_.State -eq $targetState }
    }

    Write-Host "[INFO] Found $($policies.Count) policies. Processing..." -ForegroundColor Cyan

    foreach ($policy in $policies) {

        # Users and Groups
        $includeUsers  = Convert-ToSafeString $policy.Conditions.Users.IncludeUsers
        $excludeUsers  = Convert-ToSafeString $policy.Conditions.Users.ExcludeUsers
        $includeGroups = Convert-ToSafeString $policy.Conditions.Users.IncludeGroups
        $excludeGroups = Convert-ToSafeString $policy.Conditions.Users.ExcludeGroups
        $includeRoles  = Convert-ToSafeString $policy.Conditions.Users.IncludeRoles
        $excludeRoles  = Convert-ToSafeString $policy.Conditions.Users.ExcludeRoles

        # Applications
        $includeApps = Convert-ToSafeString $policy.Conditions.Applications.IncludeApplications
        $excludeApps = Convert-ToSafeString $policy.Conditions.Applications.ExcludeApplications

        # Locations
        $includeLocations = if ($policy.Conditions.Locations) {
            Convert-ToSafeString $policy.Conditions.Locations.IncludeLocations
        } else {
            "Any"
        }

        $excludeLocations = if ($policy.Conditions.Locations) {
            Convert-ToSafeString $policy.Conditions.Locations.ExcludeLocations
        } else {
            "None"
        }

        # Platforms
        $includePlatforms = if ($policy.Conditions.Platforms) {
            Convert-ToSafeString $policy.Conditions.Platforms.IncludePlatforms "Any"
        } else {
            "Any"
        }

        $excludePlatforms = if ($policy.Conditions.Platforms) {
            Convert-ToSafeString $policy.Conditions.Platforms.ExcludePlatforms
        } else {
            "None"
        }

        # Risk Conditions
        $signInRisk = Convert-ToSafeString $policy.Conditions.SignInRiskLevels
        $userRisk   = Convert-ToSafeString $policy.Conditions.UserRiskLevels

        # Client Apps
        $clientApps = if ($policy.Conditions.ClientAppTypes) {
            Convert-ToSafeString $policy.Conditions.ClientAppTypes
        } else {
            "Not configured"
        }

        # Grant Controls
        $grantControls = if ($policy.GrantControls) {
            Convert-ToSafeString $policy.GrantControls.BuiltInControls
        } else {
            "None"
        }

        $grantOperator = if ($policy.GrantControls) {
            Convert-ToSafeString $policy.GrantControls.Operator "N/A"
        } else {
            "N/A"
        }

        $requiresMFA = if ($grantControls -match "mfa") { $true } else { $false }
        $blocksAccess = if ($grantControls -match "block") { $true } else { $false }

        # Session Controls
        $sessionControlList = @()

        if ($policy.SessionControls) {
            if ($policy.SessionControls.SignInFrequency) {
                $sessionControlList += "SignInFrequency"
            }
            if ($policy.SessionControls.PersistentBrowser) {
                $sessionControlList += "PersistentBrowser"
            }
            if ($policy.SessionControls.CloudAppSecurity) {
                $sessionControlList += "CloudAppSecurity"
            }
            if ($policy.SessionControls.DisableResilienceDefaults) {
                $sessionControlList += "DisableResilienceDefaults"
            }
        }

        $sessionControls = if ($sessionControlList.Count -gt 0) {
            $sessionControlList -join ", "
        } else {
            "None"
        }

        # Enforcement Status
        $enforcementStatus = Get-EnforcementStatus -PolicyState $policy.State

        # Coverage Analysis
        $allUsersScoped = if ($includeUsers -match "All") { $true } else { $false }
        $allAppsScoped  = if ($includeApps -match "All") { $true } else { $false }
        $hasExclusions  = if ($excludeUsers -ne "None" -or $excludeGroups -ne "None" -or $excludeRoles -ne "None") { $true } else { $false }
        $hasLocationControl = if ($includeLocations -ne "Any" -or $excludeLocations -ne "None") { $true } else { $false }

        $privilegedScope = if ($includeRoles -ne "None" -or $includeUsers -match "All" -or $includeGroups -match "Admin") {
            "Covers or may cover privileged access"
        } else {
            "Verify privileged access coverage"
        }

        $policyStrength = Get-PolicyStrength `
            -RequiresMFA $requiresMFA `
            -EnforcementStatus $enforcementStatus `
            -BlocksAccess $blocksAccess `
            -HasLocationControl $hasLocationControl

        $coverageNote = Get-CoverageNote `
            -PolicyState $policy.State `
            -RequiresMFA $requiresMFA `
            -BlocksAccess $blocksAccess `
            -EnforcementStatus $enforcementStatus

        $reviewRequired = if (
            $policyStrength -eq "Weak" -or
            $policyStrength -eq "Inactive" -or
            $policyStrength -eq "Testing" -or
            $coverageNote -ne ""
        ) {
            $true
        } else {
            $false
        }

        # Governance Classification
        $governanceRisk = "Low"

        if ($policyStrength -eq "Inactive") {
            $governanceRisk = "High"
        }
        elseif ($policyStrength -eq "Weak") {
            $governanceRisk = "High"
        }
        elseif ($policyStrength -eq "Testing") {
            $governanceRisk = "Medium"
        }
        elseif ($policyStrength -eq "Strong" -and $hasExclusions) {
            $governanceRisk = "Medium"
        }

        $results += [PSCustomObject]@{
            ExecutionId        = $executionId
            ExportDate         = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            PolicyName         = $policy.DisplayName
            PolicyId           = $policy.Id
            State              = $policy.State
            EnforcementStatus  = $enforcementStatus
            PolicyStrength     = $policyStrength
            GovernanceRisk     = $governanceRisk
            ReviewRequired     = $reviewRequired
            RequiresMFA        = $requiresMFA
            BlocksAccess       = $blocksAccess
            PrivilegedScope    = $privilegedScope
            AllUsersScoped     = $allUsersScoped
            AllAppsScoped      = $allAppsScoped
            HasExclusions      = $hasExclusions
            IncludeUsers       = $includeUsers
            ExcludeUsers       = $excludeUsers
            IncludeGroups      = $includeGroups
            ExcludeGroups      = $excludeGroups
            IncludeRoles       = $includeRoles
            ExcludeRoles       = $excludeRoles
            IncludeApps        = $includeApps
            ExcludeApps        = $excludeApps
            IncludeLocations   = $includeLocations
            ExcludeLocations   = $excludeLocations
            IncludePlatforms   = $includePlatforms
            ExcludePlatforms   = $excludePlatforms
            ClientAppTypes     = $clientApps
            SignInRiskLevels   = $signInRisk
            UserRiskLevels     = $userRisk
            GrantControls      = $grantControls
            GrantOperator      = $grantOperator
            SessionControls    = $sessionControls
            CoverageNote       = $coverageNote
            CreatedDateTime    = $policy.CreatedDateTime
            ModifiedDateTime   = $policy.ModifiedDateTime
        }
    }
}
catch {
    Write-Error "Error retrieving Conditional Access policies: $_"
    Disconnect-MgGraph | Out-Null
    exit 1
}

# ── Sort Results by Governance Risk ──────────────────────────────────────────

$results = $results | Sort-Object `
    @{ Expression = {
        switch ($_.GovernanceRisk) {
            "High"   { 1 }
            "Medium" { 2 }
            "Low"    { 3 }
            default  { 4 }
        }
    }},
    PolicyName

# ── Export Results ────────────────────────────────────────────────────────────

$csvFile  = Join-Path $OutputPath "conditional-access-policies-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "conditional-access-policies-$timestamp.json"

$results | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$results | ConvertTo-Json -Depth 6 | Out-File $jsonFile -Encoding UTF8

# ── Summary Metrics ──────────────────────────────────────────────────────────

$totalCount    = $results.Count
$strongCount   = ($results | Where-Object { $_.PolicyStrength -eq "Strong" }).Count
$testingCount  = ($results | Where-Object { $_.PolicyStrength -eq "Testing" }).Count
$inactiveCount = ($results | Where-Object { $_.PolicyStrength -eq "Inactive" }).Count
$weakCount     = ($results | Where-Object { $_.PolicyStrength -eq "Weak" }).Count
$mfaCount      = ($results | Where-Object { $_.RequiresMFA -eq $true }).Count
$blockCount    = ($results | Where-Object { $_.BlocksAccess -eq $true }).Count
$reviewCount   = ($results | Where-Object { $_.ReviewRequired -eq $true }).Count
$highRiskCount = ($results | Where-Object { $_.GovernanceRisk -eq "High" }).Count
$mediumRiskCount = ($results | Where-Object { $_.GovernanceRisk -eq "Medium" }).Count
$lowRiskCount = ($results | Where-Object { $_.GovernanceRisk -eq "Low" }).Count
$totalDuration = [math]::Round(((Get-Date) - $scriptStartTime).TotalSeconds, 2)

Write-Host "`n[SUMMARY] Conditional Access Policy Analysis" -ForegroundColor Yellow
Write-Host "  Execution ID           : $executionId"
Write-Host "  Total policies         : $totalCount"
Write-Host "  Strong policies        : $strongCount" -ForegroundColor Green
Write-Host "  Testing policies       : $testingCount" -ForegroundColor Yellow
Write-Host "  Weak policies          : $weakCount" -ForegroundColor Red
Write-Host "  Inactive policies      : $inactiveCount" -ForegroundColor Red
Write-Host "  MFA policies           : $mfaCount" -ForegroundColor Cyan
Write-Host "  Block policies         : $blockCount" -ForegroundColor Cyan
Write-Host "  Review required        : $reviewCount" -ForegroundColor Yellow
Write-Host "  High governance risk   : $highRiskCount" -ForegroundColor Red
Write-Host "  Medium governance risk : $mediumRiskCount" -ForegroundColor Yellow
Write-Host "  Low governance risk    : $lowRiskCount" -ForegroundColor Green
Write-Host "  Duration seconds       : $totalDuration"

if ($reviewCount -gt 0) {
    Write-Host "`n[REVIEW REQUIRED] Policies requiring governance review:" -ForegroundColor Yellow

    $results |
        Where-Object { $_.ReviewRequired -eq $true } |
        Select-Object PolicyName, EnforcementStatus, PolicyStrength, GovernanceRisk, CoverageNote |
        Format-Table -AutoSize
}

Write-Host "`n[INFO] CSV export : $csvFile" -ForegroundColor Green
Write-Host "[INFO] JSON export: $jsonFile" -ForegroundColor Green

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
