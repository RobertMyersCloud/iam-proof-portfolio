# Interview Questions — Access Reviews Pack

---

## "How do you ensure least privilege is maintained over time?"

Least privilege is not only established during onboarding — it must also be validated continuously over time.

This access review process uses Microsoft Entra ID Identity Governance to perform periodic certification of group-based access. Reviewers evaluate continued business need, document decisions with justification, and denied access is removed through configured enforcement settings.

The process includes:
- Independent reviewer assignment
- Automated recommendation support based on activity indicators
- Documented approval and denial decisions
- Enforcement of access removal
- Audit logging for all review actions

This approach helps ensure access remains aligned to business need while supporting auditability and governance traceability.

**Evidence:**  
- AR-STEP-01 through AR-STEP-06 :contentReference[oaicite:0]{index=0}

---

## "What is your access review process?"

The review process follows a structured governance workflow:

### 1. Campaign Creation
A review campaign is created within Microsoft Entra ID Identity Governance with:
- Defined target scope
- Assigned reviewer
- Review cadence
- Enforcement settings

### 2. Review Execution
The reviewer evaluates each user and records:
- Approve
- Deny
- Don't Know

Documented justification is required for denial decisions.

### 3. Enforcement
Denied access is removed automatically through configured auto-apply settings. If automated enforcement fails, manual remediation is required within defined operational timelines.

### 4. Evidence Capture
Microsoft Entra ID audit logs capture:
- Reviewer identity
- Decision timestamps
- Outcomes
- Enforcement actions

Evidence artifacts are retained to support governance and compliance activities.

**Evidence:**  
- AR-STEP-02 — active review workflow  
- AR-STEP-03 — documented reviewer decision  
- AR-STEP-05 — review results and enforcement  
- AR-STEP-06 — audit log correlation :contentReference[oaicite:1]{index=1}

---

## "How does this align to CMMC Level 2?"

This workflow supports several CMMC Level 2 access control and monitoring practices.

Examples include:
- AC.L2-3.1.1 — limiting access to authorized users
- AC.L2-3.1.2 — limiting access to authorized transactions and functions
- CA.L2-3.12.3 — ongoing monitoring of security controls
- AU.L2-3.3.2 — traceable audit records

Quarterly access certification provides ongoing validation that access remains appropriate and attributable to documented reviewer decisions.

The evidence package includes:
- Review configuration
- Reviewer decisions
- Access enforcement outcomes
- Audit log records
- Governance documentation

This structure demonstrates traceable access governance workflows aligned to regulated environments.

:contentReference[oaicite:2]{index=2}

---

## "How do you handle incomplete or overdue reviews?"

Incomplete reviews represent unvalidated access conditions and require escalation.

This workflow includes:
- Defined review due dates
- Escalation procedures for overdue reviews
- Reviewer accountability tracking
- Enforcement validation

For higher-risk environments, unreviewed access may require temporary suspension or additional validation before continued authorization.

The objective is to ensure access reviews remain an active governance control rather than a passive administrative task.

:contentReference[oaicite:3]{index=3}

---

## "What's the difference between an access review and a user audit?"

A user audit is typically a point-in-time report showing current access assignments.

An access review is an operational governance control requiring:
- Human validation
- Documented business justification
- Review accountability
- Enforcement actions
- Audit traceability

The review process validates whether access should continue — not simply whether access exists.

This distinction is important within regulated environments where periodic certification and documented decision-making are required for governance and compliance objectives.

:contentReference[oaicite:4]{index=4}

---

## "How do you verify that access review controls are functioning correctly?"

Control effectiveness is validated through both workflow evidence and enforcement verification.

Validation activities include:
- Confirming reviewer decisions are logged with actor and timestamp
- Verifying denied access results in actual group membership removal
- Correlating review workflows with audit logs
- Confirming evidence artifacts align to configured review settings

The objective is to verify the review process is operationally effective and not simply configured.

**Evidence:**  
- AR-STEP-05 — enforcement outcome  
- AR-STEP-06 — audit log correlation :contentReference[oaicite:5]{index=5}

---

## "What are common weaknesses in access review programs?"

Common weaknesses include:
- Reviewer approvals without validation
- Missing justification for decisions
- Failure to enforce denied access removal
- Lack of traceable audit evidence
- Reviews treated as administrative exercises rather than governance controls

An effective access review program requires:
- Reviewer accountability
- Documented justification
- Enforcement validation
- Audit traceability
- Defined governance cadence

Without these elements, organizations may have the appearance of a review process without meaningful access governance enforcement.

:contentReference[oaicite:6]{index=6}

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
