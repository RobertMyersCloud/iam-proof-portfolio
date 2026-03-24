# Privileged Access Pack — PIM

**Just-in-time privileged access implementation demonstrating role configuration, eligible assignment, approval-gated activation, and audit-ready evidence in Microsoft Entra ID Privileged Identity Management.**

Privileged Identity Management (PIM) implementation in Microsoft Entra ID, eliminating standing administrative access through just-in-time activation controls aligned to NIST 800-53 and CMMC Level 2.

## Scenario

Standing privileged access presents a high-risk condition due to potential misuse, lateral movement, and lack of accountability. A regulated organization needs to ensure administrative roles are not permanently assigned. Users with a legitimate need for privileged access must request activation with documented justification, complete MFA, obtain approval, and receive time-limited access — with all events recorded in an auditable log.

## What Was Built

| Component | Implementation |
|---|---|
| **Role configuration** | Security Reader role configured — MFA required on activation, justification required, approval required |
| **Approver assignment** | Robert Myers (Robert@rjmyers.cloud) assigned as designated approver |
| **Eligible assignment** | JML Test User and Robert Myers assigned as eligible — not permanent active |
| **Activation request** | JIT activation requested with documented business justification and 8-hour duration |
| **Approval gate** | Request routed to designated approver — pending approval before access granted |
| **Audit trail** | All PIM events captured in Resource audit log with actor, timestamp, and action |

## Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Eligible assignment model — no standing privileged access |
| AC-3 | Access Enforcement | Role-based privileged access — requires activation workflow |
| AC-6 | Least Privilege | Time-limited activation — access expires after defined duration |
| AC-6(5) | Privileged Accounts | Privileged roles assigned as eligible and activated through controlled workflow — eliminating permanent administrative assignments |
| IA-2 | Identification & Authentication | MFA required on every activation request |
| IA-2(1) | Network Access to Privileged Accounts | MFA enforced for all privileged role activations |
| IA-5 | Authenticator Management | MFA required and enforced during privileged role activation |
| AU-2 | Audit Events | All PIM events logged — role settings, assignments, activation requests |
| AU-9 | Protection of Audit Information | Audit logs retained within Entra ID with access restricted to authorized roles |

## Outcome

- Eliminated standing administrative access — Security Reader requires JIT activation
- Enforced MFA on every privileged access request — no bypass path
- Required documented justification for all activations — auditable business reason
- Implemented approval gate — no self-approval of privileged access
- Verified that privileged access is not granted until approval is completed — enforcing true just-in-time access control
- Generated complete audit trail from role configuration through activation request

## Evidence Index

| File | What It Shows | Control |
|---|---|---|
| [PIM-STEP-01-role-settings.png](./evidence/PIM-STEP-01-role-settings.png) | Role configured — Azure MFA required, justification required, approval required, approver: Robert Myers | AC-6(5), IA-2 |
| [PIM-STEP-02-role-settings-saved.png](./evidence/PIM-STEP-02-role-settings-saved.png) | Role settings update confirmed — "Role setting update succeeded" | AC-6(5) |
| [PIM-STEP-03-eligible-assignment.png](./evidence/PIM-STEP-03-eligible-assignment.png) | JML Test User assigned as eligible for Security Reader — not permanent active | AC-2, AC-6 |
| [PIM-STEP-04-eligible-role.png](./evidence/PIM-STEP-04-eligible-role.png) | Security Reader visible in My roles — eligible, Directory scope, Activate action available | AC-2, AC-6 |
| [PIM-STEP-05-activation-request.png](./evidence/PIM-STEP-05-activation-request.png) | Activation request with justification — "Security investigation… Time-limited activation per least privilege policy" | AC-6, IA-2, IA-5 |
| [PIM-STEP-06-pending-approval.png](./evidence/PIM-STEP-06-pending-approval.png) | "Your request is pending for approval" — approval gate enforced, no standing access granted | AC-6(5), AU-2 |
| [PIM-STEP-07-audit-log.png](./evidence/PIM-STEP-07-audit-log.png) | Resource audit log — role setting update, eligible assignments, activation request, approval pending | AU-2, AU-9 |

## Control Chain Summary

| Step | Action | Control Satisfied |
|---|---|---|
| 1 | Role configured with MFA, justification, and approval requirements | IA-2, IA-5, AC-6(5) |
| 2 | User assigned as eligible — no standing access | AC-2 |
| 3 | User requests activation with justification | AC-6 |
| 4 | Approval required before access is granted | AC-3, AC-6(5) |
| 5 | Access granted for time-limited duration | AC-6 |
| 6 | Audit log captures all events | AU-2, AU-9 |

## Assessment Narrative

The privileged access implementation demonstrates elimination of standing administrative access through a just-in-time activation model.

Users are assigned eligible roles and must request activation with justification, complete MFA, and obtain approval before access is granted. Access is time-limited and expires automatically.

Evidence shows that privileged access is not available without activation and approval, and all events are captured in the Entra ID audit log.

This establishes a defensible privileged access control aligned to NIST 800-53 and CMMC Level 2 requirements.

## Pack Contents

| File | Description |
|---|---|
| `PIM-Policy.md` | Privileged access management policy — scope, activation requirements, approval workflow |
| `control-mapping.md` | NIST 800-53 / CMMC Level 2 control mapping with evidence linkage |
| `resume-bullets.md` | Resume-ready bullet points tied to this implementation |
| `interview-questions.md` | Interview questions this pack answers with documented responses |
| `evidence/` | Entra ID PIM screenshots — named and indexed above |

## Interview Value

This pack demonstrates the ability to:

- Design and implement a just-in-time privileged access model
- Configure PIM role settings with MFA, justification, and approval requirements
- Eliminate standing administrative access through eligible assignment
- Enforce approval gates on privileged role activation
- Map privileged access controls to NIST 800-53 and CMMC Level 2 requirements

---

*Pack version: v1.0 — March 2026 · Environment: Microsoft Entra ID — rjmyers.cloud tenant*
