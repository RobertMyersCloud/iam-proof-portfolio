# Usage Guide — IAM Automation Scripts

## Prerequisites

### PowerShell Version
PowerShell 7.0 or later recommended. Windows PowerShell 5.1 is supported but
Microsoft Graph module performance is better on PowerShell 7.
```powershell
$PSVersionTable.PSVersion
```

### Module Installation
```powershell
# Install Microsoft Graph (all modules)
Install-Module Microsoft.Graph -Scope CurrentUser

# Or install individual modules only
Install-Module Microsoft.Graph.Users -Scope CurrentUser
Install-Module Microsoft.Graph.Groups -Scope CurrentUser
Install-Module Microsoft.Graph.Identity.Governance -Scope CurrentUser
Install-Module Microsoft.Graph.Identity.SignIns -Scope CurrentUser
Install-Module Microsoft.Graph.Reports -Scope CurrentUser
```

### Required Permissions

| Script | Required Permissions |
|---|---|
| Get-GroupMembership | Group.Read.All, User.Read.All |
| Get-StaleUsers | User.Read.All, AuditLog.Read.All |
| Get-PIMEligibleAssignments | RoleEligibilitySchedule.Read.Directory, RoleManagement.Read.Directory, User.Read.All |
| Get-ConditionalAccessPolicies | Policy.Read.All |
| Disable-EntraLeaverAccount | User.ReadWrite.All, GroupMember.ReadWrite.All, RoleManagement.ReadWrite.Directory |

Assign permissions to a service principal or use delegated access with a licensed admin account.

---

## Execution Model

The scripts are designed to support both audit evidence generation and operational IAM workflows:

- **Read-only scripts** (Get-GroupMembership, Get-StaleUsers, Get-PIMEligibleAssignments, Get-ConditionalAccessPolicies)
  → Used for access reviews, compliance assessments, and control validation

- **Execution scripts** (Disable-EntraLeaverAccount)
  → Used for controlled lifecycle enforcement with full audit logging

Typical usage pattern:

1. Run read-only scripts to identify risk and produce evidence
2. Review results and validate findings
3. Execute remediation using controlled, logged actions
4. Archive outputs as audit evidence

This ensures a closed-loop IAM control process: **detect → validate → remediate → evidence**

---

## Script Usage Reference

### Get-GroupMembership.ps1
```powershell
# Export single group
.\Get-GroupMembership.ps1 -GroupName "Finance-ReadOnly"

# Export all security groups with nested member expansion
.\Get-GroupMembership.ps1 -ExportAll -IncludeTransitive

# Export to specific path
.\Get-GroupMembership.ps1 -GroupName "Finance-ReadOnly" -OutputPath "C:\AuditEvidence"
```

**Key output fields:** GroupName, MemberName, MemberUPN, MemberType, MemberEnabled

---

### Get-StaleUsers.ps1
```powershell
# Default 90-day threshold
.\Get-StaleUsers.ps1

# 60-day threshold, enabled accounts, stale only
.\Get-StaleUsers.ps1 -InactiveDays 60 -EnabledOnly -StaleOnly

# Exclude break-glass accounts
.\Get-StaleUsers.ps1 -ExcludeGroups @("Break-Glass-Accounts") -StaleOnly
```

**Key output fields:** DisplayName, UPN, AccountEnabled, IsServiceAccount, DaysSinceLastSignIn, StaleStatus, RiskLevel

---

### Get-PIMEligibleAssignments.ps1
```powershell
# Export all eligible assignments
.\Get-PIMEligibleAssignments.ps1

# Filter to specific role
.\Get-PIMEligibleAssignments.ps1 -RoleName "Security Reader"

# Export only permanent assignments
.\Get-PIMEligibleAssignments.ps1 -PermanentOnly
```

**Key output fields:** PrincipalName, PrincipalUPN, RoleName, ActivationModel, IsPermanent, DaysEligible, RiskLevel, MultiRoleEligible

---

### Get-ConditionalAccessPolicies.ps1
```powershell
# Export all policies
.\Get-ConditionalAccessPolicies.ps1

# Export only enabled policies
.\Get-ConditionalAccessPolicies.ps1 -State Enabled

# Export to specific path
.\Get-ConditionalAccessPolicies.ps1 -OutputPath "C:\AuditEvidence"
```

**Key output fields:** PolicyName, EnforcementStatus, PolicyStrength, RequiresMFA, PrivilegedScope, CoverageNote

---

### Disable-EntraLeaverAccount.ps1
```powershell
# ALWAYS run WhatIf first
.\Disable-EntraLeaverAccount.ps1 -UserPrincipalName "user@domain.com" -WhatIf

# Execute with ticket reference and protected account guardrail
.\Disable-EntraLeaverAccount.ps1 `
    -UserPrincipalName "user@domain.com" `
    -TicketReference "CHG-2026-0342" `
    -ProtectedAccounts @("breakglass@domain.com")

# Multiple users
.\Disable-EntraLeaverAccount.ps1 `
    -UserPrincipalName @("user1@domain.com","user2@domain.com") `
    -TicketReference "CHG-2026-0343"
```

**Key output fields:** Timestamp, UPN, Action, Status, Detail, TicketReference, ExecutionMode

⚠️ Always run with `-WhatIf` before executing. Review output carefully.

---

## Common IAM Failure Scenarios

These scripts help identify and address common identity failures:

- **Dormant accounts remain enabled** → detected by Get-StaleUsers
- **Privilege accumulation across roles** → detected by Get-PIMEligibleAssignments
- **Lack of MFA enforcement** → detected by Get-ConditionalAccessPolicies
- **Unreviewed group membership growth** → detected by Get-GroupMembership
- **Incomplete offboarding** → remediated by Disable-EntraLeaverAccount

These patterns represent real-world attack paths exploited in identity-based breaches.

---

## Security Considerations

- Always use least-privilege permissions when running scripts — avoid Global Administrator where possible
- Store output files in secure locations — reports may contain sensitive identity data
- Protect execution logs — leaver workflow logs contain user activity and access changes
- Use service principals with scoped permissions for automation scenarios
- Validate Conditional Access and PIM changes in test environments before production use

---

## Automation Extension

These scripts can be integrated into automated workflows:

- Scheduled execution via Azure Automation or Task Scheduler
- Integration with ticketing systems (ServiceNow, Jira) using the TicketReference field
- Export ingestion into SIEM or GRC platforms for continuous monitoring
- CI/CD-style validation for Conditional Access and PIM configurations

This enables continuous IAM governance rather than periodic manual reviews.

---

## Operational Notes

**Service account false positives**
Get-StaleUsers flags accounts matching `svc|service|admin` UPN patterns as service accounts.
Review `IsServiceAccount = True` results before taking remediation action.

**PIM multi-role detection**
Get-PIMEligibleAssignments sets `MultiRoleEligible = True` for users with more than one
eligible role. These users represent elevated privilege aggregation risk and should be
reviewed for business justification.

**CA Report-only policies**
Get-ConditionalAccessPolicies classifies Report-only policies as `PolicyStrength = Testing`.
These are evaluating but not enforcing. Transition requires impact analysis before enabling.

**Leaver script execution order**
Disable account → validate state → revoke sessions → remove group memberships → remove
role assignments. If any step fails, the error is logged and execution continues. Review
the execution log before closing the ticket.

---

## Troubleshooting

**Authentication failures**
- Ensure required Graph scopes are granted
- Reconnect using `Connect-MgGraph -Scopes "..."`

**Missing sign-in data**
- Verify AuditLog.Read.All permission is granted
- Note: signInActivity requires Entra ID P1 or P2 licensing

**PIM data not returned**
- Confirm RoleManagement.Read.Directory permission
- Verify tenant has PIM enabled (requires P2 license)

**Permission errors during execution**
- Run `Get-MgContext` to confirm active scopes
- Reconnect with correct permissions if scopes are missing

---

*Usage Guide v1.0 — March 2026*
