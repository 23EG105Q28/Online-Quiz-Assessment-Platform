# Dockerfile for QuizMaster Pro (Next.js app)

FROM node:20-alpine AS base
WORKDIR /app

# Install deps
COPY package.json package-lock.json ./
RUN npm ci --production=false

# Copy source
COPY . .

# Build
RUN npm run build

# Production image
FROM node:20-alpine AS prod
WORKDIR /app
ENV NODE_ENV=production

COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/.next ./.next
COPY --from=base /app/public ./public
COPY --from=base /app/prisma ./prisma

EXPOSE 3000
CMD ["npm", "start"]
