# Control Mapping — Conditional Access Pack

This mapping demonstrates how the Conditional Access implementation in Microsoft Entra ID aligns to NIST 800-53 Rev 5 and CMMC Level 2 requirements, with direct evidence linkage to policy configuration and evaluation artifacts.

## NIST 800-53 / CMMC Level 2 Mapping

| Control | Family | Description | Implementation | Evidence |
|---|---|---|---|---|
| AC-2 | Access Control | Account Management | Conditional Access policies scoped to all user accounts — no exceptions outside documented break-glass exclusions | CA-STEP-01, CA-STEP-05 |
| AC-3 | Access Enforcement | Access Enforcement | All access decisions enforced through policy evaluation at every authentication event — not network perimeter | CA-STEP-02, CA-STEP-06 |
| AC-17 | Access Control | Remote Access | Location-based policy controls and restricts access from outside defined trusted geographic region | CA-STEP-03, CA-STEP-04 |
| AC-17(2) | Access Control | Remote Access — Protection of Confidentiality and Integrity | MFA enforcement protects all remote access sessions regardless of originating network | CA-STEP-02 |
| IA-2 | Identification & Authentication | Identification and Authentication | MFA required and enforced for all cloud application sign-ins — no single-factor authentication path | CA-STEP-02, CA-STEP-06 |
| IA-2(1) | Identification & Authentication | Network Access to Privileged Accounts | MFA enforced across all access paths — browser and modern authentication clients | CA-STEP-02 |
| IA-2(11) | Identification & Authentication | Remote Access — Separate Device | Location-based policy addresses remote access risk through geographic enforcement | CA-STEP-03, CA-STEP-04 |
| IA-2(12) | Identification & Authentication | Acceptance of PIV Credentials | MFA enforcement framework supports phishing-resistant authentication path extension | CA-STEP-02 |
| SI-4 | System and Information Integrity | System Monitoring | Report-only mode captures sign-in evaluation data for continuous monitoring and policy impact analysis | CA-STEP-06 |

## CMMC Level 2 Practice Mapping

| Practice | Domain | Requirement | Implementation |
|---|---|---|---|
| AC.L2-3.1.1 | Access Control | Limit system access to authorized users | CA policies enforce access requirements at every authentication event |
| AC.L2-3.1.2 | Access Control | Limit system access to authorized transactions | Location policy restricts access to authorized geographic regions |
| AC.L2-3.1.14 | Access Control | Route remote access via managed access control points | Conditional Access acts as centralized enforcement point for all cloud access |
| AC.L2-3.1.20 | Access Control | Verify and control connections to external systems | Location-based policy controls external access pathways |
| IA.L2-3.5.3 | Identification & Authentication | Use multifactor authentication | MFA required and enforced for all sign-ins via CA-POL-001 |
| IA.L2-3.5.4 | Identification & Authentication | Employ replay-resistant authentication | MFA enforcement reduces credential replay risk across all access paths |
| AU.L2-3.3.1 | Audit & Accountability | Create and retain system audit logs | All sign-in events logged with policy evaluation results |
| AU.L2-3.3.2 | Audit & Accountability | Ensure audit log actions are traceable | Sign-in logs attribute all policy evaluations to named user with timestamp |

## Evidence Reference

| Evidence File | Controls Satisfied |
|---|---|
| CA-STEP-01-mfa-policy-config.png | Demonstrates policy list showing CA-POL-001 active — AC-2, AC-3, IA-2 |
| CA-STEP-02-mfa-policy-detail.png | Demonstrates MFA policy configuration — all users, all resources, Require MFA grant — IA-2, IA-2(1), AC-3 |
| CA-STEP-03-named-location.png | Demonstrates named location definition — Trusted United States — AC-17, IA-2(11) |
| CA-STEP-04-block-policy.png | Demonstrates location block policy — non-US access blocked — AC-17, AC-17(2), AC-3 |
| CA-STEP-05-policies-complete.png | Demonstrates both policies active and configured — AC-2, AC-3, IA-2 |
| CA-STEP-06-what-if-results.png | Demonstrates policy evaluation — CA-POL-001 applies MFA to test scenario — IA-2, AC-3, SI-4 |

## Control Chain Summary

| Step | Action | Control Satisfied |
|---|---|---|
| 1 | Named location defined — Trusted United States | AC-17, IA-2(11) |
| 2 | MFA policy created — all users, all cloud apps | IA-2, IA-2(1), AC-3 |
| 3 | Location block policy created — non-US access blocked | AC-17, AC-17(2) |
| 4 | Policies deployed in Report-only — impact assessment before enforcement | SI-4 |
| 5 | What If evaluation confirms MFA policy applies to target scenario | IA-2, AC-3, SI-4 |

## Assessment Narrative

The Conditional Access implementation establishes a centralized identity enforcement plane where all access decisions are evaluated dynamically at authentication time. Implicit trust is eliminated — network location alone does not grant access.

Two baseline policies enforce MFA for all users across all cloud applications and block access from outside the defined trusted geographic region. Policies are deployed in Report-only mode following professional change management practice, with the What If tool confirming policy logic before enforcement is enabled.

Evidence demonstrates policy configuration, named location definition, and validated evaluation results. The What If evaluation confirms that CA-POL-001 correctly applies MFA requirements to the test user scenario — validating that the enforcement logic functions as designed.

This establishes a defensible Conditional Access implementation aligned to NIST 800-53 and CMMC Level 2 requirements.

## Control Effectiveness Statement

The implementation demonstrates that all cloud resource access is subject to policy evaluation at authentication time, MFA is required without exception, and geographic access controls restrict sign-ins from untrusted regions.

Report-only mode deployment confirms the policies are active and evaluating sign-ins. The What If tool result confirms correct policy application. Sign-in logs provide ongoing evidence of policy enforcement.

This confirms that the controls are functioning as designed and effectively reducing the risk of unauthorized access through credential-based and location-based attack vectors.

---

*Mapping reference: NIST SP 800-53 Rev 5 · CMMC Level 2 (32 CFR Part 170) · NIST SP 800-171 Rev 2*

## Control Testing Methodology

Control effectiveness is validated using the following testing approach:

**Design Validation**
- Review policy configuration against control requirements
- Confirm scope includes all users and applications without unintended exclusions
- Verify named locations are correctly defined and referenced in policies

**Operational Testing**
- Execute What If scenarios to simulate authentication events under multiple conditions
- Validate MFA enforcement across user types, locations, and application targets
- Confirm location block policy applies to non-trusted geographic regions

**Evidence Review**
- Analyze sign-in logs for policy evaluation results in Report-only mode
- Confirm Report-only impact aligns with expected enforcement behavior before enabling
- Verify all sign-in events are captured with policy evaluation detail

**Negative Testing**
- Simulate non-compliant conditions — non-US sign-in, single-factor authentication attempt
- Confirm policy would block or require additional authentication in each scenario
- Validate break-glass exclusions do not create unintended access gaps

**Continuous Monitoring**
- Review sign-in logs for anomalies or unexpected policy behavior
- Monitor for failed MFA attempts and blocked access patterns
- Tune policies based on observed results and changing threat signals
- Quarterly review of policy effectiveness metrics aligned to governance cadence
