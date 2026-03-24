<#
.SYNOPSIS
    Exports group membership for one or all Entra ID security groups.

.DESCRIPTION
    Retrieves group membership from Microsoft Entra ID and exports results
    to CSV and JSON for use in access reviews, audit evidence, and compliance
    reporting. Supports single group or all-groups export mode, with optional
    transitive (nested group) member expansion.

    Output is designed for direct use as AC-2 / AC-3 access review evidence.
    Handles users, service principals, nested groups, and unknown object types.

.PARAMETER GroupName
    Name of a specific group to export. If omitted, use -ExportAll.

.PARAMETER OutputPath
    Path for output files. Defaults to current directory. Created if not exists.

.PARAMETER ExportAll
    Switch to export all security groups in the tenant.

.PARAMETER IncludeTransitive
    Switch to include nested group members (transitive membership expansion).

.EXAMPLE
    # Export single group
    .\Get-GroupMembership.ps1 -GroupName "Finance-ReadOnly"

    # Export all security groups with nested member expansion
    .\Get-GroupMembership.ps1 -ExportAll -IncludeTransitive

    # Export to specific path
    .\Get-GroupMembership.ps1 -GroupName "Finance-ReadOnly" -OutputPath "C:\Reports"

.NOTES
    Required modules: Microsoft.Graph.Groups, Microsoft.Graph.Users
    Required permissions: Group.Read.All, User.Read.All
    Author: Robert J. Myers
    Version: 1.1
    Date: 2026-03-24
    Control mapping: AC-2, AC-3, AC-6
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

$requiredModules = @("Microsoft.Graph.Groups", "Microsoft.Graph.Users")
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
    Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All" -NoWelcome
    Write-Host "[INFO] Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# ── Get Groups ────────────────────────────────────────────────────────────────

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$results = @()

try {
    if ($ExportAll) {
        Write-Host "[INFO] Retrieving all security groups..." -ForegroundColor Cyan
        $groups = Get-MgGroup -Filter "securityEnabled eq true" -All
    }
    elseif ($GroupName) {
        Write-Host "[INFO] Retrieving group: $GroupName" -ForegroundColor Cyan
        $groups = Get-MgGroup -Filter "displayName eq '$GroupName'" -All
        if (-not $groups) {
            Write-Error "Group not found: $GroupName"
            Disconnect-MgGraph | Out-Null
            exit 1
        }
    }
    else {
        Write-Error "Specify -GroupName or use -ExportAll"
        Disconnect-MgGraph | Out-Null
        exit 1
    }

    Write-Host "[INFO] Found $($groups.Count) group(s). Retrieving members..." -ForegroundColor Cyan

    foreach ($group in $groups) {

        if ($IncludeTransitive) {
            $members = Get-MgGroupTransitiveMember -GroupId $group.Id -All
        }
        else {
            $members = Get-MgGroupMember -GroupId $group.Id -All
        }

        if ($members.Count -eq 0) {
            $results += [PSCustomObject]@{
                GroupName     = $group.DisplayName
                GroupId       = $group.Id
                MemberName    = "No members"
                MemberUPN     = ""
                MemberType    = ""
                MemberEnabled = ""
                ExportDate    = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            }
        }
        else {
            foreach ($member in $members) {

                $memberType = $member.AdditionalProperties["@odata.type"]
                $displayName = ""
                $upn = ""
                $enabled = ""

                if ($memberType -eq "#microsoft.graph.user") {
                    $user = Get-MgUser -UserId $member.Id -ErrorAction SilentlyContinue
                    $displayName = $user.DisplayName
                    $upn = $user.UserPrincipalName
                    $enabled = $user.AccountEnabled
                }
                elseif ($memberType -eq "#microsoft.graph.servicePrincipal") {
                    $displayName = $member.AdditionalProperties["displayName"]
                    $upn = "ServicePrincipal"
                    $enabled = "N/A"
                }
                elseif ($memberType -eq "#microsoft.graph.group") {
                    $displayName = $member.AdditionalProperties["displayName"]
                    $upn = "NestedGroup"
                    $enabled = "N/A"
                }
                else {
                    $displayName = $member.AdditionalProperties["displayName"]
                    $upn = "Unknown"
                    $enabled = "N/A"
                }

                $results += [PSCustomObject]@{
                    GroupName     = $group.DisplayName
                    GroupId       = $group.Id
                    MemberName    = $displayName
                    MemberUPN     = $upn
                    MemberType    = $memberType
                    MemberEnabled = $enabled
                    ExportDate    = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                }
            }
        }
    }
}
catch {
    Write-Error "Error retrieving group membership: $_"
    Disconnect-MgGraph | Out-Null
    exit 1
}

# ── Export ────────────────────────────────────────────────────────────────────

$csvFile  = Join-Path $OutputPath "group-membership-report-$timestamp.csv"
$jsonFile = Join-Path $OutputPath "group-membership-report-$timestamp.json"

$results | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$results | ConvertTo-Json -Depth 3 | Out-File $jsonFile -Encoding UTF8

# ── Summary ───────────────────────────────────────────────────────────────────

$summary = $results | Group-Object GroupName | Select-Object Name, Count

Write-Host "`n[SUMMARY] Group Membership Counts:" -ForegroundColor Yellow
$summary | Format-Table -AutoSize

Write-Host "[INFO] CSV export:  $csvFile" -ForegroundColor Green
Write-Host "[INFO] JSON export: $jsonFile" -ForegroundColor Green
Write-Host "[INFO] Total records: $($results.Count)" -ForegroundColor Green

# ── Disconnect ────────────────────────────────────────────────────────────────

Disconnect-MgGraph | Out-Null
Write-Host "[INFO] Disconnected from Microsoft Graph." -ForegroundColor Cyan
