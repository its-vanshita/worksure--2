import { Router } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../../config/env.js';

const router = Router();

router.post('/login', (req, res) => {
  const { email, role = 'client' } = req.body;
  const token = jwt.sign({ sub: email, role }, env.jwtSecret, { expiresIn: '1h' });
  res.json({ accessToken: token, tokenType: 'Bearer' });
});

router.post('/register', (_req, res) => {
  res.status(201).json({ message: 'Registration endpoint placeholder' });
});

export default router;
