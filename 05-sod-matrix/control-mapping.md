# Control Mapping — Segregation of Duties (SoD) Pack

This mapping demonstrates how the Segregation of Duties program aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements through formal role conflict identification, preventative enforcement controls, exception governance, and continuous access review workflows. :contentReference[oaicite:0]{index=0}

---

# NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Role assignments evaluated against SoD matrix at provisioning — conflicting assignments blocked before access is granted | SoD-Matrix.md, SoD-Policy.md |
| AC-3 | Access Control | Access Enforcement | Conflicting roles not simultaneously assigned to same user through provisioning controls and quarterly review | SoD-Matrix.md |
| AC-5 | Access Control | Separation of Duties | Formal SoD matrix defines prohibited role combinations across Finance, IT Administration, and Security domains | SoD-Matrix.md |
| AC-5(a) | Access Control | Separation of Duties — Identified Duties | Duties requiring separation explicitly identified with documented conflict descriptions and risk articulation | SoD-Matrix.md |
| AC-5(b) | Access Control | Separation of Duties — Documented | Separation requirements documented with risk tier, mitigation strategy, and exception handling process | SoD-Matrix.md, SoD-Policy.md |
| AC-6 | Access Control | Least Privilege | Access scoped to role with conflict validation preventing excessive permission concentration | SoD-Policy.md |
| AC-6(1) | Access Control | Authorize Access to Security Functions | Administrative and governance review responsibilities separated to prevent self-approval | IT-002, SEC-005 |
| AC-6(5) | Access Control | Privileged Accounts | High-risk administrative conflicts mitigated using PIM eligible-only workflows and approval controls | IT-001 |
| AU-2 | Audit & Accountability | Audit Events | SoD violations, exception approvals, remediation actions, and review outcomes logged and retained | SoD-Policy.md |
| AU-6 | Audit & Accountability | Audit Review, Analysis, and Reporting | Quarterly governance reviews validate conflict detection and remediation effectiveness | Quarterly review evidence |
| AU-9 | Audit & Accountability | Protection of Audit Information | Audit administration separated from operational security administration roles | IT-005, SEC-001 |
| CA-7 | Assessment & Authorization | Continuous Monitoring | Quarterly SoD review cadence and IAM conflict detection workflows support ongoing governance monitoring | SoD-Policy.md |

---

# CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | SoD matrix prevents conflicting role combinations creating unauthorized access exposure |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions and functions | Role separation and approval workflows prevent unauthorized operational execution |
| AC.L2-3.1.4 | Access Control | Separate duties of individuals to reduce risk of malevolent activity | Formal SoD matrix governs incompatible role assignments |
| AC.L2-3.1.5 | Access Control | Employ the principle of least privilege | Conflict validation prevents accumulation of incompatible privileges |
| AC.L2-3.1.6 | Access Control | Use non-privileged accounts for non-privileged functions | Administrative and standard user responsibilities separated |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain system audit logs | SoD violations, exceptions, and remediation actions logged and retained |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit actions are traceable | Governance activities attributable to named users with timestamps |
| CA.L2-3.12.1 | Security Assessment | Periodically assess security controls | Quarterly governance reviews validate SoD control effectiveness |
| CA.L2-3.12.3 | Security Assessment | Monitor security controls on an ongoing basis | Continuous governance review and conflict detection workflows |

---

# Conflict-to-Control Mapping

| Conflict ID | Conflict | Primary Control | Secondary Controls |
|---|---|---|---|
| FIN-001 | Accounts Payable + Vendor Management | AC-5 | AC-2, AC-3 |
| FIN-002 | Accounts Payable + General Ledger | AC-5 | AC-3, AC-6 |
| FIN-003 | Budget Owner + Procurement Approver | AC-5 | AC-6 |
| FIN-004 | Payroll Administrator + HR Records Administrator | AC-5 | AC-2 |
| FIN-005 | Accounts Receivable + Cash Application | AC-5 | AC-3 |
| IT-001 | Global Administrator + Conditional Access Administrator | AC-5 | AC-6, AC-6(5) |
| IT-002 | User Administrator + Access Reviewer | AC-5 | AC-2, AC-6(1) |
| IT-003 | DevOps Engineer + Production Deploy Approver | AC-5 | AC-3 |
| IT-004 | Backup Administrator + Security Administrator | AC-5 | AU-9 |
| IT-005 | System Administrator + Audit Log Administrator | AC-5 | AU-2, AU-9 |
| SEC-001 | Security Administrator + Audit Log Administrator | AU-9 | AC-5 |
| SEC-002 | Incident Responder + Evidence Custodian | AC-5 | AU-9 |
| SEC-003 | Risk Analyst + Control Owner | AC-5 | CA-7 |
| SEC-004 | Compliance Officer + System Administrator | AC-5 | AC-3 |
| SEC-005 | Security Reviewer + Access Approver | AC-5 | AC-2, AC-6(1) |

---

# Preventive, Detective, and Corrective Controls

| Control Type | Implementation | Governance Objective |
|---|---|---|
| Preventive | Role separation during provisioning workflows | Prevent conflicting assignments before activation |
| Preventive | PIM eligible-only privileged role assignment | Reduce standing privileged access exposure |
| Preventive | Dual approval workflows | Prevent self-approved operational activity |
| Detective | Quarterly access certification | Detect accumulated conflicts and provisioning drift |
| Detective | IAM conflict scans | Identify conflicting assignments at scale |
| Detective | Exception register review | Validate ongoing governance compliance |
| Corrective | Role removal and remediation workflows | Resolve identified conflicts |
| Corrective | Compensating controls and enhanced monitoring | Reduce residual operational risk |

---

# Exception Governance Mapping

| Exception Requirement | Governance Purpose |
|---|---|
| Documented business justification | Establish accountability |
| Security risk assessment | Evaluate operational impact |
| Compensating control requirement | Reduce residual risk |
| Defined expiration date | Prevent unmanaged permanent exceptions |
| Quarterly review | Validate continued business need |
| Approval authority enforcement | Ensure governance oversight |

---

# Evidence Requirements

| Evidence Artifact | Governance Purpose |
|---|---|
| SoD conflict matrix | Defines prohibited role combinations |
| SoD policy | Defines governance framework and workflows |
| Exception register | Tracks approved temporary conflicts |
| Quarterly access review evidence | Demonstrates ongoing governance monitoring |
| Provisioning validation records | Demonstrates preventative enforcement |
| Remediation documentation | Demonstrates corrective action tracking |

---

# Control Chain Summary

| Step | Action | Controls Supported |
|---|---|---|
| 1 | SoD matrix defines prohibited role combinations | AC-5, AC-5(a), AC-5(b) |
| 2 | Conflicts classified by risk tier | AC-5 |
| 3 | Mitigation controls documented for each conflict | AC-5, AC-6 |
| 4 | Provisioning workflows evaluate role assignments against matrix | AC-2, AC-3 |
| 5 | Quarterly reviews identify accumulated conflicts | CA-7 |
| 6 | Exceptions governed through formal approval workflow | AC-5, AU-2 |
| 7 | Violations and remediation activities logged | AU-2, AU-6 |

---

# Assessment Narrative

The Segregation of Duties implementation establishes a formal preventative and detective governance framework designed to reduce:
- fraud risk
- privilege abuse
- audit integrity failure
- unauthorized operational concentration

Role conflicts are:
- explicitly identified
- risk-tier classified
- paired with mitigation controls
- evaluated during provisioning
- monitored through quarterly governance review

The framework combines:
- preventative controls
- detective governance workflows
- corrective remediation procedures
- formal exception handling

to support regulated-environment access governance and operational accountability.

This implementation demonstrates governance alignment to:
- NIST 800-53 AC-5
- least privilege principles
- audit accountability requirements
- CMMC Level 2 access governance objectives

---

# Control Effectiveness Statement

The implementation demonstrates that:
- conflicting role assignments are formally identified and classified
- provisioning workflows evaluate assignments against governance controls
- exceptions require documented approval and compensating controls
- quarterly reviews validate ongoing governance effectiveness
- governance evidence remains traceable and reviewable

These controls collectively reduce operational and governance risk associated with excessive authority concentration and incompatible role assignments.

---

# Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Fraudulent vendor payments | Financial role separation and dual approval |
| Privilege escalation through self-approval | Administrative review separation |
| Audit evidence manipulation | Audit and operational role segregation |
| Undetectable compromise | Immutable logging and audit separation |
| Ghost employee fraud | Payroll and HR separation |

---

# Mapping References

- NIST SP 800-53 Rev 5
- NIST SP 800-171 Rev 2
- CMMC Level 2 (32 CFR Part 170)

---

# Related Framework Alignment

The controls mapped above support governance concepts commonly associated with:
- SOC 2 Type II (CC6)
- ISO 27001 Annex A
- COBIT governance principles
- financial internal control frameworks
- Zero Trust least privilege models

---

# Scope Note

This appendix demonstrates governance-driven SoD workflows within a controlled IAM and regulated-enterprise governance environment.

Expanded automation integrations and cross-framework traceability are planned for future governance and evidence-production packs.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
