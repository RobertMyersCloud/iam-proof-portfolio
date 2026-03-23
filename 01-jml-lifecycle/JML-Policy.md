# JML Identity Lifecycle Policy

**Document ID:** SMG-IAM-POL-001
**Version:** 1.0
**Date:** 2026-03-23
**Owner:** Robert J. Myers

---

## Executive Summary

This policy defines a controlled identity lifecycle for workforce access in Microsoft Entra ID, ensuring users receive appropriate access at onboarding, maintain correct access during role changes, and lose all access immediately upon termination.

The implementation enforces least privilege, prevents access accumulation, and eliminates orphaned accounts through defined SLAs, role-based access control, and session termination controls aligned to NIST 800-53 and CMMC Level 2.

---

## 1. Purpose

This policy defines the Joiner-Mover-Leaver (JML) identity lifecycle process for managing user access within Microsoft Entra ID and connected systems. It establishes controls for the timely provisioning and deprovisioning of access based on employment status and role changes.

This policy directly addresses the following risk conditions:

- Orphaned accounts remaining active after employee termination
- Excessive privileges persisting after internal role changes
- Unauthorized access due to delayed or incomplete provisioning

---

## 2. Scope

| Scope Item | Detail |
|---|---|
| Workforce identities | All employees and contractors with Entra ID accounts |
| Connected systems | All applications integrated with Entra ID |
| Access control model | Role-based and group-based access only — no direct user permissions |
| Exclusions | Non-human identities and service accounts (covered separately) |

---

## 3. Control Objectives

| Objective | Standard |
|---|---|
| Timely Provisioning | Access granted within 24 hours of HR record creation |
| Least Privilege | Access scoped to role and business need — no standing over-permission |
| Immediate Deprovisioning | Access fully revoked within 1 hour of confirmed termination |
| Access Continuity on Move | Role change triggers delta review — no gap, no accumulation |
| Auditability | All lifecycle events logged in Entra ID audit log |

---

## 4. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| HR System | Source of truth — triggers all lifecycle events via attribute changes |
| Hiring Manager | Defines required access profile for new hire or role change |
| IT / IAM | Executes provisioning, deprovisioning, and group assignment in Entra ID |
| Security Team | Reviews audit logs, validates deprovisioning, monitors for anomalies |

---

## 5. Joiner Process — New Hire Onboarding

**Trigger:** New hire record created in HR system with confirmed start date.

**Workflow:**
- HR system creates employee record with role, department, and manager attributes
- IAM provisions Entra ID account using standardized naming convention
- User assigned to role-based security groups based on job function
- Application access granted via group membership — no direct assignment
- MFA enrollment enforced via Conditional Access on first login

**Controls:**

| Control | Implementation |
|---|---|
| Default deny model | No access granted unless explicitly assigned via role group |
| MFA enrollment | Required on first login — enforced by Conditional Access |
| Privileged access | Not granted at onboarding — requires separate justification |

**SLA:** Account active within 24 hours of HR record creation.

**Evidence:** JML-STEP-01 (user creation) · JML-STEP-02 (group assignment) · JML-STEP-03 (MFA policy)

---

## 6. Mover Process — Internal Role Change

**Trigger:** Department transfer, promotion, or role change recorded in HR system.

**Workflow:**
- HR updates user attributes (department, title, manager)
- IAM reviews existing group memberships against new role profile
- New access granted via updated group assignment
- Excess access from prior role removed within 24 hours
- Privileged role changes require manager approval before execution

**Controls:**

| Control | Implementation |
|---|---|
| No access accumulation | Prior role access removed — not retained alongside new access |
| Delta review required | IAM validates before/after access state and documents change |
| Change window | Access delta completed within 24 hours of HR attribute update |

**Evidence:** JML-STEP-04 (updated group membership post-move)

---

## 7. Leaver Process — Termination and Offboarding

**Trigger:** Termination confirmed in HR system — voluntary, involuntary, or contract end.

**Workflow:**
- Account disabled in Entra ID immediately upon termination confirmation, blocking all authentication attempts
- All active sessions and refresh tokens revoked, invalidating all authentication tokens and preventing continued access
- Group memberships removed — application access terminated
- Privileged access removed first, before standard access
- Account retained in disabled state for 30 days, then soft-deleted

**Controls:**

| Control | Implementation |
|---|---|
| Deprovisioning SLA | Account disabled within 1 hour of confirmed termination |
| Token revocation | All refresh tokens revoked to prevent session persistence |
| Privileged access first | Admin access removed before standard groups |
| 30-day retention | Disabled account retained for legal hold / data recovery window |

**Evidence:** JML-STEP-05 (account disabled) · JML-STEP-06 (session revocation)

---

## 8. Enforcement Controls

- Conditional Access policies enforce MFA and device compliance on all user sign-ins
- Privileged access controlled through separate administrative accounts and documented approval workflows (PIM integration planned in future iteration)
- Access reviews conducted quarterly — high-risk roles reviewed monthly
- Automated alerts configured for deprovisioning failures and orphaned accounts

---

## 9. Logging and Monitoring

| Log Event | Implementation |
|---|---|
| Identity lifecycle events | All create, modify, disable, delete actions logged in Entra ID audit log |
| Retention | Minimum 90-day retention within Entra ID, aligned to audit and incident response requirements |
| Alert: Deprovisioning failure | Trigger if account not disabled within 2 hours of termination signal |
| Alert: Orphaned account | Trigger if disabled account not removed after 31-day window |

---

## 10. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | JML lifecycle workflows — all three phases |
| AC-2(1) | Automated Account Management | Group-based provisioning and deprovisioning |
| AC-2(2) | Removal of Temporary Accounts | Immediate disablement and session revocation |
| AC-3 | Access Enforcement | RBAC group model — no direct user permissions |
| AC-6 | Least Privilege | Role-scoped access — excess removed on move and exit |
| IA-2 | Identification & Authentication | MFA enforcement via Conditional Access |
| IA-4 | Identifier Management | Unique accounts — no shared credentials |
| AU-2 | Audit Events | Lifecycle events logged in Entra ID |
| AU-9 | Protection of Audit Information | Logs retained with restricted access |

---

## 11. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Orphaned accounts post-termination | 1-hour SLA + session revocation eliminates standing access after exit |
| Privilege accumulation on role change | Delta review + access removal prevents shadow access buildup |
| Delayed provisioning risk | 24-hour SLA reduces exposure window |
| Session persistence after termination | Token revocation closes the authentication gap immediately |

---

## 12. Review and Maintenance

- Policy reviewed annually or upon major system or organizational changes
- Version history maintained in GitHub repository
- Next scheduled review: March 2027

---

## 13. Control Validation

Control effectiveness is validated through:

- Entra ID audit log review for all lifecycle events (create, modify, disable, revoke)
- Evidence artifacts captured for each lifecycle phase (JML-STEP-01 through JML-STEP-06)
- Verification of SLA adherence (provisioning within 24 hours, deprovisioning within 1 hour)
- Periodic review of disabled accounts to confirm no active sessions or access paths remain

This validation approach ensures controls are not only defined but demonstrably enforced.

---

## 14. Assumptions

- HR system acts as authoritative source for identity lifecycle triggers
- All application access is federated through Entra ID
- No direct user permissions exist outside of group-based access model
- Non-human identities and service accounts are managed under a separate policy

---

*SMG-IAM-POL-001 · JML Identity Lifecycle Policy · v1.0 · 2026-03-23 · Internal*
