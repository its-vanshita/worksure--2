# Admin Moderation Panel

## Modules
1. **Fraud Alerts Queue**
   - High-risk users/projects
   - Device/IP anomaly feed
   - Chargeback and unusual payout pattern alerts

2. **Dispute Center**
   - Timeline replay (messages, submissions, approvals, payment events)
   - AI recommendation with confidence and explainability
   - Final actions: release, refund, split, account sanction

3. **Trust Score Operations**
   - Signal drill-down per user
   - Manual adjustments with reason codes
   - Automatic decay and recovery controls

4. **Project Verification**
   - Validate project legitimacy and client payment readiness
   - Block suspicious projects before freelancer acceptance

5. **Audit & Compliance**
   - Immutable activity log browser
   - Export regulatory audit reports

## RBAC permissions
- `admin.read`, `admin.dispute.resolve`, `admin.user.suspend`, `admin.project.verify`, `admin.audit.export`

## Operational KPIs
- Median dispute resolution time
- Escrow release success ratio
- Fraud detection precision/recall
- Chargeback percentage by cohort
