import { Router } from 'express';
import crypto from 'node:crypto';
import { auth } from '../../middleware/auth.js';

const router = Router();

router.post('/project/:projectId', auth(), (req, res) => {
  res.status(201).json({ chatId: crypto.randomUUID(), projectId: req.params.projectId });
});

router.post('/:chatId/messages', auth(), (req, res) => {
  req.logActivity('chat.message.sent', { chatId: req.params.chatId });
  res.status(201).json({ messageId: crypto.randomUUID(), ...req.body });
});

export default router;
