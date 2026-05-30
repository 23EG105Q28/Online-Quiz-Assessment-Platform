# QuizMaster Pro

Advanced Online Quiz & Assessment Platform (production-ready scaffolding).

## Local Development

Prerequisites: Docker (for Postgres/Redis), Node.js (18+), npm

0. Configure environment variables (create a `.env.local` file):

```bash
DATABASE_URL="postgresql://postgres:postgrespassword@localhost:5432/quizmaster_db?schema=public"
JWT_SECRET="replace-with-a-long-random-secret"
```

If `DATABASE_URL` is missing in development, the app now falls back to the local Docker Postgres URL above.

1. Start Postgres & Redis (via Docker Compose):

```bash
docker-compose up -d
```

2. Install dependencies:

```bash
npm install
```

3. Generate Prisma client and run migrations (first run):

```bash
npx prisma generate
npx prisma migrate dev --name init
```

4. Seed database:

```bash
npm run prisma:seed || npx tsx prisma/seed.ts
```

5. Run development server:

```bash
npm run dev
```

Open http://localhost:3000

### Health Checks

- Database health endpoint: `GET /api/health/db`
- Returns `200` when the DB is reachable and `503` when it is unavailable/misconfigured.

### Development Fallback (No Postgres)

When Postgres is unavailable in development, auth endpoints now fall back to an in-memory store so you can still register, verify OTP, login, and refresh sessions.

- This fallback is for local development only.
- Data is reset when the dev server restarts.

## Production (Docker)

Build image:

```bash
docker build -t quizmaster-pro .
```

Run with environment variables (example):

```bash
docker run -e DATABASE_URL=$DATABASE_URL -e JWT_SECRET=$JWT_SECRET -p 3000:3000 quizmaster-pro
```

## Notes
- The project uses PostgreSQL (configured in docker-compose.yml) and Redis for caching/session features.
- Authentication uses JWT (access + refresh tokens) stored in secure HTTP-only cookies.
- Prisma schema lives in `prisma/schema.prisma` and seed script is `prisma/seed.ts`.

This repository is scaffolded to implement the full QuizMaster Pro feature set. I can continue implementing the next prioritized features (auth hardening, quiz engine server endpoints, anti-cheat, analytics, CI) — tell me which area to prioritize and I'll implement it next.
