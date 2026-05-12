# Access Reviews Pack

Periodic access certification demonstration using Microsoft Entra ID Identity Governance to support least privilege enforcement, reviewer accountability, and audit-ready access governance workflows aligned to NIST 800-53 and CMMC Level 2.

This pack demonstrates practical access review governance processes including reviewer-driven access decisions, automated recommendations, access removal enforcement, and audit evidence generation within regulated environments.

---

# Scenario

A regulated organization requires periodic certification of group memberships to ensure access remains aligned to business need over time.

Reviewers evaluate continued access requirements, document decisions with justification, and denied access is removed to maintain least privilege and support audit readiness.

---

# What Was Built

| Component | Implementation |
|---|---|
| Review campaign | Quarterly access review scoped to Finance-ReadOnly security group — AR-Finance-ReadOnly-Q1-2026 |
| Reviewer assignment | Independent reviewer assigned to evaluate user access |
| Automated recommendation | System-generated recommendation surfaced based on user inactivity signals |
| Reviewer decision | Access denied with documented business justification |
| Access removal | Denied access removed upon review completion through configured enforcement settings |
| Audit trail | All decisions logged within Microsoft Entra ID audit logs with actor and timestamp |

---

# Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Periodic review and removal of unnecessary access |
| AC-2(4) | Automated Audit Actions | Automated recommendations generated from activity indicators |
| AC-5 | Separation of Duties | Reviewer separated from reviewed user |
| AC-6 | Least Privilege | Access removed when business need is not validated |
| CA-7 | Continuous Monitoring | Quarterly review cadence supporting ongoing access validation |
| AU-2 | Audit Events | Decisions logged with actor, timestamp, and outcome |

---

# Outcome

- Identified inactive access through automated recommendation workflows
- Documented reviewer decisions with justification to support audit traceability
- Enforced least privilege through removal of unnecessary group membership
- Established quarterly review cadence aligned to governance and compliance requirements
- Generated complete audit trail from review creation through access enforcement

---

# Evidence Index

| File | What It Shows | Control |
|---|---|---|
| AR-STEP-01-review-created.png | Quarterly review campaign configuration and scope | AC-2 |
| AR-STEP-02-review-active.png | Active review workflow within My Access portal | AC-2, CA-7 |
| AR-STEP-03-justification.png | Reviewer denial decision with documented justification | AC-6 |
| AR-STEP-04-decision-recorded.png | Decision recorded by assigned reviewer | AC-2, AU-2 |
| AR-STEP-05-review-results.png | Access removal outcome following review completion | AC-2, AU-2 |
| AR-STEP-06-audit-log.png | Audit log correlation showing review and enforcement events | AU-2 |

---

# Pack Contents

| File | Description |
|---|---|
| AR-Policy.md | Access review governance policy including cadence, reviewer model, and enforcement controls |
| control-mapping.md | NIST 800-53 and CMMC Level 2 mapping with evidence linkage |
| resume-bullets.md | Resume-ready governance and IAM implementation bullet points |
| interview-questions.md | IAM and governance interview questions supported by this implementation |
| evidence/ | Microsoft Entra ID Identity Governance screenshots and evidence artifacts |

---

# Interview Value

This pack demonstrates practical approaches to:

- Periodic access certification and review governance
- Reviewer accountability and separation of duties
- Automated recommendation workflows based on activity signals
- Least privilege enforcement through access removal
- Audit-ready evidence preparation and traceability
- Governance alignment to NIST 800-53 and CMMC Level 2 requirements

This directly supports IAM, identity governance, access management, governance, and compliance-focused interview discussions.

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

- Microsoft Entra ID Identity Governance
- rjmyers.cloud tenant
- Pack version: v1.0 — March 2026

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
