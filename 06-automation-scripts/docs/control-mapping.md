# Control Mapping — IAM Automation Scripts

This mapping demonstrates how the IAM automation scripts align to NIST 800-53 Rev 5
and CMMC Level 2 requirements, with direct linkage to script functionality and output.

## NIST 800-53 / CMMC Level 2 Mapping

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
| AC-6(5) | Access Control | Privileged Accounts | Get-PIMEligibleAssignments | Exports PIM eligible assignments — confirms no standing privileged access |
| AC-17 | Access Control | Remote Access | Get-ConditionalAccessPolicies | Documents location-based and MFA-enforced remote access controls |
| IA-2 | Identification & Auth | Identification and Authentication | Get-ConditionalAccessPolicies | Validates MFA enforcement across Conditional Access policies |
| IA-2 | Identification & Auth | Identification and Authentication | Get-PIMEligibleAssignments | Documents MFA requirement for privileged role activation |
| IA-2 | Identification & Auth | Identification and Authentication | Disable-EntraLeaverAccount | Revokes authentication sessions on offboarding |
| CA-7 | Assessment | Continuous Monitoring | Get-ConditionalAccessPolicies | Exports policy enforcement baseline for ongoing monitoring |
| CA-7 | Assessment | Continuous Monitoring | Get-StaleUsers | Supports recurring stale account identification as part of monitoring program |

## CMMC Level 2 Practice Mapping

| Practice | Domain | Script | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Get-GroupMembership | Documents authorized user access for access review evidence |
| AC.L2-3.1.2 | Access Control | Get-ConditionalAccessPolicies | Validates access is limited to authorized transactions |
| AC.L2-3.1.5 | Access Control | Get-PIMEligibleAssignments | Confirms least privilege through eligible-only assignment model |
| AC.L2-3.1.6 | Access Control | Get-PIMEligibleAssignments | Documents separation of standard and privileged access |
| AC.L2-3.1.20 | Access Control | Get-ConditionalAccessPolicies | Documents controls on connections to external systems |
| IA.L2-3.5.3 | Identification & Auth | Get-ConditionalAccessPolicies | Validates MFA enforcement across all sign-in policies |
| AU.L2-3.3.1 | Audit | Disable-EntraLeaverAccount | Execution log captures all lifecycle actions with timestamps |
| AU.L2-3.3.2 | Audit | Disable-EntraLeaverAccount | All actions attributed to named executor with ticket reference |
| CA.L2-3.12.3 | Assessment | Get-StaleUsers | Supports ongoing monitoring of identity-based access risk |

## Script-to-Evidence Mapping

| Script | Evidence Produced | Audit Use |
|---|---|---|
| Get-GroupMembership | Group membership CSV/JSON with member types and enabled status | AC-2 access review evidence, SOC 2 user access review |
| Get-StaleUsers | Stale account CSV/JSON with risk classification and service account flags | AC-2(3) inactive account review, remediation prioritization |
| Get-PIMEligibleAssignments | PIM assignment CSV/JSON with risk tier, permanence, and multi-role detection | AC-6(5) privileged access audit, JIT posture assessment |
| Get-ConditionalAccessPolicies | CA policy CSV/JSON with enforcement status, MFA detection, and gap analysis | AC-3 / IA-2 enforcement baseline, Zero Trust posture review |
| Disable-EntraLeaverAccount | Execution log CSV/JSON with per-action status, ticket reference, and timestamps | AC-2 leaver lifecycle evidence, offboarding audit trail |

## Risk Signal Coverage

| Risk Signal | Detection Script | Control Addressed |
|---|---|---|
| Stale active accounts | Get-StaleUsers (-StaleOnly -EnabledOnly) | AC-2(3) |
| Permanent privileged eligibility | Get-PIMEligibleAssignments (-PermanentOnly) | AC-6(5) |
| Role aggregation risk | Get-PIMEligibleAssignments (MultiRoleEligible field) | AC-6 |
| CA policies without MFA | Get-ConditionalAccessPolicies (RequiresMFA = False) | IA-2 |
| CA policies in Report-only | Get-ConditionalAccessPolicies (PolicyStrength = Testing) | AC-3 |
| Residual access after offboarding | Disable-EntraLeaverAccount (validation step) | AC-2 |

## Control Chain Summary

| Step | Action | Control Satisfied |
|---|---|---|
| 1 | Export group membership for access review | AC-2, AC-3 |
| 2 | Identify inactive accounts and classify risk | AC-2(3), AC-6 |
| 3 | Analyze privileged role eligibility and permanence | AC-6(5), IA-2 |
| 4 | Validate Conditional Access enforcement baseline | AC-3, IA-2, CA-7 |
| 5 | Execute leaver workflow with audit logging | AC-2, AU-2 |

This establishes a continuous IAM governance loop:

**Access visibility → Risk detection → Privilege validation → Enforcement verification → Lifecycle remediation**

## Assessment Narrative

The IAM automation implementation demonstrates a fully operational identity governance control framework aligned to NIST 800-53 and CMMC Level 2 requirements.

Access is continuously monitored through group membership and stale account detection, ensuring that only authorized users retain access. Privileged access is controlled through eligible-only assignments and evaluated for permanence and aggregation risk. Conditional Access policies enforce authentication requirements such as MFA and location-based controls, forming the enforcement layer of the model.

Lifecycle events are executed through controlled automation, with all actions logged, attributed, and time-stamped for audit traceability.

This establishes that identity governance controls are not only defined, but actively enforced, monitored, and evidenced.

## Control Effectiveness Statement

The implementation demonstrates that identity governance controls are:

- **Preventative** — Conditional Access and PIM restrict unauthorized actions before they occur
- **Detective** — Stale account detection and access reviews identify risk conditions
- **Corrective** — Leaver automation enforces timely removal of access

All outputs are structured, repeatable, and auditable, ensuring that evidence can be produced on demand without manual reconstruction.

This confirms that the IAM control environment is functioning as an operational security system, not a documentation artifact.

---

*Mapping reference: NIST SP 800-53 Rev 5 · CMMC Level 2 (32 CFR Part 170) · NIST SP 800-171 Rev 2*
