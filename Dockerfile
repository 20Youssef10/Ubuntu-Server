# Dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PASSWORD=changeme
ENV CODE_PASSWORD=changeme
ENV WORKDIR=/workspace
ENV NOVNC_DIR=/opt/novnc
ENV FILEBROWSER_PORT=8090
ENV NOVNC_PORT=6080
ENV TTYD_PORT=7681
ENV CODESERVER_PORT=8080

# Base deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 xfce4-goodies \
    x11vnc xvfb \
    git curl wget nano thunar \
    supervisor dbus-x11 dbus-user-session \
    python3 python3-pip python3-venv \
    ca-certificates build-essential locales \
    wget unzip gnupg2 \
    net-tools procps \
    && rm -rf /var/lib/apt/lists/*

# pip utilities (websockify used by noVNC)
RUN pip3 install --no-cache-dir websockify

# Install noVNC (latest stable) and websockify wrapper
RUN mkdir -p ${NOVNC_DIR} \
    && git clone --depth 1 https://github.com/novnc/noVNC.git ${NOVNC_DIR} \
    && git clone --depth 1 https://github.com/novnc/websockify ${NOVNC_DIR}/utils/websockify

# Install code-server (VS Code in browser)
# using official install script; will install to /usr/bin/code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install File Browser (https://filebrowser.org)
RUN curl -fsSL https://filebrowser.org/get.sh | bash -s -- -b /usr/local/bin

# Install ttyd (web terminal)
# Attempt apt first; fallback to prebuilt release if not available
RUN apt-get update && apt-get install -y --no-install-recommends ttyd || true
RUN if ! command -v ttyd >/dev/null 2>&1; then \
      TTYD_VER="1.7.4" && \
      curl -fsSL -o /tmp/ttyd.tar.gz "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VER}/ttyd.${TTYD_VER}.linux-amd64.tar.gz" && \
      mkdir -p /tmp/ttyd && tar -xzf /tmp/ttyd.tar.gz -C /tmp/ttyd && mv /tmp/ttyd/ttyd /usr/local/bin/ && rm -rf /tmp/ttyd*; \
    fi

# Create developer user and workspace
RUN useradd -m -s /bin/bash dev \
    && mkdir -p ${WORKDIR} \
    && chown -R dev:dev ${WORKDIR}

# VNC password file (default); can be overridden at runtime with VNC_PASSWORD env
RUN mkdir -p /home/dev/.vnc \
    && echo "${VNC_PASSWORD}" | x11vnc -storepasswd - /home/dev/.vnc/passwd || true \
    && chown -R dev:dev /home/dev/.vnc

# Copy supervisor config and entrypoint
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports
EXPOSE ${NOVNC_PORT} ${TT YD_PORT} ${CODESERVER_PORT} ${FILEBROWSER_PORT} 5901

WORKDIR /root

CMD ["/entrypoint.sh"]
