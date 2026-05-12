# JML Lifecycle Pack

End-to-end Joiner-Mover-Leaver (JML) identity lifecycle demonstration in Microsoft Entra ID with audit-ready evidence aligned to NIST 800-53 and CMMC Level 2.

This pack demonstrates practical identity governance workflows focused on provisioning, access governance, least privilege enforcement, and immediate deprovisioning within regulated environments.

---

# Scenario

A regulated organization requires a controlled identity lifecycle process to ensure:

- New hires receive appropriate role-based access quickly
- Internal transfers receive corrected access without privilege accumulation
- Terminated users lose all access immediately upon offboarding
- All lifecycle actions are auditable and aligned to governance requirements

---

# What Was Built

| Phase | Implementation |
|---|---|
| Joiner | User provisioned in Microsoft Entra ID and assigned via role-based security groups with MFA enforced through Conditional Access |
| Mover | Access recalculated during role change — previous group memberships removed and new role access assigned without privilege accumulation |
| Leaver | Account disabled immediately, active sessions revoked, and access removed across connected resources |

---

# Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Full JML lifecycle — provisioning, modification, disablement, and access removal |
| AC-2(1) | Automated Account Management | Group-based provisioning and deprovisioning with no direct user permissions |
| AC-3 | Access Enforcement | Role-based access through security group membership only |
| AC-6 | Least Privilege | Access scoped to role with excess permissions removed during moves and exits |
| IA-2 | Identification & Authentication | MFA enforced through Conditional Access policies |
| AU-2 | Audit Events | Lifecycle events logged within Microsoft Entra ID audit logs |

---

# Outcome

- Reduced orphaned account risk through enforced 1-hour deprovisioning SLA
- Prevented privilege accumulation during role changes using delta-based access correction
- Enforced least privilege through role-based group assignment with no direct user permissions
- Established audit-ready lifecycle evidence aligned to NIST 800-53 and CMMC Level 2 access control requirements

---

# Evidence Index

| File | What It Shows | Control |
|---|---|---|
| JML-STEP-01-user-created.png | User account created and enabled in Microsoft Entra ID | AC-2 |
| JML-STEP-02-group-assignment.png | User assigned to Finance-ReadOnly security group | AC-2, AC-3 |
| JML-STEP-03-mfa-policy.png | Conditional Access MFA policy enforced across cloud applications | IA-2 |
| JML-STEP-04-role-change.png | Group memberships updated during role transition | AC-2, AC-6 |
| JML-STEP-05-account-disabled.png | Account disabled during offboarding process | AC-2 |
| JML-STEP-06-session-revoked.png | Active sign-in sessions revoked successfully | AC-2, IA-2 |

---

# Pack Contents

| File | Description |
|---|---|
| JML-Policy.md | Identity lifecycle governance policy including workflows, SLAs, and enforcement controls |
| control-mapping.md | NIST 800-53 and CMMC Level 2 control alignment |
| resume-bullets.md | Resume-ready implementation bullet points |
| interview-questions.md | IAM interview questions supported by this implementation |
| evidence/ | Microsoft Entra ID configuration screenshots and evidence artifacts |

---

# Interview Value

This pack demonstrates practical approaches to:

- Identity lifecycle management (Joiner, Mover, Leaver)
- Least privilege enforcement through RBAC
- Access correction during internal role changes
- MFA enforcement using Conditional Access
- Immediate deprovisioning and session termination
- Audit-ready governance evidence preparation
- NIST 800-53 and CMMC Level 2 control alignment

This directly supports IAM, identity governance, access management, and compliance-focused interview discussions.

---

# Governance Alignment

This pack aligns to:
- NIST SP 800-53 Rev 5
- NIST SP 800-171
- CMMC Level 2
- SOC 2 Type II (CC6)
- CISA Zero Trust Maturity Model

---

# Environment

- Microsoft Entra ID
- rjmyers.cloud tenant
- Pack version: v1.0 — March 2026

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
