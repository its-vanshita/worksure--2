export async function generateDisputeRecommendation(payload) {
  const hasPlagiarismFlag = Number(payload?.plagiarismScore || 0) > 70;
  return {
    action: hasPlagiarismFlag ? 'refund' : 'split',
    confidence: hasPlagiarismFlag ? 88 : 62,
    rationale: hasPlagiarismFlag
      ? 'High plagiarism risk and weak originality evidence.'
      : 'Mixed evidence in chat timeline and milestone acceptance scope.'
  };
}
