# Interview Questions — Sparks AI Operations Platform (Pack 07)

**These questions probe application-layer governance thinking.**

---

## Q1: "Why did you build your own AI operations platform instead of using an existing agent framework?"

Two reasons. First, existing agent frameworks (LangChain, LlamaIndex, CrewAI) are optimized for developer experience, not for governance. None have native audit wrappers or anti-hallucination detection. Second, I had specific governance requirements: cross-entity data isolation between my sole-prop, my SMG LLC, and future Stella Maris Notary LLC. Building from scratch let me embed governance as a first-class design constraint.

---

## Q2: "How does your audit wrapper work, and what failure mode did it catch?"

Every tool function is wrapped by _audit_tool_execution() which takes a pre-execution state snapshot, runs the tool, takes a post-execution snapshot, and logs full context to sparks_audit_log.

The wrapper caught false success reporting on day one: AI claimed "invoice created, PDF generated, email sent" but the SMTP call had silently errored. Invoice row was committed, PDF generated, email never sent. Without the audit log I would have believed the AI. With it, tool_verify_last_action(count=5) shows actual execution results with timing and errors. Trust is verified against evidence, not assumed from narrative.

---

## Q3: "How do you enforce least privilege when an AI agent has access to 200+ tools?"

Right now the agent has scope to all tools — a known gap. My next iteration splits the TOOLS dict into TOOLS_PUBLIC (read-only) and TOOLS_ADMIN (mutating: payment logging, invoice creation, team changes). Default context is PUBLIC, elevated context required for ADMIN.

The parallel to traditional IAM is Pack 03 — PIM eligible assignment. JIT elevation with justification, auto-expiration.

---

## Q4: "Walk me through cross-entity isolation."

Every financial table has notary, entity, tax_year columns. Rows in notary_invoices are tagged with owning entity (sole_prop or LLC). Query patterns always filter by entity. When I form Stella Maris Notary LLC, existing sole-prop rows stay tagged as sole_prop. New rows tagged differently. Tax reports aggregate separately. No JOINs cross entity boundaries unintentionally.

Same pattern as tenant isolation in multi-tenant SaaS, but at row level. Maps to NIST AC-4.

---

## Q5: "What's different about AI governance vs. traditional IAM governance?"

Traditional IAM governance centers on human actors. AI governance has three additional attack surfaces:

First: false success reporting. AI models do this routinely due to token-probability architecture. Mitigation: audit wrapper with verification tools.

Second: prompt injection via data. Untrusted inputs can contain instructions redirecting agent behavior. Mitigation: input sanitization + output validation.

Third: action amplification. AI makes 200 decisions in seconds. Small misconfigurations blow up fast. Mitigation: rate limits + blast radius containment + transaction discipline.

Pack 07 addresses all three. Packs 01-06 address the human side.

---

## Q6: "If I asked you to scale this to 50 consultants, what changes?"

Three major changes.

First, TOOLS dict becomes role-scoped. Every tool has an authorization matrix — maps to Pack 02 access review patterns.

Second, audit log becomes granular. Today user_context is just "robert." In a 50-person environment, it's user_id + session_id + authentication_level + elevation_status at each tool call.

Third, entity isolation becomes tenant isolation — the Pack 04 Conditional Access model applied at application layer. Cross-client JOINs blocked structurally.

Same governance principles scale. What changes is granularity of enforcement and volume of audit evidence.

---

*[Back to Pack 07 README](./README.md)*
