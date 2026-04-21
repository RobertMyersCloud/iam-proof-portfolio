# SoD Matrix Evidence

Evidence artifacts for the Segregation of Duties pack.

Unlike packs that rely on Entra configuration screenshots, SoD evidence is primarily **analytical documentation** — conflict identification, risk classification, and mitigation modeling.

## Evidence Artifacts

| Artifact | Type | Purpose |
|----------|------|---------|
| `SoD-Matrix.md` (parent dir) | Matrix table | 15 role conflict pairs with risk tier + mitigation |
| `SoD-Policy.md` (parent dir) | Policy doc | Formal SoD governance framework |
| `control-mapping.md` (parent dir) | Compliance mapping | NIST 800-53 (AC-5, AC-6, AU-2, AU-9, CA-7) + CMMC L2 |
| `interview-questions.md` (parent dir) | Q&A | Common SoD interview scenarios with answers |
| `resume-bullets.md` (parent dir) | Outcome statements | 5 resume-ready bullets |

## Live Implementation Evidence

For organizations implementing this SoD framework, evidence artifacts generated during rollout would include:

1. **Role-Entitlement Inventory Export** — CSV showing all roles + assigned permissions
2. **SoD Conflict Detection Report** — automated scan output flagging live conflicts
3. **Exception Approval Records** — documented executive approvals with 90-day expiration
4. **Quarterly Access Review Integration** — cross-referenced with Pack 02 (Access Reviews) to detect SoD drift
5. **Provisioning Workflow Guardrail Logs** — evidence of SoD checks during new access requests

These artifacts are generated live during engagement execution. This pack provides the framework, not the tenant-specific evidence from any single client environment.

## Interview Talking Point

*"SoD evidence is different from configuration evidence. A hiring manager asking to see 'SoD screenshots' is asking the wrong question — the real artifact is the matrix, the classification model, the exception workflow, and the detection automation. I built all of those. They're in this pack."*

---

*Pack 05 — Segregation of Duties Matrix*
*[← Back to Portfolio Root](../../)*
