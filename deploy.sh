#!/usr/bin/env bash
set -euo pipefail

# ── Konfigūracija ────────────────────────────────────────────────────────────
# GitHub Actions (.github/workflows/docker-publish.yml) build'ina ir pushina
# Docker image'ą į ghcr.io kiekvieną kartą, kai pushinama į "dev" branch'ą.
# Šis skriptas tik nusiunčia docker-compose.yml į serverį ir pull'ina naujausią
# image'ą - jokio source kodo build'inimo serveryje nebereikia.
SERVER="admin_virgis@172.16.16.19"
DEPLOY_DIR="/app/otp-react-redux"
# ─────────────────────────────────────────────────────────────────────────────

echo "==> Siunčiama docker-compose.yml į $SERVER:$DEPLOY_DIR ..."
ssh "$SERVER" "mkdir -p $DEPLOY_DIR"
scp docker-compose.yml "$SERVER:$DEPLOY_DIR/docker-compose.yml"

echo "==> Pull + up ant serverio ..."
ssh "$SERVER" bash -s << 'EOF'
set -euo pipefail
cd /app/otp-react-redux

echo "--- docker compose pull ---"
docker compose pull

echo "--- docker compose up -d ---"
docker compose up -d

echo "--- Statusas ---"
docker compose ps
EOF

echo "==> Atlikta."
