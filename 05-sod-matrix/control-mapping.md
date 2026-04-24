# Control Mapping — Segregation of Duties Pack

This mapping demonstrates how the Segregation of Duties program aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct linkage to conflict matrix entries and governance artifacts.

## NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Role assignments evaluated against SoD matrix at provisioning — conflicting assignments blocked before access is granted | SoD-Matrix.md, SoD-Policy.md |
| AC-3 | Access Control | Access Enforcement | Conflicting roles not simultaneously assigned to same user — enforced through provisioning controls and quarterly review | SoD-Matrix.md |
| AC-5 | Access Control | Separation of Duties | Formal SoD matrix defines 15 prohibited role combinations across Finance, IT Administration, and Security domains | SoD-Matrix.md |
| AC-5(a) | Access Control | Separation of Duties — Identified Duties | Duties requiring separation explicitly identified with conflict description and risk articulation for each pair | SoD-Matrix.md |
| AC-5(b) | Access Control | Separation of Duties — Documented | Separation requirements documented in formal matrix with risk tier, mitigation, and exception process | SoD-Matrix.md, SoD-Policy.md |
| AC-6 | Access Control | Least Privilege | Access scoped to role — SoD matrix prevents over-permission through conflicting role detection | SoD-Policy.md |
| AU-2 | Audit & Accountability | Event Logging | SoD violations, exception approvals, and resolutions logged and retained for audit review | SoD-Policy.md |
| AU-9 | Audit & Accountability | Protection of Audit Information | Security Administrator and Audit Log Administrator roles formally separated — SEC-001 conflict entry | SoD-Matrix.md |
| CA-7 | Assessment & Authorization | Continuous Monitoring | Quarterly SoD review cadence with IAM tooling conflict detection — not manual, scales across role population | SoD-Policy.md |

## CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | SoD matrix prevents conflicting role assignments that would create unauthorized access combinations |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions | Dual approval and role separation controls prevent unauthorized transaction execution |
| AC.L2-3.1.5 | Access Control | Employ the principle of least privilege | SoD conflicts identified and blocked at provisioning — prevents accumulation of conflicting permissions |
| AC.L2-3.1.6 | Access Control | Use non-privileged accounts for non-privileged activities | IT-001 and IT-002 conflicts enforce separation of administrative and standard user functions |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain system audit logs | SoD violations, exceptions, and resolutions logged with actor, timestamp, and outcome |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit log actions are traceable | SEC-001 conflict separates security operations from audit log administration — log integrity maintained |
| CA.L2-3.12.3 | Security Assessment | Monitor security controls on an ongoing basis | Quarterly SoD review cadence provides continuous monitoring of access control effectiveness |

## Conflict-to-Control Mapping

| Conflict ID | Conflict | Primary Control | Secondary Control |
|---|---|---|---|
| FIN-001 | AP + Vendor Management | AC-5 | AC-2, AC-3 |
| FIN-002 | AP + General Ledger | AC-5 | AC-3, AC-6 |
| FIN-003 | Budget Owner + Procurement | AC-5 | AC-6 |
| FIN-004 | Payroll + HR Records | AC-5 | AC-2 |
| FIN-005 | AR + Cash Application | AC-5 | AC-3 |
| IT-001 | Global Admin + CA Admin | AC-5 | AC-6, AC-6(5) |
| IT-002 | User Admin + Access Reviewer | AC-5 | AC-2, AC-3 |
| IT-003 | DevOps + Deploy Approver | AC-5 | AC-3 |
| IT-004 | Backup Admin + Security Admin | AC-5 | AU-9 |
| IT-005 | System Admin + Audit Log Admin | AC-5 | AU-2, AU-9 |
| SEC-001 | Security Admin + Audit Log Admin | AU-9 | AC-5 |
| SEC-002 | Incident Responder + Evidence Custodian | AC-5 | AU-9 |
| SEC-003 | Risk Analyst + Control Owner | AC-5 | CA-7 |
| SEC-004 | Compliance Officer + System Admin | AC-5 | AC-3 |
| SEC-005 | Security Reviewer + Access Approver | AC-5 | AC-2 |

## Control Chain Summary

| Step | Action | Control Satisfied |
|---|---|---|
| 1 | SoD conflict matrix defined — 15 prohibited role pairs across three domains | AC-5, AC-5(a), AC-5(b) |
| 2 | Risk tier assigned to each conflict — Critical, High, Medium | AC-5 |
| 3 | Mitigation documented for every conflict — no unmitigated risks | AC-5, AC-6 |
| 4 | Role assignments evaluated against matrix at provisioning | AC-2, AC-3 |
| 5 | Quarterly access reviews detect existing conflicts | CA-7 |
| 6 | Exception process governs approved temporary conflicts | AC-5, AU-2 |
| 7 | Violations and exceptions logged with actor and timestamp | AU-2 |

## Assessment Narrative

The Segregation of Duties implementation establishes a formal preventative and detective control framework preventing high-risk role combinations that could enable fraud, privilege abuse, or audit integrity violations.

Fifteen role conflict pairs are explicitly defined across Finance, IT Administration, and Security domains — each classified by risk tier and paired with a required mitigation. Role assignments are evaluated against the matrix at provisioning, and quarterly access reviews detect conflicts that accumulate over time. Exceptions are governed through a formal approval process with defined SLAs, compensating controls, and expiration dates.

The separation of Security Administrator and Audit Log Administrator roles (SEC-001) directly satisfies AU-9 — ensuring audit evidence cannot be manipulated by the same party responsible for security operations.

This establishes a defensible SoD program aligned to NIST 800-53 AC-5 and CMMC Level 2 requirements, producing audit-ready evidence of access governance maturity.

## Control Effectiveness Statement

The implementation demonstrates that role conflicts are explicitly identified, risk-classified, and mitigated — with no unmitigated conflicts in the defined matrix. The exception process ensures that any approved deviations are governed, time-limited, and subject to compensating controls.

Quarterly review cadence and IAM tooling detection confirm that SoD enforcement is continuous and scalable — not dependent on manual processes.

This confirms that the SoD program is functioning as a genuine governance control, not a documentation artifact.

---

*Mapping reference: NIST SP 800-53 Rev 5 · CMMC Level 2 (32 CFR Part 170) · NIST SP 800-171 Rev 2*

---

## Related framework alignment

The NIST 800-53 controls mapped above correspond directly to the following additional frameworks. This pack's controls satisfy equivalent requirements in each:

- **NIST SP 800-171 (Rev. 3)** — DFARS 252.204-7012 / CMMC Level 2 baseline; 3.1.x (Access Control) and 3.5.x (Identification and Authentication) families applicable

> **Note on scope:** This appendix identifies cross-framework applicability. Specific control-ID crosswalks to 800-171 and SOC 2 CC6/CC7 are on the roadmap for a future Evidence Production pack that consolidates cross-framework traceability.
