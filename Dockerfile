FROM ubuntu:latest

# تجنب مشاكل التفاعل
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# تحديث النظام فقط
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# تثبيت الأدوات الأساسية فقط
RUN apt-get update && apt-get install -y \
    curl wget git \
    vim nano \
    tmux \
    openssh-server openssh-client \
    supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# إنشاء مجلد التطبيق
RUN mkdir -p /app /home/ubuntu
WORKDIR /app

# إنشاء مستخدم Ubuntu
RUN useradd -m -s /bin/bash ubuntu && \
    usermod -aG sudo ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# إعداد SSH
RUN mkdir -p /run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /home/ubuntu/.ssh && \
    chown -R ubuntu:ubuntu /home/ubuntu && \
    chmod 700 /home/ubuntu/.ssh

# تكوين Supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# تثبيت Nginx
RUN apt-get update && apt-get install -y nginx && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY nginx.conf /etc/nginx/nginx.conf

# تحويل الملكية
RUN chown -R ubuntu:ubuntu /app

# إنشاء مجلد Dashboard
RUN mkdir -p /dashboard/public
WORKDIR /dashboard

# نسخ ملفات Dashboard
COPY dashboard-package.json package.json
COPY dashboard-server.mjs .
COPY public-index.html public/index.html

# تثبيت Node.js و npm فقط
RUN apt-get update && apt-get install -y nodejs npm && \
    npm install && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# إرجاع directory للتطبيق
WORKDIR /app

# تثبيت Cockpit (لوحة التحكم الويب)
RUN apt-get update && apt-get install -y cockpit cockpit-system && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# إنشاء ملف بدء التشغيل
RUN cat > /startup.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Starting Ubuntu on Railway..."

# Start SSH
echo "Starting SSH..."
service ssh start || true

# Start Nginx
echo "Starting Nginx..."
service nginx start || true

# Start Cockpit
echo "Starting Cockpit (Web Dashboard)..."
systemctl start cockpit.service || true

# Start ttyd (Web Terminal) if available
if command -v ttyd &> /dev/null; then
    echo "Starting Web Terminal (ttyd)..."
    nohup ttyd -p 7681 -W bash > /var/log/ttyd.log 2>&1 &
fi

# Start Node.js Dashboard
echo "Starting Web Dashboard..."
cd /dashboard && npm start > /var/log/dashboard.log 2>&1 &

# Start Supervisor
echo "Starting Supervisor..."
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf

EOF

RUN chmod +x /startup.sh

# متغيرات البيئة
ENV NODE_ENV=production
ENV PYTHONUNBUFFERED=1
ENV PORT=3000

# فحص صحة الحاوية
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# تعريض الأبواب
EXPOSE 22 80 443 3000 3001 7681 9090

# نقطة الدخول
CMD ["/startup.sh"]
