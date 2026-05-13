# Usage Guide — IAM Automation Scripts

This guide provides installation requirements, execution procedures, operational safeguards, and governance usage guidance for the IAM automation framework. :contentReference[oaicite:0]{index=0}

The automation workflows are designed to support:
- IAM governance operations
- audit evidence production
- lifecycle enforcement
- privileged access validation
- Conditional Access posture verification
- continuous identity monitoring

---

# Prerequisites

## PowerShell Version

PowerShell 7.0 or later is recommended.

Windows PowerShell 5.1 is supported, but Microsoft Graph module performance and compatibility are improved on PowerShell 7.

Verify version:

```powershell
$PSVersionTable.PSVersion
```

---

# Module Installation

## Install Full Microsoft Graph SDK

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

---

## Install Individual Modules Only

```powershell
Install-Module Microsoft.Graph.Users -Scope CurrentUser
Install-Module Microsoft.Graph.Groups -Scope CurrentUser
Install-Module Microsoft.Graph.Identity.Governance -Scope CurrentUser
Install-Module Microsoft.Graph.Identity.SignIns -Scope CurrentUser
Install-Module Microsoft.Graph.Reports -Scope CurrentUser
```

---

# Required Permissions

| Script | Required Permissions |
|---|---|
| Get-GroupMembership | Group.Read.All, User.Read.All |
| Get-StaleUsers | User.Read.All, AuditLog.Read.All |
| Get-PIMEligibleAssignments | RoleEligibilitySchedule.Read.Directory, RoleManagement.Read.Directory, User.Read.All |
| Get-ConditionalAccessPolicies | Policy.Read.All |
| Disable-EntraLeaverAccount | User.ReadWrite.All, GroupMember.ReadWrite.All, RoleManagement.ReadWrite.Directory |

Use:
- delegated administrative access
- or scoped service principals

where possible.

Avoid unnecessary Global Administrator usage.

---

# Governance Execution Model

The automation workflows support both:
- governance evidence generation
- operational IAM enforcement

## Read-Only Governance Workflows

The following workflows are non-destructive:

- Get-GroupMembership
- Get-StaleUsers
- Get-PIMEligibleAssignments
- Get-ConditionalAccessPolicies

Primary uses:
- access reviews
- governance reporting
- compliance assessments
- risk identification
- control validation

---

## Enforcement Workflow

The following workflow performs remediation actions:

- Disable-EntraLeaverAccount

Primary uses:
- offboarding
- lifecycle remediation
- session revocation
- access removal

---

# Standard IAM Governance Workflow

Typical governance execution flow:

```text
Detect → Validate → Remediate → Evidence
```

1. Execute read-only governance workflows
2. Review findings and validate risk conditions
3. Execute controlled remediation actions
4. Archive outputs as audit evidence

This establishes a closed-loop IAM governance process supporting:
- continuous monitoring
- lifecycle accountability
- audit readiness
- identity risk reduction

---

# Script Usage Reference

---

# Get-GroupMembership.ps1

## Export Single Group

```powershell
.\Get-GroupMembership.ps1 -GroupName "Finance-ReadOnly"
```

---

## Export All Security Groups with Nested Expansion

```powershell
.\Get-GroupMembership.ps1 -ExportAll -IncludeTransitive
```

---

## Export to Specific Path

```powershell
.\Get-GroupMembership.ps1 `
-GroupName "Finance-ReadOnly" `
-OutputPath "C:\AuditEvidence"
```

---

## Key Output Fields

| Field | Description |
|---|---|
| GroupName | Target group |
| MemberName | Display name |
| MemberUPN | User principal name |
| MemberType | User, Group, Service Principal |
| MemberEnabled | Account enabled state |

---

# Get-StaleUsers.ps1

## Default 90-Day Threshold

```powershell
.\Get-StaleUsers.ps1
```

---

## 60-Day Threshold — Enabled Accounts Only

```powershell
.\Get-StaleUsers.ps1 `
-InactiveDays 60 `
-EnabledOnly `
-StaleOnly
```

---

## Exclude Break-Glass Accounts

```powershell
.\Get-StaleUsers.ps1 `
-ExcludeGroups @("Break-Glass-Accounts") `
-StaleOnly
```

---

## Key Output Fields

| Field | Description |
|---|---|
| DisplayName | User display name |
| UPN | User principal name |
| AccountEnabled | Enabled state |
| IsServiceAccount | Service account detection |
| DaysSinceLastSignIn | Inactivity duration |
| StaleStatus | Stale or Active |
| RiskLevel | Governance risk classification |

---

# Get-PIMEligibleAssignments.ps1

## Export All Eligible Assignments

```powershell
.\Get-PIMEligibleAssignments.ps1
```

---

## Filter to Specific Role

```powershell
.\Get-PIMEligibleAssignments.ps1 `
-RoleName "Security Reader"
```

---

## Export Permanent Assignments Only

```powershell
.\Get-PIMEligibleAssignments.ps1 `
-PermanentOnly
```

---

## Key Output Fields

| Field | Description |
|---|---|
| PrincipalName | User display name |
| PrincipalUPN | User principal name |
| RoleName | Eligible role |
| ActivationModel | Eligible vs Active |
| IsPermanent | Permanent eligibility state |
| DaysEligible | Assignment duration |
| RiskLevel | Governance risk tier |
| MultiRoleEligible | Multiple role aggregation indicator |

---

# Get-ConditionalAccessPolicies.ps1

## Export All Policies

```powershell
.\Get-ConditionalAccessPolicies.ps1
```

---

## Export Enabled Policies Only

```powershell
.\Get-ConditionalAccessPolicies.ps1 `
-State Enabled
```

---

## Export to Specific Path

```powershell
.\Get-ConditionalAccessPolicies.ps1 `
-OutputPath "C:\AuditEvidence"
```

---

## Key Output Fields

| Field | Description |
|---|---|
| PolicyName | Conditional Access policy |
| EnforcementStatus | Enabled, Disabled, Report-only |
| PolicyStrength | Governance classification |
| RequiresMFA | MFA enforcement status |
| PrivilegedScope | Administrative scope detection |
| CoverageNote | Enforcement notes |

---

# Disable-EntraLeaverAccount.ps1

## ALWAYS Run WhatIf First

```powershell
.\Disable-EntraLeaverAccount.ps1 `
-UserPrincipalName "user@domain.com" `
-WhatIf
```

---

## Execute Controlled Offboarding Workflow

```powershell
.\Disable-EntraLeaverAccount.ps1 `
-UserPrincipalName "user@domain.com" `
-TicketReference "CHG-2026-0342" `
-ProtectedAccounts @("breakglass@domain.com")
```

---

## Multiple User Remediation

```powershell
.\Disable-EntraLeaverAccount.ps1 `
-UserPrincipalName @(
"user1@domain.com",
"user2@domain.com"
) `
-TicketReference "CHG-2026-0343"
```

---

## Key Output Fields

| Field | Description |
|---|---|
| Timestamp | Execution timestamp |
| UPN | Target account |
| Action | Executed workflow step |
| Status | Success or failure |
| Detail | Additional execution details |
| TicketReference | Change ticket linkage |
| ExecutionMode | WhatIf or Execute |

---

# Operational Safety Controls

The framework incorporates operational safeguards including:

- WhatIf validation
- protected account exclusions
- structured execution logging
- rollback-aware workflow design
- non-destructive validation workflows
- timestamped audit traceability

These controls reduce risk associated with:
- accidental administrative lockout
- unintended privilege removal
- destructive lifecycle execution errors

Protected administrative identities and emergency access accounts should always be excluded from automated remediation actions unless explicitly authorized.

---

# Common IAM Failure Scenarios

These workflows help identify and remediate common identity-centric governance failures.

| Failure Scenario | Detection / Remediation |
|---|---|
| Dormant accounts remain enabled | Get-StaleUsers |
| Privilege accumulation across roles | Get-PIMEligibleAssignments |
| Lack of MFA enforcement | Get-ConditionalAccessPolicies |
| Unreviewed group membership growth | Get-GroupMembership |
| Incomplete offboarding | Disable-EntraLeaverAccount |

These conditions represent common attack paths associated with identity compromise and governance breakdown.

---

# Security Considerations

- Use least-privilege permissions whenever possible
- Avoid Global Administrator unless operationally required
- Store exports in secure locations
- Protect lifecycle execution logs
- Validate policy changes before production deployment
- Use service principals with scoped permissions for automation scenarios
- Review outputs prior to remediation execution

Governance exports may contain:
- sensitive identity data
- role assignments
- access relationships
- enforcement configurations

Treat outputs as controlled governance artifacts.

---

# Automation Extension Opportunities

The workflows support integration into broader governance operations.

Possible integrations include:
- Azure Automation
- scheduled execution
- ServiceNow ticketing
- Jira workflows
- SIEM ingestion
- GRC evidence pipelines
- governance dashboards

This enables continuous IAM governance rather than periodic manual review cycles.

---

# Operational Notes

## Service Account Detection

Get-StaleUsers flags accounts matching:
- svc
- service
- admin

UPN naming patterns as potential service accounts.

Review:
```text
IsServiceAccount = True
```

prior to remediation.

---

## Multi-Role Privilege Detection

Get-PIMEligibleAssignments sets:

```text
MultiRoleEligible = True
```

when users maintain multiple eligible privileged roles.

These identities represent elevated privilege aggregation risk and should be reviewed for:
- business justification
- excessive privilege persistence
- role rationalization

---

## Report-Only Conditional Access Policies

Get-ConditionalAccessPolicies classifies Report-only policies as:

```text
PolicyStrength = Testing
```

These policies evaluate sign-ins but do not enforce controls.

Transition to enforcement should include:
- What If analysis
- sign-in log review
- impact validation
- break-glass testing

---

## Leaver Workflow Execution Order

The remediation workflow executes in this order:

```text
Disable Account
→ Validate State
→ Revoke Sessions
→ Remove Group Memberships
→ Remove Role Assignments
```

If a step fails:
- execution continues
- the error is logged
- remediation evidence remains preserved

Always review execution logs before ticket closure.

---

# Troubleshooting

## Authentication Failures

Verify:
- required Graph scopes are granted
- the session is authenticated properly

Reconnect using:

```powershell
Connect-MgGraph -Scopes "..."
```

---

## Missing Sign-In Data

Verify:
- AuditLog.Read.All permission
- Entra ID P1 or P2 licensing

signInActivity requires premium licensing.

---

## PIM Data Not Returned

Verify:
- RoleManagement.Read.Directory permission
- PIM is enabled within the tenant
- Entra ID P2 licensing exists

---

## Permission Errors During Execution

Validate active scopes:

```powershell
Get-MgContext
```

Reconnect with required permissions if scopes are missing.

---

# Governance Alignment

This framework supports governance concepts aligned to:

- NIST SP 800-53 Rev 5
- NIST SP 800-171
- CMMC Level 2
- SOC 2 Type II
- Zero Trust governance principles

---

# Usage Guide Metadata

Usage Guide v1.0 — March 2026

Environment:
- Microsoft Entra ID
- Microsoft Graph PowerShell SDK
- rjmyers.cloud tenant

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
