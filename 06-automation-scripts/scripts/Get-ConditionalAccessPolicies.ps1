<#
.SYNOPSIS
    Exports and analyzes Conditional Access policy configuration from Microsoft
    Entra ID for governance review, compliance evidence, and enforcement baseline
    documentation.

.DESCRIPTION
    Retrieves all Conditional Access policies from Microsoft Entra ID and exports
    configuration details including assignments, conditions, grant controls, session
    controls, and policy state. Classifies policy strength, detects MFA enforcement
    gaps, identifies coverage issues, and flags policies requiring review.

    Output is designed for direct use as AC-3 / IA-2 / CA-7 compliance evidence
    and Conditional Access governance reviews.

.PARAMETER OutputPath
    Path for output files. Defaults to current directory. Created if not exists.

.PARAMETER State
    Filter by policy state: All, Enabled, Disabled, enabledForReportingButNotEnforced.
    Default: All.

.EXAMPLE
    # Export all Conditional Access policies
    .\Get-ConditionalAccessPolicies.ps1

    # Export only enabled policies
    .\Get-ConditionalAccessPolicies.ps1 -State Enabled

    # Export to specific path
    .\Get-ConditionalAccessPolicies.ps1 -OutputPath "C:\Reports"

.NOTES
    Required modules: Microsoft.Graph.Identity.SignIns
    Required permissions: Policy.Read.All
    Author: Robert J. Myers
    Version: 1.1
    Date: 2026-03-24
    Control mapping: AC-3, AC-17, IA-2, CA-7, SI-4
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

$requiredModules = @("Microsoft.Graph.Identity.SignIns")
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
    Connect-MgGraph -Scopes "Policy.Read.All" -NoWelcome
    Write-Host "[INFO] Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# ── Get Conditional Access Policies ───────────────────────────────────────────

Write-Host "[INFO] Retrieving Conditional Access policies..." -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$results   = @()

try {
    $policies = Get-MgIdentityConditionalAccessPolicy -All

    if ($State -ne "All") {
        $policies = $policies | Where-Object { $_.State -eq $State }
    }

    Write-Host "[INFO] Found $($policies.Count) policies. Processing..." -ForegroundColor Cyan

    foreach ($policy in $policies) {

        # ── User Scope ────────────────────────────────────────────────────────
        $includeUsers  = ($policy.Conditions.Users.IncludeUsers -join ", ")
        $excludeUsers  = ($policy.Conditions.Users.ExcludeUsers -join ", ")
        $includeGroups = ($policy.Conditions.Users.IncludeGroups -join ", ")
        $excludeGroups = ($policy.Conditions.Users.ExcludeGroups -join ", ")

        # ── Application Scope ─────────────────────────────────────────────────
        $includeApps = ($policy.Conditions.Applications.IncludeApplications -join ", ")
        $excludeApps = ($policy.Conditions.Applications.ExcludeApplications -join ", ")

        # ── Grant Controls ────────────────────────────────────────────────────
        $grantControls = if ($policy.GrantControls) {
            ($policy.GrantControls.BuiltInControls -join ", ")
        } else { "None" }
        $grantOperator = if ($policy.GrantControls) { $policy.GrantControls.Operator } else { "N/A" }

        # ── MFA Detection ─────────────────────────────────────────────────────
        $requiresMFA = if ($grantControls -match "mfa") { $true } else { $false }

        # ── Session Controls ──────────────────────────────────────────────────
        $sessionControls = if ($policy.SessionControls) {
            $controls = @()
            if ($policy.SessionControls.SignInFrequency)  { $controls += "SignInFrequency" }
            if ($policy.SessionControls.PersistentBrowser){ $controls += "PersistentBrowser" }
            if ($policy.SessionControls.CloudAppSecurity) { $controls += "CloudAppSecurity" }
            if ($controls.Count -gt 0) { $controls -join ", " } else { "None" }
        } else { "None" }

        # ── Location Conditions ───────────────────────────────────────────────
        $includeLocations = ($policy.Conditions.Locations.IncludeLocations -join ", ")
        $excludeLocations = ($policy.Conditions.Locations.ExcludeLocations -join ", ")

        # ── Platform Conditions ───────────────────────────────────────────────
        $includePlatforms = if ($policy.Conditions.Platforms) {
            ($policy.Conditions.Platforms.IncludePlatforms -join ", ")
        } else { "Any" }

        # ── Risk Conditions ───────────────────────────────────────────────────
        $signInRisk = if ($policy.Conditions.SignInRiskLevels) {
            ($policy.Conditions.SignInRiskLevels -join ", ")
        } else { "None" }

        $userRisk = if ($policy.Conditions.UserRiskLevels) {
            ($policy.Conditions.UserRiskLevels -join ", ")
        } else { "None" }

        # ── Enforcement Status ────────────────────────────────────────────────
        $enforcementStatus = switch ($policy.State) {
            "enabled"                           { "Enforcing" }
            "disabled"                          { "Inactive" }
            "enabledForReportingButNotEnforced" { "Report-only" }
            default                             { "Unknown" }
        }

        # ── Privileged Scope Check ────────────────────────────────────────────
        $privilegedScope = if ($includeUsers -match "All" -or $includeGroups -match "Admin") {
            "Covers Privileged Access"
        } else {
            "Verify Privileged Coverage"
        }

        # ── Policy Strength Classification ────────────────────────────────────
        $policyStrength = "Weak"
        if ($requiresMFA -and $enforcementStatus -eq "Enforcing") {
            $policyStrength = "Strong"
        }
        elseif ($enforcementStatus -eq "Report-only") {
            $policyStrength = "Testing"
        }
        elseif ($enforcementStatus -eq "Inactive") {
            $policyStrength = "Inactive"
        }

        # ── Coverage Gap Detection ────────────────────────────────────────────
        $coverageNote = ""
        if ($policy.State -eq "enabledForReportingButNotEnforced") {
            $coverageNote = "Policy in Report-only — not enforcing"
        }
        elseif ($policy.State -eq "disabled") {
            $coverageNote = "Policy disabled — not active"
        }
        elseif (-not $requiresMFA -and $enforcementStatus -eq "Enforcing") {
            $coverageNote = "Enforcing without MFA requirement — verify intent"
        }

        $results += [PSCustomObject]@{
            PolicyName        = $policy.DisplayName
            PolicyId          = $policy.Id
            State             = $policy.State
            EnforcementStatus = $enforcementStatus
            PolicyStrength    = $policyStrength
            RequiresMFA       = $requiresMFA
            PrivilegedScope   = $privilegedScope
            IncludeUsers      = $includeUsers
            ExcludeUsers      = $excludeUsers
            IncludeGroups     = $includeGroups
            ExcludeGroups     = $excludeGroups
            IncludeApps       = $includeApps
            ExcludeApps       = $excludeApps
            IncludeLocations  = $includeLocations
            ExcludeLocations  = $excludeLocations
            IncludePlatforms  = $includePlatforms
            SignInRiskLevels  = $signInRisk
            UserRiskLevels    = $userRisk
            GrantControls     = $grantControls
            GrantOperator     = $grantOperator
            SessionControls   = $sessionControls
            CoverageNote      = $coverageNote
            CreatedDateTime   = $policy.CreatedDateTime
            ModifiedDateTime  = $policy.ModifiedDateTime
            ExportDate        = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        }
    }
}
catch {
    Write-Error "Error retrieving Conditional Access policies: $_"
    Disconnect-MgGraph | Out-Null
    exit 1
}

# ── Sort by Policy Strength (Weak First) ─────────────────────────────────────

$results = $results | Sort-Object `
    @{Expression = {
        switch ($_.PolicyStrength) {
            "Weak"     { 1 }
            "Testing"  { 2 }
            "Inactive" { 3 }
            "Strong"   { 4 }
        }
    }},
    PolicyName

# ── Export ────────────────────────────────────────────────────────────────────

$csvFile  = Join-Path $OutputPath "conditional-access-policies-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "conditional-access-policies-$timestamp.json"

$results | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$results | ConvertTo-Json -Depth 5 | Out-File $jsonFile -Encoding UTF8

# ── Summary ───────────────────────────────────────────────────────────────────

$strongCount     = ($results | Where-Object { $_.PolicyStrength -eq "Strong" }).Count
$testingCount    = ($results | Where-Object { $_.PolicyStrength -eq "Testing" }).Count
$inactiveCount   = ($results | Where-Object { $_.PolicyStrength -eq "Inactive" }).Count
$weakCount       = ($results | Where-Object { $_.PolicyStrength -eq "Weak" }).Count
$mfaCount        = ($results | Where-Object { $_.RequiresMFA -eq $true }).Count
$gapCount        = ($results | Where-Object { $_.CoverageNote -ne "" }).Count
$totalCount      = $results.Count

Write-Host "`n[SUMMARY] Conditional Access Policy Analysis:" -ForegroundColor Yellow
Write-Host "  Total policies        : $totalCount"
Write-Host "  Strong (enforcing+MFA): $strongCount"  -ForegroundColor Green
Write-Host "  Testing (Report-only) : $testingCount" -ForegroundColor Yellow
Write-Host "  Weak enforcement      : $weakCount"    -ForegroundColor Red
Write-Host "  Inactive/Disabled     : $inactiveCount"-ForegroundColor Red
Write-Host "  Policies requiring MFA: $mfaCount"     -ForegroundColor Cyan
Write-Host "  Coverage gaps         : $gapCount"     -ForegroundColor Red

if ($gapCount -gt 0) {
    Write-Host "`n[GAPS] Policies requiring review:" -ForegroundColor Red
    $results | Where-Object { $_.CoverageNote -ne "" } |
        Select-Object PolicyName, PolicyStrength, CoverageNote |
        Format-Table -AutoSize
}

Write-Host "[INFO] CSV export:  $csvFile" -ForegroundColor Green
Write-Host "[INFO] JSON export: $jsonFile" -ForegroundColor Green

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
