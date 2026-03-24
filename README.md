# IAM Proof Portfolio

Identity governance proof packs demonstrating audit-ready IAM controls in Microsoft Entra ID, focused on lifecycle management, least privilege, and Zero Trust for regulated environments.

## Flagship Pack — JML Lifecycle

End-to-end Joiner-Mover-Leaver identity lifecycle demonstrating:

- HR-triggered user provisioning with role-based group assignment
- Automated access adjustment on internal role change
- Immediate account disablement and session revocation on termination

**Controls:** AC-2 · AC-2(1) · AC-3 · AC-6 · IA-2 · AU-2

**Outcome:**
- Eliminated orphaned account risk through enforced deprovisioning
- Prevented privilege accumulation during role changes
- Enforced least privilege through group-based access control
- Established audit-ready identity lifecycle aligned to AC and IA control families

**→ [View JML Lifecycle Pack](./01-jml-lifecycle/README.md)**

## Pack Index

| Pack | Status | Domain |
|---|---|---|
| [01 — JML Lifecycle](./01-jml-lifecycle/README.md) | 🟢 Complete (v1 — policy + evidence) | Identity Lifecycle |
| [02 — Access Reviews](./02-access-reviews/README.md) | 🟢 Complete (v1 — policy + evidence) | Access Governance |
| [03 — Privileged Access](./03-privileged-access/README.md) | 🟢 Complete (v1 — policy + evidence) | PAM / Zero Trust |
| [04 — Conditional Access](./04-conditional-access/README.md) | 🟢 Complete (v1 — policy + evidence) | Zero Trust |
| [05 — SoD Matrix](./05-sod-matrix/README.md) | 🟢 Complete (v1 — policy + evidence) | GRC / Compliance |
| [06 — Automation Scripts](./06-automation-scripts/README.md) | 🟢 Complete (v1 — policy + evidence)  | Engineering |

## Standards

Every pack contains:
- Policy or design document
- Entra ID configuration evidence (screenshots)
- NIST 800-53 / CMMC Level 2 control mapping
- Resume-ready bullet points
- Interview question responses

Each pack is designed to answer real IAM interview scenarios and demonstrate practical implementation, not theoretical knowledge.

## Stack

Microsoft Entra ID · PIM · Conditional Access · PowerShell · Terraform · NIST 800-53 · CMMC Level 2
