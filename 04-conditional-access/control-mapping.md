# Control Mapping — Conditional Access Pack

This mapping demonstrates how the Conditional Access implementation within Microsoft Entra ID aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct evidence linkage to policy configuration, policy evaluation workflows, and operational governance artifacts. :contentReference[oaicite:0]{index=0}

---

# NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Conditional Access policies broadly scoped across workforce identities with documented emergency access exclusions | CA-STEP-01, CA-STEP-05 |
| AC-3 | Access Control | Access Enforcement | Authentication requests evaluated dynamically through Conditional Access policy engine | CA-STEP-02, CA-STEP-06 |
| AC-17 | Access Control | Remote Access | Geographic access restrictions applied using named locations and location-based policies | CA-STEP-03, CA-STEP-04 |
| AC-17(2) | Access Control | Protection of Confidentiality and Integrity | MFA enforced for remote access authentication workflows | CA-STEP-02 |
| IA-2 | Identification & Authentication | Identification and Authentication | MFA enforced for all cloud application sign-ins | CA-STEP-02, CA-STEP-06 |
| IA-2(1) | Identification & Authentication | Network Access to Privileged Accounts | MFA enforced across authentication pathways and cloud application access | CA-STEP-02 |
| IA-2(11) | Identification & Authentication | Remote Access — Separate Device | Geographic enforcement supports remote access governance controls | CA-STEP-03, CA-STEP-04 |
| IA-2(12) | Identification & Authentication | Acceptance of PIV Credentials | MFA enforcement framework supports phishing-resistant authentication expansion | CA-STEP-02 |
| SI-4 | System & Information Integrity | System Monitoring | Report-only mode captures policy evaluation and sign-in impact data for operational monitoring | CA-STEP-06 |

---

# CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | Conditional Access policies evaluate all authentication requests |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions and functions | Geographic restrictions applied to authentication workflows |
| AC.L2-3.1.14 | Access Control | Route remote access via managed access control points | Conditional Access functions as centralized identity enforcement plane |
| AC.L2-3.1.20 | Access Control | Verify and control connections to external systems | Location-based access governance applied to remote authentication attempts |
| IA.L2-3.5.3 | Identification & Authentication | Use multifactor authentication | MFA required for all cloud application sign-ins |
| IA.L2-3.5.4 | Identification & Authentication | Employ replay-resistant authentication | MFA reduces credential replay exposure |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain system audit logs | Sign-in logs capture Conditional Access policy evaluation activity |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit log actions are traceable | Authentication events attributable to named user identities and timestamps |

---

# Evidence Reference

| Evidence File | Controls Supported |
|---|---|
| CA-STEP-01-mfa-policy-config.png | MFA policy deployment and policy state visibility — AC-2, AC-3, IA-2 |
| CA-STEP-02-mfa-policy-detail.png | MFA policy scope and grant control configuration — IA-2, IA-2(1), AC-3 |
| CA-STEP-03-named-location.png | Trusted geographic location definition — AC-17, IA-2(11) |
| CA-STEP-04-block-policy.png | Geographic access restriction policy configuration — AC-17, AC-17(2), AC-3 |
| CA-STEP-05-policies-complete.png | Multiple Conditional Access policies active within environment — AC-2, AC-3, IA-2 |
| CA-STEP-06-what-if-results.png | What If evaluation validating MFA policy application logic — IA-2, AC-3, SI-4 |

---

# Control Chain Summary

| Step | Action | Controls Supported |
|---|---|---|
| 1 | Trusted geographic location configured | AC-17, IA-2(11) |
| 2 | MFA policy created for all users and cloud applications | IA-2, IA-2(1), AC-3 |
| 3 | Geographic restriction policy configured | AC-17, AC-17(2) |
| 4 | Policies deployed in report-only mode for validation | SI-4 |
| 5 | What If evaluation confirms MFA enforcement logic | IA-2, AC-3, SI-4 |

---

# Assessment Narrative

This Conditional Access implementation establishes centralized identity-based access enforcement where authentication requests are evaluated dynamically using identity, location, and authentication strength conditions.

The design supports Zero Trust governance principles by removing implicit trust and requiring verification during authentication workflows.

Baseline policies enforce:
- MFA across cloud applications
- geographic access restrictions
- centralized identity enforcement

Policies are initially deployed in report-only mode following staged change management practices. What If evaluation testing validates policy logic before enforcement activation.

Evidence demonstrates:
- Conditional Access policy configuration
- named location governance
- report-only deployment practices
- policy evaluation validation
- centralized authentication enforcement concepts

This workflow supports identity governance, MFA enforcement, remote access governance, and regulated-environment access control objectives.

---

# Control Effectiveness Statement

The implementation demonstrates that:
- authentication requests are evaluated through Conditional Access policy logic
- MFA enforcement applies across cloud application access
- geographic restrictions are evaluated dynamically during authentication
- report-only deployment enables staged validation prior to enforcement
- sign-in logs provide traceable policy evaluation records

The What If evaluation confirms policy application logic functions as designed and supports operational validation prior to enforcement rollout.

---

# Control Testing Methodology

## Design Validation

- Review Conditional Access configuration against governance requirements
- Validate user and application scope assignments
- Verify named location configuration and policy references
- Confirm break-glass exclusions are maintained

---

## Operational Testing

- Execute What If evaluation scenarios across multiple access conditions
- Validate MFA enforcement logic
- Confirm geographic restriction policy behavior
- Review report-only evaluation results before enforcement transition

---

## Evidence Review

- Analyze sign-in logs for policy evaluation outcomes
- Confirm policy impact aligns with intended behavior
- Validate authentication events include policy evaluation details
- Verify policy state and deployment configuration

---

## Negative Testing

- Simulate authentication attempts from non-trusted locations
- Simulate password-only authentication scenarios
- Validate expected MFA or block behavior
- Confirm break-glass exclusions function appropriately

---

## Continuous Monitoring

- Review sign-in logs for anomalies and unexpected policy behavior
- Monitor MFA failure trends and blocked authentication attempts
- Tune policies based on operational observations and threat conditions
- Perform quarterly review of Conditional Access governance effectiveness

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
- CISA Zero Trust Maturity Model — centralized identity enforcement and continuous verification principles

---

# Scope Note

This appendix demonstrates Conditional Access governance workflows within a controlled IAM lab environment.

Expanded cross-framework mappings and consolidated evidence traceability are planned for future governance and evidence-production packs.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
