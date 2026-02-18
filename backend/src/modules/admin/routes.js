import { Router } from 'express';
import { auth, requireRole } from '../../middleware/auth.js';

const router = Router();

router.use(auth(), requireRole('admin'));

router.get('/dashboard', (_req, res) => {
  res.json({ disputesOpen: 0, highRiskUsers: 0, chargebackRate: 0 });
});

router.post('/disputes/:id/decision', (req, res) => {
  res.json({ disputeId: req.params.id, finalDecision: req.body.decision, enforced: true });
});

export default router;
