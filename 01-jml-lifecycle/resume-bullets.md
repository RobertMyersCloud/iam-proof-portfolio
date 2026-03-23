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
