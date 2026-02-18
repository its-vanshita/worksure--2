export function validateEscrowOperation({ amount, idempotencyKey }) {
  if (!amount || amount <= 0) throw new Error('Invalid amount');
  if (!idempotencyKey) throw new Error('Missing idempotency key');
}

export function computeReleaseEligibility({ milestoneStatus, hasDispute }) {
  if (hasDispute) return false;
  return milestoneStatus === 'approved';
}
