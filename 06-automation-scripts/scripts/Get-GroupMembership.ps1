<#
.SYNOPSIS
    Exports Microsoft Entra ID group membership for IAM governance reviews,
    access certification evidence, least privilege validation, and audit-ready
    reporting.

.DESCRIPTION
    Retrieves group membership from Microsoft Entra ID and exports results to
    CSV and JSON for access reviews, audit evidence, and compliance reporting.

    Supports:
    - single group export
    - all security groups export
    - optional transitive membership expansion
    - users, service principals, nested groups, and unknown object types
    - enabled / disabled account visibility
    - governance risk classification
    - review-required flagging
    - execution ID for audit correlation

    Output supports AC-2, AC-3, AC-6, access review evidence, SOC 2 user access
    review support, and CMMC / NIST-aligned identity governance workflows.

.PARAMETER GroupName
    Name of a specific group to export. If omitted, use -ExportAll.

.PARAMETER OutputPath
    Path for output files. Defaults to current directory.

.PARAMETER ExportAll
    Export all security-enabled groups in the tenant.

.PARAMETER IncludeTransitive
    Include nested group members through transitive membership expansion.

.EXAMPLE
    .\Get-GroupMembership.ps1 -GroupName "Finance-ReadOnly"

.EXAMPLE
    .\Get-GroupMembership.ps1 -ExportAll -IncludeTransitive

.EXAMPLE
    .\Get-GroupMembership.ps1 -GroupName "Finance-ReadOnly" -OutputPath "C:\AuditEvidence"

.NOTES
    Required modules:
        Microsoft.Graph.Groups
        Microsoft.Graph.Users

    Required permissions:
        Group.Read.All
        User.Read.All

    Author: Robert J. Myers
    Version: 1.2
    Date: 2026-03-24
    Control Mapping: AC-2, AC-3, AC-6, AU-2
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$GroupName,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ".",

    [Parameter(Mandatory = $false)]
    [switch]$ExportAll,

    [Parameter(Mandatory = $false)]
    [switch]$IncludeTransitive
)

# ── Prerequisites ─────────────────────────────────────────────────────────────

$requiredModules = @(
    "Microsoft.Graph.Groups",
    "Microsoft.Graph.Users"
)

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Error "Required module not found: $module. Run: Install-Module $module -Scope CurrentUser"
        exit 1
    }
}

# ── Parameter Validation ──────────────────────────────────────────────────────

if (-not $ExportAll -and [string]::IsNullOrWhiteSpace($GroupName)) {
    Write-Error "Specify -GroupName or use -ExportAll."
    exit 1
}

if ($ExportAll -and -not [string]::IsNullOrWhiteSpace($GroupName)) {
    Write-Error "Use either -GroupName or -ExportAll, not both."
    exit 1
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
Write-Host "[INFO] Group membership governance export started." -ForegroundColor Cyan

# ── Connect to Microsoft Graph ────────────────────────────────────────────────

Write-Host "[INFO] Connecting to Microsoft Graph..." -ForegroundColor Cyan

try {
    Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All" -NoWelcome
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

    if ([string]::IsNullOrWhiteSpace([string]$Value)) {
        return $Default
    }

    return [string]$Value
}

function Get-MemberGovernanceRisk {
    param(
        [string]$MemberType,
        [object]$MemberEnabled,
        [string]$MemberUPN
    )

    if ($MemberType -eq "#microsoft.graph.user" -and $MemberEnabled -eq $false) {
        return "Medium"
    }

    if ($MemberUPN -match "admin|breakglass|break-glass|priv") {
        return "High"
    }

    if ($MemberType -eq "#microsoft.graph.servicePrincipal") {
        return "Medium"
    }

    if ($MemberType -eq "#microsoft.graph.group") {
        return "Medium"
    }

    if ($MemberType -eq "Unknown" -or [string]::IsNullOrWhiteSpace($MemberType)) {
        return "Medium"
    }

    return "Low"
}

function Get-ReviewRequired {
    param(
        [string]$GovernanceRisk,
        [object]$MemberEnabled,
        [string]$MemberType
    )

    if ($GovernanceRisk -in @("High", "Medium")) {
        return $true
    }

    if ($MemberType -eq "#microsoft.graph.user" -and $MemberEnabled -eq $false) {
        return $true
    }

    return $false
}

# ── Retrieve Groups ───────────────────────────────────────────────────────────

try {
    if ($ExportAll) {
        Write-Host "[INFO] Retrieving all security-enabled groups..." -ForegroundColor Cyan
        $groups = Get-MgGroup -Filter "securityEnabled eq true" -All
    }
    else {
        Write-Host "[INFO] Retrieving group: $GroupName" -ForegroundColor Cyan
        $escapedGroupName = $GroupName.Replace("'", "''")
        $groups = Get-MgGroup -Filter "displayName eq '$escapedGroupName'" -All

        if (-not $groups) {
            Write-Error "Group not found: $GroupName"
            Disconnect-MgGraph | Out-Null
            exit 1
        }
    }

    Write-Host "[INFO] Found $($groups.Count) group(s). Retrieving members..." -ForegroundColor Cyan

    foreach ($group in $groups) {

        Write-Host "[INFO] Processing group: $($group.DisplayName)" -ForegroundColor Cyan

        try {
            if ($IncludeTransitive) {
                $members = Get-MgGroupTransitiveMember -GroupId $group.Id -All
                $membershipScope = "Transitive"
            }
            else {
                $members = Get-MgGroupMember -GroupId $group.Id -All
                $membershipScope = "Direct"
            }
        }
        catch {
            $results += [PSCustomObject]@{
                ExecutionId       = $executionId
                ExportDate        = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                GroupName         = $group.DisplayName
                GroupId           = $group.Id
                MembershipScope   = if ($IncludeTransitive) { "Transitive" } else { "Direct" }
                MemberName        = "ERROR"
                MemberUPN         = ""
                MemberId          = ""
                MemberType        = "Error"
                MemberEnabled     = ""
                GovernanceRisk    = "High"
                ReviewRequired    = $true
                ReviewReason      = "Unable to retrieve group membership"
                EvidenceUse       = "Access review exception evidence"
                ErrorDetail       = "$_"
            }

            continue
        }

        if ($members.Count -eq 0) {
            $results += [PSCustomObject]@{
                ExecutionId       = $executionId
                ExportDate        = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                GroupName         = $group.DisplayName
                GroupId           = $group.Id
                MembershipScope   = $membershipScope
                MemberName        = "No members"
                MemberUPN         = ""
                MemberId          = ""
                MemberType        = "None"
                MemberEnabled     = ""
                GovernanceRisk    = "Low"
                ReviewRequired    = $false
                ReviewReason      = "No group members detected"
                EvidenceUse       = "Access review evidence"
                ErrorDetail       = ""
            }

            continue
        }

        foreach ($member in $members) {

            $memberType = Convert-ToSafeString $member.AdditionalProperties["@odata.type"] "Unknown"
            $displayName = ""
            $upn = ""
            $enabled = ""
            $reviewReason = ""
            $errorDetail = ""

            if ($memberType -eq "#microsoft.graph.user") {
                try {
                    $user = Get-MgUser `
                        -UserId $member.Id `
                        -Property "id,displayName,userPrincipalName,accountEnabled" `
                        -ErrorAction Stop

                    $displayName = Convert-ToSafeString $user.DisplayName
                    $upn = Convert-ToSafeString $user.UserPrincipalName
                    $enabled = $user.AccountEnabled

                    if ($enabled -eq $false) {
                        $reviewReason = "Disabled user remains in group"
                    }
                    else {
                        $reviewReason = "Standard user membership"
                    }
                }
                catch {
                    $displayName = Convert-ToSafeString $member.AdditionalProperties["displayName"] "Unknown user"
                    $upn = "LookupFailed"
                    $enabled = "Unknown"
                    $reviewReason = "User lookup failed"
                    $errorDetail = "$_"
                }
            }
            elseif ($memberType -eq "#microsoft.graph.servicePrincipal") {
                $displayName = Convert-ToSafeString $member.AdditionalProperties["displayName"] "Service Principal"
                $upn = "ServicePrincipal"
                $enabled = "N/A"
                $reviewReason = "Service principal membership requires ownership review"
            }
            elseif ($memberType -eq "#microsoft.graph.group") {
                $displayName = Convert-ToSafeString $member.AdditionalProperties["displayName"] "Nested Group"
                $upn = "NestedGroup"
                $enabled = "N/A"
                $reviewReason = "Nested group membership requires transitive access review"
            }
            else {
                $displayName = Convert-ToSafeString $member.AdditionalProperties["displayName"] "Unknown object"
                $upn = "Unknown"
                $enabled = "N/A"
                $reviewReason = "Unknown object type requires review"
            }

            $governanceRisk = Get-MemberGovernanceRisk `
                -MemberType $memberType `
                -MemberEnabled $enabled `
                -MemberUPN $upn

            $reviewRequired = Get-ReviewRequired `
                -GovernanceRisk $governanceRisk `
                -MemberEnabled $enabled `
                -MemberType $memberType

            $results += [PSCustomObject]@{
                ExecutionId       = $executionId
                ExportDate        = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                GroupName         = $group.DisplayName
                GroupId           = $group.Id
                MembershipScope   = $membershipScope
                MemberName        = $displayName
                MemberUPN         = $upn
                MemberId          = $member.Id
                MemberType        = $memberType
                MemberEnabled     = $enabled
                GovernanceRisk    = $governanceRisk
                ReviewRequired    = $reviewRequired
                ReviewReason      = $reviewReason
                EvidenceUse       = "AC-2 / AC-3 access review evidence"
                ErrorDetail       = $errorDetail
            }
        }
    }
}
catch {
    Write-Error "Error retrieving group membership: $_"
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
    GroupName,
    MemberName

# ── Export Results ────────────────────────────────────────────────────────────

$csvFile = Join-Path $OutputPath "group-membership-report-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "group-membership-report-$timestamp.json"

$results | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$results | ConvertTo-Json -Depth 5 | Out-File $jsonFile -Encoding UTF8

# ── Summary Metrics ──────────────────────────────────────────────────────────

$totalRecords = $results.Count
$totalGroups = ($results | Select-Object -ExpandProperty GroupId -Unique).Count
$highRiskCount = ($results | Where-Object { $_.GovernanceRisk -eq "High" }).Count
$mediumRiskCount = ($results | Where-Object { $_.GovernanceRisk -eq "Medium" }).Count
$lowRiskCount = ($results | Where-Object { $_.GovernanceRisk -eq "Low" }).Count
$reviewCount = ($results | Where-Object { $_.ReviewRequired -eq $true }).Count
$disabledUserCount = ($results | Where-Object { $_.MemberEnabled -eq $false }).Count
$servicePrincipalCount = ($results | Where-Object { $_.MemberType -eq "#microsoft.graph.servicePrincipal" }).Count
$nestedGroupCount = ($results | Where-Object { $_.MemberType -eq "#microsoft.graph.group" }).Count
$totalDuration = [math]::Round(((Get-Date) - $scriptStartTime).TotalSeconds, 2)

Write-Host "`n[SUMMARY] Group Membership Governance Export" -ForegroundColor Yellow
Write-Host "  Execution ID           : $executionId"
Write-Host "  Groups processed       : $totalGroups"
Write-Host "  Total records          : $totalRecords"
Write-Host "  High governance risk   : $highRiskCount" -ForegroundColor Red
Write-Host "  Medium governance risk : $mediumRiskCount" -ForegroundColor Yellow
Write-Host "  Low governance risk    : $lowRiskCount" -ForegroundColor Green
Write-Host "  Review required        : $reviewCount" -ForegroundColor Yellow
Write-Host "  Disabled users found   : $disabledUserCount" -ForegroundColor Yellow
Write-Host "  Service principals     : $servicePrincipalCount" -ForegroundColor Cyan
Write-Host "  Nested groups          : $nestedGroupCount" -ForegroundColor Cyan
Write-Host "  Duration seconds       : $totalDuration"

if ($reviewCount -gt 0) {
    Write-Host "`n[REVIEW REQUIRED] Membership records requiring governance review:" -ForegroundColor Yellow

    $results |
        Where-Object { $_.ReviewRequired -eq $true } |
        Select-Object GroupName, MemberName, MemberUPN, MemberType, GovernanceRisk, ReviewReason |
        Format-Table -AutoSize
}

Write-Host "`n[INFO] CSV export : $csvFile" -ForegroundColor Green
Write-Host "[INFO] JSON export: $jsonFile" -ForegroundColor Green

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
