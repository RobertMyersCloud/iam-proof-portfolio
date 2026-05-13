# SoD Conflict Matrix

**Document ID:** SMG-IAM-STD-005  
**Version:** 1.0  
**Date:** 2026-03-24  
**Owner:** Robert J. Myers  

---

# Purpose

This matrix defines prohibited or high-risk role combinations within a regulated enterprise environment.

The objective is to reduce:
- fraud risk
- privilege escalation
- audit integrity failure
- unauthorized operational control
- excessive concentration of authority

The matrix supports:
- NIST 800-53 AC-5
- CMMC Level 2 access governance requirements
- least privilege enforcement
- audit accountability
- regulated-environment governance workflows

---

# Risk Tier Definitions

| Tier | Description | Response Requirement |
|---|---|---|
| 🔴 Critical | Direct fraud, privilege escalation, or audit destruction risk | Immediate remediation — exception requires CISO approval |
| 🟠 High | Significant operational abuse or integrity risk | Remediation within SLA with compensating control |
| 🟡 Medium | Governance or policy violation risk | Review during governance cycle |

---

# Finance Domain Conflicts

| ID | Role A | Role B | Conflict Description | Risk | Tier | Mitigation |
|---|---|---|---|---|---|---|
| FIN-001 | Accounts Payable | Vendor Management | Same user can create vendor and process payment | Fraudulent vendor payments | 🔴 Critical | Separate ownership and dual approval |
| FIN-002 | Accounts Payable | General Ledger | Same user can post and approve financial activity | Financial manipulation | 🔴 Critical | Independent GL review |
| FIN-003 | Budget Owner | Procurement Approver | Same user requests and approves purchases | Unauthorized spending | 🟠 High | Approval escalation |
| FIN-004 | Payroll Administrator | HR Records Administrator | Same user can create employee and process payroll | Ghost employee fraud | 🔴 Critical | Independent HR validation |
| FIN-005 | Accounts Receivable | Cash Application | Same user records and applies payments | Revenue manipulation | 🟠 High | Reconciliation review |

---

# IT Administration Domain Conflicts

| ID | Role A | Role B | Conflict Description | Risk | Tier | Mitigation |
|---|---|---|---|---|---|---|
| IT-001 | Global Administrator | Conditional Access Administrator | User can modify and bypass identity controls | Identity system compromise | 🔴 Critical | PIM eligible-only with approval |
| IT-002 | User Administrator | Access Reviewer | User can grant and certify own access | Privilege escalation | 🔴 Critical | Independent reviewer required |
| IT-003 | DevOps Engineer | Production Deploy Approver | User can deploy unreviewed code | Integrity compromise | 🟠 High | CI/CD approval gates |
| IT-004 | Backup Administrator | Security Administrator | User can alter backups and security controls | Evidence destruction risk | 🟠 High | Separate ownership |
| IT-005 | System Administrator | Audit Log Administrator | User can alter systems and audit visibility | Undetectable compromise | 🔴 Critical | Immutable logging and separation |

---

# Security Domain Conflicts

| ID | Role A | Role B | Conflict Description | Risk | Tier | Mitigation |
|---|---|---|---|---|---|---|
| SEC-001 | Security Administrator | Audit Log Administrator | User can generate and alter audit evidence | Audit integrity failure | 🔴 Critical | Separate log management |
| SEC-002 | Incident Responder | Forensic Evidence Custodian | User can investigate and control evidence | Evidence tampering | 🟠 High | Chain-of-custody controls |
| SEC-003 | Risk Analyst | Control Owner | User can assess and approve own controls | False compliance reporting | 🟠 High | Independent assessment |
| SEC-004 | Compliance Officer | System Administrator | User can define policy and implement controls | Governance bypass | 🟠 High | Governance separation |
| SEC-005 | Security Reviewer | Access Approver | User can validate and approve same request | Control bypass | 🟡 Medium | Dual-review workflow |

---

# Preventive Controls

| Control | Purpose |
|---|---|
| Role separation | Prevent conflicting role assignment |
| PIM eligible-only access | Reduce standing privileged access |
| Dual approval workflows | Require independent authorization |
| Provisioning validation | Detect conflicts before activation |
| CI/CD approval gates | Prevent self-approved deployment |

---

# Detective Controls

| Control | Purpose |
|---|---|
| Quarterly access reviews | Detect accumulated conflicts |
| IAM conflict scans | Identify unauthorized overlap |
| Exception register review | Validate approved exceptions |
| Audit log monitoring | Detect suspicious activity patterns |
| Governance reporting | Track unresolved conflicts |

---

# Corrective Controls

| Control | Purpose |
|---|---|
| Role removal | Eliminate identified conflict |
| Temporary compensating controls | Reduce residual risk |
| Approval escalation | Increase oversight |
| Enhanced monitoring | Detect abuse indicators |
| Exception expiration enforcement | Prevent unmanaged long-term exceptions |

---

# Temporary Exception Governance

Temporary SoD conflicts may be approved only when:
- operational continuity requires temporary overlap
- staffing limitations exist
- emergency operational conditions occur

All exceptions require:
- documented business justification
- compensating controls
- expiration date
- formal approval
- quarterly review

Maximum exception duration:
- 90 days unless formally renewed

---

# Exception Approval Requirements

| Tier | Approval Authority |
|---|---|
| 🔴 Critical | CISO |
| 🟠 High | Security Lead |
| 🟡 Medium | Governance Review |

---

# Provisioning Governance Workflow

| Step | Action |
|---|---|
| 1 | User role assignment requested |
| 2 | IAM workflow evaluates requested roles against SoD matrix |
| 3 | Conflict identified and classified |
| 4 | Assignment blocked or escalated |
| 5 | Exception workflow initiated if required |
| 6 | Governance evidence retained |

---

# Quarterly Governance Review

Quarterly review validates:
- no unresolved Critical conflicts exist
- all exceptions remain approved and documented
- compensating controls remain active
- expired exceptions are remediated
- SoD matrix remains aligned to current role model

---

# Metrics

| Metric | Target |
|---|---|
| Open Critical conflicts | Zero |
| Exceptions without compensating controls | Zero |
| Expired exceptions | Zero |
| Quarterly review completion | 100% |
| Unreviewed privileged conflicts | Zero |

---

# Governance Alignment

This matrix supports:
- NIST SP 800-53 Rev 5
- NIST SP 800-171
- CMMC Level 2
- SOC 2 Type II (CC6)
- Zero Trust least privilege principles

---

# Assessment Narrative

This SoD matrix establishes a formal governance framework designed to reduce fraud, privilege abuse, audit manipulation, and excessive concentration of authority.

Conflicts are:
- explicitly defined
- risk-tiered
- paired with mitigation controls
- reviewed continuously
- governed through documented exception workflows

This structure supports operational IAM governance maturity and regulated-environment access control requirements.

---

*SMG-IAM-STD-005 · SoD Conflict Matrix · v1.0 · Internal*
