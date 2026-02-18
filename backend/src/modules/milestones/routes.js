import { Router } from 'express';
import crypto from 'node:crypto';
import { auth, requireRole } from '../../middleware/auth.js';

const router = Router();

router.post('/:milestoneId/submissions', auth(), requireRole('freelancer'), (req, res) => {
  req.logActivity('milestone.submitted', { milestoneId: req.params.milestoneId });
  res.status(201).json({ submissionId: crypto.randomUUID(), status: 'submitted' });
});

router.post('/:milestoneId/review', auth(), requireRole('client'), (req, res) => {
  const { decision } = req.body;
  req.logActivity('milestone.reviewed', { milestoneId: req.params.milestoneId, decision });
  res.json({ milestoneId: req.params.milestoneId, decision });
});

export default router;
