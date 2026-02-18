# Trust-First Freelance Marketplace (Architecture + Starter Backend)

Production-oriented blueprint and backend scaffold for a freelance marketplace focused on **trust, transparency, and fraud prevention**.

## Stack
- **Frontend:** Next.js + Tailwind CSS
- **Backend:** Node.js + Express
- **Database:** PostgreSQL
- **Auth:** JWT (access + refresh)
- **Payments:** Stripe/Razorpay with milestone escrow ledger
- **Storage:** AWS S3 (pre-signed URL upload)
- **AI services:** scope clarity, fraud risk, dispute recommendation, plagiarism checks

## Deliverables in this repository
- `database/schema.sql` – relational schema with constraints, indexes, and auditability.
- `docs/api-structure.md` – REST API contract and module boundaries.
- `docs/escrow-milestone-logic.md` – escrow lifecycle and state machine.
- `docs/ai-integration.md` – AI decision points and safety controls.
- `docs/admin-moderation-panel.md` – moderation workflows and RBAC.
- `docs/deployment-architecture.md` – deployment-ready architecture and scaling model.
- `backend/` – Express starter with secure middleware + modular routes.

## Security and fraud prevention highlights
- RBAC authorization and strict resource ownership checks.
- Immutable activity log for all critical operations.
- Escrow ledger with idempotent payment operations.
- Trust score engine with explainable signal features.
- Dispute AI as recommendation-only; admin approval required for final enforcement.
- File integrity checks + plagiarism/authenticity pipeline before payout release.

## Quick start (backend scaffold)
```bash
cd backend
npm install
npm run dev
```

> Note: This repo intentionally provides production-grade architecture and service skeletons; integrations (Stripe/Razorpay keys, S3, model providers) are wired through interfaces and environment variables.
