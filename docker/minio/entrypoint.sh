#!/bin/sh
set -e

# Configurable values
CONSOLE_PORT="${CONSOLE_PORT:-8900}"
API_HOST="127.0.0.1"
API_PORT="${API_PORT:-9000}"
BUCKETS="${BUCKETS:-local}"   # Comma-separated list, defaults to "local"

# Start MinIO in the background
minio server /data/minio --console-address ":${CONSOLE_PORT}" &
MINIO_PID=$!

# Wait for MinIO to become live
echo "Waiting for MinIO to be live on ${API_HOST}:${API_PORT}..."
for i in $(seq 1 30); do
  if curl -sf "http://${API_HOST}:${API_PORT}/minio/health/live" >/dev/null; then
    echo "MinIO is live."
    break
  fi
  sleep 2
done

# If still not live, exit
if ! curl -sf "http://${API_HOST}:${API_PORT}/minio/health/live" >/dev/null; then
  echo "MinIO did not become live in time."
  kill "$MINIO_PID" || true
  exit 1
fi

# Download mc (static) if not already present
if ! command -v /usr/local/bin/mc >/dev/null 2>&1; then
  echo "Downloading MinIO Client (mc)..."
  curl -sSL -o /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
  chmod +x /usr/local/bin/mc
fi

# Configure mc alias to the local MinIO (inside the same container)
MC="/usr/local/bin/mc"
$MC alias set local "http://${API_HOST}:${API_PORT}" "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"

# Create and configure buckets (idempotent)
# BUCKETS can be "local,images,logs"
OLDIFS="$IFS"
IFS=','

for BUCKET in $BUCKETS; do
  BUCKET_TRIMMED="$(echo "$BUCKET" | tr -d ' ')"
  if [ -z "$BUCKET_TRIMMED" ]; then
    continue
  fi

  # Create bucket if missing
  if ! $MC ls "local/${BUCKET_TRIMMED}" >/dev/null 2>&1; then
    echo "Creating bucket: ${BUCKET_TRIMMED}"
    $MC mb "local/${BUCKET_TRIMMED}"
  else
    echo "Bucket already exists: ${BUCKET_TRIMMED}"
  fi

  # Allow anonymous download (public read) – safe to re-run
  $MC anonymous set download "local/${BUCKET_TRIMMED}" || true
done

IFS="$OLDIFS"

echo "MinIO bootstrap complete."

# Keep MinIO in the foreground
wait "$MINIO_PID"