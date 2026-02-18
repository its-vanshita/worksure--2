# Frontend (Next.js + Tailwind) Architecture

## App routes
- `/dashboard/client` – project + milestone management
- `/dashboard/freelancer` – verified project feed and active work
- `/dashboard/admin` – moderation panel
- `/projects/[id]` – project workspace (timeline, milestones, chat)
- `/disputes/[id]` – dispute room + evidence viewer

## UI principles for trust
- Always show milestone status and escrow state.
- Timeline panel with immutable event entries.
- Risk labels and verification badges on profiles/projects.
- Dispute recommendations visually marked as "AI suggestion only".

## Realtime
- WebSocket/SSE for chat and milestone status updates.
- Optimistic UI with server reconciliation for messages and submission uploads.
