FROM node:18-slim AS base
RUN apt-get update \
    && apt-get install -y openssl git bash curl \
    && rm -rf /var/lib/apt/lists/*

# ==========================
# 1. Install deps
# ==========================
FROM base AS deps
WORKDIR /app
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN npm ci

# ==========================
# 2. Build Next.js
# ==========================
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# ==========================
# 3. Runner
# ==========================
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

RUN addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 nextjs

# copy hasil build
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# copy bootstrap script
COPY bootstrap.sh /app/bootstrap.sh
RUN chmod +x /app/bootstrap.sh

EXPOSE 3000

# Jangan set USER di sini → biar postStartCommand jalan sebagai root
CMD ["node", "server.js"]
