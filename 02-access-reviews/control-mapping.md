# Control Mapping — Access Reviews Pack

This mapping demonstrates how the access review program implemented in Microsoft Entra ID Identity Governance aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct evidence linkage to review artifacts.

## NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Periodic review and removal of unnecessary group-based access | AR-STEP-01, AR-STEP-05 |
| AC-2(4) | Access Control | Automated Audit Actions | System-generated recommendations based on user activity (e.g., inactivity) are automatically surfaced to reviewers to support access decision-making and reduce manual analysis | AR-STEP-03, AR-STEP-04 |
| AC-5 | Access Control | Separation of Duties | Reviewer (Robert Myers) is distinct from user being reviewed (JML Test User) | AR-STEP-03, AR-STEP-04 |
| AC-6 | Access Control | Least Privilege | Access denied and removed when business need cannot be confirmed | AR-STEP-03, AR-STEP-05 |
| AC-6(7) | Access Control | Review of User Privileges | Periodic review of user privileges (group memberships) to ensure continued alignment with least privilege principles | AR-STEP-01, AR-STEP-02 |
| CA-7 | Assessment & Authorization | Continuous Monitoring | Defined quarterly review cadence provides ongoing monitoring of access assignments, supporting continuous assessment of access control effectiveness | AR-STEP-01, AR-STEP-02 |
| IA-5 | Identification & Authentication | Authenticator Management | Access reviews validate continued assignment of user identities tied to authenticators | AR-STEP-02 |
| AU-2 | Audit & Accountability | Event Logging | All review decisions logged with actor, timestamp, and outcome | AR-STEP-06 |

## CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | Quarterly certification confirms continued authorization |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions | Access is removed when continued authorization cannot be validated during review |
| AC.L2-3.1.6 | Access Control | Use non-privileged accounts for non-privileged activities | Review scope includes separation of standard and privileged groups |
| CA.L2-3.12.3 | Security Assessment | Monitor security controls on an ongoing basis | Quarterly access review cadence supports continuous monitoring requirement |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain system audit logs | Entra ID audit log captures all review events and decisions |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit log actions are traceable | All decisions attributed to named reviewer with timestamp |

## Evidence Reference

| Evidence File | Controls Satisfied |
|---|---|
| AR-STEP-01-review-created.png | Demonstrates review campaign configuration — AC-2, AC-6(7), CA-7 |
| AR-STEP-02-review-active.png | Demonstrates active review with pending decision — AC-2, AC-6(7), CA-7, IA-5 |
| AR-STEP-03-justification.png | Demonstrates documented denial with reviewer justification — AC-5, AC-6, AC-2(4) |
| AR-STEP-04-decision-recorded.png | Demonstrates decision recorded by named reviewer — AC-2, AC-5, AU-2 |
| AR-STEP-05-review-results.png | Demonstrates access removal outcome following reviewer decision — AC-2, AC-6, AU-2 |
| AR-STEP-06-audit-log.png | Demonstrates complete audit trail from decision through enforcement — AU-2, CA-7 |

## Control Chain Summary

| Step | Action | Control Satisfied |
|---|---|---|
| 1 | Review campaign created with defined scope and reviewer | AC-2, CA-7 |
| 2 | System identifies inactive user and recommends Deny | AC-2(4) |
| 3 | Reviewer makes independent decision with documented justification | AC-5, AC-6 |
| 4 | Decision recorded with actor, timestamp, and outcome | AU-2 |
| 5 | Access removed upon review completion | AC-2, AC-6 |
| 6 | Audit log captures complete event trail | AU-2 |

## Assessment Narrative

The access review process demonstrates enforcement of least privilege through periodic certification of group membership.

A scheduled review campaign was initiated, and system-generated recommendations identified an inactive user. The assigned reviewer independently evaluated the recommendation, denied access with documented justification, and the system enforced access removal upon review completion.

All actions were recorded in the Entra ID audit log, providing a complete and traceable record of control execution. Evidence artifacts demonstrate the full lifecycle from review initiation through enforcement and logging.

This establishes a defensible control implementation aligned to NIST 800-53 and CMMC Level 2 requirements.

---

*Mapping reference: NIST SP 800-53 Rev 5 · CMMC Level 2 (32 CFR Part 170) · NIST SP 800-171 Rev 2*
