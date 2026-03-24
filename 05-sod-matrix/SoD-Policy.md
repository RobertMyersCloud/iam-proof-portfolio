# Segregation of Duties Policy

**Document ID:** SMG-IAM-POL-005
**Version:** 1.0
**Date:** 2026-03-24
**Owner:** Robert J. Myers

---

## Executive Summary

This policy establishes a preventative control framework reducing the risk of fraud, privilege abuse, and audit control failure through enforced role separation and continuous governance.

It defines the Segregation of Duties program for a regulated enterprise handling sensitive data (CUI, PII, financial records). The program identifies prohibited role combinations, classifies conflicts by risk tier, and enforces mitigation through role separation, compensating controls, and a formal exception process.

---

## Control Objective

Ensure that no single user holds a combination of roles that would enable them to initiate, approve, execute, and conceal unauthorized actions — reducing the risk of fraud, privilege escalation, and audit integrity violations.

---

## 1. Purpose

This policy establishes SoD requirements for all workforce identities with access to financial, administrative, and security systems. It ensures:

- High-risk role combinations are identified and prevented before access is granted
- Conflicts are classified by risk tier and mitigated through documented controls
- Exceptions are managed through a formal approval and compensating control process
- SoD compliance is monitored continuously and reviewed quarterly

---

## 2. Scope

| Scope Item | Detail |
|---|---|
| Users in scope | All workforce identities with access to financial, IT administrative, or security systems |
| Systems in scope | Financial systems, IAM platforms, IT administrative tools, security operations platforms |
| Role model | Role-based access control — SoD matrix evaluated at provisioning and review |
| Exclusions | Emergency break-glass accounts managed under separate procedure |

---

## 3. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| IAM Engineer | Evaluates role assignments against SoD matrix — blocks conflicting assignments |
| Security Lead | Approves High-tier exceptions — escalates Critical conflicts to CISO |
| CISO | Approves Critical-tier exceptions — accountable for SoD program outcomes |
| Compliance | Maintains exception register — validates SoD evidence for audit |
| Access Reviewer | Detects existing conflicts during quarterly access certification |
| Role Owner | Submits exception requests with documented business justification |

---

## 4. Conflict Identification

SoD conflicts are identified through two mechanisms:

**Preventative detection** — role assignments evaluated against the SoD conflict matrix at provisioning time. Conflicting assignments are blocked or flagged before access is granted.

**Detective detection** — quarterly access reviews identify existing conflicts that have accumulated over time through role changes, transfers, or provisioning gaps.

---

## 5. Risk Tier Classification

| Tier | Definition | Response SLA |
|---|---|---|
| 🔴 Critical | Direct fraud, system compromise, or audit destruction risk | Immediate — exception requires CISO approval |
| 🟠 High | Significant abuse or manipulation potential | 5 business days — exception requires Security Lead approval |
| 🟡 Medium | Policy violation or governance risk | Next review cycle — documented acknowledgment required |

---

## 6. Mitigation Requirements

Every identified conflict must have one of the following mitigations:

| Mitigation Type | Description | Example |
|---|---|---|
| Role separation | Conflicting roles assigned to separate individuals | Accounts Payable and Vendor Management owned by different users |
| Dual approval | Actions in one role require approval from holder of conflicting role | Journal entries approved by separate GL reviewer |
| Approval escalation | Actions escalated to third party above both role holders | Procurement approval by finance leadership |
| Technical enforcement | System or tooling prevents conflict from being exercised | PIM eligible-only — activation requires separate approver |
| Compensating control | Detective control offsets inability to separate | Enhanced logging + monthly reconciliation review |

---

## 7. Exception Process

When a conflict cannot be immediately remediated:

| Step | Action | Owner | Timeframe |
|---|---|---|---|
| 1 | Submit exception request with business justification | Role Owner | Immediately |
| 2 | Risk assessment of exception impact | Security Lead | 2 business days |
| 3 | Approve or deny | CISO (Critical) / Security Lead (High) | 3 business days |
| 4 | Document compensating control | IAM Engineer | Before activation |
| 5 | Set expiration — maximum 90 days | Compliance | At approval |
| 6 | Review at next certification cycle | Access Reviewer | Quarterly |

Exceptions are logged in the exception register with business justification, approver, compensating control, and expiration date.

---

## 8. Enforcement Controls

- SoD matrix evaluated at provisioning — conflicting assignments blocked before access is granted
- Quarterly access reviews detect existing conflicts
- IAM tooling identifies conflicting role assignments — detection is not manual
- Exception register maintained and reviewed at each certification cycle
- Critical conflicts escalated immediately — no waiting for review cycle

---

## 9. Control Classification

**Preventative controls** reduce risk before it occurs:
- Role separation enforced at provisioning
- PIM eligible-only for high-risk administrative roles
- CI/CD approval gates preventing self-deployment
- System-enforced dual approval requirements

**Detective controls** identify risk after it occurs:
- Quarterly access certification reviewing role combinations
- Log monitoring for conflicting role activation patterns
- Exception register review at each certification cycle
- IAM tooling conflict scans

---

## 10. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Role assignments reviewed against SoD matrix at provisioning |
| AC-3 | Access Enforcement | Conflicting roles not simultaneously assigned to same user |
| AC-5 | Separation of Duties | Formal SoD matrix defines all prohibited role combinations |
| AC-6 | Least Privilege | Access scoped to role — conflicts prevent over-permission |
| AU-2 | Audit Events | SoD violations, exceptions, and resolutions logged |
| AU-9 | Protection of Audit Information | Audit log admin role separated from security admin role |
| CA-7 | Continuous Monitoring | Quarterly SoD review cadence with automated detection |

---

## 11. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Fraudulent vendor payments | Accounts Payable and Vendor Management role separation enforced |
| Financial statement manipulation | GL approval authority separated from transaction posting |
| Privilege escalation via self-approval | Access review authority separated from access grant authority |
| Audit evidence destruction | Security admin and log admin roles formally separated |
| Undetectable system compromise | System admin and audit log admin roles formally separated |
| Ghost employee fraud | Payroll execution separated from HR record modification |

---

## 12. Control Validation

Control effectiveness is validated through:

- Quarterly access certification confirming no unmitigated conflicts exist
- Exception register review confirming all exceptions have compensating controls and expiration dates
- IAM tooling conflict scan results reviewed each certification cycle
- Audit log review confirming SoD-related events are captured

---

## 13. Assumptions

- Role-based access control is enforced — access granted via roles, not direct permission assignment
- IAM tooling is capable of evaluating role assignments against conflict matrix
- Quarterly access reviews are conducted and cover all in-scope role populations
- Exception register is maintained and accessible for audit review

---

## 14. Evidence Requirements

The SoD program must produce the following evidence:

- SoD conflict matrix (current version with all conflicts documented)
- Exception register (all active exceptions with justification, approver, compensating control, expiration)
- Quarterly access review results showing SoD conflict detection and remediation
- Provisioning records confirming conflicting roles were not simultaneously assigned

---

## 15. Metrics and Governance

| Metric | Target |
|---|---|
| Open Critical conflicts | Zero at all times |
| Open High conflicts beyond SLA | Zero |
| Exceptions without compensating control | Zero |
| Exceptions beyond 90-day expiration | Zero |
| Quarterly review completion rate | 100% |

Metrics reviewed quarterly by IAM, Security, and Compliance leadership.

---

## 16. Prohibited Conditions

The following are explicitly prohibited:

- Assigning conflicting roles to the same user without a documented exception
- Approving exceptions without a compensating control
- Granting Critical-tier exceptions without CISO approval
- Allowing exceptions to expire without review and renewal or remediation
- Self-approving access that creates an SoD conflict

---

## 17. Review and Maintenance

- Policy reviewed annually or upon major organizational or system changes
- SoD matrix updated when new roles are created or existing roles are modified
- Version history maintained in GitHub repository
- Next scheduled review: March 2027

---

## 18. Assessment Narrative

The Segregation of Duties program establishes a formal preventative and detective control framework preventing high-risk role combinations that could enable fraud, privilege abuse, or audit integrity violations.

Conflicts are explicitly defined in a risk-tiered matrix, mitigated through role separation and compensating controls, and monitored through quarterly access reviews and IAM tooling. Exceptions are governed through a formal approval process with defined SLAs, compensating controls, and expiration dates.

This establishes a defensible SoD program aligned to NIST 800-53 AC-5 and CMMC Level 2 requirements, producing audit-ready evidence of access governance maturity.

---

*SMG-IAM-POL-005 · Segregation of Duties Policy · v1.0 · 2026-03-24 · Internal*
