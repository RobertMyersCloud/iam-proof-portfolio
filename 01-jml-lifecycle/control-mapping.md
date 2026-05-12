# Control Mapping — JML Lifecycle Pack

This mapping demonstrates how identity lifecycle governance workflows configured in Microsoft Entra ID align to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct evidence linkage to configuration artifacts and operational workflows.

---

# NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Full identity lifecycle governance including provisioning, modification, disablement, and session revocation | JML-STEP-01, JML-STEP-04, JML-STEP-05 |
| AC-2(1) | Access Control | Automated Account Management | Group-based provisioning and deprovisioning with no direct user permissions | JML-STEP-02, JML-STEP-04 |
| AC-2(2) | Access Control | Removal of Temporary / Emergency Accounts | Account disablement and session revocation remove active access immediately upon termination | JML-STEP-05, JML-STEP-06 |
| AC-3 | Access Control | Access Enforcement | Role-based security group model with default-deny access approach | JML-STEP-02 |
| AC-6 | Access Control | Least Privilege | Access scoped to business role with excess access removed during role changes and offboarding | JML-STEP-04 |
| AC-6(1) | Access Control | Least Privilege — Authorize Access to Security Functions | Privileged access excluded from standard onboarding workflow and requires separate approval | JML-STEP-01 |
| IA-2 | Identification & Authentication | Identification and Authentication | MFA enforced through Conditional Access for cloud application sign-ins | JML-STEP-03 |
| IA-4 | Identification & Authentication | Identifier Management | Unique identity assignment using standardized UPN structure with no shared accounts | JML-STEP-01 |
| AU-2 | Audit & Accountability | Event Logging | Lifecycle events logged within Microsoft Entra ID audit logs | JML-STEP-05, JML-STEP-06 |
| AU-9 | Audit & Accountability | Protection of Audit Information | Audit logs retained with restricted administrative access controls | JML-STEP-06 |

---

# CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | Role-based security group assignment with no standing over-permission |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions and functions | Application access granted through group membership only |
| AC.L2-3.1.3 | Access Control | Control the flow of CUI | Access scoped by business role with no privilege accumulation across role changes |
| AC.L2-3.1.6 | Access Control | Use non-privileged accounts for non-privileged activities | Standard user onboarding excludes administrative permissions |
| IA.L2-3.5.3 | Identification & Authentication | Use multifactor authentication | MFA enforced through Conditional Access policies |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain audit logs | Microsoft Entra ID audit logging enabled for all lifecycle events |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit actions are traceable | UPN-based logging ties lifecycle actions to unique user identities |

---

# Evidence Reference

| Evidence File | Controls Supported |
|---|---|
| JML-STEP-01-user-created.png | AC-2, IA-4 |
| JML-STEP-02-group-assignment.png | AC-2, AC-2(1), AC-3 |
| JML-STEP-03-mfa-policy.png | IA-2 |
| JML-STEP-04-role-change.png | AC-2, AC-2(1), AC-6 |
| JML-STEP-05-account-disabled.png | AC-2, AC-2(2), AU-2 |
| JML-STEP-06-session-revoked.png | AC-2, AC-2(2), IA-2, AU-2, AU-9 |

---

# Mapping References

- NIST SP 800-53 Rev 5
- NIST SP 800-171 Rev 2
- CMMC Level 2 (32 CFR Part 170)

---

# Related Framework Alignment

The controls mapped above correspond to additional governance and compliance frameworks commonly associated with regulated environments.

This pack supports concepts aligned to:

- NIST SP 800-171 Rev 2 — Access Control (3.1.x) and Identification & Authentication (3.5.x)
- SOC 2 Type II (TSC 2017) — Common Criteria CC6 Logical Access Controls and CC7 Monitoring Controls
- CISA Zero Trust Maturity Model — identity, authentication, and access governance principles

---

# Scope Note

This appendix demonstrates governance alignment and cross-framework applicability within a controlled IAM lab environment.

Expanded cross-framework mappings and consolidated evidence traceability are planned for future governance and evidence-production packs.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
