<#
.SYNOPSIS
    Identifies stale Entra ID user accounts based on sign-in inactivity.

.DESCRIPTION
    Queries Microsoft Entra ID sign-in activity to identify user accounts
    that have not authenticated within a defined threshold (default 90 days).
    Classifies accounts by risk level, detects service accounts to reduce
    false positives, and exports results to CSV and JSON for use in access
    reviews, lifecycle governance, and audit evidence.

    Supports filtering by enabled accounts only, stale-only export, custom
    inactivity threshold, and exclusion of break-glass or service account groups.

    Output is designed for direct use as AC-2 / AC-2(3) lifecycle evidence
    and supports JML leaver identification workflows.

.PARAMETER InactiveDays
    Number of days without sign-in activity to classify as stale. Default: 90.

.PARAMETER OutputPath
    Path for output files. Defaults to current directory. Created if not exists.

.PARAMETER EnabledOnly
    Switch to return only enabled accounts. Disabled accounts are excluded.

.PARAMETER StaleOnly
    Switch to export only stale accounts — actionable remediation list.

.PARAMETER ExcludeGroups
    Array of group names whose members should be excluded (e.g. break-glass accounts).

.EXAMPLE
    # Find accounts inactive for 90+ days
    .\Get-StaleUsers.ps1

    # Find enabled stale accounts only, 60-day threshold
    .\Get-StaleUsers.ps1 -InactiveDays 60 -EnabledOnly -StaleOnly

    # Exclude break-glass group members
    .\Get-StaleUsers.ps1 -ExcludeGroups @("Break-Glass-Accounts") -StaleOnly

.NOTES
    Required modules: Microsoft.Graph.Users, Microsoft.Graph.Reports
    Required permissions: User.Read.All, AuditLog.Read.All
    Author: Robert J. Myers
    Version: 1.1
    Date: 2026-03-24
    Control mapping: AC-2, AC-2(3), AC-6
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [int]$InactiveDays = 90,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ".",

    [Parameter(Mandatory = $false)]
    [switch]$EnabledOnly,

    [Parameter(Mandatory = $false)]
    [switch]$StaleOnly,

    [Parameter(Mandatory = $false)]
    [string[]]$ExcludeGroups = @()
)

# ── Prerequisites ─────────────────────────────────────────────────────────────

$requiredModules = @("Microsoft.Graph.Users", "Microsoft.Graph.Reports")
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Error "Required module not found: $module. Run: Install-Module $module"
        exit 1
    }
}

# ── Safety Guard Rail ─────────────────────────────────────────────────────────

if ($InactiveDays -lt 30) {
    Write-Warning "InactiveDays is set below 30 — verify this is intentional before using results for remediation."
}

# ── Output Path Validation ────────────────────────────────────────────────────

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
    Write-Host "[INFO] Created output directory: $OutputPath" -ForegroundColor Cyan
}

# ── Connect ───────────────────────────────────────────────────────────────────

Write-Host "[INFO] Connecting to Microsoft Graph..." -ForegroundColor Cyan
try {
    Connect-MgGraph -Scopes "User.Read.All", "AuditLog.Read.All" -NoWelcome
    Write-Host "[INFO] Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# ── Build Exclusion List ──────────────────────────────────────────────────────

$excludedUserIds = @()

if ($ExcludeGroups.Count -gt 0) {
    Write-Host "[INFO] Building exclusion list from groups: $($ExcludeGroups -join ', ')" -ForegroundColor Cyan
    foreach ($groupName in $ExcludeGroups) {
        $group = Get-MgGroup -Filter "displayName eq '$groupName'" -ErrorAction SilentlyContinue
        if ($group) {
            $members = Get-MgGroupMember -GroupId $group.Id -All
            $excludedUserIds += $members.Id
            Write-Host "[INFO] Excluding $($members.Count) members from: $groupName" -ForegroundColor Cyan
        }
        else {
            Write-Warning "Exclusion group not found: $groupName"
        }
    }
}

# ── Get Users ─────────────────────────────────────────────────────────────────

Write-Host "[INFO] Retrieving users with sign-in activity..." -ForegroundColor Cyan

$thresholdDate = (Get-Date).AddDays(-$InactiveDays)
$timestamp     = Get-Date -Format "yyyyMMdd-HHmmss"
$results       = @()

try {
    $properties = "id,displayName,userPrincipalName,accountEnabled,signInActivity,userType,department,jobTitle,createdDateTime"
    $users = Get-MgUser -All -Property $properties

    Write-Host "[INFO] Retrieved $($users.Count) users. Evaluating sign-in activity..." -ForegroundColor Cyan

    foreach ($user in $users) {

        # Apply enabled filter
        if ($EnabledOnly -and -not $user.AccountEnabled) { continue }

        # Apply exclusion list
        if ($excludedUserIds -contains $user.Id) { continue }

        # ── Service Account Detection ─────────────────────────────────────────
        $isServiceAccount = $false
        if ($user.UserType -eq "Guest") {
            $isServiceAccount = $true
        }
        elseif ($user.UserPrincipalName -match "svc|service|svc-|_svc|admin") {
            $isServiceAccount = $true
        }

        # ── Sign-in Analysis ──────────────────────────────────────────────────
        $lastSignIn               = $null
        $lastNonInteractiveSignIn = $null
        $daysSinceSignIn          = $null
        $staleStatus              = "Unknown"

        if ($user.SignInActivity) {
            $lastSignIn               = $user.SignInActivity.LastSignInDateTime
            $lastNonInteractiveSignIn = $user.SignInActivity.LastNonInteractiveSignInDateTime

            $mostRecent = $lastSignIn
            if ($lastNonInteractiveSignIn -and ($lastNonInteractiveSignIn -gt $mostRecent)) {
                $mostRecent = $lastNonInteractiveSignIn
            }

            if ($mostRecent) {
                $daysSinceSignIn = [int]((Get-Date) - $mostRecent).TotalDays
                $staleStatus     = if ($mostRecent -lt $thresholdDate) { "Stale" } else { "Active" }
            }
            else {
                $staleStatus     = "Never signed in"
                $daysSinceSignIn = $null
            }
        }
        else {
            $staleStatus = "No sign-in data"
        }

        # ── Risk Classification ───────────────────────────────────────────────
        $riskLevel = "Low"
        if ($staleStatus -eq "Stale" -and $user.AccountEnabled) {
            $riskLevel = "High"
        }
        elseif ($staleStatus -eq "Never signed in") {
            $riskLevel = "Medium"
        }
        elseif ($staleStatus -eq "Stale" -and -not $user.AccountEnabled) {
            $riskLevel = "Low"
        }

        $results += [PSCustomObject]@{
            DisplayName              = $user.DisplayName
            UserPrincipalName        = $user.UserPrincipalName
            AccountEnabled           = $user.AccountEnabled
            UserType                 = $user.UserType
            Department               = $user.Department
            JobTitle                 = $user.JobTitle
            IsServiceAccount         = $isServiceAccount
            CreatedDateTime          = $user.CreatedDateTime
            LastInteractiveSignIn    = $lastSignIn
            LastNonInteractiveSignIn = $lastNonInteractiveSignIn
            DaysSinceLastSignIn      = $daysSinceSignIn
            StaleStatus              = $staleStatus
            RiskLevel                = $riskLevel
            InactiveDaysThreshold    = $InactiveDays
            ExportDate               = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        }
    }
}
catch {
    Write-Error "Error retrieving user data: $_"
    Disconnect-MgGraph | Out-Null
    exit 1
}

# ── Apply Stale Filter ────────────────────────────────────────────────────────

if ($StaleOnly) {
    $results = $results | Where-Object { $_.StaleStatus -eq "Stale" -or $_.StaleStatus -eq "Never signed in" }
    Write-Host "[INFO] StaleOnly filter applied." -ForegroundColor Cyan
}

# ── Sort by Risk ──────────────────────────────────────────────────────────────

$results = $results | Sort-Object RiskLevel, DaysSinceLastSignIn -Descending

# ── Export ────────────────────────────────────────────────────────────────────

$csvFile  = Join-Path $OutputPath "stale-users-report-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "stale-users-report-$timestamp.json"

$results | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$results | ConvertTo-Json -Depth 3 | Out-File $jsonFile -Encoding UTF8

# ── Summary ───────────────────────────────────────────────────────────────────

$staleCount          = ($results | Where-Object { $_.StaleStatus -eq "Stale" }).Count
$neverSignIn         = ($results | Where-Object { $_.StaleStatus -eq "Never signed in" }).Count
$activeCount         = ($results | Where-Object { $_.StaleStatus -eq "Active" }).Count
$highRiskCount       = ($results | Where-Object { $_.RiskLevel -eq "High" }).Count
$serviceAccountCount = ($results | Where-Object { $_.IsServiceAccount -eq $true }).Count
$totalCount          = $results.Count

Write-Host "`n[SUMMARY] Stale User Analysis (Threshold: $InactiveDays days):" -ForegroundColor Yellow
Write-Host "  Total users evaluated  : $totalCount"
Write-Host "  Active                 : $activeCount"
Write-Host "  Stale (inactive)       : $staleCount"  -ForegroundColor Red
Write-Host "  Never signed in        : $neverSignIn"  -ForegroundColor Red
Write-Host "  High risk              : $highRiskCount" -ForegroundColor Red
Write-Host "  Service accounts found : $serviceAccountCount" -ForegroundColor Yellow

Write-Host "`n[INFO] CSV export:  $csvFile" -ForegroundColor Green
Write-Host "[INFO] JSON export: $jsonFile" -ForegroundColor Green

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
