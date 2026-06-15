#!/usr/bin/env bash
set -euo pipefail

export PORT="${PORT:-8080}"
export JUPYTER_ROOT_DIR="${JUPYTER_ROOT_DIR:-/data}"
export JUPYTER_COLLABORATIVE="${JUPYTER_COLLABORATIVE:-true}"
export JUPYTER_ALLOW_ORIGIN="${JUPYTER_ALLOW_ORIGIN:-*}"
export JUPYTER_BASE_URL="${JUPYTER_BASE_URL:-/}"

mkdir -p "$JUPYTER_ROOT_DIR"

if [[ -z "${JUPYTER_PASSWORD:-}" ]]; then
  echo "ERROR: JUPYTER_PASSWORD is not set. Add it in Railway Variables." >&2
  exit 1
fi

HASHED_PASSWORD="$(python -c 'import os; from jupyter_server.auth import passwd; print(passwd(os.environ["JUPYTER_PASSWORD"]))')"

ARGS=(
  lab
  --ip=0.0.0.0
  --port="$PORT"
  --no-browser
  --ServerApp.password="$HASHED_PASSWORD"
  --ServerApp.token=
  --ServerApp.allow_remote_access=True
  --ServerApp.root_dir="$JUPYTER_ROOT_DIR"
  --ServerApp.base_url="$JUPYTER_BASE_URL"
)

if [[ "$JUPYTER_ALLOW_ORIGIN" != "" ]]; then
  ARGS+=(--ServerApp.allow_origin="$JUPYTER_ALLOW_ORIGIN")
fi

if [[ "$JUPYTER_COLLABORATIVE" == "true" ]]; then
  ARGS+=(--collaborative)
fi

exec tini -g -- jupyter "${ARGS[@]}"
