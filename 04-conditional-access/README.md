# Conditional Access Pack

Zero Trust access policy demonstration using Microsoft Entra ID Conditional Access to support MFA enforcement, location-based access controls, policy evaluation, and centralized identity governance aligned to NIST 800-53 and CMMC Level 2. :contentReference[oaicite:0]{index=0}

This pack demonstrates practical Conditional Access governance workflows including MFA enforcement, named location configuration, geographic access restriction, report-only deployment strategy, and policy validation within regulated environments.

---

# Scenario

A regulated organization requires centralized identity-based access enforcement that evaluates authentication requests dynamically rather than relying on perimeter-based trust.

Access decisions must consider:
- user identity
- geographic location
- authentication strength
- policy scope
- access conditions

The organization requires:
- MFA enforcement across cloud applications
- geographic access restrictions
- centralized access governance
- staged policy deployment using change management practices
- auditability and policy evaluation validation

---

# What Was Built

| Component | Implementation |
|---|---|
| MFA policy | CA-POL-001 — Require MFA — All Users |
| Location policy | CA-POL-002 — Block Non-US Sign-ins |
| Named location | Trusted United States geographic location definition |
| Policy deployment model | Report-only deployment for staged validation and impact assessment |
| Policy evaluation | What If evaluation tool used to validate MFA enforcement behavior |

---

# Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Policies scoped broadly across user population |
| AC-3 | Access Enforcement | Access evaluated through Conditional Access policy engine |
| AC-17 | Remote Access | Geographic access restrictions applied through named locations |
| IA-2 | Identification & Authentication | MFA required for cloud application access |
| IA-2(1) | Privileged Network Access | MFA enforced across authentication workflows |
| IA-2(11) | Remote Access — Separate Device | Geographic restrictions applied to remote access conditions |
| SI-4 | System Monitoring | Report-only deployment supports policy monitoring and impact analysis |

---

# Risk Mitigation Summary

| Risk Condition | Mitigation |
|---|---|
| Password-only authentication | MFA enforcement required for cloud application access |
| Unauthorized geographic access | Non-trusted locations blocked through Conditional Access policies |
| Implicit trust based on network location | Access evaluated dynamically at authentication time |
| Policy deployment disruption | Report-only mode used for staged validation before enforcement |
| Misconfigured access controls | What If evaluation validates policy logic before rollout |

---

# Outcome

- Established MFA enforcement baseline across cloud applications
- Implemented location-based access restrictions for non-trusted regions
- Configured named trusted geographic location definitions
- Applied report-only deployment strategy to support change management and impact assessment
- Validated Conditional Access behavior through What If policy evaluation testing

---

# Evidence Index

| File | What It Shows | Control |
|---|---|---|
| CA-STEP-01-mfa-policy-config.png | MFA policy configured and deployed in report-only mode | AC-3, IA-2 |
| CA-STEP-02-mfa-policy-detail.png | MFA policy scoped to users and cloud applications | IA-2, IA-2(1) |
| CA-STEP-03-named-location.png | Trusted geographic location definition | AC-17, IA-2(11) |
| CA-STEP-04-block-policy.png | Non-US access restriction policy configuration | AC-17, AC-3 |
| CA-STEP-05-policies-complete.png | Conditional Access policies deployed and active | AC-3, IA-2 |
| CA-STEP-06-what-if-results.png | What If evaluation validating MFA enforcement logic | IA-2, SI-4 |

---

# Control Chain Summary

| Step | Action | Controls Supported |
|---|---|---|
| 1 | Trusted geographic location configured | AC-17, IA-2(11) |
| 2 | MFA policy created for cloud application access | IA-2, IA-2(1) |
| 3 | Geographic access restriction policy configured | AC-17, AC-3 |
| 4 | Policies deployed in report-only mode for validation | SI-4 |
| 5 | What If evaluation confirms policy enforcement logic | IA-2, AC-3 |

---

# Emergency Access Controls

Break-glass emergency accounts are excluded from standard Conditional Access enforcement to reduce tenant lockout risk.

Emergency access governance includes:
- dedicated break-glass accounts
- restricted use procedures
- long randomized credentials
- monitoring and alerting
- post-use review requirements

Break-glass accounts are governed separately under emergency access procedures.

---

# Planned Enhancements

| Planned Control | Description |
|---|---|
| Sign-in risk enforcement | Identity Protection-based MFA escalation for risky sign-ins |
| Device compliance enforcement | Require compliant or hybrid-joined devices |
| Continuous Access Evaluation | Real-time session revocation on risk changes |
| Privileged access Conditional Access | Enhanced restrictions for administrative accounts |

---

# Operational Lifecycle

- Policy impact reviewed through Microsoft Entra sign-in logs
- Report-only mode used before enforcement rollout
- Quarterly policy reviews performed to validate effectiveness
- Blocked sign-ins and policy outcomes monitored for tuning opportunities
- Policy changes follow staged change management practices

---

# Design Considerations & Limitations

| Consideration | Detail |
|---|---|
| VPN and proxy usage | Geographic restrictions may be bypassed through external routing services |
| Travel scenarios | Geographic blocking may require exception handling for legitimate travel |
| Legacy authentication | Conditional Access may not fully protect legacy authentication protocols |
| MFA fatigue | Push fatigue risks require additional phishing-resistant controls |
| Continuous tuning | Policies require operational tuning to balance security and usability |

---

# Assessment Narrative

This Conditional Access implementation establishes a centralized identity enforcement plane where access decisions are evaluated dynamically using identity, location, and authentication conditions.

The design supports Zero Trust concepts by removing implicit trust and enforcing verification during authentication events.

MFA policies and geographic access restrictions are deployed using staged report-only validation prior to enforcement activation. Policy logic is validated using What If evaluation testing before rollout.

Evidence demonstrates:
- Conditional Access policy configuration
- named location governance
- policy deployment state
- policy evaluation validation
- centralized access enforcement concepts

This workflow supports identity governance, MFA enforcement, remote access governance, and regulated-environment access control objectives.

---

# Pack Contents

| File | Description |
|---|---|
| CA-Policy.md | Conditional Access governance policy including enforcement model and deployment practices |
| control-mapping.md | NIST 800-53 and CMMC Level 2 control mapping with evidence linkage |
| resume-bullets.md | Resume-ready Conditional Access and Zero Trust governance bullet points |
| interview-questions.md | IAM and Conditional Access interview questions supported by this implementation |
| evidence/ | Microsoft Entra ID Conditional Access screenshots and evidence artifacts |

---

# Interview Value

This pack demonstrates practical approaches to:

- Zero Trust access governance
- MFA enforcement across cloud applications
- Conditional Access policy configuration
- Geographic access restriction using named locations
- Report-only deployment and staged rollout practices
- Policy validation using What If evaluation workflows
- Governance alignment to NIST 800-53 and CMMC Level 2 requirements

This directly supports IAM, Conditional Access, Zero Trust, access governance, identity security, and compliance-focused interview discussions.

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

- Microsoft Entra ID Conditional Access
- rjmyers.cloud tenant
- Pack version: v1.0 — March 2026

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
