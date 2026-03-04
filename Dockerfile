FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV WORKDIR=/workspace
ENV PORT=8080

RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    x11vnc xvfb \
    git curl wget nano thunar \
    supervisor dbus-x11 \
    python3 python3-pip \
    nginx \
    ttyd \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install websockify

RUN git clone https://github.com/novnc/noVNC.git /opt/novnc

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN curl -fsSL https://filebrowser.org/get.sh | bash

RUN mkdir -p /home/dev/.vnc

RUN useradd -m -s /bin/bash dev

RUN mkdir -p /workspace && chown -R dev:dev /workspace

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["/entrypoint.sh"]
