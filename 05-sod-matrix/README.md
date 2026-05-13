# Segregation of Duties (SoD) Matrix Pack

**Role conflict identification, risk classification, and mitigation modeling for a regulated enterprise environment — demonstrating governance-driven access control across Finance, IT Administration, and Security operations.** :contentReference[oaicite:0]{index=0}

This pack demonstrates practical Segregation of Duties (SoD) governance workflows including role conflict identification, risk-tier classification, mitigation modeling, exception handling, escalation procedures, and audit-ready evidence aligned to NIST 800-53 and CMMC Level 2.

---

# Scenario

A regulated organization handling sensitive data including:
- Controlled Unclassified Information (CUI)
- financial records
- identity data
- operational security information

requires a formal Segregation of Duties (SoD) governance program to reduce:
- fraud risk
- privilege abuse
- unauthorized access
- audit integrity violations
- operational control failures

Role conflicts across:
- Finance
- IT Administration
- Security Operations

must be identified, classified by risk tier, evaluated during provisioning and review workflows, and paired with documented mitigation controls.

The organization also requires:
- audit-ready SoD evidence
- compensating control documentation
- escalation procedures
- exception governance
- periodic review processes

---

# What Was Built

| Component | Implementation |
|---|---|
| Conflict matrix | 15 role conflict pairs across Finance, IT Administration, and Security domains |
| Risk classification | Three-tier risk model — Critical, High, Medium |
| Mitigation framework | Compensating controls and role separation requirements for all conflicts |
| Violation workflow | Detection, escalation, remediation, and validation process |
| Exception governance | Temporary exception handling with documented approval requirements |
| Governance alignment | NIST 800-53 and CMMC Level 2 mapping |

---

# Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Role assignments evaluated against SoD conflict matrix |
| AC-3 | Access Enforcement | Conflicting roles restricted from simultaneous assignment |
| AC-5 | Separation of Duties | Formal SoD matrix defines prohibited role combinations |
| AC-6 | Least Privilege | Access scoped to business role with conflict validation |
| AU-2 | Audit Events | SoD violations and exceptions logged and reviewed |
| AU-9 | Protection of Audit Information | Audit administration separated from operational security roles |
| CA-7 | Continuous Monitoring | Periodic SoD review cadence supports ongoing governance |

---

# Outcome

- Identified 15 high-risk role conflict pairs across multiple operational domains
- Classified conflicts using a formal risk-tier methodology
- Documented mitigation strategies for all identified conflicts
- Established escalation and remediation workflow for SoD violations
- Implemented governance framework supporting fraud reduction and access accountability
- Produced audit-ready SoD governance evidence aligned to CMMC Level 2 and SOC 2 concepts

---

# Governance Model

## Risk Tiers

| Tier | Description |
|---|---|
| 🔴 Critical | Direct fraud, privilege escalation, or full-system compromise risk |
| 🟠 High | Significant operational abuse or integrity risk |
| 🟡 Medium | Governance or policy violation risk |

---

# SoD Conflict Matrix

## Finance Domain

| Role A | Role B | Conflict | Risk | Tier | Mitigation |
|---|---|---|---|---|---|
| Accounts Payable | Vendor Management | Same user creates vendor and processes payment | Fraudulent vendor payments | 🔴 Critical | Dual approval workflow and role separation |
| Accounts Payable | General Ledger | Same user posts and approves journal entries | Financial manipulation | 🔴 Critical | Independent GL approval required |
| Budget Owner | Procurement Approver | Same user requests and approves purchases | Unauthorized spending | 🟠 High | Approval escalation to Finance leadership |
| Payroll Administrator | HR Records Administrator | Same user modifies employee records and processes payroll | Ghost employee fraud | 🔴 Critical | Independent HR validation before payroll execution |
| Accounts Receivable | Cash Application | Same user records and applies receipts | Revenue manipulation | 🟠 High | Dual review for cash application workflows |

---

## IT Administration Domain

| Role A | Role B | Conflict | Risk | Tier | Mitigation |
|---|---|---|---|---|---|
| Global Administrator | Conditional Access Administrator | User can configure and bypass identity controls | Full identity compromise | 🔴 Critical | PIM eligible-only assignment with approval workflow |
| User Administrator | Access Reviewer | User can grant and approve own access | Privilege escalation | 🔴 Critical | Separate access review authority |
| DevOps Engineer | Production Deploy Approver | User can deploy unreviewed code | Integrity and backdoor risk | 🟠 High | CI/CD approval gate enforcement |
| Backup Administrator | Security Administrator | User can alter backups and security controls | Evidence destruction risk | 🟠 High | Separate backup and security ownership |
| System Administrator | Audit Log Access | User can modify systems and audit visibility | Undetectable compromise | 🔴 Critical | Log immutability and restricted access |

---

## Security Domain

| Role A | Role B | Conflict | Risk | Tier | Mitigation |
|---|---|---|---|---|---|
| Security Administrator | Audit Log Administrator | User can generate and alter audit evidence | Audit integrity failure | 🔴 Critical | Separate log management and security operations |
| Incident Responder | Forensic Evidence Custodian | User can investigate and control evidence | Evidence tampering risk | 🟠 High | Chain-of-custody enforcement |
| Risk Analyst | Control Owner | User can assess and approve own controls | False compliance reporting | 🟠 High | Independent validation required |
| Compliance Officer | System Administrator | User can define policy and implement controls | Governance bypass risk | 🟠 High | Separate governance and execution roles |
| Security Reviewer | Access Approver | User can validate and approve same access request | Control bypass | 🟡 Medium | Dual-control approval workflow |

---

# Preventive, Detective, and Corrective Controls

| Control Type | Example |
|---|---|
| Preventive | IAM governance workflows evaluate proposed role assignments against SoD matrix during provisioning |
| Detective | Quarterly access reviews identify conflicting role assignments |
| Corrective | Conflicting role assignment removed or compensating control applied |

---

# Role Ownership Model

Each governed role must have:
- documented business owner
- defined approval authority
- periodic review cadence
- classification within the SoD matrix

Role owners are responsible for:
- validating business need
- reviewing role assignments
- approving exceptions when authorized
- ensuring continued SoD compliance

---

# Temporary Exception Governance

Temporary SoD conflicts may be approved when:
- operational requirements require temporary overlap
- staffing limitations exist
- emergency business operations occur

All exceptions require:
- documented business justification
- compensating controls
- defined expiration date
- management approval
- periodic review

Permanent exceptions require formal risk acceptance.

---

# Violation Detection and Response Workflow

## 1. Detection

- Periodic role review identifies conflicting assignments
- IAM governance workflows may evaluate proposed assignments against the SoD matrix during provisioning and review activities
- Access reviews identify unauthorized role overlap

---

## 2. Classification

Conflicts are evaluated against:
- Critical risk
- High risk
- Medium risk

Classification considers:
- fraud potential
- privilege escalation risk
- audit integrity impact
- operational exposure

---

## 3. Escalation

| Tier | Escalation Requirement |
|---|---|
| 🔴 Critical | Immediate escalation to Security and Compliance leadership |
| 🟠 High | Review within defined SLA |
| 🟡 Medium | Included in periodic governance review |

---

## 4. Remediation

Remediation may include:
- removal of conflicting role assignment
- implementation of compensating controls
- temporary exception approval with documented justification
- additional monitoring requirements

---

## 5. Validation

- Confirm conflict resolution
- Validate mitigation effectiveness
- Record remediation outcome
- Maintain audit evidence for governance review

---

# Monitoring and Review

| Activity | Frequency |
|---|---|
| SoD matrix review | Annual |
| Role assignment review | Quarterly |
| Exception review | Monthly |
| High-risk conflict review | Immediate |
| Governance reporting | Quarterly |

---

# Design Considerations & Limitations

| Consideration | Detail |
|---|---|
| Temporary operational overlap | Certain business functions may require short-term exceptions |
| Role granularity | Broad roles increase potential conflict exposure |
| Manual review dependency | Governance effectiveness depends on review discipline |
| Shared operational ownership | Cross-functional responsibilities require careful classification |
| IAM integration maturity | Automated enforcement depends on IAM workflow integration |

---

# Assessment Narrative

The Segregation of Duties implementation establishes a formal governance framework designed to reduce fraud, privilege abuse, audit integrity failure, and operational control risk.

Conflicts are:
- explicitly defined
- classified by risk tier
- paired with mitigation strategies
- evaluated through governance workflows
- monitored through periodic review

Role assignments are evaluated against the SoD matrix, and violations are escalated and remediated through structured operational procedures.

This implementation demonstrates governance alignment to:
- NIST 800-53 AC-5
- CMMC Level 2 access governance concepts
- regulated-environment audit accountability practices

---

# Pack Contents

| File | Description |
|---|---|
| SoD-Matrix.md | Full role conflict matrix with risk classification and mitigation |
| SoD-Policy.md | Governance policy defining SoD enforcement and exception handling |
| control-mapping.md | NIST 800-53 and CMMC Level 2 control mapping |
| resume-bullets.md | Resume-ready governance and SoD bullet points |
| interview-questions.md | IAM and governance interview questions supported by this implementation |

---

# Interview Value

This pack demonstrates practical approaches to:

- Multi-domain Segregation of Duties governance
- Risk-tier classification methodology
- Fraud and privilege abuse reduction controls
- Compensating control design
- Governance exception handling
- Access governance workflows
- NIST 800-53 AC-5 alignment
- Audit-ready SoD evidence preparation

This directly supports IAM governance, IGA, access governance, compliance, GRC, and regulated-environment interview discussions.

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

- Generic regulated enterprise model
- Governance-focused IAM operating model
- Scope includes Finance, IT Administration, and Security domains
- Pack version: v1.0 — March 2026

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
