import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { activityLog } from './middleware/activityLog.js';

import authRoutes from './modules/auth/routes.js';
import projectRoutes from './modules/projects/routes.js';
import milestoneRoutes from './modules/milestones/routes.js';
import escrowRoutes from './modules/escrow/routes.js';
import disputeRoutes from './modules/disputes/routes.js';
import messagingRoutes from './modules/messaging/routes.js';
import adminRoutes from './modules/admin/routes.js';
import trustRoutes from './modules/trust/routes.js';

export const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(morgan('combined'));
app.use(activityLog);

app.get('/health', (_req, res) => res.json({ status: 'ok' }));

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/projects', projectRoutes);
app.use('/api/v1/milestones', milestoneRoutes);
app.use('/api/v1/escrow', escrowRoutes);
app.use('/api/v1/disputes', disputeRoutes);
app.use('/api/v1/chats', messagingRoutes);
app.use('/api/v1/admin', adminRoutes);
app.use('/api/v1', trustRoutes);

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});
