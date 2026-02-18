import { Router } from 'express';
import { auth } from '../../middleware/auth.js';
import { fraudRiskAssessment } from '../ai/service.js';

const router = Router();

router.get('/users/:id/trust-score', auth(), async (req, res) => {
  const model = await fraudRiskAssessment({ chargebacks: 0 });
  res.json({ userId: req.params.id, trustScore: 76.4, fraudModel: model });
});

router.get('/projects/:projectId/timeline', auth(), (req, res) => {
  res.json({ projectId: req.params.projectId, events: [] });
});

export default router;
