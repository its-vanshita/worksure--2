# REST API Structure

Base path: `/api/v1`

## Auth
- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`
- `POST /auth/2fa/enable`

## Client APIs
- `POST /projects` – create project draft + AI scope analysis.
- `PATCH /projects/:id` – edit project scope.
- `POST /projects/:id/publish` – publish verified project.
- `POST /projects/:id/milestones` – define milestone structure.
- `POST /milestones/:id/fund` – deposit escrow for milestone.
- `POST /milestones/:id/review` – approve/reject submission.
- `POST /reviews` – rate freelancer.

## Freelancer APIs
- `GET /projects?verified=true&status=open`
- `POST /projects/:id/accept`
- `POST /milestones/:id/submissions`
- `GET /payments/me`
- `POST /reviews` – rate client.

## Messaging + files
- `POST /chats/project/:projectId`
- `GET /chats/:chatId/messages`
- `POST /chats/:chatId/messages`
- `POST /files/presign-upload`
- `POST /files/:id/attach`

## Disputes
- `POST /disputes`
- `GET /disputes/:id`
- `POST /disputes/:id/evidence`
- `POST /disputes/:id/ai-recommendation`

## Trust & transparency
- `GET /users/:id/trust-score`
- `GET /projects/:id/timeline`
- `GET /projects/:id/audit-log` (admin only)

## Admin
- `GET /admin/dashboard`
- `GET /admin/disputes`
- `POST /admin/disputes/:id/decision` – final ruling.
- `POST /admin/users/:id/suspend`
- `POST /admin/projects/:id/verify`
- `GET /admin/fraud-alerts`

## Security conventions
- JWT access token + rotating refresh token.
- Role claims: `role`, `permissions`, `session_id`.
- Request idempotency header on payment and release endpoints.
- Rate limiting for login, chat spam, payout operations.
- Signed URL upload policy with MIME/type/size enforcement.
