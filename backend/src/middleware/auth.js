import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';

export function auth(required = true) {
  return (req, res, next) => {
    const header = req.headers.authorization;
    if (!header) {
      if (required) return res.status(401).json({ error: 'Missing auth header' });
      return next();
    }

    const [, token] = header.split(' ');
    try {
      req.user = jwt.verify(token, env.jwtSecret);
      return next();
    } catch {
      return res.status(401).json({ error: 'Invalid token' });
    }
  };
}

export function requireRole(...roles) {
  return (req, res, next) => {
    if (!req.user) return res.status(401).json({ error: 'Unauthorized' });
    if (!roles.includes(req.user.role)) return res.status(403).json({ error: 'Forbidden' });
    return next();
  };
}
