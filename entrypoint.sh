#!/bin/bash

mkdir -p /workspace
chown -R dev:dev /workspace

Xvfb :1 -screen 0 1280x800x24 &

export DISPLAY=:1

startxfce4 &

x11vnc -display :1 -forever -shared -rfbport 5901 &

websockify 6080 localhost:5901 --web=/opt/novnc &

exec /usr/bin/supervisord
