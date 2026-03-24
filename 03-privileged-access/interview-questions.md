# Interview Questions — Privileged Access Pack

## "How do you manage privileged access in your environment?"

I use a just-in-time model through Microsoft Entra ID Privileged Identity Management. No administrative role is permanently assigned — users are assigned as eligible and must request activation when they have a legitimate need.

Every activation requires three things: MFA, documented business justification, and approval from a designated approver. Access is time-limited and expires automatically. There is no standing administrative access, no self-approval path, and no activation without a documented reason.

This ensures privileged access is not persistent, not self-granted, and always traceable — which is the core requirement for both security and compliance.

*Evidence: PIM-STEP-01 through PIM-STEP-07.*

---

## "What is the difference between eligible and active assignment in PIM?"

An active assignment grants the role immediately and permanently — the user has standing access without any activation step. This is the traditional model and the one PIM is designed to replace.

An eligible assignment means the user can request the role but does not have it by default. To get access they must go through the activation workflow — MFA, justification, approval. The role is then active for a defined time window and expires automatically.

For any administrative role with real privilege, eligible assignment is the correct model. Active assignments should only exist for break-glass accounts and service accounts with documented exception approval.

---

## "How do you prevent privilege escalation?"

Three controls working together:

First, eligible assignment means no one has standing administrative access that could be leveraged for escalation.

Second, the approval gate means even a compromised account cannot self-escalate — a separate approver must validate the request.

Third, MFA on every activation means stolen password credentials alone are insufficient to activate a privileged role.

Combined, these controls significantly reduce the primary privilege escalation paths — standing access exploitation, credential reuse, and unauthorized self-elevation.

*Evidence: PIM-STEP-06 — pending approval confirms no self-escalation path.*

---

## "How does this map to CMMC Level 2?"

Three primary practices:

AC.L2-3.1.5 requires employing least privilege — JIT activation with time-limited duration enforces least privilege at runtime, not just at provisioning.

AC.L2-3.1.6 requires using non-privileged accounts for non-privileged activities — the eligible model enforces this by design. Users operate from standard accounts and activate privilege only when needed.

IA.L2-3.5.3 requires MFA — enforced on every activation request with no bypass path.

This also supports AU.L2-3.3.2 by ensuring all privileged access events are attributable to a named actor with timestamped audit records.

The evidence package — role configuration, eligible assignments, activation request, and PIM audit log — is structured to be dropped directly into an SSP as AC-6 and IA-2 implementation evidence. This ensures the control is not only documented but demonstrably enforced and testable during assessment.

---

## "What happens if a privileged access request is denied?"

The user receives a notification that the request was denied and no access is granted. The denial is recorded in the PIM audit log with the approver's identity and timestamp.

The user must either revise their justification and resubmit, or escalate through a defined exception process if the denial was made in error.

The critical point is that denial is the safe outcome — access defaults to not granted. The burden is on the requestor to justify access, not on the approver to justify denial.

---

## "How do you prove your privileged access controls actually work?"

I validate through outcome verification, not just configuration review.

I confirm that no permanent active assignments exist for in-scope roles — the assignment tab should show eligible only. I verify that the activation workflow actually routes to an approver and does not grant access immediately. I check the PIM audit log to confirm that all activations have justification, MFA completion, and approval events recorded.

The pending approval state in my evidence is the strongest proof — it shows that after submitting a valid activation request, access was not granted. The system enforced the gate.

*Evidence: PIM-STEP-06 — "Your request is pending for approval."*

---

## "What are common failures in PIM implementations?"

The most common failure is enabling PIM without fully enforcing its controls.

Typical issues include:

- Leaving permanent active assignments in place alongside eligible assignments
- Allowing activation without approval — defeating the purpose of the workflow
- Weak or missing justification requirements — rubber-stamped approvals with no business reason
- Not reviewing PIM audit logs for anomalous activation patterns

A properly implemented PIM solution eliminates standing access, enforces MFA and approval, requires justification, and produces a complete audit trail. Without enforcement, PIM becomes a monitoring tool instead of a control — and that distinction is exactly what assessors test for.
