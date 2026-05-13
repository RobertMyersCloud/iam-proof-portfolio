# Control Mapping — IAM Automation Scripts

This mapping demonstrates how the IAM automation framework aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements through operational identity governance workflows, lifecycle enforcement, privileged access validation, Conditional Access verification, and audit-ready evidence production. :contentReference[oaicite:0]{index=0}

---

# Governance Control Classification

| Control Type | Implementation |
|---|---|
| Preventative | Conditional Access enforcement, PIM eligible-only assignments |
| Detective | Stale account analysis, privileged role reporting, policy validation |
| Corrective | Automated leaver remediation and session revocation |
| Compensating | Risk classification, governance review, exportable audit evidence |

This layered approach ensures IAM controls are not dependent on a single enforcement mechanism and remain resilient across operational failure scenarios.

---

# NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Script | Implementation |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Get-GroupMembership | Exports group membership for periodic access review and account management evidence |
| AC-2 | Access Control | Account Management | Get-StaleUsers | Identifies inactive accounts requiring review or disablement |
| AC-2 | Access Control | Account Management | Disable-EntraLeaverAccount | Executes account disablement, session revocation, and access removal on offboarding |
| AC-2(2) | Access Control | Removal of Temporary Accounts | Disable-EntraLeaverAccount | Removes access and role assignments for departing users |
| AC-2(3) | Access Control | Disable Inactive Accounts | Get-StaleUsers | Identifies enabled accounts with no sign-in activity beyond defined threshold |
| AC-3 | Access Control | Access Enforcement | Get-GroupMembership | Documents group-based access enforcement model |
| AC-3 | Access Control | Access Enforcement | Get-ConditionalAccessPolicies | Exports enforcement policies controlling all cloud resource access |
| AC-6 | Access Control | Least Privilege | Get-GroupMembership | Supports least privilege validation through group membership analysis |
| AC-6 | Access Control | Least Privilege | Get-StaleUsers | Identifies over-permissioned inactive accounts |
| AC-6 | Access Control | Least Privilege | Get-PIMEligibleAssignments | Documents eligible-only privileged access model |
| AC-6(5) | Access Control | Privileged Accounts | Get-PIMEligibleAssignments | Exports PIM eligible assignments confirming no standing privileged access |
| AC-17 | Access Control | Remote Access | Get-ConditionalAccessPolicies | Documents location-based and MFA-enforced remote access controls |
| IA-2 | Identification & Authentication | Identification and Authentication | Get-ConditionalAccessPolicies | Validates MFA enforcement across Conditional Access policies |
| IA-2 | Identification & Authentication | Identification and Authentication | Get-PIMEligibleAssignments | Documents MFA requirement for privileged role activation |
| IA-2 | Identification & Authentication | Identification and Authentication | Disable-EntraLeaverAccount | Revokes authentication sessions during offboarding |
| CA-7 | Assessment | Continuous Monitoring | Get-ConditionalAccessPolicies | Exports policy enforcement baseline for ongoing monitoring |
| CA-7 | Assessment | Continuous Monitoring | Get-StaleUsers | Supports recurring stale account identification as part of monitoring program |

---

# CMMC Level 2 Practice Mapping

| Practice | Domain | Script | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Get-GroupMembership | Documents authorized user access for access review evidence |
| AC.L2-3.1.2 | Access Control | Get-ConditionalAccessPolicies | Validates access is limited to authorized transactions |
| AC.L2-3.1.5 | Access Control | Get-PIMEligibleAssignments | Confirms least privilege through eligible-only assignment model |
| AC.L2-3.1.6 | Access Control | Get-PIMEligibleAssignments | Documents separation of standard and privileged access |
| AC.L2-3.1.20 | Access Control | Get-ConditionalAccessPolicies | Documents controls on connections to external systems |
| IA.L2-3.5.3 | Identification & Authentication | Get-ConditionalAccessPolicies | Validates MFA enforcement across sign-in policies |
| AU.L2-3.3.1 | Audit | Disable-EntraLeaverAccount | Execution log captures lifecycle actions with timestamps |
| AU.L2-3.3.2 | Audit | Disable-EntraLeaverAccount | All actions attributable to named executor with ticket reference |
| CA.L2-3.12.3 | Assessment | Get-StaleUsers | Supports ongoing monitoring of identity-based access risk |

---

# Script-to-Evidence Mapping

| Script | Evidence Produced | Audit Use |
|---|---|---|
| Get-GroupMembership | Group membership CSV/JSON with member types and enabled status | AC-2 access review evidence, SOC 2 user access review |
| Get-StaleUsers | Stale account CSV/JSON with risk classification and service account flags | AC-2(3) inactive account review and remediation prioritization |
| Get-PIMEligibleAssignments | PIM assignment CSV/JSON with risk tier, permanence, and multi-role detection | AC-6(5) privileged access audit and JIT posture assessment |
| Get-ConditionalAccessPolicies | Conditional Access policy CSV/JSON with enforcement status, MFA detection, and gap analysis | AC-3 / IA-2 enforcement baseline and Zero Trust posture review |
| Disable-EntraLeaverAccount | Execution log CSV/JSON with per-action status, ticket reference, and timestamps | AC-2 lifecycle evidence and offboarding audit trail |

---

# Risk Signal Coverage

| Risk Signal | Detection Script | Control Addressed |
|---|---|---|
| Stale active accounts | Get-StaleUsers (-StaleOnly -EnabledOnly) | AC-2(3) |
| Permanent privileged eligibility | Get-PIMEligibleAssignments (-PermanentOnly) | AC-6(5) |
| Role aggregation risk | Get-PIMEligibleAssignments (MultiRoleEligible field) | AC-6 |
| Conditional Access policies without MFA | Get-ConditionalAccessPolicies (RequiresMFA = False) | IA-2 |
| Conditional Access policies in Report-only mode | Get-ConditionalAccessPolicies (PolicyStrength = Testing) | AC-3 |
| Residual access after offboarding | Disable-EntraLeaverAccount validation step | AC-2 |

---

# Identity Attack Surface Reduction

The automation framework reduces common identity-centric attack paths including:

- dormant credential exposure
- excessive privilege persistence
- privilege aggregation
- stale account compromise
- MFA enforcement gaps
- incomplete offboarding
- unauthorized remote access persistence

This aligns the governance framework with Zero Trust identity protection principles and modern IAM security operations models.

---

# Control Chain Summary

| Step | Action | Control Satisfied |
|---|---|---|
| 1 | Export group membership for access review | AC-2, AC-3 |
| 2 | Identify inactive accounts and classify risk | AC-2(3), AC-6 |
| 3 | Analyze privileged role eligibility and permanence | AC-6(5), IA-2 |
| 4 | Validate Conditional Access enforcement baseline | AC-3, IA-2, CA-7 |
| 5 | Execute leaver workflow with audit logging | AC-2, AU-2 |

This establishes a continuous IAM governance loop:

```text
Access Visibility → Risk Detection → Privilege Validation → Enforcement Verification → Lifecycle Remediation
```

---

# Operational Safety Controls

Automation workflows incorporate operational safeguards including:

- WhatIf validation prior to enforcement actions
- protected account exclusions
- execution logging
- rollback-aware workflow design
- structured error handling
- timestamped audit traceability

Enforcement workflows are specifically designed to reduce:
- accidental administrative lockout
- unintended privilege removal
- destructive lifecycle execution errors

Protected administrative identities and emergency access accounts are excluded from automated remediation actions unless explicitly overridden.

---

# Assessment Narrative

The IAM automation implementation demonstrates a continuously operating identity governance control framework aligned to NIST 800-53 Rev 5 and CMMC Level 2 access control objectives.

Identity governance workflows provide continuous visibility into:
- account status
- privileged role assignment
- Conditional Access enforcement posture
- stale account exposure
- lifecycle remediation state

Access governance controls are operationalized through:
- group-based access validation
- stale account detection
- privileged access analysis
- Conditional Access verification
- automated leaver remediation

The framework establishes preventative, detective, and corrective governance controls operating together as a continuous identity security lifecycle.

All lifecycle actions, governance exports, and remediation activities are logged, attributable, reviewable, and structured for audit evidence production.

This demonstrates that identity governance controls are:
- implemented
- operationalized
- continuously monitored
- audit defensible
- capable of producing repeatable evidence on demand

---

# Control Effectiveness Statement

The implementation demonstrates that identity governance controls are:

| Control Type | Outcome |
|---|---|
| Preventative | Conditional Access and PIM restrict unauthorized actions before they occur |
| Detective | Stale account detection and governance reporting identify risk conditions |
| Corrective | Leaver automation enforces timely removal of access |

All outputs are:
- structured
- repeatable
- attributable
- reviewable
- audit ready

This confirms the IAM control environment functions as an operational governance system rather than a documentation-only exercise.

---

# Governance Outcomes

| Governance Objective | Result |
|---|---|
| Reduce stale account exposure | Automated stale account detection |
| Eliminate standing privileged access | PIM eligible-only governance model |
| Validate Zero Trust enforcement | Conditional Access posture analysis |
| Improve lifecycle accountability | Automated offboarding workflows |
| Produce audit-ready evidence | Structured CSV/JSON governance exports |
| Increase governance visibility | Continuous operational reporting |

---

# Mapping References

- NIST SP 800-53 Rev 5
- NIST SP 800-171 Rev 2
- CMMC Level 2 (32 CFR Part 170)

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

# Scope Note

This implementation demonstrates governance-focused IAM automation workflows operating within a controlled Microsoft Entra ID environment.

The framework is designed to:
- operationalize governance controls
- improve audit readiness
- support lifecycle enforcement
- reduce identity-centric risk
- produce repeatable governance evidence

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
