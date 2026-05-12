# Interview Questions — JML Lifecycle Pack

---

## "Walk me through your JML process."

My JML model is designed around lifecycle governance, SLA enforcement, least privilege, and auditability across all identity states.

### Joiner
When a new hire event occurs, a user account is provisioned in Microsoft Entra ID and assigned to role-based security groups aligned to department and job function. Access is granted through group membership only — no direct user permissions are assigned. MFA is enforced through Conditional Access during initial authentication.

### Mover
When a role change occurs, group memberships are reviewed against the updated role profile. New access is assigned and prior access is removed through a delta-based review process to prevent privilege accumulation across role changes.

### Leaver
When termination is confirmed, the account is disabled immediately, group memberships are removed, and active sign-in sessions are revoked. This addresses token persistence risk, since disabling an account alone does not invalidate active refresh tokens within Microsoft Entra ID.

**Evidence:** JML-STEP-01 through JML-STEP-06

---

## "How do you reduce orphaned account risk?"

This workflow uses multiple controls together to reduce orphaned account exposure:

- Immediate account disablement prevents new authentication attempts
- Session revocation invalidates active refresh tokens
- Group membership removal eliminates inherited application access

Together, these controls remove both active and residual access paths following offboarding.

**Evidence:**  
- JML-STEP-05 — account disabled  
- JML-STEP-06 — active sessions revoked

---

## "How do you enforce least privilege?"

Least privilege is enforced through two primary mechanisms:

### Role-Based Access Assignment
All access is granted through role-based security groups rather than direct user permissions. Access decisions are based on job function and business role requirements.

### Delta-Based Access Review
During role changes, prior access is reviewed and removed before new access is assigned. This prevents privilege accumulation over time and maintains role alignment.

**Evidence:**  
- JML-STEP-02 — role-based group assignment  
- JML-STEP-04 — role transition and access correction

---

## "What's the difference between disabling an account and revoking sessions?"

Disabling an account blocks future authentication attempts, but existing sessions with valid refresh tokens may remain active until token expiration.

Session revocation invalidates active refresh tokens immediately.

For offboarding scenarios, both controls are important:
- Account disablement prevents new logins
- Session revocation removes active authenticated sessions

Using both controls together reduces residual access exposure during termination events.

**Evidence:**  
- JML-STEP-06 — active sign-in sessions revoked

---

## "How does this align to CMMC Level 2?"

This workflow aligns to several CMMC Level 2 practices associated with identity lifecycle governance, access control, and authentication management.

Examples include:
- AC.L2-3.1.1 — limiting system access to authorized users
- AC.L2-3.1.2 — limiting access to authorized transactions and functions
- AC.L2-3.1.6 — use of non-privileged accounts
- IA.L2-3.5.3 — multifactor authentication enforcement
- AU.L2-3.3.1 — audit logging and retention

This pack includes:
- Governance documentation
- Lifecycle workflow evidence
- Control mappings
- Microsoft Entra ID configuration evidence
- Audit-ready screenshots aligned to control implementation

The structure is designed to demonstrate how lifecycle governance concepts can support regulated IAM and compliance operations.

---

## "How do you handle privilege accumulation during role changes?"

Privilege accumulation is addressed through a role-transition review process.

When a user changes roles:
1. Existing access is reviewed against the prior role
2. Access no longer required is removed
3. New access aligned to the updated role is assigned
4. Group memberships are validated against least privilege expectations

This reduces the risk of users retaining unnecessary access across multiple role transitions.

**Evidence:**  
- JML-STEP-04 — role-based access correction

---

## "Why use group-based access instead of direct permissions?"

Group-based access improves:
- scalability
- consistency
- auditability
- access review efficiency
- least privilege enforcement

It also simplifies onboarding, role transitions, and offboarding workflows because access can be managed centrally through role-aligned security groups rather than individual permission assignments.

This approach supports governance consistency and reduces configuration drift over time.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
