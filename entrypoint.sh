#!/usr/bin/env bash
set -euo pipefail

# Ensure workspace exists and ownership is correct
mkdir -p "${WORKDIR}"
chown -R dev:dev "${WORKDIR}"

# If user passed VNC_PASSWORD or CODE_PASSWORD via env, (re)write passwd
if [ -n "${VNC_PASSWORD:-}" ]; then
  echo "${VNC_PASSWORD}" | x11vnc -storepasswd - /home/dev/.vnc/passwd || true
  chown dev:dev /home/dev/.vnc/passwd || true
fi

# set locale to avoid warnings
if ! grep -q "en_US.UTF-8" /etc/locale.gen 2>/dev/null; then
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen || true
fi
locale-gen || true

# allow running commands as dev by default
export HOME=/home/dev
export USER=dev

# start supervisord (it will manage services and autorestart)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
