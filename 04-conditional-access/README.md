# Conditional Access Pack

**Zero Trust access policy implementation demonstrating MFA enforcement, location-based access control, named location configuration, and policy evaluation evidence in Microsoft Entra ID Conditional Access.**

Conditional Access policy implementation in Microsoft Entra ID, establishing a centralized identity enforcement plane where all access decisions are evaluated dynamically based on identity, location, and authentication strength.

## Scenario

A regulated organization needs to enforce access controls that go beyond perimeter-based security. Every sign-in must be evaluated against defined conditions — user identity, location, device, and risk — before access is granted. Implicit trust is eliminated. MFA is required for all users on all cloud applications, and sign-ins from outside trusted locations are blocked. Policies are deployed using professional change management practices with impact assessment before enforcement.

## What Was Built

| Component | Implementation |
|---|---|
| **MFA policy** | CA-POL-001 — Require MFA — All Users — scoped to all users and all cloud apps |
| **Location policy** | CA-POL-002 — Block Non-US Sign-ins — blocks access from outside trusted location |
| **Named location** | Trusted — United States — Countries (IP) location definition |
| **Policy state** | Report-only — professional practice for initial deployment and impact assessment |
| **What If evaluation** | Policy evaluation tool confirms CA-POL-001 applies MFA requirement to test user sign-in |

## Controls Enforced

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Access policies scoped to all user accounts — no exceptions |
| AC-3 | Access Enforcement | All access decisions enforced through policy evaluation at every authentication event |
| AC-17 | Remote Access | Location-based policy controls access from outside trusted network |
| IA-2 | Identification & Authentication | MFA required for all cloud application sign-ins |
| IA-2(1) | Network Access to Privileged Accounts | MFA enforced across all access paths — browser and client apps |
| IA-2(11) | Remote Access — Separate Device | Location-based enforcement controls remote access risk |
| SI-4 | System Monitoring | Report-only mode captures sign-in data for policy impact analysis |

## Risk Mitigation Summary

- Eliminates password-only authentication across all cloud resources
- Reduces exposure to credential stuffing and password spray attacks
- Enforces identity verification at every authentication event regardless of network location
- Prevents unauthorized access from unmanaged geographic regions
- Establishes centralized policy enforcement point for all cloud access decisions

## Outcome

- Established MFA enforcement baseline for all users across all cloud applications
- Implemented location-based access control blocking non-US sign-ins
- Configured named trusted location defining authorized access geography
- Deployed policies in Report-only mode following professional change management practice
- Validated policy evaluation using What If tool — confirmed MFA requirement applies correctly

## Evidence Index

| File | What It Shows | Control |
|---|---|---|
| [CA-STEP-01-mfa-policy-config.png](./evidence/CA-STEP-01-mfa-policy-config.png) | Demonstrates policy list — CA-POL-001 active, Report-only, created 3/24/2026 | AC-3, IA-2 |
| [CA-STEP-02-mfa-policy-detail.png](./evidence/CA-STEP-02-mfa-policy-detail.png) | Demonstrates CA-POL-001 detail — All users, all resources, Grant: Require MFA, Report-only | IA-2, IA-2(1) |
| [CA-STEP-03-named-location.png](./evidence/CA-STEP-03-named-location.png) | Demonstrates named location — Trusted United States, Countries (IP) type | AC-17, IA-2(11) |
| [CA-STEP-04-block-policy.png](./evidence/CA-STEP-04-block-policy.png) | Demonstrates CA-POL-002 — Block Non-US Sign-ins — All users, all resources, Grant: Block | AC-17, AC-3 |
| [CA-STEP-05-policies-complete.png](./evidence/CA-STEP-05-policies-complete.png) | Demonstrates both policies active — CA-POL-001 and CA-POL-002, Report-only | AC-3, IA-2 |
| [CA-STEP-06-what-if-results.png](./evidence/CA-STEP-06-what-if-results.png) | Demonstrates What If evaluation — CA-POL-001 applies Require MFA to test user scenario | IA-2, SI-4 |

## Control Chain Summary

| Step | Action | Control Satisfied |
|---|---|---|
| 1 | Named location defined — Trusted United States | AC-17, IA-2(11) |
| 2 | MFA policy created — all users, all cloud apps | IA-2, IA-2(1) |
| 3 | Location block policy created — non-US access blocked | AC-17, AC-3 |
| 4 | Policies deployed in Report-only — impact assessment before enforcement | SI-4 |
| 5 | What If evaluation confirms policy applies to target user scenario | IA-2, AC-3 |

## Emergency Access Controls

Break-glass emergency accounts require special handling in a Conditional Access deployment:

- Break-glass accounts excluded from Conditional Access policies to prevent tenant lockout
- Protected with long randomized passwords and no MFA dependency
- Sign-in activity monitored — any use triggers immediate alert and post-incident review
- Used only for tenant lockout recovery and policy misconfiguration remediation
- Documented under separate break-glass account procedure

## Advanced Controls — Planned Extension

| Control | Description |
|---|---|
| Sign-in risk-based MFA | Entra ID Identity Protection — enforce step-up MFA on risky sign-ins |
| Device compliance enforcement | Intune integration — require compliant or hybrid joined device |
| Continuous Access Evaluation | Session controls — revoke access in real time on risk signal |
| Admin-specific CA policies | Stricter policies for privileged accounts — shorter session limits |

## Operational Lifecycle

- Policy impact monitored via Entra sign-in logs in Report-only mode before enforcement
- Quarterly policy review aligned to NIST AC-2 account management requirements
- Regular review of failed sign-ins and blocked access attempts for tuning
- Policy changes follow change management process — impact assessment before enabling

## Design Considerations & Limitations

- Location-based controls rely on IP intelligence and may be bypassed via VPN or proxy services
- Geo-blocking may introduce user friction for legitimate travel scenarios
- Conditional Access does not protect non-interactive authentication (service principals, legacy protocols)
- MFA fatigue and push fatigue risks must be mitigated through number matching or phishing-resistant methods
- Policies must be continuously tuned to balance security enforcement with user productivity

## Assessment Narrative

This implementation establishes a centralized identity enforcement plane where all access decisions are evaluated dynamically based on identity, location, and authentication strength. The design eliminates implicit trust and enforces verification at every authentication event, aligning with Zero Trust architecture principles and CMMC Level 2 control requirements.

Two policies enforce baseline access controls — MFA for all users and location-based blocking for non-trusted regions. Policies are deployed in Report-only mode following professional change management practice, with What If evaluation confirming policy logic before enforcement is enabled.

Evidence demonstrates policy configuration, named location definition, and validated evaluation results — establishing a defensible Conditional Access implementation aligned to NIST 800-53 and CMMC Level 2 requirements.

## Pack Contents

| File | Description |
|---|---|
| `CA-Policy.md` | Conditional Access program policy — scope, policy framework, enforcement model |
| `control-mapping.md` | NIST 800-53 / CMMC Level 2 control mapping with evidence linkage |
| `resume-bullets.md` | Resume-ready bullet points tied to this implementation |
| `interview-questions.md` | Interview questions this pack answers with documented responses |
| `evidence/` | Entra ID Conditional Access screenshots — named and indexed above |

## Interview Value

This pack demonstrates the ability to:

- Design a Zero Trust access policy framework eliminating implicit trust
- Configure MFA enforcement across all users and cloud applications
- Implement location-based access controls using named locations
- Deploy policies using professional change management practices
- Validate policy behavior using the What If evaluation tool
- Articulate risk reduction outcomes and design tradeoffs at an architect level

---

*Pack version: v1.0 — March 2026 · Environment: Microsoft Entra ID — rjmyers.cloud tenant*
