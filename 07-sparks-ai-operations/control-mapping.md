# Control Mapping — Sparks AI Operations Platform

**NIST 800-53 Rev 5 and CMMC Level 2 control implementation evidence for application-layer IAM governance.**

---

## NIST 800-53 Rev 5 Controls

### AC-2 — Account Management
**Sparks Implementation:** smg_team table is the canonical team roster. Schema enforces member_code (PK), role_type (enum), status (enum: active/onboarding/terminated/suspended). Lifecycle tracked via start_date and end_date. Account creation via tool_team_manage(action='add') logs to sparks_audit_log.

### AC-3 — Access Enforcement
**Sparks Implementation:** Central TOOLS Python dict maps tool_name to callable function. Tool dispatch only via TOOLS.get(tool_name) — unknown tool names rejected. TOOL_DEFINITIONS list is the schema contract — validation checks zero orphans and zero ghosts on every deploy. Current state: Tools 203, Definitions 203, zero mismatches.

### AC-4 — Information Flow Enforcement
**Sparks Implementation:** Every financial table includes notary, entity, tax_year columns for row-level filtering. is_test boolean + partial indexes prevent test data from appearing in production reports. Cross-entity JOINs explicitly scoped.

### AC-6 — Least Privilege
**Sparks Implementation:** Tools grouped by prefix (notary_, study_, github_). Database user helm has limited scope. Each tool validates inputs before executing side effects. Planned: TOOLS_PUBLIC vs TOOLS_ADMIN split.

### AU-2 — Audit Events
**Sparks Implementation:** sparks_audit_log captures every tool invocation. Columns: id, tool_name, args_hash, result_status, error_type, duration_ms, pre_state_hash, post_state_hash, created_at, user_context. Audit log is INSERT-only per PostgreSQL role permissions.

### AU-9 — Protection of Audit Information
**Sparks Implementation:** sparks_audit_log has no UPDATE or DELETE grants for the helm role. Only PostgreSQL superuser can modify audit history. SHA-256 hash chain planned for full tamper evidence.

### CA-7 — Continuous Monitoring
**Sparks Implementation:** Nightly cron runs tool_audit_summary(hours=24). Weekly run produces tool_phase_status() snapshot. Wazuh SIEM on both hosts. Money Wall + War Room dashboards provide real-time visibility.

### IA-2 — Identification and Authentication
**Sparks Implementation:** 3-factor chain: YubiKey hardware WebAuthn, Cloudflare Access verification, Authentik SSO session. No username/password paths to Sparks.

### SI-4 — System Monitoring
**Sparks Implementation:** Wazuh SIEM on smg-dell + smg-victus. FIM on 5,421 files. Custom detection rules: brute force, privilege escalation, suspicious scripts. 5 IR playbooks documented.

---

## CMMC Level 2 Practice Mapping

| NIST | CMMC L2 | Domain |
|---|---|---|
| AC-2 | AC.L2-3.1.1, AC.L2-3.1.2 | Access Control |
| AC-3 | AC.L2-3.1.2 | Access Control |
| AC-4 | AC.L2-3.1.3 | Access Control |
| AC-6 | AC.L2-3.1.5 | Access Control |
| AU-2 | AU.L2-3.3.1, AU.L2-3.3.2 | Audit & Accountability |
| AU-9 | AU.L2-3.3.8 | Audit & Accountability |
| CA-7 | CA.L2-3.12.3 | Security Assessment |
| IA-2 | IA.L2-3.5.1, IA.L2-3.5.2 | Identification & Auth |
| SI-4 | SI.L2-3.14.3, SI.L2-3.14.6 | System & Info Integrity |

---

*[Back to Pack 07 README](./README.md)*

---

## Related framework alignment

The NIST 800-53 controls mapped above correspond directly to the following additional frameworks. This pack's controls satisfy equivalent requirements in each:

- **NIST 800-53 (Rev. 5)** — federal baseline; Access Control (AC) and Identification and Authentication (IA) families covered by the mappings above
- **NIST SP 800-171 (Rev. 3)** — DFARS 252.204-7012 / CMMC Level 2 baseline; 3.1.x (Access Control) and 3.5.x (Identification and Authentication) families applicable

> **Note on scope:** This appendix identifies cross-framework applicability. Specific control-ID crosswalks to 800-171 and SOC 2 CC6/CC7 are on the roadmap for a future Evidence Production pack that consolidates cross-framework traceability.
