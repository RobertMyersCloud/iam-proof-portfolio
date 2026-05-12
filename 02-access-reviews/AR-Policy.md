# Access Review Program Policy

**Document ID:** SMG-IAM-POL-002  
**Version:** 1.0  
**Date:** 2026-03-24  
**Owner:** Robert J. Myers  

---

# Executive Summary

This policy defines a periodic access review program for workforce group memberships within Microsoft Entra ID Identity Governance.

The program establishes reviewer accountability, documented decision-making, and access removal procedures to support least privilege enforcement, ongoing access validation, and audit traceability within regulated environments.

The program helps ensure:
- Access is not retained beyond business need
- Inactive users are identified through automated recommendations
- Reviewer decisions are documented with justification
- Access removal actions are enforced and traceable
- Audit-ready evidence is retained for governance and compliance activities

---

# Control Objective

Ensure that access to systems and data is reviewed periodically, validated against business need, and removed when no longer required, with all decisions documented and auditable.

The program supports least privilege enforcement by requiring periodic validation of continued business need for group-based access.

This control also supports continuous monitoring of identity-based access governance.

---

# 1. Purpose

This policy establishes the access review program for certifying continued business need for group-based access within Microsoft Entra ID.

The policy ensures:
- Unnecessary access is identified and removed on a defined cadence
- Reviewer decisions are documented with justification
- Access removal is enforced upon review completion
- Audit-ready evidence is produced for each review cycle
- Access governance activities remain traceable and repeatable

---

# 2. Scope

| Scope Item | Detail |
|---|---|
| Groups in scope | Security groups controlling access to business-sensitive applications and data |
| Review population | All members of in-scope groups at time of review |
| Reviewer model | Assigned reviewer per group — no self-review |
| Exclusions | Service accounts and non-human identities managed under separate governance procedures |

---

# 3. Review Cadence

| Group Tier | Frequency | Rationale |
|---|---|---|
| Standard access groups | Quarterly | Baseline cadence for least privilege enforcement |
| Privileged / administrative groups | Monthly | Elevated risk requires increased review frequency |
| Guest / external users | Monthly | Higher exposure risk requires shorter certification window |

---

# 4. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| Review Owner | Creates and manages access review campaigns within Microsoft Entra ID Identity Governance |
| Reviewer | Evaluates continued business need and records decision with justification |
| IAM / IT | Monitors review completion, escalates overdue reviews, and validates enforcement |
| Security Team | Reviews audit logs, validates evidence, and confirms governance alignment |

---

# 5. Review Process

**Trigger:**  
Scheduled review campaigns activate automatically based on defined review cadence.

## Workflow

1. Review campaign created within Microsoft Entra ID Identity Governance
2. Reviewers notified through My Access portal
3. Reviewer evaluates each user account:
   - Approve
   - Deny
   - Don't Know
4. Justification required for Deny decisions
5. Automated recommendations surfaced based on activity indicators
6. Denied access removed upon review completion through configured enforcement settings
7. Audit logs capture all review events, decisions, and outcomes

---

## Decision Options

| Decision | Meaning | Outcome |
|---|---|---|
| Approve | Continued business need verified | Access retained |
| Deny | Business need not confirmed or user inactive | Access removed |
| Don't Know | Reviewer unable to validate access | Escalated for secondary review |

---

# 6. Automated Recommendations

Microsoft Entra ID Identity Governance provides automated recommendations using:
- User sign-in activity
- Inactive user detection thresholds
- Activity and risk indicators surfaced through Microsoft Entra ID Identity Governance

Reviewers may consider automated recommendations during evaluation but remain responsible for the final decision and documented justification.

---

# 7. Access Removal

- Denied access is removed automatically upon review completion through configured auto-apply settings
- If automated enforcement fails, manual removal is required within 24 hours of review closure
- Delayed or incomplete removal is treated as an access governance exception and escalated for review
- Access removal events are logged within Microsoft Entra ID audit logs
- Group membership changes remain traceable to originating review actions

---

# 8. Enforcement Controls

- Reviews are managed through Microsoft Entra ID Identity Governance
- Reviewer assignment enforces separation of duties
- Users are prohibited from reviewing their own access
- Auto-apply settings enforce access removal after denial decisions
- Overdue reviews escalate to IAM leadership after defined grace periods

---

# 9. Logging and Monitoring

| Log Event | Implementation |
|---|---|
| Review creation | Captured within Microsoft Entra ID audit logs |
| Reviewer decisions | Logged with actor, timestamp, decision, and justification |
| Access removal | Captured as security group membership change |
| Retention | Minimum 90-day audit log retention |

---

# 10. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Periodic review and removal of unnecessary access |
| AC-2(4) | Automated Audit Actions | Automated recommendations generated from activity indicators |
| AC-5 | Separation of Duties | Reviewer distinct from reviewed user |
| AC-6 | Least Privilege | Access removed when business need is not validated |
| CA-7 | Continuous Monitoring | Quarterly review cadence supporting ongoing validation |
| AU-2 | Audit Events | Decisions logged with actor, timestamp, and outcome |

---

# 11. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Accumulation of unnecessary access over time | Quarterly certification requires active validation of business need |
| Inactive users retaining group membership | Automated inactivity recommendations surface dormant accounts |
| Undocumented access decisions | Reviewer justification required for denial decisions |
| Residual access following role change | Review cadence identifies access not removed during transitions |

Failure to periodically validate access increases the risk of privilege accumulation, unauthorized access retention, and reduced audit traceability across regulated environments.

---

# 12. Control Validation

Control effectiveness is validated through:
- Audit log review confirming reviewer decisions are recorded with actor and timestamp
- Evidence artifacts captured for each review phase (AR-STEP-01 through AR-STEP-06)
- Verification that denied access resulted in actual access removal
- Quarterly review of completion rates and overdue campaigns

---

# 13. Assumptions

- Microsoft Entra ID P2 licensing is active
- Application access is controlled through group membership
- Reviewers have access to My Access portal
- Reviewers are trained on review procedures
- Auto-apply enforcement is enabled for denied access removal

---

# 14. Governance Principle

Access reviews are treated as an operational governance control rather than an administrative activity.

Reviewer accountability, documented justification, enforcement actions, and audit traceability are required for all review cycles.

---

# 15. Review and Maintenance

- Policy reviewed annually or upon major organizational or technical change
- Version history maintained within GitHub repository
- Next scheduled review: March 2027

---

# 16. Evidence Requirements

Each review cycle must produce:
- Review configuration evidence
- Reviewer decision records
- Access removal confirmation
- Audit log evidence
- Evidence index mapping artifacts to controls

Required audit log artifacts include:
- Review creation
- Reviewer decisions
- Group membership changes
- Enforcement outcomes

All evidence must remain accessible for governance, compliance, and audit activities.

---

# 17. Metrics and Governance

The following metrics are tracked:
- Review completion rate
- Overdue review count
- Denied access rate
- Time-to-removal following denial

Metrics are reviewed quarterly to evaluate review effectiveness, completion trends, and governance gaps.

---

# Governance Alignment

This policy supports concepts aligned to:
- NIST SP 800-53 Rev 5
- NIST SP 800-171
- CMMC Level 2
- SOC 2 Type II
- CISA Zero Trust Maturity Model

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*

**SMG-IAM-POL-002 · Access Review Program Policy · v1.0 · Internal**
