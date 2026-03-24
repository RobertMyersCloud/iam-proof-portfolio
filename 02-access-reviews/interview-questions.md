# Interview Questions — Access Reviews Pack

## "How do you ensure least privilege is maintained over time?"

Least privilege at provisioning is only half the answer. The other half is periodic certification.

I implement quarterly access reviews in Microsoft Entra ID Identity Governance scoped to business-sensitive security groups. Each review assigns a named reviewer who is distinct from the users being reviewed — enforcing separation of duties. The reviewer evaluates each user's continued business need, documents a decision with justification, and denied access is removed automatically upon review completion via auto-apply settings.

The system also surfaces automated recommendations based on user activity signals — flagging inactive accounts for denial. This reduces manual burden while maintaining reviewer accountability for the final decision.

This ensures access is not only granted correctly, but continuously validated, enforced, and auditable — which is what actually satisfies compliance requirements.

*Evidence: AR-STEP-01 through AR-STEP-06.*

---

## "What is your access review process?"

I structure access reviews as a four-phase control lifecycle:

1. **Campaign creation** — Review scoped to target group, reviewer assigned, recurrence set (quarterly standard, monthly for privileged groups)
2. **Review execution** — Reviewer accesses My Access portal, evaluates each user, records Approve / Deny / Don't Know with justification
3. **Enforcement** — Auto-apply removes denied access upon review completion. If auto-apply fails, manual removal is required within 24 hours — treated as a control failure if missed
4. **Evidence capture** — Entra ID audit log records all decisions with actor, timestamp, and outcome. Evidence artifacts are indexed and retained for audit purposes

*Evidence: AR-STEP-02 (active review), AR-STEP-03 (decision with justification), AR-STEP-05 (results), AR-STEP-06 (audit log).*

---

## "How does this map to CMMC Level 2?"

Two primary practices:

AC.L2-3.1.1 requires limiting system access to authorized users — quarterly certification forces active confirmation that each user's access remains authorized.

CA.L2-3.12.3 requires ongoing monitoring of security controls — the quarterly review cadence provides a defined, repeatable monitoring mechanism for access control effectiveness.

This also supports AU.L2-3.3.2 by ensuring all access decisions are attributable to a named reviewer with timestamped audit records.

The evidence package — review configuration, reviewer decisions, access removal confirmation, and audit log — is structured to be dropped directly into an SSP as AC-2 and CA-7 implementation evidence. This ensures the control is not only documented but demonstrably enforced and testable during assessment.

---

## "How do you handle a reviewer who doesn't complete their review?"

This is a control failure condition, not just an administrative gap.

My policy defines an escalation path — overdue reviews escalate to the IAM lead after a defined grace period. In high-risk environments, access defaults to removal to eliminate unvalidated access exposure. In standard environments, the review is extended with documented justification.

The key point is that an incomplete review is not a neutral outcome. It represents unvalidated access — which is a risk condition that needs to be tracked, escalated, and resolved.

---

## "What's the difference between an access review and a user audit?"

A user audit is a point-in-time snapshot — who has what access right now.

An access review is a control — it requires a human decision, documents business justification, enforces an outcome, and produces an audit trail. It's not just observation, it's certification.

The distinction matters for compliance: CMMC and SOC 2 assessors want to see that access is periodically certified by a responsible party, not just that someone ran a report. The reviewer's documented decision and the enforcement action that follows is what satisfies the control.

---

## "How do you prove your access review process actually works?"

I validate effectiveness through both system evidence and outcome verification.

First, I confirm that review decisions are recorded in Entra ID audit logs with actor, timestamp, and justification. Then I verify that denied access resulted in actual group membership removal — not just a recorded decision.

Finally, I correlate review events with audit logs to ensure a complete control chain exists from review initiation through enforcement.

This ensures the control is not only configured, but functioning as intended — which is what assessors care about.

*Evidence: AR-STEP-05 (access removal), AR-STEP-06 (audit log correlation).*

---

## "What are common failures in access review implementations?"

The most common failure is treating access reviews as an administrative task instead of a control.

Typical issues include:

- Reviewers approving access without validation — rubber-stamping instead of certifying
- Lack of justification for decisions — no documented reasoning, no audit defensibility
- Failure to enforce access removal after denial — decision recorded, access retained
- No audit evidence linking decisions to outcomes — review happened, nothing proves it

A properly implemented access review program enforces reviewer accountability, requires justification, ensures removal of denied access, and produces a complete audit trail. Without all four, you have the appearance of a control, not the control itself.
