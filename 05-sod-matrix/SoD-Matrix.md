# Segregation of Duties (SoD) Policy

**Document ID:** SMG-IAM-POL-005  
**Version:** 1.0  
**Date:** 2026-03-24  
**Owner:** Robert J. Myers  
**Scope:** Generic regulated enterprise — CUI / PII / financial data :contentReference[oaicite:0]{index=0}

---

# Executive Summary

This policy establishes the Segregation of Duties (SoD) governance framework for regulated enterprise operations.

The objective of SoD governance is to reduce the risk of:
- fraud
- privilege abuse
- unauthorized transactions
- audit integrity failure
- operational control bypass
- excessive concentration of authority

The framework defines prohibited role combinations across:
- Finance
- IT Administration
- Security Operations

and establishes:
- risk-tier classification
- mitigation requirements
- exception governance
- escalation procedures
- periodic review requirements

Role assignments are evaluated against the SoD matrix during provisioning, review, and governance workflows.

No user may maintain conflicting roles without an approved and documented exception.

---

# Control Objective

Ensure no individual possesses conflicting access rights capable of:
- bypassing oversight
- concealing unauthorized activity
- manipulating audit evidence
- performing incompatible operational functions

This control supports:
- least privilege
- separation of authority
- fraud prevention
- operational accountability
- audit integrity
- governance traceability

---

# 1. Purpose

This policy establishes formal Segregation of Duties governance controls for enterprise identity and access management workflows.

The policy ensures:
- conflicting role assignments are identified and classified
- high-risk role combinations are restricted
- mitigation controls exist for all identified conflicts
- violations are escalated and remediated
- temporary exceptions follow formal approval procedures
- periodic review validates ongoing compliance

---

# 2. Scope

| Scope Item | Detail |
|---|---|
| Users in scope | Workforce identities with assigned enterprise roles |
| Systems in scope | IAM, Finance, IT Administration, Security, and operational platforms |
| Enforcement model | Role conflict evaluation during provisioning and governance review |
| Governance domains | Finance, IT Administration, Security Operations |
| Exclusions | Temporary approved exceptions governed through formal exception workflow |

---

# 3. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| IAM Engineer | Maintains SoD matrix and governance workflows |
| Security Lead | Reviews high-risk conflicts and exception requests |
| Compliance Team | Performs governance review and evidence validation |
| Role Owner | Validates business need for assigned access |
| Access Reviewer | Performs periodic access certification |
| CISO / Security Leadership | Approves Critical-tier exceptions |

---

# 4. Governance Principles

Segregation of Duties controls are designed to ensure:
- incompatible functions remain separated
- no single user can bypass governance controls
- access assignments remain attributable and reviewable
- operational oversight exists for sensitive activities

The framework follows three governance principles:
1. Preventive controls
2. Detective controls
3. Corrective controls

All three are required for effective SoD governance.

---

# 5. Control Types

| Control Type | Definition | Examples |
|---|---|---|
| Preventive | Controls designed to stop conflicts before assignment | Role separation, approval workflows, PIM enforcement |
| Detective | Controls designed to identify conflicts after assignment | Access reviews, audit monitoring, exception review |
| Corrective | Controls designed to remediate identified conflicts | Role removal, compensating controls, escalation |

---

# 6. Risk Tier Definitions

| Tier | Label | Definition | Response Requirement |
|---|---|---|---|
| 🔴 Critical | Direct fraud, privilege escalation, or audit destruction risk | Immediate remediation — no exception without CISO approval |
| 🟠 High | Significant abuse, manipulation, or integrity risk | Remediation within defined SLA with compensating control |
| 🟡 Medium | Governance or policy violation risk | Review and remediation during governance cycle |

---

# 7. SoD Governance Domains

## Finance Domain

Controls designed to reduce:
- payment fraud
- unauthorized expenditure
- financial manipulation
- payroll abuse

Examples include:
- Accounts Payable vs Vendor Management
- Payroll Administrator vs HR Records Administrator
- Budget Owner vs Procurement Approver

---

## IT Administration Domain

Controls designed to reduce:
- privilege escalation
- unauthorized deployment
- audit bypass
- identity compromise

Examples include:
- Global Administrator vs Conditional Access Administrator
- User Administrator vs Access Reviewer
- System Administrator vs Audit Log Administrator

---

## Security Domain

Controls designed to reduce:
- evidence manipulation
- false compliance reporting
- governance bypass
- investigation integrity failure

Examples include:
- Security Administrator vs Audit Log Administrator
- Incident Responder vs Evidence Custodian
- Risk Analyst vs Control Owner

---

# 8. Role Ownership

Each governed role must have:
- documented business owner
- defined approval authority
- periodic review cadence
- classification within the SoD matrix

Role owners are responsible for:
- validating business need
- reviewing role assignments
- participating in access certification
- ensuring ongoing compliance with SoD policy requirements

---

# 9. Provisioning Governance

Role assignments must be evaluated against the SoD matrix during:
- onboarding workflows
- access request workflows
- role modification events
- periodic governance review

IAM governance workflows may evaluate proposed assignments against existing conflict pairs before provisioning approval.

Conflicting assignments must:
- be denied
- escalated
- or routed through formal exception procedures

---

# 10. Violation Detection and Response Workflow

## Detection

Violations may be identified through:
- periodic access reviews
- IAM governance workflows
- audit log review
- provisioning validation
- compliance assessment activities

---

## Classification

Conflicts are evaluated using:
- fraud exposure
- privilege escalation potential
- audit integrity impact
- operational risk severity

---

## Escalation

| Tier | Escalation Requirement |
|---|---|
| 🔴 Critical | Immediate escalation to Security and Compliance leadership |
| 🟠 High | Review within defined SLA |
| 🟡 Medium | Included in periodic governance review |

---

## Remediation

Remediation actions may include:
- removal of conflicting role
- temporary compensating control
- access restriction
- enhanced monitoring
- formal exception review

---

## Validation

After remediation:
- conflict resolution is verified
- evidence is retained
- governance records are updated
- review outcomes are logged

---

# 11. Exception Governance

Temporary SoD conflicts may be approved when:
- operational continuity requires temporary overlap
- staffing limitations exist
- emergency operational conditions occur

All exceptions require:
- documented business justification
- risk assessment
- compensating controls
- expiration date
- formal approval

Permanent exceptions require formal risk acceptance.

---

# 12. Exception Workflow

| Step | Action | Owner | Timeframe |
|---|---|---|---|
| 1 | Submit exception request with business justification | Role Owner | Immediately upon detection |
| 2 | Perform risk assessment | Security Lead | Within 2 business days |
| 3 | Approve or deny exception | CISO / Security Lead | Within 3 business days |
| 4 | Document compensating controls | IAM Engineer | Before activation |
| 5 | Define expiration date (maximum 90 days) | Compliance | During approval |
| 6 | Review at next certification cycle | Access Reviewer | Quarterly |

---

# 13. Enforcement Controls

- Conflicting role assignments prohibited unless formally approved
- Role assignments reviewed against SoD matrix
- High-risk conflicts escalated immediately
- Quarterly governance review required
- Exception register maintained and reviewed
- Governance evidence retained for audit purposes

---

# 14. Monitoring and Review

| Activity | Frequency |
|---|---|
| SoD matrix review | Quarterly |
| Access certification review | Quarterly |
| Exception register review | Quarterly |
| Critical conflict review | Immediate |
| Governance reporting | Quarterly |

---

# 15. Logging and Auditability

| Event | Implementation |
|---|---|
| Role assignment changes | Logged through IAM workflows |
| SoD violations | Recorded and tracked |
| Exception approvals | Documented with approver and expiration |
| Access reviews | Retained for governance evidence |
| Remediation outcomes | Logged and validated |

---

# 16. Design Considerations & Limitations

| Consideration | Detail |
|---|---|
| Temporary operational overlap | Certain business conditions may require controlled exceptions |
| Shared responsibilities | Cross-functional roles increase governance complexity |
| Role granularity | Broad role definitions increase conflict exposure |
| Manual review dependency | Governance quality depends on review discipline |
| IAM maturity | Automated detection effectiveness depends on IAM integration maturity |

---

# 17. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Role assignments reviewed against SoD matrix |
| AC-3 | Access Enforcement | Conflicting assignments restricted |
| AC-5 | Separation of Duties | Formal SoD matrix defines prohibited role combinations |
| AC-6 | Least Privilege | Access scoped and evaluated for conflict exposure |
| AU-2 | Audit Events | Violations and exceptions logged |
| AU-9 | Protection of Audit Information | Audit roles separated from operational administration |
| CA-7 | Continuous Monitoring | Periodic review validates ongoing governance effectiveness |

---

# 18. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Fraudulent transactions | Role separation and approval workflows |
| Privilege escalation | Conflicting administrative roles restricted |
| Audit evidence manipulation | Audit administration segregated from operations |
| Unauthorized expenditure | Financial approval separation |
| Governance bypass | Independent review and exception approval |

---

# 19. Control Validation

Control effectiveness is validated through:
- periodic access certification
- governance review
- conflict remediation tracking
- exception register review
- IAM workflow validation
- audit evidence review

Evidence artifacts include:
- SoD conflict matrix
- governance workflows
- exception records
- review evidence
- remediation documentation

---

# 20. Assessment Narrative

This implementation establishes a formal Segregation of Duties governance framework designed to reduce fraud, privilege abuse, audit integrity failure, and operational control risk.

Conflicts are:
- explicitly defined
- classified by risk tier
- paired with mitigation strategies
- governed through structured workflows
- monitored through periodic review

Role assignments are evaluated against the SoD matrix during provisioning and governance review activities. Violations are escalated and remediated through documented operational procedures.

This workflow supports:
- NIST 800-53 AC-5
- least privilege governance
- audit accountability
- regulated-environment access governance objectives

---

# 21. Review and Maintenance

- Policy reviewed annually or after significant organizational changes
- New enterprise roles evaluated against SoD matrix prior to provisioning
- Exception register reviewed quarterly
- Version history maintained within GitHub repository
- Next scheduled review: March 2027

---

# 22. Governance Principle

No single individual should possess sufficient authority to:
- initiate
- approve
- execute
- conceal

a sensitive operational activity without independent oversight or review.

Segregation of Duties is treated as an operational governance control rather than a compliance-only requirement.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*

**SMG-IAM-POL-005 · Segregation of Duties Policy · v1.0 · Internal**
