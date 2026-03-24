# Conditional Access Policy

**Document ID:** SMG-IAM-POL-004
**Version:** 1.0
**Date:** 2026-03-24
**Owner:** Robert J. Myers

---

## Executive Summary

This policy establishes identity as the primary security control plane, replacing network-based trust with continuous authentication and authorization enforcement.

It defines the Conditional Access framework for Microsoft Entra ID, establishing a centralized identity enforcement plane where all access decisions are evaluated dynamically based on identity, location, device state, and risk signals. It eliminates implicit trust by requiring verification at every authentication event regardless of network location.

The implementation enforces MFA for all users across all cloud applications, blocks access from untrusted geographic regions, and establishes the operational framework for ongoing policy management, monitoring, and tuning.

---

## Control Objective

Ensure that all access to cloud resources is evaluated against defined policy conditions at authentication time, with access granted only when identity verification requirements are satisfied and no high-risk signals are present.

This control supports Zero Trust architecture by eliminating perimeter-based implicit trust and enforcing continuous verification of identity, location, and authentication strength.

---

## 1. Purpose

This policy establishes the Conditional Access framework for Microsoft Entra ID. It ensures:

- All cloud resource access is controlled through policy evaluation at authentication time
- MFA is enforced for all users on all cloud applications without exception
- Geographic access controls restrict sign-ins from untrusted locations
- Policies are deployed and managed using professional change management practices
- Break-glass accounts are protected from policy lockout
- Sign-in activity is monitored and policies are tuned on an ongoing basis

---

## 2. Scope

| Scope Item | Detail |
|---|---|
| Users in scope | All workforce identities with Entra ID accounts |
| Applications in scope | All cloud applications integrated with Entra ID |
| Enforcement model | Policy evaluation at every authentication event |
| Exclusions | Break-glass emergency accounts (managed under separate procedure) |
| Non-interactive auth | Service principals and legacy protocols managed under separate policy |

---

## 3. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| IAM Engineer | Policy configuration, deployment, and change management |
| Security Lead | Policy approval, risk acceptance, and enforcement decisions |
| Compliance | Control validation, audit alignment, and evidence review |
| Operations | Monitoring, incident response, and policy tuning |

---

## 4. Policy Framework

| Policy ID | Policy Name | Scope | Control | State |
|---|---|---|---|---|
| CA-POL-001 | Require MFA — All Users | All users, all cloud apps | Require MFA | Report-only → On |
| CA-POL-002 | Block Non-US Sign-ins | All users, all cloud apps | Block access | Report-only → On |

**Deployment model:** All policies deployed in Report-only mode initially. Impact assessed via sign-in logs before transitioning to enforcement mode. Changes follow change management process with Security Lead approval.

---

## 5. Named Locations

| Location Name | Type | Definition | Usage |
|---|---|---|---|
| Trusted — United States | Countries (IP) | United States | Excluded from block policy — trusted geography |

---

## 6. MFA Enforcement Policy — CA-POL-001

**Objective:** Require multi-factor authentication for all user sign-ins to all cloud applications.

**Configuration:**
- Users: All users (break-glass accounts excluded)
- Target resources: All cloud apps
- Grant control: Require multifactor authentication
- Session controls: None (baseline policy)
- State: Report-only → On

**Risk addressed:**
- Eliminates password-only authentication path
- Reduces credential stuffing and password spray attack surface
- Enforces identity verification regardless of network location or device

---

## 7. Location-Based Access Policy — CA-POL-002

**Objective:** Block access attempts originating from outside the defined trusted geographic region.

**Configuration:**
- Users: All users
- Target resources: All cloud apps
- Conditions: Any location, excluding Trusted — United States
- Grant control: Block access
- State: Report-only → On

**Risk addressed:**
- Reduces exposure to access attempts from high-risk geographic regions
- Provides coarse geographic control as a layered defense signal

**Known limitations:**
- Location controls rely on IP intelligence and may be bypassed via VPN or proxy
- May introduce friction for legitimate users traveling internationally
- Not relied upon as a primary control — layered with MFA enforcement

---

## 8. Break-Glass Account Handling

Break-glass emergency accounts must be explicitly excluded from Conditional Access policies:

- Exclusion prevents tenant lockout during policy misconfiguration or MFA service outage
- Break-glass accounts protected with long randomized credentials and no MFA dependency
- Any sign-in from break-glass accounts triggers immediate alert and post-incident review
- Break-glass usage restricted to tenant lockout recovery and emergency policy remediation
- Documented and reviewed under separate break-glass account procedure

---

## 9. Control Dependencies

Conditional Access effectiveness depends on the following integrations:

| Dependency | Purpose | Status |
|---|---|---|
| Entra ID P1/P2 licensing | Required for Conditional Access and Identity Protection | Active |
| Identity Protection | Risk signals for sign-in and user risk-based policies | Planned |
| Intune | Device compliance signals for device-based policies | Planned |
| PIM | Privileged access governance integration | Active |
| CAE-capable apps | Continuous Access Evaluation for real-time session revocation | Planned |

---

## 10. Enforcement Controls

- All policies deployed in Report-only before transitioning to enforcement mode
- Impact analysis performed using sign-in logs and What If tool before enabling
- Policy changes require Security Lead approval and impact documentation
- Break-glass accounts excluded from all Conditional Access policies
- Emergency rollback procedure documented for each policy

---

## 11. Advanced Controls — Planned Extension

| Control | Description | Dependency |
|---|---|---|
| Sign-in risk-based MFA | Step-up MFA for risky sign-ins via Identity Protection | Entra ID P2 |
| Device compliance enforcement | Require compliant or hybrid joined device | Intune |
| Continuous Access Evaluation | Real-time session revocation on risk signal | CAE-capable apps |
| Admin-specific policies | Stricter controls for privileged accounts | PIM integration |
| Phishing-resistant MFA | FIDO2 / Windows Hello for high-risk roles | Hardware keys |

---

## 12. Logging and Monitoring

| Log Event | Implementation |
|---|---|
| Sign-in events | All sign-ins logged with policy evaluation results |
| Policy impact | Report-only mode captures would-be enforcement results |
| Failed sign-ins | Monitored for attack or misconfiguration patterns |
| Block events | Logged when location policy would block access |
| Retention | Minimum 90-day retention within Entra ID |

---

## 13. Failure and Recovery Scenarios

| Scenario | Response |
|---|---|
| MFA service outage | Break-glass access invoked — documented procedure executed |
| Misconfigured policy causing lockout | Rollback procedure executed — policy disabled via break-glass |
| False positive blocks for legitimate users | Policy tuning via Report-only log analysis |
| Identity compromise detected | Step-up MFA enforcement or session revocation via CAE |
| Geo-block affecting traveling user | Temporary named location exclusion with documented approval |

---

## 14. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Policies scoped to all user accounts — no exceptions outside break-glass |
| AC-3 | Access Enforcement | All access enforced through policy evaluation at authentication time |
| AC-17 | Remote Access | Location-based policy controls remote access from untrusted regions |
| IA-2 | Identification & Authentication | MFA required for all cloud app sign-ins |
| IA-2(1) | Network Access to Privileged Accounts | MFA enforced across all access paths |
| IA-2(11) | Remote Access — Separate Device | Location enforcement addresses remote access risk |
| SI-4 | System Monitoring | Sign-in logs and Report-only mode provide continuous monitoring |

---

## 15. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Password-only authentication | MFA policy eliminates single-factor access path |
| Credential stuffing / spray attacks | MFA requirement invalidates stolen credentials alone |
| Unauthorized access from untrusted regions | Location block policy restricts non-US sign-ins |
| Tenant lockout from policy misconfiguration | Break-glass account exclusions prevent lockout |
| Undetected policy impact before enforcement | Report-only deployment enables impact analysis |

---

## 16. Design Considerations & Limitations

- Location-based controls rely on IP intelligence and may be bypassed via VPN or proxy services
- Geo-blocking may introduce user friction for legitimate travel scenarios
- Conditional Access does not protect non-interactive authentication — service principals and legacy protocols require separate controls
- MFA fatigue and push fatigue risks must be mitigated through number matching or phishing-resistant authentication methods
- Policies must be continuously tuned to balance security enforcement with user productivity
- Report-only mode does not enforce — transition to On requires deliberate change management action

---

## 17. Control Validation

Control effectiveness is validated through:

- Sign-in log review confirming policy evaluation results are captured
- What If tool evaluation confirming policy applies to target scenarios
- Regular review of Report-only impact data before enforcement transition
- Periodic policy review confirming break-glass exclusions are maintained
- Quarterly review of blocked and failed sign-in patterns

---

## 18. Assumptions

- Microsoft Entra ID P1 license minimum — required for Conditional Access
- All cloud application access is federated through Entra ID
- Break-glass accounts are documented and credentials are securely stored
- Named locations are reviewed and updated when organizational network changes occur

---

## 19. Evidence Requirements

Each policy deployment must produce:

- Policy configuration showing assignments, conditions, and grant controls
- Named location definitions
- What If evaluation results confirming policy logic
- Sign-in log evidence showing policy evaluation in Report-only mode
- Change management documentation for enforcement transition

---

## 20. Metrics and Governance

The following metrics are tracked:

- Sign-ins evaluated by CA policy (Report-only impact volume)
- MFA success and failure rates
- Location block events (would-be blocks in Report-only)
- Break-glass account sign-in events (should be zero in normal operations)
- Policy review completion rate (quarterly)

Metrics reviewed quarterly by IAM and Security leadership.

---

## 21. Prohibited Conditions

The following are explicitly prohibited:

- Disabling Conditional Access policies without documented Security Lead approval
- Creating policies without break-glass account exclusions
- Enabling enforcement mode without Report-only impact analysis
- Granting permanent policy exclusions without documented business justification
- Removing MFA requirements from any user population without security review

---

## 22. Review and Maintenance

- Policy reviewed annually or upon major system or organizational changes
- Named locations reviewed when network topology changes
- Version history maintained in GitHub repository
- Next scheduled review: March 2027

---

## 23. Assessment Narrative

This implementation establishes a centralized identity enforcement plane where all access decisions are evaluated dynamically based on identity, location, and authentication strength. The design eliminates implicit trust and enforces verification at every authentication event.

Two baseline policies enforce MFA for all users and block access from untrusted geographic regions. Policies are deployed in Report-only mode following professional change management practice. Break-glass accounts are excluded to prevent tenant lockout. Control dependencies, failure scenarios, and design limitations are explicitly documented.

Evidence demonstrates policy configuration, named location definition, What If evaluation results, and operational monitoring capability — establishing a defensible Conditional Access implementation aligned to NIST 800-53 and CMMC Level 2 requirements.

---

*SMG-IAM-POL-004 · Conditional Access Policy · v1.0 · 2026-03-24 · Internal*
