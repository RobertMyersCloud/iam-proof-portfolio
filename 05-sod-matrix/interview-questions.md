# Interview Questions — Segregation of Duties (SoD) Pack

---

# "What is Segregation of Duties and why is it important?"

Segregation of Duties (SoD) is a governance control designed to prevent a single individual from having enough authority to initiate, approve, execute, and conceal unauthorized activity. :contentReference[oaicite:0]{index=0}

The objective is to reduce:
- fraud risk
- privilege abuse
- audit integrity failure
- operational control bypass
- excessive concentration of authority

In regulated environments, SoD ensures incompatible operational functions remain separated through:
- role design
- provisioning controls
- access review workflows
- compensating controls
- governance oversight

This implementation establishes:
- formal role conflict definitions
- risk-tier classification
- mitigation requirements
- exception governance
- quarterly review processes

---

# "How do you identify SoD conflicts?"

Conflicts are identified through both preventative and detective governance workflows.

## Preventative Detection

During:
- onboarding
- access requests
- role modifications
- provisioning workflows

requested assignments are evaluated against the SoD matrix.

Conflicting assignments are:
- blocked
- escalated
- or routed through formal exception handling

## Detective Detection

Quarterly access reviews identify:
- accumulated role overlap
- provisioning drift
- unresolved exceptions
- unauthorized privilege combinations

This combination reduces the likelihood that high-risk conflicts remain undetected over time.

:contentReference[oaicite:1]{index=1}

---

# "Can you explain your SoD risk-tier model?"

The implementation uses a three-tier governance classification model.

| Tier | Definition |
|---|---|
| 🔴 Critical | Direct fraud, privilege escalation, or audit destruction risk |
| 🟠 High | Significant operational abuse or integrity risk |
| 🟡 Medium | Governance or policy violation risk |

Examples:
- Global Administrator + Conditional Access Administrator → 🔴 Critical
- Payroll Administrator + HR Records Administrator → 🔴 Critical
- Security Reviewer + Access Approver → 🟡 Medium

The classification determines:
- escalation path
- remediation urgency
- approval authority
- exception handling requirements

Critical conflicts require immediate remediation or CISO-approved exception handling.

:contentReference[oaicite:2]{index=2}

---

# "What are the most dangerous SoD conflicts?"

The highest-risk conflicts are combinations that allow:
- self-approval
- fraud concealment
- audit manipulation
- unrestricted administrative authority

Examples include:

| Conflict | Risk |
|---|---|
| Accounts Payable + Vendor Management | Fraudulent vendor payments |
| Payroll Admin + HR Records Admin | Ghost employee fraud |
| System Admin + Audit Log Admin | Undetectable compromise |
| Global Admin + Conditional Access Admin | Identity system compromise |

These conflicts are classified as Critical because a single user could perform unauthorized activity without independent oversight.

:contentReference[oaicite:3]{index=3}

---

# "How do you handle SoD exceptions?"

Exceptions are treated as temporary governance conditions rather than permanent operational states.

All exceptions require:
- documented business justification
- risk assessment
- compensating controls
- expiration date
- formal approval

Critical-tier exceptions require CISO approval.

The maximum duration is:
- 90 days unless formally renewed through governance review

Examples of compensating controls include:
- enhanced monitoring
- dual approval workflows
- reconciliation review
- PIM approval requirements

The objective is to reduce residual risk while maintaining operational continuity.

:contentReference[oaicite:4]{index=4}

---

# "What are compensating controls in SoD governance?"

Compensating controls reduce operational risk when full role separation is temporarily not possible.

Examples include:
- enhanced audit logging
- dual approval workflows
- independent reconciliation review
- elevated monitoring
- PIM activation controls

For example:
if staffing limitations temporarily prevent role separation, the organization may implement:
- increased logging
- independent review
- shortened certification cycles
- approval escalation

until full separation is restored.

Compensating controls must:
- be documented
- reduce residual risk
- have defined ownership
- remain reviewable during governance cycles

:contentReference[oaicite:5]{index=5}

---

# "How does SoD relate to IAM and IGA?"

SoD is a core governance function within Identity Governance & Administration (IGA).

IAM systems handle:
- provisioning
- authentication
- role assignment
- access requests

IGA adds governance capabilities including:
- access certification
- SoD conflict management
- role ownership
- exception governance
- audit traceability

This implementation demonstrates how governance workflows evaluate role assignments against defined conflict rules during provisioning and review activities.

SoD governance becomes part of:
- onboarding
- role engineering
- privileged access governance
- quarterly certification
- audit readiness

:contentReference[oaicite:6]{index=6}

---

# "How do you validate SoD controls are effective?"

Validation occurs through multiple governance activities.

## Quarterly Access Certification

Reviewers validate:
- role assignments
- unresolved conflicts
- expired exceptions
- compensating control effectiveness

## Provisioning Governance Review

Provisioning workflows are reviewed to confirm:
- conflicts are detected
- assignments are blocked appropriately
- escalations function correctly
- exception approvals remain enforced

## Audit Validation

Governance review includes:
- exception register accuracy
- remediation evidence
- audit traceability
- governance logging

The objective is to ensure SoD functions as an operational governance control rather than static documentation.

:contentReference[oaicite:7]{index=7}

---

# "How does this align to CMMC Level 2?"

This implementation directly supports:
- AC.L2-3.1.4 — separation of duties
- AC.L2-3.1.5 — least privilege
- AU.L2-3.3.1 — audit logging
- CA.L2-3.12.1 — periodic assessment

The framework demonstrates:
- formal role conflict governance
- preventative enforcement
- quarterly review
- exception management
- audit-ready governance evidence

The evidence package includes:
- SoD matrix
- governance policy
- review workflows
- exception procedures
- remediation tracking

This structure supports SSP evidence alignment and assessor review readiness.

:contentReference[oaicite:8]{index=8}

---

# "What are common weaknesses in SoD programs?"

Weak SoD programs often suffer from:
- unmanaged exceptions
- outdated role definitions
- lack of governance ownership
- poor review discipline
- excessive operational overlap
- spreadsheet-only tracking with no operational enforcement

Another common issue is treating SoD as:
> an audit exercise instead of a governance program.

Strong SoD governance requires:
- preventative controls
- detective controls
- corrective controls
- operational review
- executive accountability
- IAM workflow integration

Without those elements, SoD becomes documentation instead of an active control system.

:contentReference[oaicite:9]{index=9}

---

# "How would you mature this SoD program further?"

Future maturity improvements could include:
- automated IGA provisioning enforcement
- real-time entitlement-level conflict analysis
- application-specific SoD models
- risk-scored governance workflows
- integrated access certification campaigns
- workflow orchestration through SailPoint or Okta governance tooling

The long-term objective is to move from static governance documentation toward continuous automated governance enforcement.

:contentReference[oaicite:10]{index=10}

---

# "How do you balance operational needs with SoD governance?"

Operational reality sometimes requires temporary overlap due to:
- staffing shortages
- emergency operations
- business continuity requirements

The balance comes from:
- temporary exceptions
- compensating controls
- expiration dates
- enhanced monitoring
- periodic review

The goal is not perfect theoretical separation at all times — the goal is managed risk with accountability and governance visibility.

:contentReference[oaicite:11]{index=11}

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
