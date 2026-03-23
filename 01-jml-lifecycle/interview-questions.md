# Interview Questions — JML Lifecycle Pack

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
