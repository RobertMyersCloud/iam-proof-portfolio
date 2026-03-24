# IAM Automation Scripts — Microsoft Entra ID

**PowerShell automation suite for Microsoft Entra ID identity governance operations — producing audit-ready evidence, enabling lifecycle enforcement, and supporting access review and privileged access assessment workflows.**

## Executive Summary

This repository demonstrates a complete Identity Governance & Administration (IGA) automation framework for Microsoft Entra ID.

The solution operationalizes core IAM controls across five domains:
- Access governance (who has access)
- Identity lifecycle (who should still have access)
- Privileged access (who has elevated permissions)
- Conditional access enforcement (how access is controlled)
- Lifecycle remediation (how access is removed)

Each script produces audit-ready evidence aligned to NIST 800-53 and CMMC Level 2, transforming governance requirements into executable controls.

This is not a collection of scripts — it is a working IAM control system.

## IAM Control Flow

The scripts are designed to operate as a cohesive control system:

1. **Get-GroupMembership** → establishes baseline access inventory (AC-2, AC-3)
2. **Get-StaleUsers** → identifies lifecycle risk and dormant accounts (AC-2(3))
3. **Get-PIMEligibleAssignments** → evaluates privileged exposure and standing access (AC-6(5))
4. **Get-ConditionalAccessPolicies** → validates enforcement controls and MFA gaps (AC-3, IA-2)
5. **Disable-EntraLeaverAccount** → executes controlled lifecycle remediation (AC-2)

Together, these scripts form a continuous governance loop:

**Detect → Analyze → Validate → Enforce → Remediate**

## Scripts

| Script | Purpose | IAM Domain | Controls |
|---|---|---|---|
| [Get-GroupMembership.ps1](./scripts/Get-GroupMembership.ps1) | Export group membership for access reviews and audit evidence | Access Governance | AC-2, AC-3, AC-6 |
| [Get-StaleUsers.ps1](./scripts/Get-StaleUsers.ps1) | Identify inactive accounts with risk classification | Identity Lifecycle | AC-2, AC-2(3), AC-6 |
| [Get-PIMEligibleAssignments.ps1](./scripts/Get-PIMEligibleAssignments.ps1) | Export and analyze PIM eligible role assignments | Privileged Access | AC-2, AC-6, AC-6(5), IA-2 |
| [Get-ConditionalAccessPolicies.ps1](./scripts/Get-ConditionalAccessPolicies.ps1) | Export CA policy configuration with enforcement analysis | Zero Trust | AC-3, AC-17, IA-2, CA-7 |
| [Disable-EntraLeaverAccount.ps1](./scripts/Disable-EntraLeaverAccount.ps1) | Automate leaver workflow — disable, revoke, remove | Identity Lifecycle | AC-2, AC-2(2), IA-2 |

## Real-World Use Case

In a regulated environment (CMMC / NIST 800-171), an auditor asks:

- Who has access to sensitive systems?
- Which accounts are inactive but still enabled?
- Who has privileged access, and is it justified?
- Are access controls enforced consistently?
- How is access removed when users leave?

This automation pack answers all five questions with structured, exportable evidence, repeatable execution, and audit-defensible outputs.

## Risk Signals Detected

The scripts identify common IAM failure patterns including:

- Stale active accounts — dormant access risk
- Permanent privileged eligibility — standing access risk
- Role aggregation — privilege escalation risk
- Conditional Access gaps — lack of MFA or enforcement
- Incomplete offboarding — residual access risk

These are the same failure modes exploited in real-world identity-based breaches.

## Design Principles

Every script follows these standards:

- **Read-only by default** — reporting scripts never modify data
- **WhatIf support** — destructive scripts require `-WhatIf` preview before execution
- **Structured output** — CSV and JSON exports for direct audit use
- **Risk classification** — results sorted by risk tier, not alphabetically
- **Audit logging** — timestamped execution logs with ticket reference support
- **Safe failure** — errors logged and handled, never silent
- **Protected account guardrails** — leaver script prevents accidental offboarding of break-glass accounts

## Quick Start
```powershell
# Install required modules
Install-Module Microsoft.Graph -Scope CurrentUser

# Preview leaver workflow (always run WhatIf first)
.\scripts\Disable-EntraLeaverAccount.ps1 -UserPrincipalName "user@domain.com" -WhatIf

# Export group membership for access review
.\scripts\Get-GroupMembership.ps1 -GroupName "Finance-ReadOnly"

# Find stale accounts (enabled, 90+ days inactive)
.\scripts\Get-StaleUsers.ps1 -EnabledOnly -StaleOnly

# Export PIM eligible assignments
.\scripts\Get-PIMEligibleAssignments.ps1

# Analyze Conditional Access enforcement baseline
.\scripts\Get-ConditionalAccessPolicies.ps1
```

## Output Files

All scripts export to the current directory by default. Use `-OutputPath` to specify a location.

| Script | CSV Output | JSON Output |
|---|---|---|
| Get-GroupMembership | group-membership-report-[timestamp].csv | group-membership-report-[timestamp].json |
| Get-StaleUsers | stale-users-report-[timestamp].csv | stale-users-report-[timestamp].json |
| Get-PIMEligibleAssignments | pim-eligible-assignments-[timestamp].csv | pim-eligible-assignments-[timestamp].json |
| Get-ConditionalAccessPolicies | conditional-access-policies-[timestamp].csv | conditional-access-policies-[timestamp].json |
| Disable-EntraLeaverAccount | leaver-execution-log-[timestamp].csv | leaver-execution-log-[timestamp].json |

## Control Mapping Summary

| Control | Description | Scripts |
|---|---|---|
| AC-2 | Account Management | Get-GroupMembership, Get-StaleUsers, Disable-EntraLeaverAccount |
| AC-2(2) | Removal of Temporary Accounts | Disable-EntraLeaverAccount |
| AC-2(3) | Disable Inactive Accounts | Get-StaleUsers |
| AC-3 | Access Enforcement | Get-GroupMembership, Get-ConditionalAccessPolicies |
| AC-6 | Least Privilege | Get-GroupMembership, Get-StaleUsers, Get-PIMEligibleAssignments |
| AC-6(5) | Privileged Accounts | Get-PIMEligibleAssignments |
| AC-17 | Remote Access | Get-ConditionalAccessPolicies |
| IA-2 | Identification & Authentication | Get-PIMEligibleAssignments, Get-ConditionalAccessPolicies, Disable-EntraLeaverAccount |
| CA-7 | Continuous Monitoring | Get-ConditionalAccessPolicies |

## Skills Demonstrated

- Identity Governance & Administration (IGA)
- Privileged Access Management (PAM)
- Microsoft Entra ID / Azure AD
- Role-Based Access Control (RBAC)
- Conditional Access & Zero Trust
- Identity Lifecycle Management (JML)
- PowerShell automation using Microsoft Graph
- Audit evidence generation aligned to NIST 800-53 / CMMC Level 2
- Risk classification and control validation

## Pack Contents

| File | Description |
|---|---|
| `scripts/` | Five production-grade PowerShell scripts |
| `sample-output/` | Example CSV outputs showing script results |
| `docs/control-mapping.md` | Detailed NIST / CMMC control mapping |
| `docs/usage-guide.md` | Installation, permissions, and usage reference |
| `resume-bullets.md` | Resume-ready bullet points |

## Interview Value

This pack demonstrates the ability to:

- Automate IAM governance operations using Microsoft Graph PowerShell
- Produce structured, audit-ready evidence for access reviews and compliance assessments
- Implement lifecycle enforcement automation with safety controls and audit logging
- Bridge governance design and technical execution — not just policy, but working code
- Identify and surface real-world IAM risk signals across access, privilege, and enforcement domains

---

*Pack version: v1.0 — March 2026 · Environment: Microsoft Entra ID — rjmyers.cloud tenant*
