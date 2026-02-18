export async function analyzeScope(payload) {
  const missing = [];
  if (!payload.description || payload.description.length < 120) missing.push('Detailed acceptance criteria');
  if (!payload.timeline) missing.push('Delivery timeline');
  return {
    ambiguityScore: Math.min(100, missing.length * 25),
    missing,
    recommendation: 'Clarify milestones and acceptance tests before publishing.'
  };
}

export async function fraudRiskAssessment(context) {
  return {
    riskLevel: context?.chargebacks ? 'high' : 'low',
    score: context?.chargebacks ? 82 : 24,
    factors: ['kyc_status', 'payment_behavior', 'device_anomaly']
  };
}
