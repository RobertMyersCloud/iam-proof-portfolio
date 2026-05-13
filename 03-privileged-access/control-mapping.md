# Control Mapping — Privileged Access Pack

This mapping demonstrates how the privileged access governance workflow configured within Microsoft Entra ID Privileged Identity Management (PIM) aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct evidence linkage to privileged access activation workflows and audit artifacts. :contentReference[oaicite:0]{index=0}

---

# NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Eligible assignment model removes standing privileged access | PIM-STEP-03, PIM-STEP-04 |
| AC-3 | Access Control | Access Enforcement | Privileged access requires approval-based activation workflow prior to access grant | PIM-STEP-06 |
| AC-6 | Access Control | Least Privilege | Privileged access granted temporarily with automatic expiration enforcement | PIM-STEP-05, PIM-STEP-06 |
| AC-6(5) | Access Control | Privileged Accounts | Privileged roles managed through eligible assignment and controlled activation workflow | PIM-STEP-01, PIM-STEP-02 |
| AC-6(10) | Access Control | Privileged Access Monitoring | Audit logs capture privileged access requests, approvals, and activation events | PIM-STEP-07 |
| IA-2 | Identification & Authentication | Identification and Authentication | MFA enforced for all privileged role activation requests | PIM-STEP-01, PIM-STEP-05 |
| IA-2(1) | Identification & Authentication | Privileged Network Access | MFA specifically enforced for privileged access workflows | PIM-STEP-01 |
| IA-5 | Identification & Authentication | Authenticator Management | MFA validated during privileged activation process | PIM-STEP-05 |
| AU-2 | Audit & Accountability | Event Logging | Privileged access events logged with actor, timestamp, and action detail | PIM-STEP-07 |
| AU-9 | Audit & Accountability | Protection of Audit Information | Audit logs retained within Microsoft Entra ID with restricted administrative access | PIM-STEP-07 |

---

# CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | Eligible assignment requires approved activation prior to privileged access |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions and functions | Approval workflow validates privileged access authorization |
| AC.L2-3.1.5 | Access Control | Employ the principle of least privilege | Time-limited privileged activation with automatic expiration |
| AC.L2-3.1.6 | Access Control | Use non-privileged accounts for non-privileged activities | Standard account usage maintained outside approved activation windows |
| IA.L2-3.5.3 | Identification & Authentication | Use multifactor authentication | MFA enforced on all privileged role activations |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain audit logs | Microsoft Entra ID PIM audit logs capture privileged access lifecycle events |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit actions are traceable | Audit records include actor attribution, timestamps, and workflow activity |

---

# Evidence Reference

| Evidence File | Controls Supported |
|---|---|
| PIM-STEP-01-role-settings.png | Role configured with MFA, justification, and approval requirements — AC-6(5), IA-2, IA-2(1) |
| PIM-STEP-02-role-settings-saved.png | Role configuration successfully applied and enforced — AC-6(5) |
| PIM-STEP-03-eligible-assignment.png | User assigned as eligible rather than permanently active — AC-2, AC-6 |
| PIM-STEP-04-eligible-role.png | Eligible role visible with activation workflow available — AC-2, AC-6 |
| PIM-STEP-05-activation-request.png | Activation request submitted with documented business justification — AC-6, IA-2, IA-5 |
| PIM-STEP-06-pending-approval.png | Approval gate enforced prior to privileged access activation — AC-3, AC-6(5), AU-2 |
| PIM-STEP-07-audit-log.png | Audit logs showing privileged access workflow activity and monitoring events — AU-2, AU-9, AC-6(10) |

---

# Control Chain Summary

| Step | Action | Controls Supported |
|---|---|---|
| 1 | Role configured with MFA, justification, and approval requirements | IA-2, IA-2(1), IA-5, AC-6(5) |
| 2 | User assigned as eligible rather than permanently active | AC-2 |
| 3 | User submits activation request with business justification | AC-6 |
| 4 | MFA challenge completed during activation request | IA-2, IA-5 |
| 5 | Approval required before privileged access activation | AC-3, AC-6(5) |
| 6 | Privileged access granted temporarily with automatic expiration | AC-6 |
| 7 | Audit logs capture all privileged access workflow events | AU-2, AU-9, AC-6(10) |

---

# Assessment Narrative

This privileged access implementation demonstrates a just-in-time administrative access model using Microsoft Entra ID Privileged Identity Management.

Users receive eligible assignments rather than permanent administrative access. Activation requires MFA, documented business justification, approval, and time-limited duration enforcement.

Evidence demonstrates that privileged access is not granted without workflow enforcement and that all privileged access events remain traceable through audit logging.

The pending approval state validates that privileged access remains gated until approval workflow completion.

This workflow supports least privilege, privileged access accountability, and regulated-environment governance objectives.

---

# Control Effectiveness Statement

The implementation demonstrates that:
- Privileged access is not persistently assigned
- MFA is enforced during privileged activation
- Approval is required before privileged access is granted
- Privileged access expires automatically after approved duration
- Audit logs provide traceable records of all privileged access activity

These controls collectively reduce the risk associated with standing administrative access and improve privileged access accountability.

---

# Mapping References

- NIST SP 800-53 Rev 5
- NIST SP 800-171 Rev 2
- CMMC Level 2 (32 CFR Part 170)

---

# Related Framework Alignment

The controls mapped above support governance concepts commonly associated with additional regulated-environment frameworks including:

- NIST SP 800-171 Rev 2 — Access Control and Identification & Authentication requirements
- SOC 2 Type II (TSC 2017) — Logical access control and monitoring concepts
- CISA Zero Trust Maturity Model — privileged access governance and identity validation principles

---

# Scope Note

This appendix demonstrates privileged access governance workflows within a controlled IAM lab environment.

Expanded cross-framework mappings and consolidated evidence traceability are planned for future governance and evidence-production packs.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
