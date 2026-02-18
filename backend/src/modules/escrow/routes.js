import { Router } from 'express';
import { auth, requireRole } from '../../middleware/auth.js';
import { validateEscrowOperation } from './service.js';

const router = Router();

router.post('/milestones/:milestoneId/fund', auth(), requireRole('client'), (req, res) => {
  validateEscrowOperation({
    amount: req.body.amount,
    idempotencyKey: req.header('Idempotency-Key')
  });
  req.logActivity('escrow.funded', { milestoneId: req.params.milestoneId, amount: req.body.amount });
  res.status(202).json({ status: 'funding_initiated' });
});

router.post('/milestones/:milestoneId/release', auth(), requireRole('client', 'admin'), (req, res) => {
  validateEscrowOperation({
    amount: req.body.amount,
    idempotencyKey: req.header('Idempotency-Key')
  });
  req.logActivity('escrow.released', { milestoneId: req.params.milestoneId, amount: req.body.amount });
  res.status(202).json({ status: 'release_initiated' });
});

export default router;
