# Conditional Access Policy

**Document ID:** SMG-IAM-POL-004  
**Version:** 1.0  
**Date:** 2026-03-24  
**Owner:** Robert J. Myers  

---

# Executive Summary

This policy establishes identity as the primary security control plane, replacing perimeter-based trust with continuous authentication and authorization enforcement. :contentReference[oaicite:0]{index=0}

The policy defines the Conditional Access framework for Microsoft Entra ID, establishing centralized identity enforcement where access decisions are evaluated dynamically using:
- identity
- location
- authentication strength
- device state
- risk signals

The implementation supports Zero Trust access governance by enforcing verification at every authentication event regardless of network location.

Baseline controls include:
- MFA enforcement for all users
- geographic access restrictions
- report-only staged deployment
- centralized policy governance
- operational monitoring and tuning

---

# Control Objective

Ensure all cloud resource access is evaluated against defined Conditional Access policy requirements at authentication time, with access granted only when identity verification requirements are satisfied and no blocking conditions exist.

This control supports:
- Zero Trust access governance
- centralized identity enforcement
- remote access governance
- authentication strength enforcement
- continuous verification principles

---

# 1. Purpose

This policy establishes the Conditional Access governance framework for Microsoft Entra ID.

The policy ensures:
- All cloud resource access is evaluated through Conditional Access policy logic
- MFA is enforced across cloud applications
- Geographic access restrictions are centrally managed
- Policies follow staged deployment and change management practices
- Break-glass emergency access remains available during failure scenarios
- Sign-in activity and policy impact are continuously monitored

---

# 2. Scope

| Scope Item | Detail |
|---|---|
| Users in scope | Workforce identities authenticated through Microsoft Entra ID |
| Applications in scope | Cloud applications federated through Microsoft Entra ID |
| Enforcement model | Policy evaluation during authentication events |
| Exclusions | Break-glass emergency accounts governed separately |
| Non-interactive authentication | Service principals and legacy authentication governed under separate controls |

---

# 3. Roles and Responsibilities

| Role | Responsibility |
|---|---|
| IAM Engineer | Policy configuration, deployment, and lifecycle management |
| Security Lead | Approval of enforcement changes and risk acceptance |
| Compliance Team | Governance validation and evidence review |
| Operations Team | Monitoring, incident response, and policy tuning |

---

# 4. Policy Framework

| Policy ID | Policy Name | Scope | Control | State |
|---|---|---|---|---|
| CA-POL-001 | Require MFA — All Users | All users, all cloud apps | Require MFA | Report-only → On |
| CA-POL-002 | Block Non-US Sign-ins | All users, all cloud apps | Block access | Report-only → On |

---

## Deployment Model

All Conditional Access policies are deployed initially in report-only mode.

Impact assessment is performed using:
- sign-in logs
- What If evaluation testing
- policy impact review

Policies transition to enforcement mode only after validation and Security Lead approval.

---

# 5. Named Locations

| Location Name | Type | Definition | Usage |
|---|---|---|---|
| Trusted — United States | Countries (IP) | United States | Trusted geographic region excluded from block policy |

---

# 6. MFA Enforcement Policy — CA-POL-001

## Objective

Require MFA for all users accessing cloud applications through Microsoft Entra ID.

## Configuration

| Setting | Configuration |
|---|---|
| Users | All users (excluding break-glass accounts) |
| Applications | All cloud applications |
| Grant Control | Require multifactor authentication |
| Session Controls | None — baseline policy |
| Deployment State | Report-only → On |

---

## Risks Addressed

- Password-only authentication
- Credential stuffing attacks
- Password spray attacks
- Weak authentication pathways
- Authentication attempts without identity verification

---

# 7. Location-Based Access Policy — CA-POL-002

## Objective

Restrict authentication attempts originating from outside approved geographic regions.

## Configuration

| Setting | Configuration |
|---|---|
| Users | All users |
| Applications | All cloud applications |
| Conditions | Any location excluding Trusted — United States |
| Grant Control | Block access |
| Deployment State | Report-only → On |

---

## Risks Addressed

- Access attempts from untrusted regions
- Geographic attack surface exposure
- Unauthorized remote access attempts

---

## Known Limitations

- Geographic controls rely on IP intelligence
- VPN and proxy services may bypass geographic restrictions
- International travel scenarios may require temporary exception handling
- Geographic controls operate as layered security controls rather than primary authentication controls

---

# 8. Break-Glass Account Handling

Break-glass emergency accounts are excluded from Conditional Access enforcement to reduce tenant lockout risk during:
- MFA outages
- Conditional Access misconfiguration
- authentication service disruption

Break-glass governance includes:
- dedicated emergency accounts
- long randomized credentials
- restricted operational use
- monitoring and alerting
- post-use review procedures

Break-glass accounts are governed separately under emergency access procedures.

---

# 9. Control Dependencies

| Dependency | Purpose | Status |
|---|---|---|
| Microsoft Entra ID P1/P2 | Conditional Access and Identity Protection functionality | Active |
| Identity Protection | Risk-based authentication and sign-in risk policies | Planned |
| Intune | Device compliance evaluation | Planned |
| PIM | Privileged access governance integration | Active |
| Continuous Access Evaluation (CAE) | Real-time session revocation | Planned |

---

# 10. Enforcement Controls

- Policies deployed initially in report-only mode
- Sign-in logs reviewed before enforcement transition
- What If evaluation performed before rollout
- Security Lead approval required for enforcement changes
- Break-glass exclusions maintained for all policies
- Emergency rollback procedures documented

---

# 11. Planned Enhancements

| Planned Control | Description |
|---|---|
| Risk-based MFA | MFA escalation for risky sign-ins |
| Device compliance enforcement | Require compliant or hybrid-joined devices |
| Continuous Access Evaluation | Real-time session revocation |
| Privileged account Conditional Access | Enhanced restrictions for privileged accounts |
| Phishing-resistant MFA | FIDO2 and Windows Hello deployment |

---

# 12. Logging and Monitoring

| Event | Implementation |
|---|---|
| Sign-in events | All sign-ins logged with Conditional Access evaluation results |
| Report-only impact | Policy impact captured prior to enforcement |
| Failed sign-ins | Monitored for attack and misconfiguration indicators |
| Block events | Geographic block events logged and reviewed |
| Retention | Minimum 90-day log retention |

---

# 13. Failure and Recovery Scenarios

| Scenario | Response |
|---|---|
| MFA outage | Break-glass access procedure executed |
| Tenant lockout from misconfiguration | Policy rollback using emergency access procedure |
| False positive location blocks | Policy tuning through report-only analysis |
| Identity compromise detection | MFA escalation or session revocation |
| International travel exception | Temporary geographic exclusion with approval |

---

# 14. Control Mapping

| Control | Description | Implementation |
|---|---|---|
| AC-2 | Account Management | Policies broadly scoped across workforce identities |
| AC-3 | Access Enforcement | Access evaluated through Conditional Access policy engine |
| AC-17 | Remote Access | Geographic access restrictions applied through named locations |
| IA-2 | Identification & Authentication | MFA required for cloud application access |
| IA-2(1) | Privileged Network Access | MFA enforced across authentication workflows |
| IA-2(11) | Remote Access — Separate Device | Geographic restrictions applied to remote access conditions |
| SI-4 | System Monitoring | Report-only mode supports policy monitoring and tuning |

---

# 15. Risk Reduction Summary

| Risk Condition | Mitigation |
|---|---|
| Password-only authentication | MFA enforcement across cloud applications |
| Credential stuffing and spray attacks | MFA invalidates password-only compromise |
| Unauthorized geographic access | Geographic access restrictions through Conditional Access |
| Tenant lockout risk | Break-glass account exclusions |
| Policy deployment disruption | Report-only staged rollout and impact assessment |

---

# 16. Design Considerations & Limitations

- Geographic controls rely on IP intelligence and may be bypassed through VPN or proxy services
- International travel may require temporary exception handling
- Conditional Access does not fully protect legacy authentication or non-interactive authentication pathways
- MFA fatigue risks require phishing-resistant authentication enhancements
- Policies require continuous operational tuning to balance security and usability
- Report-only mode validates impact but does not enforce controls

---

# 17. Control Validation

Control effectiveness is validated through:
- sign-in log review
- What If policy evaluation testing
- report-only impact analysis
- blocked sign-in review
- quarterly policy review
- validation of break-glass exclusions

Evidence artifacts include:
- CA-STEP-01 through CA-STEP-06

---

# 18. Assumptions

- Microsoft Entra ID P1 licensing minimum is active
- Cloud applications federate authentication through Microsoft Entra ID
- Break-glass accounts are securely managed
- Named locations are reviewed periodically for accuracy

---

# 19. Evidence Requirements

Each policy deployment must produce:
- policy configuration evidence
- named location definitions
- What If evaluation results
- sign-in log evidence
- deployment and change management records

Evidence must remain accessible for governance and compliance activities.

---

# 20. Metrics and Governance

Tracked metrics include:
- sign-ins evaluated by Conditional Access
- MFA success and failure rates
- geographic block events
- break-glass account activity
- quarterly policy review completion

Metrics are reviewed quarterly by IAM and Security leadership.

---

# 21. Prohibited Conditions

The following are prohibited:
- disabling Conditional Access without approval
- deploying policies without break-glass exclusions
- enabling enforcement without report-only validation
- permanent policy exclusions without justification
- removing MFA requirements without security review

Violations require escalation and review.

---

# 22. Review and Maintenance

- Policy reviewed annually or after major organizational or technical changes
- Named locations reviewed when network topology changes
- Version history maintained within GitHub repository
- Next scheduled review: March 2027

---

# 23. Governance Principle

Access decisions are treated as dynamic identity governance events rather than perimeter-based trust decisions.

Authentication requests must be continuously evaluated using identity, authentication strength, location, and policy conditions before access is granted.

---

# 24. Assessment Narrative

This implementation establishes a centralized identity enforcement plane where authentication requests are evaluated dynamically using identity, location, and authentication strength conditions.

The design supports Zero Trust concepts by eliminating implicit trust and requiring verification during authentication events.

Baseline policies enforce:
- MFA across cloud applications
- geographic access restrictions
- centralized access governance workflows

Policies are deployed initially in report-only mode following staged change management practices. What If evaluation testing validates policy behavior before enforcement rollout.

Evidence demonstrates:
- Conditional Access policy configuration
- named location governance
- report-only deployment
- policy evaluation validation
- centralized identity enforcement concepts

This workflow supports identity governance, MFA enforcement, remote access governance, and regulated-environment access control objectives.

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*

**SMG-IAM-POL-004 · Conditional Access Policy · v1.0 · Internal**
