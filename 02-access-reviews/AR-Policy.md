# Access Review Program Policy

**Document ID:** SMG-IAM-POL-002
**Version:** 1.0
**Date:** 2026-03-24
**Owner:** Robert J. Myers

---

## Executive Summary

This policy defines a periodic access certification program for workforce group memberships in Microsoft Entra ID. It establishes reviewer accountability, decision documentation requirements, and access removal procedures to enforce least privilege over time and produce assessor-ready compliance evidence.

The program ensures access is not retained beyond business need, inactive users are identified through automated recommendations, and all decisions are traceable to a named reviewer with documented justification.

---

## Control Objective

Ensure that access to systems and data is reviewed periodically, validated against business need, and removed when no longer required, with all decisions documented and auditable.

This control supports enforcement of least privilege and continuous monitoring of identity-based access.

---

## 1. Purpose

This policy establishes the access review program for certifying continued business need for group-based access in Microsoft Entra ID. It ensures:

- Unnecessary access is identified and removed on a defined cadence
- Reviewer decisions are documented with justification
- Access removal is enforced upon review completion
- Audit-ready evidence is produced for each review cycle

---

## 2. Scope

| Scope Item | Detail |
|---|---|
| Groups in scope | Security groups controlling access to business-sensitive applications and data |
| Review population | All members of in-scope groups at time of review |
| Reviewer model | Selected reviewer assigned per group — not self-review |
| Exclusions | Service accounts and non-human identities (covered under separate policy) |

---

## 3. Review Cadence

| Group Tier | Frequency | Rationale |
|---|---|---|
| Standard access groups | Quarterly | Baseline cadence for least privilege enforcement |
| Privileged / admin groups | Monthly | Elevated risk — more frequent certification required |
| Guest / external users | Monthly | Higher risk profile — shorter certification window |

---

## 4. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| Review Owner | Creates and manages review campaigns in Entra ID Identity Governance |
| Reviewer | Evaluates each user's continued need for access and records decision with justification |
| IAM / IT | Monitors review completion, escalates overdue reviews, applies results |
| Security Team | Validates evidence, reviews audit logs, confirms access removal |

---

## 5. Review Process

**Trigger:** Scheduled review campaign activates automatically per defined cadence.

**Workflow:**
- Review campaign created in Entra ID Identity Governance scoped to target group
- Reviewers notified via email with link to My Access portal
- Reviewer evaluates each user — Approve, Deny, or Don't Know
- Justification required for all Deny decisions
- System provides automated recommendations based on user activity signals
- Upon review completion, denied access is removed per configured auto-apply settings
- Audit log captures all decisions with actor, timestamp, and outcome

**Decision options:**

| Decision | Meaning | Outcome |
|---|---|---|
| Approve | Access confirmed — continued business need verified | Access retained |
| Deny | Access not confirmed — no business need or user inactive | Access removed on completion |
| Don't Know | Reviewer unable to determine — escalated for secondary review | Pending resolution |

---

## 6. Automated Recommendations

Microsoft Entra ID Identity Governance provides automated recommendations based on:

- User sign-in activity (last interactive sign-in date)
- Inactive user detection (no sign-in within defined threshold)
- Machine learning signals from Microsoft's identity platform

Reviewers should consider system recommendations but are required to make an independent decision and document justification.

---

## 7. Access Removal

- Denied access is removed automatically upon review completion via auto-apply settings
- If auto-apply is unavailable or fails, manual removal is required within 24 hours of review closure
- Failure to remove denied access within defined timeframe is treated as a control failure and escalated
- Removed users are logged in the Entra ID audit log
- Group membership changes are traceable to the originating review decision

---

## 8. Enforcement Controls

- Reviews are created and managed in Entra ID Identity Governance (P2 license required)
- Reviewer assignment enforces separation of duties — users do not review their own access
- Auto-apply settings enforce access removal without manual intervention
- Overdue reviews escalate to IAM lead after defined grace period

---

## 9. Logging and Monitoring

| Log Event | Implementation |
|---|---|
| Review creation | Captured in Entra ID audit log — Service: Access Reviews |
| Reviewer decisions | Logged with actor, timestamp, decision, and justification |
| Access removal | Captured as group membership change in Core Directory audit log |
| Retention | Minimum 90-day retention within Entra ID audit log |

---

## 10. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Periodic review and removal of unnecessary access |
| AC-2(4) | Automated Audit Actions | System recommendations based on user activity signals |
| AC-5 | Separation of Duties | Reviewer distinct from user being reviewed |
| AC-6 | Least Privilege | Access removed when business need unconfirmed |
| CA-7 | Continuous Monitoring | Quarterly review cadence — ongoing access validation |
| AU-2 | Audit Events | All decisions logged with actor, timestamp, and outcome |

---

## 11. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Accumulation of unnecessary access over time | Quarterly certification forces active confirmation of business need |
| Inactive users retaining active group membership | Automated inactivity recommendations surface dormant accounts |
| Undocumented access decisions | Justification required for all Deny decisions — reviewer accountability enforced |
| Access retained after role change | Review cadence catches residual access not removed during mover process |

---

## 12. Control Validation

Control effectiveness is validated through:

- Entra ID audit log review confirming decisions are recorded with actor and timestamp
- Evidence artifacts captured for each review phase (AR-STEP-01 through AR-STEP-06)
- Verification that denied access was removed upon review completion
- Quarterly review of access review completion rates and overdue campaigns

---

## 13. Assumptions

- Microsoft Entra ID P2 license is active — required for Identity Governance and Access Reviews
- All application access is controlled via Entra ID group membership
- Reviewers have access to My Access portal and are trained on review procedures
- Auto-apply is configured to remove denied access upon review completion

---

## 14. Review and Maintenance

- Policy reviewed annually or upon major system or organizational changes
- Version history maintained in GitHub repository
- Next scheduled review: March 2027

---

## 15. Evidence Requirements

Each access review cycle must produce the following evidence artifacts:

- Review configuration (scope, reviewers, recurrence)
- Reviewer decision records (approve/deny with justification)
- Access removal confirmation for denied users
- Entra ID audit log entries capturing:
  - Review creation
  - Reviewer decisions
  - Group membership changes
- Evidence index mapping artifacts to control requirements

All evidence must be retained and accessible for audit and assessment purposes.

---

## 16. Metrics and Governance

The following metrics are tracked for each review cycle:

- Review completion rate (% completed vs assigned)
- Overdue reviews count
- Denied access rate (% of users denied)
- Time to access removal (hours from decision to enforcement)

Metrics are reviewed quarterly by IAM and Security leadership to assess control effectiveness and identify gaps.

---

*SMG-IAM-POL-002 · Access Review Program Policy · v1.0 · 2026-03-24 · Internal*
