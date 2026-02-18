# Escrow & Milestone Logic

## Milestone states
`pending_funding -> funded -> in_progress -> submitted -> approved -> released`

Alternative branches:
- `submitted -> rejected -> in_progress`
- `submitted -> disputed -> (released | refunded)`

## Core invariants
1. Work cannot start payout flow unless milestone is `funded`.
2. Milestone release is only possible from `approved` or resolved dispute.
3. Every money movement must create immutable `escrow_transactions` record.
4. Idempotency key required for deposit/release/refund operations.

## Flow
1. Client defines milestone plan.
2. Client deposits each milestone amount into escrow.
3. Freelancer submits deliverable and supporting files.
4. AI checks authenticity/plagiarism + risk flags.
5. Client approves or rejects within SLA window.
6. If approved: release escrow to freelancer wallet/bank.
7. If disputed: funds locked until admin final decision.

## Chargeback and risk management
- If provider chargeback occurs, flag project as high risk and freeze future releases.
- Reduce trust score for chargeback initiator unless overturned.
- Enforce progressive payout delay for low-trust accounts.

## Pseudocode (release)
```text
if milestone.status not in [approved, dispute_resolved_release]: reject
if escrow.balance < milestone.amount: alert + block
begin tx
  create escrow_transaction(type=release, idempotency_key)
  debit escrow.balance, debit escrow.locked_balance
  credit freelancer_pending_balance
  set milestone.status='released'
  log activity
commit
```
