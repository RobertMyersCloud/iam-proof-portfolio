# Privileged Access Management Policy

**Document ID:** SMG-IAM-POL-003  
**Version:** 1.0  
**Date:** 2026-03-24  
**Owner:** Robert J. Myers  

---

# Executive Summary

This policy defines the privileged access management program for Microsoft Entra ID administrative roles using Privileged Identity Management (PIM).

The program establishes just-in-time privileged access controls including MFA enforcement, approval workflows, documented justification, and time-limited activation to reduce standing administrative access risk and support audit traceability within regulated environments.

Standing privileged access increases exposure to:
- credential theft
- privilege escalation
- unauthorized administrative activity
- reduced accountability
- lateral movement risk

This policy addresses those risks by ensuring privileged access is:
- temporary
- approved
- attributable
- monitored
- auditable

---

# Control Objective

Ensure privileged access is granted:
- only when required
- only for the minimum duration necessary
- only with documented business justification
- only after approval
- with all actions logged and traceable

This policy supports:
- least privilege enforcement
- separation of duties
- privileged access accountability
- continuous monitoring of administrative activity

---

# 1. Purpose

This policy establishes privileged access governance controls for Microsoft Entra ID administrative roles using Privileged Identity Management (PIM).

The policy ensures:
- No standing administrative access exists for in-scope privileged roles
- Privileged access requires just-in-time activation
- MFA is enforced for every activation
- Activation requests require documented justification
- Privileged access is time-limited and expires automatically
- All privileged access activity is logged and auditable

---

# 2. Scope

| Scope Item | Detail |
|---|---|
| Roles in scope | Microsoft Entra ID administrative roles managed through PIM |
| Assignment model | Eligible assignment only — no permanent active assignments |
| Activation requirements | MFA + justification + approval |
| Exclusions | Break-glass emergency accounts managed under separate procedures |

---

# 3. Role Tiers and Activation Requirements

| Role Tier | Example Roles | MFA | Justification | Approval | Maximum Duration |
|---|---|---|---|---|---|
| Tier 0 — Critical | Global Administrator | Required | Required | Required | 2 hours |
| Tier 1 — High | Security Administrator, User Administrator | Required | Required | Required | 4 hours |
| Tier 2 — Standard | Security Reader, Reports Reader | Required | Required | Required | 8 hours |

---

# 4. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| PIM Owner | Configures role settings, manages eligible assignments, reviews audit logs |
| Approver | Reviews activation requests and validates business justification |
| Eligible User | Requests activation, provides justification, completes MFA |
| Security Team | Monitors audit logs and reviews privileged access activity |

---

# 5. Activation Workflow

**Trigger:**  
An eligible user requires privileged access to perform an authorized administrative task.

## Workflow

1. User selects eligible role within PIM
2. User enters documented business justification
3. User selects activation duration within approved maximum
4. User completes MFA challenge
5. Activation request routes to designated approver
6. Approver reviews and approves or denies request
7. If approved, privileged access activates temporarily
8. Access expires automatically at duration end
9. All events are recorded within Microsoft Entra ID audit logs

---

# Justification Standards

| Quality | Example |
|---|---|
| Acceptable | "Security investigation requiring Security Reader access for incident review" |
| Acceptable | "Quarterly audit validation requiring temporary log review access" |
| Not Acceptable | "Need access" |
| Not Acceptable | "Admin work" |

---

# 6. Approval Requirements

- All privileged activations require approval before access is granted
- Self-approval is prohibited
- Approvers must review documented justification prior to approval
- Blanket approvals and habitual approvals are prohibited
- Requests without adequate justification must be denied
- Requests expire if approval is not completed within the defined response window

---

# 7. Break-Glass Accounts

Break-glass accounts are excluded from standard PIM activation workflows due to emergency operational requirements.

These accounts require:
- Separate governance procedures
- Restricted physical and logical access controls
- Immediate alerting upon use
- Mandatory post-event review
- Regular credential rotation

---

# 8. Enforcement Controls

- All in-scope privileged roles managed through PIM
- Eligible assignment model enforced for privileged roles
- Direct permanent assignment prohibited for in-scope roles
- MFA enforced on every activation request
- Time-limited access enforced automatically
- Audit logging enabled for all privileged access events

---

# 9. Logging and Monitoring

| Event | Implementation |
|---|---|
| Role configuration changes | Logged within PIM Resource audit logs |
| Eligible assignments | Logged with actor and timestamp |
| Activation requests | Logged with justification and duration |
| Approval decisions | Logged with approver and decision outcome |
| Access expiration | Logged automatically upon expiration |
| Retention | Minimum 90-day retention |

---

# 10. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Eligible assignment model eliminates standing privileged access |
| AC-3 | Access Enforcement | Privileged access requires activation workflow |
| AC-6 | Least Privilege | Access expires automatically after approved duration |
| AC-6(5) | Privileged Accounts | Privileged access controlled through eligible assignment and approval workflow |
| IA-2 | Identification & Authentication | MFA required for every activation |
| IA-2(1) | Privileged Network Access | MFA enforced specifically for privileged access |
| IA-5 | Authenticator Management | MFA validated during activation workflow |
| AU-2 | Audit Events | All privileged access events logged and attributable |

---

# 11. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Standing administrative access | Eligible assignment eliminates permanent access |
| Credential theft exposure | MFA and approval required before activation |
| Undocumented privileged access | Justification required for every request |
| Unauthorized privilege escalation | Approval gate prevents self-elevation |
| Missing privileged access traceability | Audit logs capture complete activation lifecycle |

---

# 12. Control Validation

Control effectiveness is validated through:
- Review of PIM audit logs
- Verification of eligible-only assignments
- Activation workflow testing
- Evidence artifact review
- Quarterly review of privileged access activity
- Verification that approval is required before activation completes

Evidence artifacts include:
- PIM-STEP-01 through PIM-STEP-07

---

# 13. Assumptions

- Microsoft Entra ID P2 licensing is active
- Administrative roles are managed through PIM
- Approvers are available within defined response windows
- Break-glass accounts are governed separately

---

# 14. Evidence Requirements

Each activation workflow must produce:
- Role configuration evidence
- Eligible assignment evidence
- Activation request with justification
- Approval or denial evidence
- Audit log correlation records

Evidence must remain accessible for governance and compliance activities.

---

# 15. Metrics and Governance

Tracked metrics include:
- Total activation requests
- Approval vs denial rate
- Average approval response time
- Activation requests without justification
- Detection of direct active assignments

Metrics are reviewed quarterly to evaluate privileged access governance effectiveness and identify operational gaps.

---

# 16. Review and Maintenance

- Policy reviewed annually or after major organizational or technical changes
- Version history maintained within GitHub repository
- Next scheduled review: March 2027

---

# 17. Prohibited Conditions

The following conditions are prohibited:
- Permanent active assignment for in-scope privileged roles
- Activation without MFA
- Self-approval of privileged access
- Approval without justification review
- Vague or undocumented activation requests

Violations require escalation and review.

---

# 18. Control Violations and Detection

Violations may include:
- Direct active assignments outside PIM
- Missing justification
- Approval anomalies
- Excessive activation frequency
- Abnormal activation durations

Detected violations are reviewed and escalated to Security leadership.

---

# 19. Governance Principle

Privileged access is treated as a controlled governance function rather than a persistent administrative entitlement.

All privileged access must be:
- temporary
- attributable
- approved
- monitored
- auditable

---

# 20. Assessment Narrative

This privileged access implementation demonstrates a just-in-time administrative access model using Microsoft Entra ID Privileged Identity Management.

Users receive eligible assignments rather than permanent administrative access. Activation requires MFA, documented business justification, approval, and time-limited duration enforcement.

Evidence demonstrates that privileged access is not granted without workflow enforcement and that all events remain traceable through audit logging.

This workflow supports least privilege, privileged access accountability, and regulated-environment governance objectives.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*

**SMG-IAM-POL-003 · Privileged Access Management Policy · v1.0 · Internal**
