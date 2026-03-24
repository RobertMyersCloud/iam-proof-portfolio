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
