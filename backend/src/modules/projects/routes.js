import { Router } from 'express';
import crypto from 'node:crypto';
import { auth, requireRole } from '../../middleware/auth.js';
import { analyzeScope } from '../ai/service.js';

const router = Router();

router.post('/', auth(), requireRole('client'), async (req, res) => {
  const ai = await analyzeScope(req.body);
  req.logActivity('project.created', { title: req.body.title });
  res.status(201).json({ projectId: crypto.randomUUID(), aiSuggestions: ai });
});

router.get('/', auth(false), (_req, res) => {
  res.json({ items: [], message: 'Use filters for verified/open projects' });
});

export default router;
