# Deployment-Ready Architecture

## Topology
- **Next.js frontend** behind CDN + WAF
- **API gateway** -> Express service cluster
- **PostgreSQL** primary + read replicas
- **Redis** for cache, sessions, queue dedupe
- **Worker services** for AI jobs, plagiarism scans, webhook processing
- **Object storage** (S3) for evidence and deliverables

## Scalability strategy
- Stateless API pods, horizontal auto-scaling.
- Queue-based async workloads for AI and heavy document processing.
- Read replicas for analytics/timeline queries.
- Partition `activity_logs`, `messages` by time when volume grows.

## Security baseline
- TLS everywhere, HSTS, secure cookies for refresh tokens.
- Secrets in cloud secret manager; rotate keys regularly.
- WAF + DDoS protection + bot mitigation on auth/payment endpoints.
- Database row-level ownership checks in service layer.
- SIEM integration for anomaly detection.

## Reliability
- Multi-AZ deployment for API and Postgres.
- PITR backups, tested restore playbooks.
- Outbox pattern for payment/dispute event delivery.
- Idempotent webhook handlers.

## Suggested environments
- `dev`, `staging`, `prod` with isolated DB/payment/storage resources.
- Contract tests against sandbox Stripe/Razorpay.
