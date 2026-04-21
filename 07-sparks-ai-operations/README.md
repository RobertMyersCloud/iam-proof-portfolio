# Pack 07 — Sparks AI Operations Platform

**Zero-trust internal operating system demonstrating identity governance applied to AI tool execution at scale — with cryptographic audit trails, role-based tool access, and entity-level data isolation.**

An agentic AI operations platform powering a solo SDVOSB defense consultancy, with governance controls enforced at every layer: authentication, tool dispatch, data access, and cross-entity isolation.

---

## Scenario

A solo founder operating multiple businesses (defense consulting, notary agency, career track) needs an AI operating system that:
- Authenticates every request through hardware-bound identity (YubiKey + Cloudflare Access + Authentik SSO)
- Executes 200+ discrete tools with audit trail per invocation
- Isolates personal vs. business vs. consulting data at the row level
- Detects and blocks false-success responses from AI models (hallucinations claiming completed work that wasn't done)
- Produces audit evidence sufficient for SOC 2 + CMMC Level 2 review

This pack is the governance controls AND the platform implementation. Not theory — the system is operational.

---

## What Was Built

| Component | Implementation |
|---|---|
| **Authentication perimeter** | YubiKey hardware token + Cloudflare Access + Authentik SSO (3-factor chained) |
| **Trust layer (Phase 0)** | _audit_tool_execution() wrapper logs every tool call to sparks_audit_log table with pre/post state |
| **Anti-hallucination detector** | tool_verify_last_action() cross-checks claimed results against database state |
| **Entity isolation** | notary, entity, tax_year columns on every financial row enable row-level security |
| **Test data segregation** | is_test boolean column + partial index on every operational table |
| **Tool dispatch security** | Central TOOLS dict + TOOL_DEFINITIONS schema list — no orphans, no ghosts |
| **Secret management** | .env file + sparks_config table (hybrid) — never inline, never in git |
| **Hash-chain journal** | notary_journal uses SHA-256 chain per Texas notary law — tamper-evident |
| **Transaction discipline** | Per-statement commits on DDL, full rollback on DML errors, no partial writes |

---

## Controls Enforced

This pack enforces **cross-cutting controls** at the application layer that complement the platform-specific controls from Packs 01-06.

| Control | Description | Implementation in Sparks |
|---|---|---|
| AC-2 | Account Management | smg_team table with member_code PK, role_type, current_capacity_pct |
| AC-3 | Access Enforcement | Tool dispatch only via registered TOOLS dict; unknown tool names rejected |
| AC-6 | Least Privilege | Tools grouped by module; role-scoping planned via TOOLS_PUBLIC / TOOLS_ADMIN split |
| AU-2 | Audit Events | sparks_audit_log captures: timestamp, tool_name, args_hash, result_status, user_context |
| AU-9 | Protection of Audit Info | Audit log rows are INSERT-only via role permissions |
| CA-7 | Continuous Monitoring | Nightly cron runs tool_audit_summary() on 24-hour audit window |
| IA-2 | Identification & Auth | 3-factor chain: YubiKey + Cloudflare Access + Authentik SSO |
| SC-8 | Transmission Confidentiality | All traffic terminates at Cloudflare (TLS 1.3) |
| SC-28 | Protection of Info at Rest | PostgreSQL on encrypted volume |
| SI-4 | System Monitoring | Wazuh SIEM with 2 agents; FIM on 5,421 files; custom detection rules |

---

## What Makes This Different from Packs 01-06

Packs 01-06 demonstrate **platform-level IAM controls** — Entra ID, PIM, Conditional Access.

Pack 07 demonstrates **application-level IAM controls** — the same governance principles (JML, least privilege, audit, isolation) enforced inside a custom-built application rather than a vendor platform.

This is relevant for hiring managers evaluating candidates for:
- **IAM Architect roles** where the expectation is "design governance across platforms AND custom applications"
- **DevSecOps / Application Security** roles where the expectation is "embed identity governance into engineering practices"
- **CMMC / GRC consulting** where the expectation is "advise clients building custom systems, not just deploying vendor products"

---

## The Trust Layer — Detailed Design

Phase 0 of the Sparks build specifically addressed a governance problem AI models create: **false success reporting**.

Observed failure mode: AI claims "Invoice created, PDF generated, email sent" but reality shows the SMTP call errored silently. User believes work is complete.

Design response: Every tool function wrapped by _audit_tool_execution() which takes a pre-execution state snapshot, runs the tool, takes a post-execution snapshot, and logs full context to sparks_audit_log.

Verification pattern: Following any agent claim of completed work, tool_verify_last_action() queries the audit log and returns the last N tool executions with timing, success/error status. The AI cannot hide failures inside a summary.

---

## Outcome

- **200+ discrete tools** callable through a secure, audited API
- **Zero orphan/ghost tool mismatches** in TOOLS / TOOL_DEFINITIONS registries
- **Every financial operation** leaves a full audit trail
- **Cross-entity isolation** between sole-prop, LLC, and personal data
- **Hash-chain journal** meets Texas notary law tamper-evidence requirements
- **Transaction discipline** prevents partial-write corruption

---

## Stack

**Backend:** Python 3.14 · FastAPI · PostgreSQL 16 · psycopg2 · systemd
**Authentication:** Authentik SSO · Cloudflare Access · YubiKey WebAuthn
**AI:** Anthropic Claude · Mistral · Groq
**Observability:** Wazuh SIEM · File Integrity Monitoring · custom audit log
**Automation:** n8n workflows · systemd cron · Docker Compose

---

## Source

The Sparks platform source is not public. It contains business logic, API keys, and client-specific configurations.

This pack demonstrates the **governance architecture and design patterns** — which is what hiring managers evaluate.

Available under NDA for interviews: architecture diagrams, schema designs, selected code samples.

---

## Status

- **Version:** v1.0
- **Built:** April 2026 (single-founder sprint)
- **Operational:** Yes — running production for Stella Maris Governance LLC
- **Open-sourced:** No (application code proprietary; governance patterns documented here)

---

*Pack 07 — Sparks AI Operations Platform*
*[Back to Portfolio Root](../)*
