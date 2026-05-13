# IAM Automation Scripts — Microsoft Entra ID

**PowerShell governance automation framework for Microsoft Entra ID identity governance operations — producing audit-ready evidence, supporting lifecycle enforcement, validating privileged access governance, and operationalizing IAM controls within regulated environments.**

---

# Executive Summary

This repository demonstrates a complete Identity Governance & Administration (IGA) automation framework for Microsoft Entra ID.

The framework operationalizes core IAM governance controls across five domains:

- Access Governance
- Identity Lifecycle Management
- Privileged Access Governance
- Conditional Access Enforcement
- Lifecycle Remediation

Each automation workflow produces structured, audit-ready evidence aligned to:
- NIST 800-53 Rev 5
- NIST SP 800-171
- CMMC Level 2
- Zero Trust governance concepts

This is not a collection of scripts.

This is a working IAM governance control system designed to support operational identity governance, compliance validation, lifecycle enforcement, and continuous access review workflows.

---

# Governance Operations Model

The automation framework supports recurring IAM governance operations including:

- quarterly access reviews
- stale account analysis
- privileged access validation
- Conditional Access baseline verification
- lifecycle remediation workflows
- audit evidence generation

Outputs are structured for:
- governance review
- compliance assessment support
- operational reporting
- access certification activities
- audit evidence retention

---

# IAM Control Flow

The automation workflows are designed to operate as a continuous governance loop:

```text
Detect → Analyze → Validate → Enforce → Remediate
```

| Workflow | Governance Objective | Controls |
|---|---|---|
| Get-GroupMembership | Establish access inventory baseline | AC-2, AC-3 |
| Get-StaleUsers | Detect dormant account exposure | AC-2(3), AC-6 |
| Get-PIMEligibleAssignments | Validate privileged access governance | AC-6(5), IA-2 |
| Get-ConditionalAccessPolicies | Validate Zero Trust enforcement posture | AC-3, IA-2, CA-7 |
| Disable-EntraLeaverAccount | Execute lifecycle remediation | AC-2, AC-2(2), IA-2 |

Together these workflows support:
- access governance
- privilege governance
- lifecycle accountability
- audit readiness
- continuous monitoring

---

# Identity Risk Reduction Objectives

The framework is designed to reduce:

- dormant account exposure
- orphaned account persistence
- standing privileged access
- excessive entitlement accumulation
- Conditional Access enforcement gaps
- audit visibility limitations
- lifecycle remediation delays

These conditions represent common IAM failure patterns associated with real-world identity compromise and governance breakdown.

---

# Scripts

| Script | Purpose | IAM Domain | Controls |
|---|---|---|---|
| Get-GroupMembership.ps1 | Export group membership for access reviews and governance evidence | Access Governance | AC-2, AC-3, AC-6 |
| Get-StaleUsers.ps1 | Identify inactive accounts with risk classification | Identity Lifecycle | AC-2, AC-2(3), AC-6 |
| Get-PIMEligibleAssignments.ps1 | Export and analyze PIM eligible role assignments | Privileged Access | AC-2, AC-6, AC-6(5), IA-2 |
| Get-ConditionalAccessPolicies.ps1 | Export Conditional Access configuration with enforcement analysis | Zero Trust | AC-3, AC-17, IA-2, CA-7 |
| Disable-EntraLeaverAccount.ps1 | Execute lifecycle remediation workflow — disable, revoke, remove | Identity Lifecycle | AC-2, AC-2(2), IA-2 |

---

# Real-World Governance Use Case

In a regulated environment aligned to:
- CMMC
- NIST 800-171
- NIST 800-53
- SOC 2

an auditor or governance reviewer may ask:

- Who currently has access to sensitive systems?
- Which accounts remain enabled despite inactivity?
- Who maintains privileged access and is it justified?
- Are Conditional Access policies consistently enforced?
- How is access removed during offboarding?

This automation framework answers those questions through:
- structured exports
- repeatable governance workflows
- operational evidence generation
- lifecycle enforcement automation
- audit-defensible outputs

---

# Risk Signals Detected

The automation workflows identify common IAM governance risks including:

| Risk Signal | Governance Concern |
|---|---|
| Dormant enabled accounts | Residual access exposure |
| Standing privileged eligibility | Excessive administrative persistence |
| Role aggregation | Privilege escalation risk |
| Conditional Access gaps | MFA and enforcement weakness |
| Incomplete offboarding | Orphaned account persistence |
| Excessive entitlement accumulation | Least privilege violation |

These represent common identity-centric attack paths and governance failure conditions.

---

# Operational Safety Controls

Automation workflows include:

- WhatIf validation prior to enforcement actions
- protected account exclusions
- structured error handling
- execution logging
- rollback-aware execution design
- audit traceability for remediation activities

Lifecycle remediation actions are designed to reduce:
- accidental administrative lockout
- unintended privilege removal
- governance workflow disruption

The Disable-EntraLeaverAccount workflow specifically prevents accidental remediation of:
- break-glass accounts
- emergency access identities
- protected administrative accounts

---

# Design Principles

Every workflow follows these governance and engineering standards:

| Principle | Implementation |
|---|---|
| Read-only by default | Reporting workflows never modify tenant state |
| WhatIf validation | Enforcement actions require preview support |
| Structured output | CSV and JSON exports for governance evidence |
| Risk classification | Results organized by operational risk |
| Audit logging | Timestamped execution records |
| Safe failure | Errors handled and logged explicitly |
| Governance traceability | Outputs attributable and reviewable |

---

# Quick Start

## Install Required Modules

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

---

## Preview Lifecycle Remediation (Always Use WhatIf First)

```powershell
.\scripts\Disable-EntraLeaverAccount.ps1 `
-UserPrincipalName "user@domain.com" `
-WhatIf
```

---

## Export Group Membership

```powershell
.\scripts\Get-GroupMembership.ps1 `
-GroupName "Finance-ReadOnly"
```

---

## Identify Dormant Accounts

```powershell
.\scripts\Get-StaleUsers.ps1 `
-EnabledOnly `
-StaleOnly
```

---

## Export PIM Eligible Assignments

```powershell
.\scripts\Get-PIMEligibleAssignments.ps1
```

---

## Analyze Conditional Access Enforcement

```powershell
.\scripts\Get-ConditionalAccessPolicies.ps1
```

---

# Output Files

All workflows export to the current directory by default.

Use:

```powershell
-OutputPath
```

to specify a custom export location.

| Workflow | CSV Output | JSON Output |
|---|---|---|
| Get-GroupMembership | group-membership-report-[timestamp].csv | group-membership-report-[timestamp].json |
| Get-StaleUsers | stale-users-report-[timestamp].csv | stale-users-report-[timestamp].json |
| Get-PIMEligibleAssignments | pim-eligible-assignments-[timestamp].csv | pim-eligible-assignments-[timestamp].json |
| Get-ConditionalAccessPolicies | conditional-access-policies-[timestamp].csv | conditional-access-policies-[timestamp].json |
| Disable-EntraLeaverAccount | leaver-execution-log-[timestamp].csv | leaver-execution-log-[timestamp].json |

---

# Control Mapping Summary

| Control | Description | Workflows |
|---|---|---|
| AC-2 | Account Management | Get-GroupMembership, Get-StaleUsers, Disable-EntraLeaverAccount |
| AC-2(2) | Removal of Temporary / Emergency Accounts | Disable-EntraLeaverAccount |
| AC-2(3) | Disable Inactive Accounts | Get-StaleUsers |
| AC-3 | Access Enforcement | Get-GroupMembership, Get-ConditionalAccessPolicies |
| AC-6 | Least Privilege | Get-GroupMembership, Get-StaleUsers, Get-PIMEligibleAssignments |
| AC-6(5) | Privileged Accounts | Get-PIMEligibleAssignments |
| AC-17 | Remote Access | Get-ConditionalAccessPolicies |
| IA-2 | Identification & Authentication | Get-PIMEligibleAssignments, Get-ConditionalAccessPolicies, Disable-EntraLeaverAccount |
| CA-7 | Continuous Monitoring | Get-ConditionalAccessPolicies |

---

# Skills Demonstrated

- Identity Governance & Administration (IGA)
- Privileged Access Management (PAM)
- Microsoft Entra ID / Azure AD
- Role-Based Access Control (RBAC)
- Conditional Access & Zero Trust
- Identity Lifecycle Management (JML)
- Microsoft Graph PowerShell automation
- Governance evidence generation
- Lifecycle remediation automation
- Access governance operations
- Risk classification and governance validation
- NIST 800-53 / CMMC Level 2 governance alignment

---

# Pack Contents

| File | Description |
|---|---|
| scripts/ | Five governance automation workflows |
| sample-output/ | Example governance exports and evidence |
| docs/control-mapping.md | Detailed NIST / CMMC control mapping |
| docs/usage-guide.md | Installation, permissions, and operational guidance |
| resume-bullets.md | Resume-ready IAM governance bullets |
| interview-questions.md | IAM and governance interview support |

---

# Interview Value

This pack demonstrates the ability to:

- Automate IAM governance operations using Microsoft Graph PowerShell
- Produce structured, audit-ready governance evidence
- Execute lifecycle remediation workflows with operational safeguards
- Validate privileged access governance and Conditional Access posture
- Detect real-world IAM risk signals across access, privilege, and lifecycle domains
- Bridge governance architecture with operational execution

This directly supports discussions around:
- IAM Engineering
- IGA Operations
- Governance Automation
- Identity Security Operations
- PAM Operations
- Access Governance

---

# Governance Alignment

This implementation aligns to:

- NIST SP 800-53 Rev 5
- NIST SP 800-171
- CMMC Level 2
- SOC 2 Type II (CC6)
- CISA Zero Trust Maturity Model

---

# Related Framework Alignment

The controls mapped above support governance concepts commonly associated with:

- SOC 2 Common Criteria (CC6 / CC7)
- ISO 27001 Annex A
- Zero Trust identity governance
- regulated-environment audit accountability
- least privilege governance operations

Expanded cross-framework traceability is planned for future evidence-production packs.

---

# Environment

- Microsoft Entra ID
- Microsoft Graph PowerShell SDK
- Governance-focused IAM operating model
- Controlled regulated-environment lab
- rjmyers.cloud tenant

Pack version: v1.0 — March 2026

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
