# Access Reviews Pack

**Periodic access certification implementation demonstrating reviewer-driven access decisions, automated recommendations, enforced removal of unnecessary access, and audit-ready evidence in Microsoft Entra ID Identity Governance.**

Quarterly access review program implemented in Microsoft Entra ID, aligned to NIST 800-53 and CMMC Level 2 access control requirements.

## Scenario

A regulated organization requires periodic certification of group memberships to enforce least privilege over time. Reviewers evaluate continued business need, record disposition with justification, and denied access is removed to maintain least privilege and produce assessor-ready evidence.

## What Was Built

| Component | Implementation |
|---|---|
| **Review campaign** | Quarterly access review scoped to `Finance-ReadOnly` group — `AR-Finance-ReadOnly-Q1-2026` |
| **Reviewer assignment** | Selected reviewer (Robert Myers) assigned — not self-review |
| **Automated recommendation** | System flagged JML Test User as Deny based on inactive status |
| **Reviewer decision** | Access denied with documented justification — "Access no longer required — user inactive" |
| **Access removal** | Upon review completion, denied access was removed from the target group per configured review settings |
| **Audit trail** | All decisions captured in Entra ID audit log with timestamp and actor |

## Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Periodic review and removal of unnecessary access |
| AC-2(4) | Automated Audit Actions | System-generated recommendations based on user activity |
| AC-5 | Separation of Duties | Reviewer is distinct from the user being reviewed |
| AC-6 | Least Privilege | Access removed when business need cannot be confirmed |
| CA-7 | Continuous Monitoring | Quarterly review cadence enforces ongoing access validation |
| AU-2 | Audit Events | All review decisions logged with actor, timestamp, and outcome |

## Outcome

- Identified and denied access for inactive user through automated recommendation
- Documented reviewer decision with justification — defensible audit evidence
- Enforced least privilege by removing unnecessary group membership upon review completion
- Established quarterly review cadence aligned to CMMC Level 2 CA and AC control families
- Generated complete audit trail from review creation through access removal decision

## Evidence Index

| File | What It Shows | Control |
|---|---|---|
| [AR-STEP-01-review-created.png](./evidence/AR-STEP-01-review-created.png) | Review `AR-Finance-ReadOnly-Q1-2026` active — Owner, Group, Quarterly recurrence | AC-2 |
| [AR-STEP-02-review-active.png](./evidence/AR-STEP-02-review-active.png) | My Access portal — review in progress, due 3/31/2026, 0 of 1 pending | AC-2, CA-7 |
| [AR-STEP-03-justification.png](./evidence/AR-STEP-03-justification.png) | Deny decision with justification — "Access no longer required — user inactive" | AC-6 |
| [AR-STEP-04-decision-recorded.png](./evidence/AR-STEP-04-decision-recorded.png) | Decision confirmed — JML Test User: Denied, Reviewed by: Robert Myers | AC-2, AU-2 |
| [AR-STEP-05-review-results.png](./evidence/AR-STEP-05-review-results.png) | Admin view — Outcome: Denied, Reviewed by Robert Myers on 3/24/2026 | AC-2, AU-2 |
| [AR-STEP-06-audit-log.png](./evidence/AR-STEP-06-audit-log.png) | Full audit log — Deny decision, group management, user lifecycle events with timestamps | AU-2 |

## Pack Contents

| File | Description |
|---|---|
| `AR-Policy.md` | Access review program policy — scope, cadence, reviewer model, controls |
| `control-mapping.md` | NIST 800-53 / CMMC Level 2 control mapping with evidence linkage |
| `resume-bullets.md` | Resume-ready bullet points tied to this implementation |
| `interview-questions.md` | Interview questions this pack answers with documented responses |
| `evidence/` | Entra ID Identity Governance screenshots — named and indexed above |

## Interview Value

This pack demonstrates the ability to:

- Design and operate a periodic access certification program
- Configure automated review recommendations based on user activity signals
- Document reviewer decisions with audit-defensible justification
- Enforce access removal on denial through review completion settings
- Map access review controls to NIST 800-53 and CMMC Level 2 requirements

---

*Pack version: v1.0 — March 2026 · Environment: Microsoft Entra ID — rjmyers.cloud tenant*
