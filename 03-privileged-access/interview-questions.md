# Interview Questions — Privileged Access Pack

---

## "How do you manage privileged access in your environment?"

I use a just-in-time privileged access model through Microsoft Entra ID Privileged Identity Management (PIM).

Administrative roles are assigned as eligible rather than permanently active. Users request activation only when privileged access is required for a specific administrative task.

The activation workflow requires:
- MFA
- documented business justification
- approval from a designated approver
- time-limited activation duration

Access expires automatically after the approved duration.

This approach reduces standing administrative access exposure while improving accountability, traceability, and least privilege enforcement.

**Evidence:**  
- PIM-STEP-01 through PIM-STEP-07 :contentReference[oaicite:0]{index=0}

---

## "What is the difference between eligible and active assignment in PIM?"

An active assignment grants privileged access immediately and continuously. The user maintains standing administrative access without requiring activation.

An eligible assignment allows the user to request privileged access when required but does not grant administrative permissions by default.

To activate an eligible role, the user must complete the activation workflow including:
- MFA
- documented justification
- approval
- duration selection

For privileged administrative roles, eligible assignment helps reduce standing access exposure and supports just-in-time access governance principles.

Permanent active assignments should be restricted to approved exception scenarios such as break-glass operational accounts.

:contentReference[oaicite:1]{index=1}

---

## "How do you reduce privilege escalation risk?"

This implementation uses several controls together to reduce privilege escalation exposure:

### Eligible Assignment Model
Users do not maintain standing administrative access.

### Approval Workflow
Privileged access requests require approval before activation. Users cannot self-approve privileged access requests.

### MFA Enforcement
Activation requires MFA, reducing the risk associated with password-only credential compromise.

### Time-Limited Access
Administrative access expires automatically after the approved activation duration.

Together, these controls reduce common privileged access risks associated with standing access, unauthorized elevation, and credential misuse.

**Evidence:**  
- PIM-STEP-06 — pending approval workflow enforced :contentReference[oaicite:2]{index=2}

---

## "How does this align to CMMC Level 2?"

This workflow supports several CMMC Level 2 practices associated with privileged access governance and authentication controls.

Examples include:
- AC.L2-3.1.5 — least privilege enforcement
- AC.L2-3.1.6 — use of non-privileged accounts
- IA.L2-3.5.3 — multifactor authentication
- AU.L2-3.3.2 — traceable audit logging

The implementation demonstrates:
- eligible role assignment
- MFA enforcement
- approval-based activation
- time-limited privileged access
- audit traceability

The evidence package includes:
- role configuration
- eligible assignments
- activation workflows
- audit logs
- governance documentation

This structure demonstrates traceable privileged access governance workflows aligned to regulated environments.

:contentReference[oaicite:3]{index=3}

---

## "What happens if a privileged access request is denied?"

If a request is denied:
- privileged access is not granted
- the denial is recorded within audit logs
- the requestor may submit an updated request with revised justification if appropriate

This follows a default-deny governance approach where privileged access requires positive authorization before activation.

The workflow ensures privileged access is not activated without approval.

:contentReference[oaicite:4]{index=4}

---

## "How do you validate that privileged access controls are functioning correctly?"

Control validation includes both configuration review and workflow testing.

Validation activities include:
- verifying eligible-only assignments for in-scope roles
- confirming activation requests require approval
- validating MFA enforcement during activation
- reviewing audit logs for activation events and approvals
- confirming privileged access is not activated immediately after request submission

The pending approval state provides evidence that privileged access remains gated until workflow approval is completed.

**Evidence:**  
- PIM-STEP-06 — pending approval state  
- PIM-STEP-07 — audit log correlation :contentReference[oaicite:5]{index=5}

---

## "What are common weaknesses in privileged access implementations?"

Common weaknesses include:
- leaving permanent active assignments in place
- missing approval requirements
- weak or undocumented business justification
- lack of audit log review
- excessive activation durations
- inconsistent MFA enforcement

A strong privileged access governance model requires:
- eligible assignment
- MFA enforcement
- approval-based activation
- time-limited access
- audit traceability
- ongoing monitoring

Without enforcement controls, privileged access management may become visibility-only rather than an operational governance control.

:contentReference[oaicite:6]{index=6}

---

## "Why is just-in-time access important?"

Just-in-time access reduces the amount of time privileged access exists within the environment.

Instead of maintaining persistent administrative access:
- users activate access only when required
- access expires automatically
- all activity remains traceable

This reduces exposure associated with:
- compromised administrative credentials
- standing privileged sessions
- privilege misuse
- unauthorized long-term administrative access

JIT access supports least privilege and improves privileged access accountability.

:contentReference[oaicite:7]{index=7}

---

*This portfolio demonstrates governance concepts, operational workflows, and identity security practices within a controlled lab environment aligned to regulated IAM operations.*
