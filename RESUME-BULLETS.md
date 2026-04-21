# Resume Bullets — Master Reference

**All resume-ready outcome statements across the six IAM Proof Portfolio packs.**

Use these bullets directly in resume, LinkedIn, or cover letters. Each bullet is written outcome-first (measurable result → technical implementation) and aligned to specific NIST 800-53 controls for ATS keyword matching.

---

## Pick Your 5-7 for Resume

For a single resume block, select the strongest bullet from each domain rather than cramming multiple from one pack:

### Recommended Starter Set (IGA Architect role)

1. **JML Lifecycle** — "Designed and implemented a Joiner-Mover-Leaver (JML) identity lifecycle model in Microsoft Entra ID supporting 24-hour provisioning and 1-hour deprovisioning SLAs — automating role-based provisioning, access adjustment on role change, and immediate deprovisioning aligned to NIST AC-2 account management controls."

2. **Privileged Access** — "Implemented a just-in-time privileged access model in Microsoft Entra ID Privileged Identity Management, eliminating standing administrative access by enforcing eligible assignments, MFA, documented justification, and approval-gated activation aligned to NIST AC-6(5)."

3. **Conditional Access** — "Architected and implemented a Zero Trust Conditional Access framework in Microsoft Entra ID, establishing identity as the primary security control plane and enforcing policy evaluation on 100% of authentication events."

4. **Access Reviews** — "Implemented a quarterly access certification program in Microsoft Entra ID Identity Governance, scoping reviews to business-sensitive security groups, assigning independent reviewers to enforce separation of duties, and configuring auto-apply to remove denied access upon completion."

5. **SoD** — "Designed and implemented enterprise Segregation of Duties (SoD) framework identifying 15 high-risk role conflicts across Finance, IT Administration, and Security domains with risk-tier classification and defined mitigations aligned to NIST AC-5."

6. **Automation** — "Developed a PowerShell-based IAM automation suite for Microsoft Entra ID covering access governance, stale account detection, privileged access analysis (PIM), Conditional Access evaluation, and lifecycle enforcement — producing audit-ready evidence aligned to NIST 800-53 and CMMC Level 2."

7. **Portfolio impact statement** — "Published a six-pack IAM governance portfolio demonstrating end-to-end Entra ID identity lifecycle, PIM, Conditional Access, Access Reviews, SoD, and PowerShell automation — with policy documentation, control mappings to NIST 800-53 / CMMC Level 2, and audit-ready evidence for each domain."

---

## All Bullets by Pack


### JML Lifecycle

*From [01-jml-lifecycle/](./01-jml-lifecycle/)*

# Resume Bullets — JML Lifecycle Pack

## Primary Bullets

- Designed and implemented a Joiner-Mover-Leaver (JML) identity lifecycle model in Microsoft Entra ID supporting 24-hour provisioning and 1-hour deprovisioning SLAs — automating role-based provisioning, access adjustment on role change, and immediate deprovisioning aligned to NIST AC-2 account management controls.

- Reduced orphaned account risk by implementing a leaver workflow with immediate account disablement, session and token revocation, and group membership removal within one hour of offboarding — eliminating post-termination access persistence and residual session risk.

- Enforced least privilege across identity lifecycle using role-based group assignment with no direct user permissions — preventing privilege accumulation across role changes through clean delta enforcement.

- Implemented Conditional Access policy enforcing MFA on all cloud application sign-ins, aligned to NIST IA-2 and Zero Trust access control principles.

- Produced audit-ready identity lifecycle evidence package (policy, control mapping, and configuration evidence) aligned to NIST 800-53 and CMMC Level 2, supporting SOC 2 Type II requirements.

## Supporting Bullets

- Documented identity lifecycle workflows covering joiner provisioning, mover access adjustment, and leaver deprovisioning — providing repeatable, auditable process evidence for compliance reviews.

- Configured Microsoft Entra ID security groups for role-based access control — removing direct user permissions and enforcing access assignment via group membership only.

- Demonstrated immediate token revocation on user offboarding — closing the authentication persistence gap that exists when accounts are disabled but active sessions remain valid.

---

### Access Reviews

*From [02-access-reviews/](./02-access-reviews/)*

# Resume Bullets — Access Reviews Pack

## Primary Bullets

- Implemented a quarterly access certification program in Microsoft Entra ID Identity Governance, scoping reviews to business-sensitive security groups, assigning independent reviewers to enforce separation of duties, and configuring auto-apply to remove denied access upon completion.

- Enforced least privilege through reviewer-driven access certification, leveraging automated inactivity recommendations to identify dormant accounts and requiring documented justification for all denial decisions aligned to NIST AC-6 and AC-6(7).

- Produced audit-ready evidence packages including review configuration, decision records with justification, access removal confirmation, and Entra ID audit logs — enabling direct use in CMMC Level 2 and SOC 2 Type II assessments.

- Established continuous monitoring of access control effectiveness via a defined quarterly review cadence aligned to NIST CA-7, ensuring all access decisions are attributable, traceable, and auditable.

- Configured automated access review recommendations based on user activity signals, reducing manual analysis effort while preserving reviewer accountability and control integrity aligned to AC-2(4).

- Validated full access governance control chain from review initiation through enforcement and audit logging, ensuring controls are not only documented but operationally effective and testable during audit.

- Translated identity governance controls into audit-defensible evidence, bridging technical implementation with compliance requirements for NIST 800-53 and CMMC Level 2 assessments.

## Supporting Bullets

- Designed reviewer model enforcing separation of duties, ensuring users cannot review their own access and all decisions require documented justification.

- Verified enforcement of denied access through auto-apply and audit log correlation, confirming that access removal occurs as a result of reviewer decisions.

- Mapped access review implementation to NIST 800-53 AC-2, AC-5, AC-6, CA-7, and AU-2, producing structured evidence aligned for CMMC Level 2 SSP inclusion.

---

### Privileged Access (PIM)

*From [03-privileged-access/](./03-privileged-access/)*

# Resume Bullets — Privileged Access Pack

## Primary Bullets

- Implemented a just-in-time privileged access model in Microsoft Entra ID Privileged Identity Management, eliminating standing administrative access by enforcing eligible assignments, MFA, documented justification, and approval-gated activation aligned to NIST AC-6(5).

- Enforced least privilege for administrative roles through time-bound activation, ensuring access is granted only for the minimum required duration, automatically expires, and requires re-authorization for each use aligned to NIST AC-6.

- Configured PIM role settings requiring MFA, business justification, and designated approver authorization, eliminating self-approval paths and undocumented privileged access aligned to IA-2 and AC-3.

- Produced audit-ready privileged access evidence including role configuration, eligible assignments, activation requests with justification, approval decisions, and PIM audit logs — enabling direct use in CMMC Level 2 and SOC 2 Type II assessments.

- Validated full privileged access control chain from role configuration through activation and approval enforcement, confirming access is not granted without MFA, justification, and explicit authorization.

- Mapped PIM implementation to NIST 800-53 AC-2, AC-3, AC-6, AC-6(5), AC-6(10), IA-2, IA-2(1), and AU-2, producing structured evidence aligned for CMMC Level 2 SSP inclusion.

- Translated privileged access governance controls into audit-defensible evidence, bridging technical implementation with compliance requirements for NIST 800-53 and CMMC Level 2.

## Supporting Bullets

- Designed PIM approver model enforcing separation of duties — users cannot self-approve privileged access requests, and approvers must validate documented justification before granting access.

- Eliminated credential theft risk associated with standing administrative access — JIT model ensures stolen credentials cannot be used for persistent privileged access without MFA and approval.

- Configured role-tiered activation controls with differentiated duration limits — Tier 0 critical roles restricted to 2-hour maximum activation, standard roles to 8-hour maximum, aligned to risk-based least privilege principles.

---

### Conditional Access

*From [04-conditional-access/](./04-conditional-access/)*

# Resume Bullets — Conditional Access Pack

## Primary Bullets

- Architected and implemented a Zero Trust Conditional Access framework in Microsoft Entra ID, establishing identity as the primary security control plane and enforcing policy evaluation on 100% of authentication events — eliminating implicit trust.

- Enforced tenant-wide MFA across all users and cloud applications, removing all password-only authentication paths and significantly reducing exposure to credential stuffing and password spray attacks aligned to NIST IA-2.

- Designed and deployed location-based access controls using named locations, restricting authentication from untrusted geographic regions and introducing layered geographic risk controls aligned to NIST AC-17.

- Executed enterprise-grade Conditional Access deployment lifecycle using Report-only mode, What If simulation, and sign-in log analysis — validating policy impact prior to enforcement and preventing production lockouts.

- Produced audit-ready evidence packages including policy configurations, evaluation outputs, and control mappings — enabling direct use in CMMC Level 2 and SOC 2 assessments without rework.

- Mapped and validated controls against NIST 800-53 AC, IA, and SI control families and CMMC Level 2 requirements — translating technical enforcement into assessment-ready compliance artifacts.

- Bridged Zero Trust architecture with regulatory frameworks, delivering defensible identity governance controls aligned to NIST 800-53 and CMMC Level 2.

- Secured 100% of cloud authentication pathways under Conditional Access policy enforcement — establishing a complete identity enforcement perimeter with no authentication bypass paths.

## Supporting Bullets

- Identified and documented real-world control limitations including VPN bypass risk, non-interactive authentication gaps, and MFA fatigue — incorporating mitigation strategies and layered defenses that demonstrate architect-level awareness.

- Designed break-glass access model with Conditional Access exclusions, secure credential controls, monitoring, and incident response procedures — preventing tenant lockout while maintaining audit accountability.

- Established control validation methodology including What If simulation, negative testing, and continuous log-based monitoring — ensuring ongoing control effectiveness beyond initial deployment.

---

### Segregation of Duties

*From [05-sod-matrix/](./05-sod-matrix/)*

# Resume Bullets — Segregation of Duties Pack

## Primary Bullets (Resume-Ready)

- Designed and implemented enterprise Segregation of Duties (SoD) framework identifying 15 high-risk role conflicts across Finance, IT Administration, and Security domains with risk-tier classification and defined mitigations aligned to NIST AC-5.

- Enforced preventative and detective SoD controls by integrating conflict validation into provisioning workflows and leveraging quarterly access reviews for continuous monitoring aligned to NIST CA-7.

- Modeled cross-domain access risks including fraud exposure (Finance), privilege abuse (IT Administration), and audit integrity violations (Security) — demonstrating governance beyond single-domain access control.

- Established formal SoD exception governance process requiring executive approval, compensating control documentation, 90-day maximum expiration, and mandatory recurring review cycles.

- Mapped SoD controls to NIST 800-53 AC-5, AC-6, AU-2, AU-9, and CA-7 and CMMC Level 2 — producing audit-ready evidence packages structured for direct compliance assessment use.

- Translated access governance into audit-defensible control evidence aligned to fraud prevention, privilege abuse mitigation, and audit integrity requirements at a GRC practitioner level.

- Identified and enforced separation between Security Administrator and Audit Log Administrator roles, directly satisfying NIST AU-9 audit log integrity requirements.

## Supporting Bullets

- Classified 7 Critical, 7 High, and 1 Medium risk conflicts across three functional domains — providing quantified risk prioritization enabling security leadership to focus remediation on highest-impact conflicts.

- Produced complete SoD evidence package including conflict matrix, risk classification, mitigation requirements, exception governance, and control mapping — enabling direct SSP inclusion without rework.

- Demonstrated architect-level SoD thinking by unifying Finance fraud risk, IT privilege escalation, and Security audit integrity into a single governance framework.

## LinkedIn Experience Bullets

- Designed and implemented a Segregation of Duties (SoD) control framework identifying 15 high-risk role conflict pairs across Finance, IT Administration, and Security domains, with risk-tier classification and defined mitigation strategies

- Implemented preventative and detective SoD controls by enforcing conflict checks at provisioning and leveraging access reviews to identify and remediate role conflicts over time

- Modeled cross-domain access risks including fraud exposure, privilege abuse, and audit integrity violations, demonstrating governance beyond single-domain access control

- Established formal SoD exception process requiring executive approval, compensating controls, defined expiration windows, and recurring review cycles

- Mapped SoD controls to NIST 800-53 (AC-5, AC-6, AU-2, AU-9, CA-7) and CMMC Level 2, producing audit-ready evidence aligned for compliance assessments

- Identified and enforced separation between Security Administrator and Audit Log Administrator roles, satisfying audit log integrity requirements (AU-9)

---

### PowerShell Automation

*From [06-automation-scripts/](./06-automation-scripts/)*

# Resume Bullets — IAM Automation Scripts Pack

## Primary Bullets (Resume — Pick 4–5)

- Developed a PowerShell-based IAM automation suite for Microsoft Entra ID covering access governance, stale account detection, privileged access analysis (PIM), Conditional Access evaluation, and lifecycle enforcement — producing audit-ready evidence aligned to NIST 800-53 and CMMC Level 2.

- Automated generation of audit-ready evidence including group membership reporting, stale account identification with risk classification, PIM eligible assignment exports, and Conditional Access policy inventories for direct use in access reviews and compliance assessments.

- Implemented controlled leaver workflow automation with WhatIf simulation, protected account guardrails, validation steps, and timestamped execution logging — enabling auditable lifecycle enforcement aligned to NIST AC-2.

- Developed automation to identify stale Entra ID accounts using sign-in telemetry, incorporating risk classification, service account detection, and exclusion controls aligned to AC-2 and AC-2(3).

- Built PIM analysis automation identifying permanent privileged access, role aggregation risk, and eligibility duration — producing audit-ready evidence aligned to AC-6(5) and IA-2.

- Designed Conditional Access analysis automation detecting MFA enforcement gaps, policy strength classification, and privileged scope coverage — supporting Zero Trust validation aligned to AC-3 and IA-2.

## Supporting Bullets (Resume — Pick 2–3)

- Mapped automation outputs to NIST 800-53 AC-2, AC-3, AC-6, IA-2, and CA-7 producing structured evidence packages for direct CMMC Level 2 SSP inclusion.

- Designed scripts following enterprise engineering standards including read-only defaults, WhatIf support, dual CSV/JSON output, risk-prioritized sorting, and safe failure handling.

- Translated IAM control objectives into repeatable automation workflows across preventative, detective, and corrective control layers — establishing a complete identity governance control system.

## LinkedIn Experience Bullets

- Developed PowerShell automation suite for Microsoft Entra ID supporting access governance, privileged access analysis (PIM), Conditional Access evaluation, and lifecycle enforcement

- Automated audit-ready evidence generation for access reviews, stale account detection, privileged role analysis, and policy validation aligned to NIST 800-53 and CMMC Level 2

- Implemented controlled leaver workflow automation with WhatIf simulation, guardrails, validation, and audit logging for lifecycle enforcement

- Translated IAM governance requirements into repeatable, auditable automation workflows across the full identity lifecycle

---


## LinkedIn Featured Section Recommendations

If using GitHub portfolio as a LinkedIn Featured item:
1. Pin the root repo (`iam-proof-portfolio`)
2. Pin the JML Lifecycle pack README directly (strongest single pack for IGA interviews)
3. Pin the Automation Scripts pack (proves you code, not just talk)

## Cover Letter Reference Paragraph

> *"In addition to the experience detailed above, I maintain a public six-pack IAM governance portfolio at github.com/RobertMyersCloud/iam-proof-portfolio — demonstrating my end-to-end approach to identity lifecycle, privileged access, and CMMC-aligned evidence production. Each pack includes the policy documents, control mappings, and implementation evidence that a CMMC Level 2 assessor expects."*

---

*Last updated: April 2026*
*[← Back to Portfolio Root](./)*
