# Privileged Access Pack — PIM

Just-in-time privileged access demonstration using Microsoft Entra ID Privileged Identity Management (PIM) to support least privilege enforcement, approval-based activation, MFA validation, and audit-ready privileged access governance aligned to NIST 800-53 and CMMC Level 2. :contentReference[oaicite:0]{index=0}

This pack demonstrates practical privileged access governance workflows including eligible role assignment, activation approval, MFA enforcement, time-limited administrative access, and audit traceability within regulated environments.

---

# Scenario

Standing privileged access presents elevated risk due to:
- credential theft
- privilege escalation
- lateral movement
- unauthorized administrative activity
- reduced accountability

A regulated organization requires administrative access to be:
- temporary
- approved
- attributable
- time-limited
- auditable

Users requiring privileged access must:
- receive eligible assignments rather than permanent access
- request activation with documented business justification
- complete MFA
- obtain approval prior to activation
- operate within defined activation durations

All privileged access activity must remain traceable through audit logging.

---

# What Was Built

| Component | Implementation |
|---|---|
| Role configuration | Security Reader role configured with MFA, justification, approval, and activation duration requirements |
| Approver assignment | Designated approver assigned for privileged activation review |
| Eligible assignment | Users assigned as eligible rather than permanently active |
| Activation request | User submits time-limited activation request with documented business justification |
| Approval workflow | Activation request routed for approval prior to access grant |
| Audit trail | All privileged access events captured within Microsoft Entra ID PIM audit logs |

---

# Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Eligible assignment model removes standing privileged access |
| AC-3 | Access Enforcement | Privileged access requires activation workflow and approval |
| AC-6 | Least Privilege | Access granted temporarily and expires automatically |
| AC-6(5) | Privileged Accounts | Privileged roles managed through controlled activation workflow |
| IA-2 | Identification & Authentication | MFA required for every activation |
| IA-2(1) | Privileged Network Access | MFA enforced specifically for privileged access |
| IA-5 | Authenticator Management | MFA validated during activation workflow |
| AU-2 | Audit Events | All privileged access events logged with actor and timestamp |
| AU-9 | Protection of Audit Information | Audit logs retained within Microsoft Entra ID with restricted access |

---

# Outcome

- Eliminated standing privileged access through eligible assignment model
- Enforced MFA on all privileged role activations
- Required documented business justification for privileged access requests
- Implemented approval-based activation workflow preventing self-approval
- Verified privileged access is not granted until approval workflow completion
- Generated complete audit trail from role configuration through activation request and approval workflow

---

# Evidence Index

| File | What It Shows | Control |
|---|---|---|
| PIM-STEP-01-role-settings.png | Role configured with MFA, justification, and approval requirements | AC-6(5), IA-2 |
| PIM-STEP-02-role-settings-saved.png | Role settings successfully updated and enforced | AC-6(5) |
| PIM-STEP-03-eligible-assignment.png | User assigned as eligible rather than permanently active | AC-2, AC-6 |
| PIM-STEP-04-eligible-role.png | Eligible role visible with activation workflow available | AC-2, AC-6 |
| PIM-STEP-05-activation-request.png | Activation request submitted with documented justification | AC-6, IA-2, IA-5 |
| PIM-STEP-06-pending-approval.png | Activation request pending approval prior to access grant | AC-3, AC-6(5), AU-2 |
| PIM-STEP-07-audit-log.png | Audit logs showing role configuration, assignments, and activation events | AU-2, AU-9 |

---

# Control Chain Summary

| Step | Action | Controls Supported |
|---|---|---|
| 1 | Role configured with MFA, justification, and approval requirements | IA-2, IA-5, AC-6(5) |
| 2 | User assigned as eligible rather than permanently active | AC-2 |
| 3 | User submits activation request with business justification | AC-6 |
| 4 | Approval required before privileged access activation | AC-3, AC-6(5) |
| 5 | Access granted temporarily with automatic expiration | AC-6 |
| 6 | Audit logs capture activation lifecycle events | AU-2, AU-9 |

---

# Assessment Narrative

This privileged access implementation demonstrates a just-in-time administrative access model using Microsoft Entra ID Privileged Identity Management.

Users receive eligible assignments rather than permanent privileged access. Activation requires MFA, documented business justification, approval, and time-limited duration enforcement.

Evidence demonstrates that privileged access is not granted without workflow enforcement and that all privileged access events remain traceable through audit logging.

This workflow supports least privilege, privileged access accountability, and regulated-environment governance objectives.

---

# Pack Contents

| File | Description |
|---|---|
| PIM-Policy.md | Privileged access management policy including activation controls, approval workflow, and governance requirements |
| control-mapping.md | NIST 800-53 and CMMC Level 2 control mapping with evidence linkage |
| resume-bullets.md | Resume-ready privileged access governance bullet points |
| interview-questions.md | IAM and privileged access interview questions supported by this implementation |
| evidence/ | Microsoft Entra ID PIM screenshots and governance evidence artifacts |

---

# Interview Value

This pack demonstrates practical approaches to:

- Just-in-time privileged access management
- Eligible assignment governance
- MFA enforcement for administrative access
- Approval-based privileged role activation
- Time-limited administrative access control
- Audit-ready privileged access evidence preparation
- Governance alignment to NIST 800-53 and CMMC Level 2 requirements

This directly supports IAM, PAM, privileged access governance, access management, and compliance-focused interview discussions.

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

- Microsoft Entra ID Privileged Identity Management (PIM)
- rjmyers.cloud tenant
- Pack version: v1.0 — March 2026

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
