# Control Mapping — Access Reviews Pack

This mapping demonstrates how the access review governance process configured within Microsoft Entra ID Identity Governance aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct evidence linkage to review workflows and configuration artifacts. :contentReference[oaicite:0]{index=0}

---

# NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Periodic review and removal of unnecessary group-based access | AR-STEP-01, AR-STEP-05 |
| AC-2(4) | Access Control | Automated Audit Actions | Automated recommendations generated from activity indicators to support reviewer decision-making | AR-STEP-03, AR-STEP-04 |
| AC-5 | Access Control | Separation of Duties | Reviewer separated from reviewed user to maintain independent review process | AR-STEP-03, AR-STEP-04 |
| AC-6 | Access Control | Least Privilege | Access removed when continued business need cannot be validated | AR-STEP-03, AR-STEP-05 |
| AC-6(7) | Access Control | Review of User Privileges | Periodic review of group memberships to validate continued least privilege alignment | AR-STEP-01, AR-STEP-02 |
| CA-7 | Assessment & Authorization | Continuous Monitoring | Quarterly review cadence supporting ongoing validation of access assignments | AR-STEP-01, AR-STEP-02 |
| IA-5 | Identification & Authentication | Authenticator Management | Reviews validate continued assignment of user identities associated with authenticators | AR-STEP-02 |
| AU-2 | Audit & Accountability | Event Logging | Review decisions logged with actor, timestamp, and outcome | AR-STEP-06 |

---

# CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | Quarterly certification validates continued authorization |
| AC.L2-3.1.2 | Access Control | Limit access to authorized transactions and functions | Access removed when authorization cannot be confirmed during review |
| AC.L2-3.1.6 | Access Control | Use non-privileged accounts for non-privileged activities | Review scope separates standard and privileged access groups |
| CA.L2-3.12.3 | Security Assessment | Monitor security controls on an ongoing basis | Quarterly review cadence supports continuous monitoring objectives |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain audit logs | Microsoft Entra ID audit logs capture review actions and decisions |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit actions are traceable | Decisions attributed to named reviewer with timestamp correlation |

---

# Evidence Reference

| Evidence File | Controls Supported |
|---|---|
| AR-STEP-01-review-created.png | Review campaign configuration and cadence — AC-2, AC-6(7), CA-7 |
| AR-STEP-02-review-active.png | Active review workflow and pending review actions — AC-2, AC-6(7), CA-7, IA-5 |
| AR-STEP-03-justification.png | Reviewer denial decision with documented justification — AC-5, AC-6, AC-2(4) |
| AR-STEP-04-decision-recorded.png | Reviewer decision recorded with actor attribution — AC-2, AC-5, AU-2 |
| AR-STEP-05-review-results.png | Access removal outcome following reviewer decision — AC-2, AC-6, AU-2 |
| AR-STEP-06-audit-log.png | Audit log correlation showing review and enforcement events — AU-2, CA-7 |

---

# Control Chain Summary

| Step | Action | Controls Supported |
|---|---|---|
| 1 | Review campaign created with defined scope and assigned reviewer | AC-2, CA-7 |
| 2 | Automated recommendation identifies inactive access | AC-2(4) |
| 3 | Reviewer evaluates access and documents decision | AC-5, AC-6 |
| 4 | Decision recorded with actor and timestamp | AU-2 |
| 5 | Access removed following review completion | AC-2, AC-6 |
| 6 | Audit logs capture complete review and enforcement workflow | AU-2 |

---

# Assessment Narrative

The access review governance process demonstrates periodic validation of group-based access to support least privilege and ongoing access accountability.

A scheduled review campaign was initiated within Microsoft Entra ID Identity Governance. Automated recommendation logic surfaced inactive access for reviewer evaluation. The assigned reviewer independently reviewed the recommendation, documented the decision with justification, and access removal was enforced through configured review settings.

Audit logs captured all workflow events including review creation, reviewer actions, access enforcement, and final outcomes.

The resulting evidence demonstrates traceable governance workflows aligned to identity lifecycle governance, least privilege enforcement, and regulated-environment audit requirements.

---

# Mapping References

- NIST SP 800-53 Rev 5
- NIST SP 800-171 Rev 2
- CMMC Level 2 (32 CFR Part 170)

---

# Related Framework Alignment

The controls mapped above support governance concepts commonly associated with additional regulated-environment frameworks including:

- NIST SP 800-171 Rev 2 — Access Control and Identification & Authentication requirements
- SOC 2 Type II (TSC 2017) — Logical access control and monitoring concepts
- CISA Zero Trust Maturity Model — identity governance and continuous validation principles

---

# Scope Note

This appendix demonstrates governance alignment and access review workflows within a controlled IAM lab environment.

Expanded cross-framework mappings and consolidated evidence traceability are planned for future governance and evidence-production packs.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
