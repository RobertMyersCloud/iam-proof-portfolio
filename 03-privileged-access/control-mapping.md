# Control Mapping — Privileged Access Pack

This mapping demonstrates how the privileged access management implementation in Microsoft Entra ID Privileged Identity Management aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct evidence linkage to activation artifacts.

## NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Eligible assignment model — no standing privileged access granted | PIM-STEP-03, PIM-STEP-04 |
| AC-3 | Access Control | Access Enforcement | Privileged access is enforced through an approval-gated activation workflow — access is not granted until approval is completed | PIM-STEP-06 |
| AC-6 | Access Control | Least Privilege | Privileged access is granted only for the minimum duration required and automatically expires — enforcing least privilege at runtime | PIM-STEP-05, PIM-STEP-06 |
| AC-6(5) | Access Control | Privileged Accounts | Privileged roles assigned as eligible and activated through controlled workflow — eliminating permanent administrative assignments | PIM-STEP-01, PIM-STEP-02 |
| AC-6(10) | Access Control | Privileged Access Monitoring | PIM audit logs capture all privileged activation activity for monitoring and review | PIM-STEP-07 |
| IA-2 | Identification & Authentication | Identification and Authentication | MFA required and enforced on every activation request — no bypass path available | PIM-STEP-01, PIM-STEP-05 |
| IA-2(1) | Identification & Authentication | Network Access to Privileged Accounts | MFA enforced specifically for privileged role activations | PIM-STEP-01 |
| IA-5 | Identification & Authentication | Authenticator Management | MFA required and enforced during privileged role activation — authenticator validated at every request | PIM-STEP-05 |
| AU-2 | Audit & Accountability | Event Logging | All PIM events logged — role settings, assignments, activation requests, approval decisions | PIM-STEP-07 |

## CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | Eligible assignment — activation required, no standing access |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions | Access is not granted until explicitly approved by an authorized approver — enforcing controlled authorization of privileged actions |
| AC.L2-3.1.5 | Access Control | Employ the principle of least privilege | Time-limited activation scoped to minimum required duration — access expires automatically |
| AC.L2-3.1.6 | Access Control | Use non-privileged accounts for non-privileged activities | Eligible model enforces use of standard account except during approved activation |
| IA.L2-3.5.3 | Identification & Authentication | Use multifactor authentication | MFA required and enforced on every privileged role activation |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain system audit logs | PIM Resource audit log captures all activation lifecycle events |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit log actions are traceable | All events attributed to named actor with timestamp and justification |

## Evidence Reference

| Evidence File | Controls Satisfied |
|---|---|
| PIM-STEP-01-role-settings.png | Demonstrates role configured with MFA, justification, and approval requirements — AC-6(5), IA-2, IA-2(1) |
| PIM-STEP-02-role-settings-saved.png | Demonstrates role settings update confirmed and applied — AC-6(5) |
| PIM-STEP-03-eligible-assignment.png | Demonstrates eligible assignment — no standing active access for JML Test User — AC-2, AC-6 |
| PIM-STEP-04-eligible-role.png | Demonstrates eligible role visible with Activate action — access not yet granted — AC-2, AC-6 |
| PIM-STEP-05-activation-request.png | Demonstrates activation request with documented justification and MFA requirement — AC-6, IA-2, IA-5 |
| PIM-STEP-06-pending-approval.png | Demonstrates approval gate enforced — access pending, not granted without approval — AC-3, AC-6(5) |
| PIM-STEP-07-audit-log.png | Demonstrates complete audit trail — role config, assignments, activation request, approval pending — AU-2, AC-6(10) |

## Control Chain Summary

| Step | Action | Control Satisfied |
|---|---|---|
| 1 | Role configured with MFA, justification, and approval requirements | IA-2, IA-2(1), IA-5, AC-6(5) |
| 2 | User assigned as eligible — no standing access granted | AC-2 |
| 3 | User requests activation with documented justification | AC-6 |
| 4 | MFA completed as part of activation request | IA-2, IA-5 |
| 5 | Approval required before access is granted | AC-3, AC-6(5) |
| 6 | Access granted for time-limited duration upon approval | AC-6 |
| 7 | Audit log captures all events with actor and timestamp | AU-2, AC-6(10) |

## Assessment Narrative

The privileged access management implementation demonstrates elimination of standing administrative access through a just-in-time activation model.

Users are assigned eligible roles and must request activation with documented justification, complete MFA, and obtain approval before access is granted. Access is time-limited and automatically expires upon duration end.

Evidence demonstrates that privileged access is not available without activation and approval — the pending approval state confirms the enforcement gate is active. All events are recorded in the Entra ID PIM audit log with actor, timestamp, and action detail.

This establishes a defensible privileged access control implementation aligned to NIST 800-53 and CMMC Level 2 requirements.

## Control Effectiveness Statement

The implementation demonstrates that privileged access is not persistently assigned, cannot be activated without MFA and approval, and is automatically revoked after the approved duration.

The presence of a pending approval state confirms that access is gated and not immediately granted. Audit logs provide a complete and traceable record of all privileged access events.

This confirms that the control is functioning as designed and effectively reducing the risk of unauthorized privileged access.

---

*Mapping reference: NIST SP 800-53 Rev 5 · CMMC Level 2 (32 CFR Part 170) · NIST SP 800-171 Rev 2*

---

## Related framework alignment

The NIST 800-53 controls mapped above correspond directly to the following additional frameworks. This pack's controls satisfy equivalent requirements in each:

- **NIST SP 800-171 (Rev. 3)** — DFARS 252.204-7012 / CMMC Level 2 baseline; 3.1.x (Access Control) and 3.5.x (Identification and Authentication) families applicable
- **SOC 2 (TSC 2017)** — Common Criteria CC6.1 through CC6.8 (Logical & Physical Access Controls) and CC7.2 (System Monitoring) applicable

> **Note on scope:** This appendix identifies cross-framework applicability. Specific control-ID crosswalks to 800-171 and SOC 2 CC6/CC7 are on the roadmap for a future Evidence Production pack that consolidates cross-framework traceability.
