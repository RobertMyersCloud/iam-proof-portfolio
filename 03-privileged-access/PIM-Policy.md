# Privileged Access Management Policy

**Document ID:** SMG-IAM-POL-003
**Version:** 1.0
**Date:** 2026-03-24
**Owner:** Robert J. Myers

---

## Executive Summary

This policy defines the privileged access management program for administrative roles in Microsoft Entra ID. It establishes just-in-time activation controls, MFA enforcement, approval workflows, and time-limited access duration to eliminate standing administrative privileges and produce audit-ready evidence for compliance assessments.

Standing privileged access presents a high-risk condition due to potential misuse, credential theft, lateral movement, and lack of accountability. This policy addresses that risk by ensuring privileged access is never permanently assigned and always requires a documented, approved, time-limited activation.

---

## Control Objective

Ensure that privileged access to systems and administrative roles is granted only when required, only for the minimum duration necessary, only with documented justification, and only after approval — with all events recorded and auditable.

This control supports enforcement of least privilege, separation of duties, and continuous monitoring of privileged identity activity.

---

## 1. Purpose

This policy establishes privileged access management controls for Microsoft Entra ID administrative roles using Privileged Identity Management (PIM). It ensures:

- No standing administrative access exists for in-scope roles
- All privileged access requires just-in-time activation
- Activation requires MFA, documented justification, and approval
- Access is time-limited and expires automatically
- All events are captured in an auditable log

---

## 2. Scope

| Scope Item | Detail |
|---|---|
| Roles in scope | All Microsoft Entra ID administrative roles managed through PIM |
| Assignment model | Eligible only — no permanent active assignments for in-scope roles |
| Activation requirements | MFA + justification + approval for all activations |
| Exclusions | Break-glass emergency accounts (covered under separate procedure) |

---

## 3. Role Tiers and Activation Requirements

| Role Tier | Examples | MFA | Justification | Approval | Max Duration |
|---|---|---|---|---|---|
| Tier 0 — Critical | Global Administrator | Required | Required | Required | 2 hours |
| Tier 1 — High | Security Administrator, User Administrator | Required | Required | Required | 4 hours |
| Tier 2 — Standard | Security Reader, Reports Reader | Required | Required | Required | 8 hours |

---

## 4. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| PIM Owner | Configures role settings, manages eligible assignments, reviews audit logs |
| Approver | Reviews activation requests, approves or denies based on documented justification |
| Eligible User | Submits activation request with business justification, completes MFA |
| Security Team | Reviews PIM audit logs, monitors for anomalous activation patterns |

---

## 5. Activation Process

**Trigger:** Eligible user requires privileged access to perform an administrative task.

**Workflow:**
- User navigates to PIM My roles and selects eligible role
- User enters business justification and selects duration (within maximum)
- User completes MFA challenge
- Activation request routed to designated approver
- Approver reviews justification and approves or denies
- If approved — role activated for specified duration, access expires automatically
- If denied — user notified, no access granted
- All events captured in PIM Resource audit log

**Justification requirements:**

| Quality | Example |
|---|---|
| Acceptable | "Security investigation — requires read access to audit logs for incident IR-2026-042" |
| Acceptable | "Quarterly user access review — requires Security Reader for 4 hours" |
| Not acceptable | "Need access" |
| Not acceptable | "Admin work" |

---

## 6. Approval Requirements

- All activation requests require approval before access is granted
- Approvers must be distinct from the requestor — no self-approval
- Approvers must review justification before approving
- Approvals must be based on documented business justification — blanket or habitual approvals are prohibited
- Approvals without review constitute a control failure
- If no approver responds within defined window, request expires without access being granted

---

## 7. Break-Glass Accounts

Break-glass emergency accounts are excluded from PIM activation requirements due to their emergency-access nature. They are subject to:

- Separate policy and procedure documentation
- Strict physical and logical access controls
- Mandatory immediate alert upon any use
- Mandatory post-incident review after any use
- Regular credential rotation

---

## 8. Enforcement Controls

- All in-scope roles configured in PIM with activation requirements
- Eligible assignment model enforced — direct active assignment not permitted for in-scope roles
- MFA enforcement cannot be bypassed — required on every activation
- Time-limited access enforced by PIM — no manual extension without new activation request
- Audit alerts configured for activation requests, approvals, and denials

---

## 9. Logging and Monitoring

| Log Event | Implementation |
|---|---|
| Role setting changes | Captured in PIM Resource audit log |
| Eligible assignments | Logged with requestor, target, and timestamp |
| Activation requests | Logged with justification, duration, and requestor |
| Approval decisions | Logged with approver, decision, and timestamp |
| Access expiration | Logged automatically when activation duration expires |
| Retention | Minimum 90-day retention within Entra ID audit log |

---

## 10. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Eligible assignment model — no standing privileged access |
| AC-3 | Access Enforcement | Privileged access requires activation workflow — not direct assignment |
| AC-6 | Least Privilege | Time-limited activation — access expires after defined duration |
| AC-6(5) | Privileged Accounts | Privileged roles assigned as eligible and activated through controlled workflow — eliminating permanent administrative assignments |
| IA-2 | Identification & Authentication | MFA required on every activation request |
| IA-2(1) | Network Access to Privileged Accounts | MFA enforced for all privileged role activations |
| IA-5 | Authenticator Management | MFA enforced during privileged role activation |
| AU-2 | Audit Events | All PIM events logged with actor, timestamp, and outcome |

---

## 11. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Standing privileged access misuse | Eligible assignment eliminates permanent admin access |
| Credential theft enabling persistent admin access | JIT model means stolen credentials cannot be used for standing privilege |
| Undocumented privileged access | Justification required for every activation |
| Privilege escalation without oversight | Approval gate ensures human review before access is granted |
| No audit trail for privileged activity | PIM audit log captures complete activation lifecycle |

---

## 12. Control Validation

Control effectiveness is validated through:

- PIM Resource audit log review confirming activation requests, approvals, and expirations
- Evidence artifacts captured for each activation lifecycle phase (PIM-STEP-01 through PIM-STEP-07)
- Verification that no permanent active assignments exist for in-scope roles
- Periodic review of eligible assignments to confirm continued business need
- Quarterly review of PIM audit logs for anomalous activation patterns

---

## 13. Assumptions

- Microsoft Entra ID P2 license is active — required for Privileged Identity Management
- All administrative roles are managed through PIM — direct active assignment not used
- Approvers are available and responsive within the defined approval window
- Break-glass accounts are documented and managed under separate procedure

---

## 14. Evidence Requirements

Each activation cycle must produce the following evidence:

- Role configuration showing activation requirements (MFA, justification, approval)
- Eligible assignment record for the requesting user
- Activation request with documented justification
- Approval or denial decision by designated approver
- PIM audit log entries capturing all events with timestamps

---

## 15. Metrics and Governance

The following metrics are tracked:

- Total activation requests per period
- Approval rate vs denial rate
- Average time from request to approval decision
- Activations without justification (should be zero)
- Direct active assignments detected (should be zero)

Metrics are reviewed quarterly by IAM and Security leadership.

---

## 16. Review and Maintenance

- Policy reviewed annually or upon major system or organizational changes
- Version history maintained in GitHub repository
- Next scheduled review: March 2027

---

## 17. Prohibited Conditions

The following conditions are explicitly prohibited:

- Permanent active assignment of privileged roles for in-scope accounts
- Activation of privileged roles without MFA
- Approval of activation requests without reviewing justification
- Self-approval of privileged access requests
- Activation requests with vague or missing justification

Any occurrence of these conditions constitutes a control violation and must be investigated.

---

## 18. Control Violations and Detection

Control violations are identified through:

- Detection of direct active role assignments outside PIM
- Activation requests without justification or with invalid justification
- Approval patterns indicating lack of reviewer validation
- Audit log anomalies in activation frequency or duration

All violations are logged, reviewed, and escalated to Security leadership.

---

## 19. Assessment Narrative

The privileged access management implementation demonstrates elimination of standing administrative access through a just-in-time activation model.

Users are assigned eligible roles and must request activation with documented justification, complete MFA, and obtain approval before access is granted. Access is time-limited and automatically expires.

Evidence confirms that privileged access is not available without activation and approval, and all events are recorded in the Entra ID audit log.

This establishes a defensible privileged access control aligned to NIST 800-53 and CMMC Level 2 requirements.

---

*SMG-IAM-POL-003 · Privileged Access Management Policy · v1.0 · 2026-03-24 · Internal*
