# Interview Preparation — Master Reference

**Consolidated interview questions and responses across all six IAM Proof Portfolio packs.**

This document aggregates every pack's interview-questions.md into a single pre-interview review. Read before IAM Architect / IGA / CMMC interviews.

---

## How to Use This

- **Night before interview:** Read sections matching the role's expected depth
- **Morning of interview:** Re-read only the packs listed in the JD
- **During interview:** Reference the actual pack if screen-sharing is possible ("let me show you the exact implementation")

---

## Quick Navigation

1. [JML Lifecycle](#jml-lifecycle)
2. [Access Reviews](#access-reviews)
3. [Privileged Access (PIM)](#privileged-access-pim)
4. [Conditional Access](#conditional-access)
5. [Segregation of Duties](#segregation-of-duties)

---


## JML Lifecycle

*From [01-jml-lifecycle/](01-jml-lifecycle/)*

## "Walk me through your JML process."

My JML model is designed around lifecycle triggers, SLA enforcement, and least privilege controls across all identity states.

**Joiner:** When a new hire record is created in HR, an account is provisioned in Entra ID and assigned to role-based security groups based on department and job function. No direct user permissions are granted — all access flows through group membership. MFA is enforced via Conditional Access on first sign-in.

**Mover:** When an internal role change is recorded, group memberships are reviewed against the new role profile. New access is granted and prior role access is removed within 24 hours. No accumulation — the delta is enforced clean.

**Leaver:** When termination is confirmed, the account is disabled immediately, all group memberships are removed, and sign-in sessions are revoked. This closes the token persistence gap — disabling an account alone does not invalidate active sessions in Entra ID.

*Evidence: JML-STEP-01 through JML-STEP-06.*

---

## "How do you reduce orphaned account risk?"

Three controls working together:

1. Immediate disablement — account cannot authenticate
2. Session revocation — active refresh tokens are invalidated, not just expired naturally
3. Group membership removal — access to all connected applications is cut

The combination means a terminated user has no path back in — not through a cached session, not through a token, not through a group-inherited permission.

*Evidence: JML-STEP-05 (disabled) and JML-STEP-06 (sessions revoked).*

---

## "How do you enforce least privilege?"

Two mechanisms:

First, no direct user permissions — all access is assigned via security group membership. Access is role-scoped by design, not by individual judgment.

Second, the mover workflow enforces a delta review. When someone changes roles, prior group memberships are removed and new ones assigned. The system does not allow access to accumulate across roles over time.

*Evidence: JML-STEP-02 (group assignment), JML-STEP-04 (role change).*

---

## "What's the difference between disabling an account and revoking sessions?"

Disabling the account prevents new authentication attempts. But any existing sessions with valid refresh tokens can continue operating until those tokens expire — which can be hours or days depending on policy.

Session revocation immediately invalidates all active refresh tokens. Combined with account disablement, this eliminates both new and existing access paths simultaneously.

For a terminated employee you need both. Disablement alone leaves a window.

*Evidence: JML-STEP-06 — "Successfully revoked sign-in sessions for JML Test User."*

---

## "How does this map to CMMC Level 2?"

AC-2 requires organizations to manage information system accounts — including establishment, activation, modification, review, disablement, and removal. This JML pack provides documented evidence for each of those phases with Entra ID configuration screenshots and a policy artifact.

AC-2(1) requires automated account management — this implementation uses group-based provisioning and deprovisioning rather than manual processes, satisfying the automation requirement.

This evidence package is structured to be dropped directly into an SSP as AC-2 implementation evidence. This approach ensures the control is not only documented, but demonstrably implemented and testable during assessment.

---

## Access Reviews

*From [02-access-reviews/](02-access-reviews/)*

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

---

## Privileged Access (PIM)

*From [03-privileged-access/](03-privileged-access/)*

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

---

## Conditional Access

*From [04-conditional-access/](04-conditional-access/)*

## "How do you implement Zero Trust using Conditional Access?"

Zero Trust means no implicit trust — every access request is evaluated regardless of where it originates. Conditional Access is the enforcement mechanism that makes that real.

I implement it as an identity enforcement plane where every sign-in is evaluated against defined conditions before access is granted. My baseline implementation has two policies: one requiring MFA for all users on all cloud applications, and one blocking access from outside a defined trusted location. Every authentication event hits these policies — there is no network path that bypasses them.

The key principle is that network location is no longer the trust boundary. Identity, authentication strength, and contextual signals are.

*Evidence: CA-STEP-01 through CA-STEP-06.*

---

## "What is your Conditional Access deployment process?"

I follow a four-phase process:

1. **Design** — define policy scope, conditions, and grant controls. Document break-glass exclusions before creating any policy.
2. **Report-only deployment** — enable the policy in Report-only mode. It evaluates sign-ins but does not enforce. This captures impact data without risk.
3. **Validation** — run What If tool scenarios to confirm policy logic. Analyze sign-in logs to confirm expected behavior.
4. **Enforcement** — transition to On only after impact analysis confirms the policy behaves as designed.

This approach prevents tenant lockout, reduces false positive risk, and produces evidence of professional change management — which is exactly what auditors look for.

*Evidence: CA-STEP-06 — What If evaluation confirming policy applies before enforcement.*

---

## "What are the limitations of location-based Conditional Access policies?"

Three main ones:

First, location controls rely on IP intelligence and can be bypassed using VPNs or proxy services. An attacker routing through a US-based exit node can appear as a trusted source.

Second, geo-blocking introduces user friction. Legitimate users traveling internationally may be blocked, which creates operational challenges if exception handling is not well designed.

Third, location is a coarse signal — it should never be treated as a primary control. It must be layered with stronger signals like MFA, device compliance, and risk-based access.

In my implementation, location-based control is used as a secondary defense layer, not a standalone security control.

---

## "How do you prevent tenant lockout when deploying Conditional Access?"

The first thing I do is define and validate break-glass accounts before any policy is deployed.

These accounts are excluded from all Conditional Access policies, secured with long randomized credentials, not dependent on MFA, and monitored with alerting — any use triggers immediate investigation.

Then I deploy policies in Report-only mode first, validate using What If and sign-in logs, and only move to enforcement after confirming there is no unintended impact.

That combination — break-glass plus staged deployment — eliminates the risk of locking out the tenant.

---

## "How do you validate that Conditional Access policies are working correctly?"

I validate at three levels:

**What If testing** — simulate authentication scenarios to confirm the correct policy applies and expected controls are triggered.

**Sign-in log analysis** — review Entra ID sign-in logs to verify policy evaluation results, Report-only impact, and authentication requirements triggered.

**Negative testing** — simulate non-compliant conditions: sign-in without MFA, sign-in from a blocked location. Confirm the policy would enforce or block as expected.

This ensures the control is not just configured — it is functioning as designed under real conditions.

*Evidence: CA-STEP-06 — What If result confirming CA-POL-001 applies MFA requirement.*

---

## "How does Conditional Access map to CMMC Level 2?"

Three primary practices:

AC.L2-3.1.14 requires routing remote access through managed access control points — Conditional Access acts as exactly that, a centralized enforcement point for all cloud access.

IA.L2-3.5.3 requires MFA — CA-POL-001 enforces this for all users without exception.

AC.L2-3.1.20 requires verifying and controlling connections to external systems — the location policy satisfies this by restricting access to authorized geographic regions.

This also supports AU.L2-3.3.2 — all sign-in events are logged with policy evaluation results, attributable to a named user with timestamp.

The evidence package is structured for direct SSP inclusion as AC-3 and IA-2 implementation evidence. This ensures the control is not only documented but demonstrably enforced and testable during assessment.

---

## "How would you evolve this Conditional Access design for a mature enterprise?"

I would extend the baseline into adaptive, risk-based access:

- Sign-in risk policies using Entra ID Identity Protection — step-up MFA on risky sign-ins
- Device compliance enforcement via Intune integration
- Stricter policies for privileged roles integrated with PIM
- Phishing-resistant MFA — FIDO2 or Windows Hello for high-risk accounts
- Continuous Access Evaluation for real-time session revocation on risk signal

The goal is to move from static policy enforcement to dynamic, risk-aware access control. The baseline I've built is the foundation — the architecture is designed to extend.

---

## "What's the biggest mistake people make with Conditional Access?"

Treating it like a configuration task instead of a control system.

Most people turn on MFA, create a few policies, and stop there. But Conditional Access is a control enforcement plane, a change-managed system, and a continuously tuned security mechanism.

If you don't validate it, monitor it, and evolve it — you don't actually have control, you just have configuration. The difference between those two things is exactly what assessors test for.

---

## "How do you balance security and user experience with Conditional Access?"

By using a layered and data-driven approach.

Start with broad baseline controls — MFA for all users. Use Report-only mode to measure impact before enforcement. Analyze sign-in data to identify friction points. Introduce adaptive controls instead of blanket restrictions where the risk profile supports it.

The goal is to maximize security without breaking productivity. That balance is achieved through continuous tuning, not one-time configuration.

---

## Segregation of Duties

*From [05-sod-matrix/](05-sod-matrix/)*

## "What is Segregation of Duties and why does it matter?"

Segregation of Duties is a preventative control that ensures no single user can initiate, approve, execute, and conceal an unauthorized action. It matters because access controls like MFA and RBAC control who can get in — SoD controls what damage they can do once they're in.

The classic example is a user who can both create vendor records and process payments. Without SoD, that user can create a fraudulent vendor and pay themselves. With SoD enforced, those roles are held by separate people — neither can complete the fraud alone.

In regulated environments, SoD is not optional. It directly satisfies NIST AC-5 and is a core requirement for SOX, SOC 2, and CMMC Level 2 compliance.

---

## "How do you build an SoD matrix?"

I build it in three steps:

First, identify the high-risk role combinations — I cover three domains: Finance (fraud risk), IT Administration (privilege abuse), and Security (audit integrity). Each domain has different risk drivers and different consequences if violated.

Second, classify each conflict by risk tier — Critical, High, or Medium — based on the potential for fraud, system compromise, or undetectable abuse. This prioritizes remediation effort.

Third, document a specific mitigation for every conflict. Not "separate the roles" generically — a precise control like "payroll execution requires independent HR record validation" or "PIM eligible-only with separate approver for Global Admin and Conditional Access Admin."

The result is a matrix where every conflict has a risk, a tier, and a mitigation. No unmitigated risks.

*Evidence: SoD-Matrix.md — 15 conflict pairs across three domains.*

---

## "What's the difference between preventative and detective SoD controls?"

Preventative controls stop conflicts before they occur — role assignments evaluated against the matrix at provisioning time, conflicting assignments blocked before access is granted.

Detective controls identify conflicts after they occur — quarterly access reviews, IAM tooling scans, and exception register reviews that catch conflicts accumulated through role changes or provisioning gaps over time.

Both are required. Preventative controls reduce risk. Detective controls validate that prevention is working and catch edge cases. A SoD program with only one type is incomplete.

---

## "How do you handle SoD exceptions?"

Exceptions are inevitable in real organizations — sometimes one person has to temporarily hold conflicting roles due to staffing constraints or business continuity needs.

The key is that exceptions are governed, not ignored. My process requires:

A formal exception request with documented business justification. Risk assessment by the Security Lead. Approval at the appropriate level — CISO for Critical, Security Lead for High. A documented compensating control that offsets the risk. A maximum 90-day expiration. Mandatory review at the next certification cycle.

An exception without a compensating control is just an unmitigated risk with paperwork. The compensating control is what makes it defensible in an audit.

---

## "How does SoD map to CMMC Level 2?"

AC.L2-3.1.5 requires employing least privilege — SoD prevents conflicting role combinations that would create over-privileged access, enforcing least privilege at the role design level, not just the permission level.

AC.L2-3.1.2 requires limiting access to authorized transactions — dual approval and role separation controls prevent unauthorized transaction execution even when a user has access to one part of the process.

AU.L2-3.3.2 requires traceable audit logs — the separation of Security Administrator and Audit Log Administrator roles directly satisfies this by ensuring audit evidence cannot be manipulated by the same party responsible for security operations.

The SoD matrix and exception register together form the AC-5 evidence package for an SSP — directly answering the assessor question "show me how you prevent a single user from executing and concealing an unauthorized action."

---

## "What are common failures in SoD implementations?"

Three patterns I see consistently:

First, the matrix exists but isn't enforced at provisioning. People build the spreadsheet, file it away, and then provision access manually without checking it. SoD only works if it's evaluated at the point of access grant.

Second, exceptions proliferate without governance. One exception becomes ten, then thirty, then the matrix is meaningless because everyone has an exception. The 90-day maximum and compensating control requirement exist specifically to prevent this.

Third, the matrix covers one domain and ignores the others. Most people think SoD is a finance concept. But the most dangerous SoD violations are often in IT — a user who can both administer systems and manage audit logs can breach a system and delete the evidence. That's undetectable without SoD enforcement in the security domain.

A properly implemented SoD program covers all three domains, enforces at provisioning, governs exceptions rigorously, and detects violations through continuous review.

---

## "How does SoD relate to the rest of your IAM program?"

SoD doesn't stand alone — it's one layer in a defense-in-depth identity governance model.

JML lifecycle controls ensure access is granted correctly at hire and removed at termination. Access reviews ensure access remains appropriate over time. PIM ensures privileged access is time-limited and approval-gated. Conditional Access ensures authentication is enforced at every sign-in. SoD ensures that even correctly provisioned, reviewed, and authenticated users cannot combine roles in ways that enable fraud or abuse.

Each control addresses a different failure mode. Together they create a complete identity governance program where access is granted correctly, maintained correctly, enforced at authentication, and structurally prevented from enabling unauthorized actions.

That's the difference between configuring IAM tools and designing an identity governance system.

---


## General Interview Principles

Regardless of which pack the question references:

1. **Frame as implementation, not theory.** "I implemented..." not "One would implement..."
2. **Lead with outcome.** "To achieve 1-hour deprovisioning SLA, I..." — business outcome first, technical detail second.
3. **Tie back to the pack.** "That's demonstrated in the Access Reviews pack of my portfolio — pack 02. The evidence shows exactly how that played out."
4. **Don't oversell unsanitized work.** For Navy experience: "At the federal scale I operated at, we enforced..." — no specific system names, no numbers requiring clearance review.
5. **Offer to share evidence.** "I can walk you through the actual Entra configuration if screen sharing is available."

## The Resume-Bullet Match

When a JD says a specific responsibility, cross-reference to the pack's resume-bullets.md and use the exact language in your application. The bullets were written to be copy-paste compliant with recruiter ATS keyword scanning.

---

*Last updated: April 2026*
*[← Back to Portfolio Root](./)*
