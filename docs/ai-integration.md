# AI Integration Points

## 1) Scope clarity analysis
Trigger: `POST /projects` and significant scope edits.
- Inputs: title, description, budget, milestones.
- Output: ambiguity score, missing requirements list, suggested refinements.
- Action: show suggestions to client before publish.

## 2) Fraud risk + trust scoring
Trigger: login anomalies, payment events, messaging behavior, disputes.
- Features: account age, KYC, chargeback rate, review entropy, IP/device anomalies.
- Output: risk level (`low/medium/high`) + explainable feature contributions.
- Action: increase verification, delay releases, notify admin queue.

## 3) Dispute analysis
Trigger: dispute creation or evidence update.
- Inputs: chat transcript, files metadata/hashes, milestone details, timeline events.
- Output: recommendation JSON (`release`, `refund`, `split`) + confidence + rationale.
- Guardrail: recommendation is non-binding; admin decision mandatory.

## 4) Plagiarism/authenticity detection
Trigger: milestone submission.
- Inputs: submitted artifacts and external corpus checks.
- Output: plagiarism score + suspicious overlap sources.
- Action: if above threshold, require manual review before payout release.

## AI safety and compliance
- Human-in-the-loop for financial enforcement and disputes.
- Store prompt/response metadata for auditability.
- Redact PII before model calls when possible.
- Version model outputs to support reproducibility.
