# Segregation of Duties Matrix Pack

**Role conflict identification, risk classification, and mitigation modeling for a regulated mid-size enterprise — demonstrating GRC-aligned access governance across Finance, IT Administration, and Security functions.**

Segregation of Duties (SoD) implementation demonstrating conflict identification, risk-tiered classification, and documented mitigation controls aligned to NIST 800-53 and CMMC Level 2.

## Scenario

A regulated mid-size enterprise handling sensitive data (CUI, PII, financial records) requires a formal SoD program to prevent fraud, privilege abuse, and audit integrity violations. Role conflicts across Finance, IT Administration, and Security functions are identified, classified by risk tier, and mitigated through documented controls — producing audit-ready evidence for compliance assessments.

## What Was Built

| Component | Implementation |
|---|---|
| **Conflict matrix** | 15 role conflict pairs across Finance, IT Admin, and Security domains |
| **Risk classification** | Three-tier model — Critical, High, Medium — based on fraud and abuse potential |
| **Mitigation model** | Each conflict paired with specific compensating control or role separation |
| **Control mapping** | NIST 800-53 and CMMC Level 2 alignment for each conflict category |
| **Violation workflow** | Documented process for detecting, escalating, and remediating SoD violations |

## Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Role assignments reviewed against SoD conflict matrix |
| AC-3 | Access Enforcement | Conflicting roles not assigned to same user simultaneously |
| AC-5 | Separation of Duties | Formal SoD matrix defines prohibited role combinations |
| AC-6 | Least Privilege | Access scoped to role — conflicts identified before assignment |
| AU-2 | Audit Events | SoD violations and exceptions logged and reviewed |
| AU-9 | Protection of Audit Information | Audit log admin role separated from security admin role |
| CA-7 | Continuous Monitoring | Periodic SoD review cadence enforces ongoing compliance |

## Outcome

- Identified 15 high-risk role conflict pairs across three functional domains
- Classified conflicts by risk tier — 5 Critical, 6 High, 4 Medium
- Documented specific mitigation for every conflict — no unmitigated risks
- Established violation detection and escalation workflow
- Established preventative control framework reducing risk of fraud, privilege abuse, and audit control failure
- Produced audit-ready SoD evidence aligned to CMMC Level 2 and SOC 2

## SoD Conflict Matrix

> Risk Tiers: 🔴 Critical — direct fraud or system compromise risk | 🟠 High — significant abuse potential | 🟡 Medium — policy violation risk

### Finance Domain

| Role A | Role B | Conflict | Risk | Tier | Mitigation |
|---|---|---|---|---|---|
| Accounts Payable | Vendor Management | Same user creates vendor and processes payment | Fraudulent vendor payments | 🔴 Critical | Dual approval required — enforce role separation |
| Accounts Payable | General Ledger | Same user posts and approves journal entries | Financial statement manipulation | 🔴 Critical | Independent GL approval required |
| Budget Owner | Procurement Approver | Same user requests and approves purchases | Unauthorized spend | 🟠 High | Approval escalated to finance leadership |
| Payroll Admin | HR Records Admin | Same user modifies employee records and runs payroll | Ghost employee fraud | 🔴 Critical | HR changes require independent validation before payroll |
| Accounts Receivable | Cash Application | Same user records and applies receipts | Revenue manipulation | 🟠 High | Dual review for cash application |

### IT Administration Domain

| Role A | Role B | Conflict | Risk | Tier | Mitigation |
|---|---|---|---|---|---|
| Global Administrator | Conditional Access Admin | Can configure and bypass all access controls | Total identity compromise | 🔴 Critical | PIM eligible-only roles with approval workflow |
| User Administrator | Access Reviewer | Can grant and approve own access | Privilege escalation | 🔴 Critical | Separate access review authority |
| DevOps Engineer | Production Deploy Approver | Can deploy unreviewed code | Integrity / backdoor risk | 🟠 High | CI/CD approval gates enforced |
| Backup Administrator | Security Administrator | Can alter backups and controls | Evidence destruction | 🟠 High | Separate backup and security ownership |
| System Administrator | Audit Log Access | Can modify system and logs | Undetectable compromise | 🔴 Critical | Log immutability + restricted access |

### Security Domain

| Role A | Role B | Conflict | Risk | Tier | Mitigation |
|---|---|---|---|---|---|
| Security Administrator | Audit Log Administrator | Can generate and alter audit evidence | Audit integrity failure | 🔴 Critical | Segregate log management and security operations |
| Incident Responder | Forensic Evidence Custodian | Can investigate and control evidence | Evidence tampering | 🟠 High | Chain-of-custody enforcement |
| Risk Analyst | Control Owner | Can assess and approve own controls | False compliance reporting | 🟠 High | Independent validation required |
| Compliance Officer | System Administrator | Can define policy and implement controls | Policy bypass risk | 🟠 High | Separate governance and execution roles |
| Security Reviewer | Access Approver | Can validate and approve access decisions | Control bypass | 🟡 Medium | Dual-control approval workflow |

## Violation Detection and Response Workflow

1. **Detection**
   - Periodic role review identifies conflicting assignments
   - Automated IAM tooling flags SoD violations at provisioning time

2. **Classification**
   - Conflict evaluated against risk tier (Critical / High / Medium)

3. **Escalation**
   - Critical conflicts escalated immediately to Security and Compliance leadership
   - High/Medium reviewed within defined SLA

4. **Remediation**
   - Remove conflicting role or implement compensating control
   - Document exception if temporary overlap is required with business justification

5. **Validation**
   - Confirm conflict resolution
   - Log outcome for audit evidence

## Assessment Narrative

The Segregation of Duties implementation establishes a formal control framework preventing high-risk role combinations that could enable fraud, privilege abuse, or audit integrity violations.

Conflicts are explicitly defined, risk-tiered, and paired with documented mitigation strategies. Role assignments are evaluated against the matrix, and violations are detected, escalated, and remediated through a structured workflow.

This implementation demonstrates alignment to NIST 800-53 AC-5 and CMMC Level 2 requirements, producing defensible, audit-ready evidence of access governance controls.

## Pack Contents

| File | Description |
|---|---|
| `SoD-Matrix.md` | Full role conflict matrix with risk classification |
| `SoD-Policy.md` | Governance policy defining SoD enforcement model |
| `control-mapping.md` | NIST 800-53 / CMMC Level 2 control mapping |
| `resume-bullets.md` | Resume-ready bullet points tied to this implementation |
| `interview-questions.md` | Interview questions this pack answers with documented responses |

## Interview Value

This pack demonstrates the ability to:

- Design a multi-domain SoD conflict matrix across Finance, IT, and Security functions
- Classify role conflicts by risk tier using fraud and abuse potential
- Document specific mitigations for every identified conflict
- Map SoD controls to NIST 800-53 AC-5 and CMMC Level 2 requirements
- Operate at the intersection of IAM, GRC, and compliance

---

*Pack version: v1.0 — March 2026 · Scope: Generic regulated enterprise — CUI / PII / financial data*
