# Interview Questions — Segregation of Duties Pack

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
