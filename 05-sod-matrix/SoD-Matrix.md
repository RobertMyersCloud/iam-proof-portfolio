# Segregation of Duties — Role Conflict Matrix

**Document ID:** SMG-IAM-SOD-001
**Version:** 1.0
**Date:** 2026-03-24
**Owner:** Robert J. Myers
**Scope:** Generic regulated enterprise — CUI / PII / financial data

---

## Purpose

This matrix establishes a preventative control framework reducing the risk of fraud, privilege abuse, and audit control failure through enforced role separation.

It defines prohibited role combinations for a regulated enterprise environment. Each entry identifies a conflict pair, the nature of the conflict, the risk it creates, the risk tier classification, and the required mitigation or compensating control.

No user should hold both roles in any conflict pair without a documented, approved exception.

---

## Control Types

| Type | Definition | Examples |
|---|---|---|
| **Preventative** | Controls that stop conflicts before they occur | Role separation, PIM enforcement, CI/CD approval gates |
| **Detective** | Controls that identify conflicts after they occur | Log monitoring, access review cycles, exception tracking |

Both control types are required — preventative controls reduce risk, detective controls validate enforcement.

---

## Risk Tier Definitions

| Tier | Label | Definition | Response |
|---|---|---|---|
| 🔴 | Critical | Direct fraud, system compromise, or audit destruction risk | Immediate remediation — no exceptions without CISO approval |
| 🟠 | High | Significant abuse or manipulation potential | Remediation within 5 business days — compensating control required |
| 🟡 | Medium | Policy violation or governance risk | Remediation at next review cycle — documented acknowledgment required |

---

## Finance Domain Conflicts

| ID | Role A | Role B | Conflict Description | Risk Created | Tier | Required Mitigation |
|---|---|---|---|---|---|---|
| FIN-001 | Accounts Payable | Vendor Management | Same user creates vendor record and processes payment to that vendor | Fraudulent vendor payments — ghost vendor creation | 🔴 Critical | Enforce role separation — dual approval required for vendor creation and payment processing |
| FIN-002 | Accounts Payable | General Ledger | Same user posts transactions and approves journal entries | Financial statement manipulation — unauthorized adjustments | 🔴 Critical | Independent GL reviewer required for all journal entry approvals |
| FIN-003 | Budget Owner | Procurement Approver | Same user submits purchase requests and approves own spend | Unauthorized expenditure — budget circumvention | 🟠 High | Procurement approval escalated to finance leadership above budget owner |
| FIN-004 | Payroll Administrator | HR Records Administrator | Same user modifies employee records (salary, status) and executes payroll | Ghost employee fraud — unauthorized pay modifications | 🔴 Critical | HR record changes require independent validation and approval before payroll cycle runs |
| FIN-005 | Accounts Receivable | Cash Application | Same user records receivables and applies incoming cash | Revenue manipulation — concealment of misappropriation | 🟠 High | Dual review required for all cash application entries — separate AR and treasury functions |

---

## IT Administration Domain Conflicts

| ID | Role A | Role B | Conflict Description | Risk Created | Tier | Required Mitigation |
|---|---|---|---|---|---|---|
| IT-001 | Global Administrator | Conditional Access Admin | Same user can configure and bypass all access control policies | Total identity compromise — self-granted unlimited access | 🔴 Critical | PIM eligible-only for both roles — separate approvers required for each activation |
| IT-002 | User Administrator | Access Reviewer | Same user grants access rights and performs access certifications | Privilege escalation — self-approved access grants | 🔴 Critical | Access review authority assigned to separate reviewer population — User Admin excluded |
| IT-003 | DevOps Engineer | Production Deploy Approver | Same user writes code and approves own deployments to production | Integrity violation — malicious code deployment without review | 🟠 High | CI/CD pipeline enforces separate deployment approver — no self-approval permitted |
| IT-004 | Backup Administrator | Security Administrator | Same user manages backup integrity and security controls | Evidence destruction — backup manipulation to conceal breach | 🟠 High | Backup operations assigned to separate team — security team provides oversight only |
| IT-005 | System Administrator | Audit Log Administrator | Same user administers systems and controls audit log access | Undetectable compromise — log deletion or modification | 🔴 Critical | Log immutability enforced — audit log access restricted to separate read-only role |

---

## Security Domain Conflicts

| ID | Role A | Role B | Conflict Description | Risk Created | Tier | Required Mitigation |
|---|---|---|---|---|---|---|
| SEC-001 | Security Administrator | Audit Log Administrator | Same user manages security controls and administers audit logs | Audit integrity failure — evidence manipulation after incident | 🔴 Critical | Segregate security operations and log management — separate role ownership required |
| SEC-002 | Incident Responder | Forensic Evidence Custodian | Same user conducts investigation and controls evidence chain | Evidence tampering — investigation results manipulated | 🟠 High | Chain-of-custody enforcement — evidence custody assigned to separate custodian |
| SEC-003 | Risk Analyst | Control Owner | Same user assesses risk and owns the controls being assessed | False compliance reporting — self-assessed controls | 🟠 High | Independent validation required — risk assessment and control ownership must be separate |
| SEC-004 | Compliance Officer | System Administrator | Same user defines compliance policy and administers assessed systems | Policy bypass risk — policy written to match existing deficiencies | 🟠 High | Governance and execution roles separated — compliance officer has no admin system access |
| SEC-005 | Security Reviewer | Access Approver | Same user validates access decisions and approves access grants | Control bypass — self-validated approval authority | 🟡 Medium | Dual-control approval workflow — review and approval require separate actors |

---

## Exception Process

When a conflict cannot be immediately remediated due to business constraints, a formal exception must be submitted:

| Step | Action | Owner | Timeframe |
|---|---|---|---|
| 1 | Submit exception request with business justification | Role Owner | Immediately upon detection |
| 2 | Risk assessment of exception impact | Security Lead | Within 2 business days |
| 3 | Approve or deny exception | CISO / Security Lead | Within 3 business days |
| 4 | Document compensating control if approved | IAM Engineer | Before exception is active |
| 5 | Set expiration date — maximum 90 days | Compliance | At approval |
| 6 | Review at next certification cycle | Access Reviewer | Quarterly |

**Critical-tier conflicts:** Exception requires CISO approval and compensating control documentation before activation.

**High-tier conflicts:** Exception requires Security Lead approval and documented compensating control.

**Medium-tier conflicts:** Exception requires documented acknowledgment and review at next cycle.

---

## Conflict Summary

| Domain | Total Conflicts | Critical | High | Medium |
|---|---|---|---|---|
| Finance | 5 | 3 | 2 | 0 |
| IT Administration | 5 | 3 | 2 | 0 |
| Security | 5 | 1 | 3 | 1 |
| **Total** | **15** | **7** | **7** | **1** |

---

## Review and Maintenance

- Matrix reviewed quarterly and upon organizational role changes
- New role additions evaluated against existing conflict pairs before provisioning
- SoD conflicts detected through periodic access reviews and IAM tooling capable of identifying conflicting role assignments — detection is not manual, it scales
- Exception register reviewed at each quarterly access certification cycle
- Version history maintained in GitHub repository

---

*SMG-IAM-SOD-001 · SoD Role Conflict Matrix · v1.0 · 2026-03-24 · Internal*
