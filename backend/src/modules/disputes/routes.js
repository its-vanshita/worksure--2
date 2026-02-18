import { Router } from 'express';
import crypto from 'node:crypto';
import { auth } from '../../middleware/auth.js';
import { generateDisputeRecommendation } from './service.js';

const router = Router();

router.post('/', auth(), async (req, res) => {
  req.logActivity('dispute.created', { projectId: req.body.projectId, milestoneId: req.body.milestoneId });
  res.status(201).json({ disputeId: crypto.randomUUID(), status: 'open' });
});

router.post('/:id/ai-recommendation', auth(), async (req, res) => {
  const recommendation = await generateDisputeRecommendation(req.body);
  res.json({ disputeId: req.params.id, recommendation, requiresAdminApproval: true });
});

export default router;
