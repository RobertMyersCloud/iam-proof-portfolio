# IAM Proof Portfolio

**Production-grade identity governance evidence packs for Microsoft Entra ID.** Built for CMMC Level 2 and NIST 800-53 regulated environments by a Navy-trained IAM architect.

[![License: MIT](https://img.shields.io/badge/License-MIT-gold.svg)](./LICENSE)
[![NIST 800-53](https://img.shields.io/badge/NIST-800--53-blue)](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
[![CMMC Level 2](https://img.shields.io/badge/CMMC-Level%202-green)](https://dodcio.defense.gov/CMMC/)
[![Zero Trust](https://img.shields.io/badge/Zero-Trust-red)](https://www.cisa.gov/zero-trust-maturity-model)
[![Status: Complete](https://img.shields.io/badge/Status-7%20Packs%20Complete-brightgreen)](https://github.com/RobertMyersCloud/iam-proof-portfolio)

---

## What This Portfolio Is

Seven complete governance packs. Each pack contains the deliverables that real IAM programs require and real CMMC Level 2 assessors expect.

Every pack includes:
- **Policy document** — the governing framework
- **Control mapping** — NIST 800-53 + CMMC Level 2 traceability
- **Implementation evidence** — configured in a live Entra tenant, screenshots preserved
- **Interview responses** — real questions with operator-level answers
- **Resume-ready outcome statements** — measurable business impact, not task descriptions

This is not tutorial content. It is not theory. It is a working implementation with evidence.

---

## For IAM Hiring Managers

These packs answer the question most candidates can't: **"Can this person actually operate identity governance at scale?"**

Open any pack and see real policies, real Entra configurations, real control mappings. The packs demonstrate end-to-end lifecycle thinking — provisioning through deprovisioning, activation through revocation, review through enforcement.

**Strongest packs for IAM Architect interviews:**
1. [**JML Lifecycle**](./01-jml-lifecycle/) — 1-hour deprovisioning SLA, AC-2/AC-6/IA-2
2. [**Privileged Access (PIM)**](./03-privileged-access/) — JIT activation, approval gates, AC-6(5)
3. [**Conditional Access**](./04-conditional-access/) — Zero Trust deployment with Report-only → enforce lifecycle
4. [**Automation Scripts**](./06-automation-scripts/) — Complete PowerShell IGA control system

---

## For CMMC Consulting Clients

Each pack includes the exact deliverables a CMMC Level 2 assessor expects: policy, configuration evidence, control narrative, NIST 800-53 mapping.

These packs double as kickstarter templates for CMMC readiness engagements. For custom implementation or CMMC readiness consulting, contact:

**Stella Maris Governance LLC** — SDVOSB | CAGE 1AGQ9
[stellamarisgovernance.com](https://stellamarisgovernance.com)

---

## Pack Index

| # | Pack | Domain | Key Controls | Evidence |
|---|------|--------|--------------|----------|
| [01](./01-jml-lifecycle/) | **JML Lifecycle** | Identity Lifecycle | AC-2, AC-2(1), AC-3, AC-6, IA-2 | 6 screenshots |
| [02](./02-access-reviews/) | **Access Reviews** | Access Governance | AC-2, AC-6, AC-6(7), CA-7 | 6 screenshots |
| [03](./03-privileged-access/) | **Privileged Access (PIM)** | PAM / Zero Trust | AC-6(5), IA-2, AC-3 | 7 screenshots |
| [04](./04-conditional-access/) | **Conditional Access** | Zero Trust | IA-2, AC-3, AC-17 | 6 screenshots |
| [05](./05-sod-matrix/) | **SoD Matrix** | GRC / Compliance | AC-5, AC-6, AU-2, AU-9, CA-7 | 15-conflict matrix |
| [06](./06-automation-scripts/) | **PowerShell Automation** | IGA Engineering | Cross-cutting automation | 5-script control system |
| [07](./07-sparks-ai-operations/) | **Sparks AI Operations** NEW | Application-layer IAM | AC-2, AC-3, AC-4, AC-6, AU-2, AU-9, IA-2, SI-4 | Live production platform |

---

## Standards

Every pack is aligned to:
- **NIST SP 800-53 Rev 5** — full control mapping per pack
- **CMMC Level 2** — applicable practice mapping
- **SOC 2 Type II (CC6)** — access control criteria
- **Zero Trust** — CISA Zero Trust Maturity Model

---

## Stack

Microsoft Entra ID (Azure AD) · Microsoft Entra ID Governance · Microsoft Entra PIM · Conditional Access · PowerShell · Microsoft Graph · NIST SP 800-53 · CMMC Level 2

---

## Author

**Robert J. Myers** — IAM Architect · Founder, Stella Maris Governance LLC

20 years U.S. Navy (2001–2021) — federal identity governance at scale. 3,500+ identities, 2,200+ CAC/PKI credentials, zero security incidents across four years as IT Operations & Access Governance Lead.

Civilian IAM implementation and CMMC consulting since 2025. Holder of 25+ active certifications including CMMC RP, CCZT, SailPoint ISL, Okta Identity Foundations, FinOps Certified Practitioner, Security+, Network+, CCSK v5, SC-900, AZ-900.

Currently pursuing SC-300 (Microsoft Identity Administrator), AZ-500 (Azure Security Engineer), Okta Certified Professional, Okta Certified Administrator.

Active U.S. Government Secret clearance · DOJ High-Risk Public Trust.

**Open to:**
- IAM / IGA Architect roles ($130K–170K target)
- CMMC Level 2 readiness consulting engagements
- SDVOSB defense identity governance contracts

**Contact:** robert@stellamarisgovernance.com · [LinkedIn](https://linkedin.com/in/robertjmyers5) · [Stella Maris Governance](https://stellamarisgovernance.com)

---

*This portfolio is actively maintained. Each pack is versioned. Pack updates are documented in individual pack READMEs.*

*Last updated: April 2026*
