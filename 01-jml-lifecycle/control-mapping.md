# Control Mapping — JML Lifecycle Pack

This mapping demonstrates how identity lifecycle controls implemented in Microsoft Entra ID align to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct evidence linkage to system configuration.

## NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Full identity lifecycle — account provisioning, access modification, account disablement, and session termination | JML-STEP-01, JML-STEP-04, JML-STEP-05 |
| AC-2(1) | Access Control | Automated Account Management | Group-based provisioning and deprovisioning — no direct user permissions | JML-STEP-02, JML-STEP-04 |
| AC-2(2) | Access Control | Removal of Temporary / Emergency Accounts | Account disablement and session revocation ensure immediate removal of active access | JML-STEP-05, JML-STEP-06 |
| AC-3 | Access Control | Access Enforcement | Role-based group membership only — default deny model | JML-STEP-02 |
| AC-6 | Access Control | Least Privilege | Access scoped to role — excess removed on move and exit | JML-STEP-04 |
| AC-6(1) | Access Control | Least Privilege — Authorize Access to Security Functions | Privileged access not granted at provisioning — requires separate justification | JML-STEP-01 |
| IA-2 | Identification & Authentication | Identification and Authentication | MFA enforced via Conditional Access on all cloud app sign-ins | JML-STEP-03 |
| IA-4 | Identification & Authentication | Identifier Management | Unique user identity — standardized UPN format, no shared accounts | JML-STEP-01 |
| AU-2 | Audit & Accountability | Event Logging | All lifecycle events logged in Entra ID audit log | JML-STEP-05, JML-STEP-06 |
| AU-9 | Audit & Accountability | Protection of Audit Information | Logs retained within Entra ID with restricted access — modification not permitted for standard users | JML-STEP-06 |

## CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | Role-based group assignment — no standing over-permission |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions | Group-based access — application access via membership only |
| AC.L2-3.1.3 | Access Control | Control CUI flow | Access scoped by role — no accumulation across moves |
| AC.L2-3.1.6 | Access Control | Use non-privileged accounts for non-privileged activities | Standard user provisioning — no admin rights at onboarding |
| IA.L2-3.5.3 | Identification & Authentication | Use multifactor authentication | MFA enforced via Conditional Access policy |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain system audit logs | Entra ID audit log captures all lifecycle events |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit log actions are traceable | UPN-based logging — all actions attributed to specific identity |

## Evidence Reference

| Evidence File | Controls Satisfied |
|---|---|
| JML-STEP-01-user-created.png | AC-2, IA-4 |
| JML-STEP-02-group-assignment.png | AC-2, AC-2(1), AC-3 |
| JML-STEP-03-mfa-policy.png | IA-2 |
| JML-STEP-04-role-change.png | AC-2, AC-2(1), AC-6 |
| JML-STEP-05-account-disabled.png | AC-2, AC-2(2), AU-2 |
| JML-STEP-06-session-revoked.png | AC-2, AC-2(2), IA-2, AU-2, AU-9 |

---

*Mapping reference: NIST SP 800-53 Rev 5 · CMMC Level 2 (32 CFR Part 170) · NIST SP 800-171 Rev 2*
