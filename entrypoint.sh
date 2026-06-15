#!/usr/bin/env bash
set -euo pipefail

: "${JUPYTER_PASSWORD:?JUPYTER_PASSWORD is required}"
PORT="${PORT:-8080}"
ROOT_DIR="${JUPYTER_ROOT_DIR:-/data}"
YDOC_SAVE_DELAY="${YDOC_SAVE_DELAY:-0.5}"
YSTORE_DB_PATH="${YSTORE_DB_PATH:-${ROOT_DIR}/.jupyter_ystore.db}"

mkdir -p "$ROOT_DIR" /root/.jupyter

HASH="$(python - <<'PY'
import os
from jupyter_server.auth import passwd
print(passwd(os.environ['JUPYTER_PASSWORD']))
PY
)"

cat > /root/.jupyter/jupyter_server_config.py <<PY
c = get_config()

c.ServerApp.root_dir = r"${ROOT_DIR}"
c.ServerApp.allow_origin = "*"
c.ServerApp.open_browser = False

c.IdentityProvider.token = ""
c.PasswordIdentityProvider.hashed_password = r"${HASH}"

c.YDocExtension.document_save_delay = ${YDOC_SAVE_DELAY}
c.SQLiteYStore.db_path = r"${YSTORE_DB_PATH}"
PY

echo "Starting JupyterLab on port ${PORT}"
echo "Root dir: ${ROOT_DIR}"
echo "YStore DB: ${YSTORE_DB_PATH}"

exec jupyter lab \
  --ip=0.0.0.0 \
  --port="${PORT}" \
  --no-browser \
  --allow-root
