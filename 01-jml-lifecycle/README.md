# JML Lifecycle Pack

**End-to-end identity lifecycle implementation demonstrating provisioning, access governance, and immediate deprovisioning with audit-ready evidence in Microsoft Entra ID.**

End-to-end Joiner-Mover-Leaver identity lifecycle implemented in Microsoft Entra ID with audit-ready evidence aligned to NIST 800-53 and CMMC Level 2.

## Scenario

A regulated organization needs to ensure new hires receive role-based access immediately, internal transfers receive corrected access without accumulation, and terminated users lose all access within one hour of offboarding.

## What Was Built

| Phase | Implementation |
|---|---|
| **Joiner** | User provisioned in Entra ID, assigned via role-based security group, MFA enforced through Conditional Access |
| **Mover** | Access recalculated on role change — previous group membership removed, new role assigned, no privilege accumulation |
| **Leaver** | Account disabled immediately, sessions revoked, access terminated across all resources |

## Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Full JML lifecycle — provisioning, modification, disablement |
| AC-2(1) | Automated Account Management | Group-based provisioning — no direct user permissions |
| AC-3 | Access Enforcement | Role-based group membership only |
| AC-6 | Least Privilege | Access scoped to role — excess removed on move and exit |
| IA-2 | Identification & Authentication | MFA enforced via Conditional Access policy |
| AU-2 | Audit Events | All lifecycle events logged in Entra ID audit log |

## Outcome

- Eliminated orphaned account risk through enforced 1-hour deprovisioning SLA
- Prevented privilege accumulation during role changes via clean delta enforcement
- Enforced least privilege through group-based access — no direct user permissions
- Established audit-ready lifecycle evidence aligned to CMMC Level 2 AC and IA control families

## Evidence Index

| File | What It Shows | Control |
|---|---|---|
| [JML-STEP-01-user-created.png](./evidence/JML-STEP-01-user-created.png) | User `jml.test@rjmyers.cloud` created — Account status: Enabled | AC-2 |
| [JML-STEP-02-group-assignment.png](./evidence/JML-STEP-02-group-assignment.png) | User assigned to `Finance-ReadOnly` security group | AC-2, AC-3 |
| [JML-STEP-03-mfa-policy.png](./evidence/JML-STEP-03-mfa-policy.png) | Conditional Access policy "Require MFA - JML Test" active — all cloud apps | IA-2 |
| [JML-STEP-04-role-change.png](./evidence/JML-STEP-04-role-change.png) | Mover — group memberships updated to reflect role change | AC-2, AC-6 |
| [JML-STEP-05-account-disabled.png](./evidence/JML-STEP-05-account-disabled.png) | Leaver — Account disabled, authentication blocked regardless of existing group memberships | AC-2 |
| [JML-STEP-06-session-revoked.png](./evidence/JML-STEP-06-session-revoked.png) | Successfully revoked sign-in sessions for JML Test User | AC-2, IA-2 |

## Pack Contents

| File | Description |
|---|---|
| `JML-Policy.md` | Full identity lifecycle policy — scope, workflows, SLAs, enforcement controls |
| `control-mapping.md` | NIST 800-53 / CMMC Level 2 control mapping |
| `resume-bullets.md` | Resume-ready bullet points tied to this implementation |
| `interview-questions.md` | Interview questions this pack answers with documented responses |
| `evidence/` | Entra ID configuration screenshots — named and indexed above |

## Interview Value

This pack demonstrates the ability to:

- Design and implement a full identity lifecycle (Joiner, Mover, Leaver)
- Enforce least privilege through RBAC and access correction
- Apply Conditional Access policies for MFA enforcement
- Execute immediate deprovisioning and session termination
- Map identity controls to NIST 800-53 and CMMC Level 2 requirements

This directly answers common IAM interview questions related to lifecycle management, access governance, and Zero Trust enforcement.

---

*Pack version: v1.0 — March 2026 · Environment: Microsoft Entra ID — rjmyers.cloud tenant*
