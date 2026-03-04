FROM ubuntu:latest

# تجنب مشاكل التفاعل
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# تحديث النظام - المرحلة الأولى
RUN apt-get update && apt-get upgrade -y

# تثبيت الأدوات الأساسية - المرحلة الثانية
RUN apt-get install -y \
    curl wget git build-essential gcc g++ make cmake \
    vim nano emacs htop procps \
    tmux screen \
    net-tools iputils-ping dnsutils \
    openssh-server openssh-client

# تثبيت لغات البرمجة - المرحلة الثالثة
RUN apt-get install -y \
    nodejs npm yarn \
    python3 python3-pip python3-dev python3-venv \
    ruby golang rust \
    openjdk-17-jdk openjdk-17-jre

# تثبيت قواعس البيانات - المرحلة الرابعة
RUN apt-get install -y \
    postgresql postgresql-contrib \
    mysql-server \
    redis-server \
    sqlite3

# تثبيت خوادم الويب والأدوات - المرحلة الخامسة
RUN apt-get install -y \
    nginx apache2 \
    docker.io git-flow \
    zip unzip tar gzip bzip2 \
    graphviz supervisor \
    systemd systemd-sysv cron logrotate sysstat \
    netcat-openbsd socat telnet \
    libssl-dev libffi-dev \
    zlib1g-dev libjpeg-dev libpng-dev \
    jq ca-certificates

# تثبيت npm packages عالمياً
RUN npm install -g \
    express @nestjs/cli \
    typescript ts-node \
    pm2 webpack webpack-cli \
    eslint prettier nodemon http-server

# تثبيت أدوات Python الشهيرة
RUN pip3 install --upgrade pip setuptools wheel && \
    pip3 install \
    flask django fastapi starlette \
    requests beautifulsoup4 lxml \
    pandas numpy scipy scikit-learn \
    sqlalchemy psycopg2-binary pymongo \
    celery redis gunicorn uvicorn \
    jupyter jupyterlab pytest pytest-cov \
    black flake8 pylint

# تثبيت ttyd (Web Terminal)
RUN mkdir -p /tmp/ttyd && cd /tmp/ttyd && \
    wget https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.linux.x86_64 -O ttyd 2>/dev/null && \
    chmod +x ttyd && \
    mv ttyd /usr/local/bin/ && \
    cd / && rm -rf /tmp/ttyd

# تنظيف المخزن المؤقت
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# إنشاء مجلد التطبيق
RUN mkdir -p /app /home/ubuntu
WORKDIR /app

# إنشاء مستخدم Ubuntu عادي
RUN useradd -m -s /bin/bash ubuntu && \
    usermod -aG docker ubuntu && \
    usermod -aG sudo ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# إعداد SSH
RUN mkdir -p /run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# إنشاء دليل الرئيسية المناسب
RUN mkdir -p /home/ubuntu/.ssh && \
    chown -R ubuntu:ubuntu /home/ubuntu && \
    chmod 700 /home/ubuntu/.ssh

# تكوين PostgreSQL
RUN mkdir -p /var/run/postgresql && \
    chown postgres:postgres /var/run/postgresql

# تكوين Redis
RUN mkdir -p /var/lib/redis && \
    chown redis:redis /var/lib/redis

# تكوين Supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# نسخ إعدادات Nginx
RUN mkdir -p /etc/nginx/conf.d
COPY nginx.conf /etc/nginx/nginx.conf

# تحويل الملكية للمستخدم
RUN chown -R ubuntu:ubuntu /app

# إنشاء مجلد Dashboard
RUN mkdir -p /dashboard/public
WORKDIR /dashboard

# نسخ ملفات Dashboard
COPY dashboard-package.json package.json
COPY dashboard-server.mjs .
COPY public-index.html public/index.html

# تثبيت dependencies Dashboard
RUN npm install

# إرجاع directory للتطبيق الرئيسي
WORKDIR /app

# تثبيت Cockpit (لوحة التحكم الويب)
RUN apt-get update && apt-get install -y cockpit cockpit-system && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# إنشاء ملف بدء التشغيل
RUN cat > /startup.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 بدء تشغيل Ubuntu على Railway..."

# بدء SSH
echo "Starting SSH..."
service ssh start || true

# بدء PostgreSQL
echo "Starting PostgreSQL..."
service postgresql start || true

# بدء MySQL
echo "Starting MySQL..."
service mysql start || true

# بدء Redis
echo "Starting Redis..."
service redis-server start || true

# بدء Cockpit
echo "Starting Cockpit (Web Dashboard)..."
systemctl start cockpit.service || true

# بدء Nginx
echo "Starting Nginx..."
service nginx start || true

# بدء ttyd (Web Terminal)
echo "Starting Web Terminal (ttyd)..."
nohup ttyd -p 7681 -W bash > /var/log/ttyd.log 2>&1 &

# بدء Node.js Dashboard
echo "Starting Web Dashboard..."
cd /dashboard && npm start > /var/log/dashboard.log 2>&1 &

# بدء Supervisor
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
    CMD curl -f http://localhost:9090/ || curl -f http://localhost:80/ || exit 1

# تعريض الأبواب
EXPOSE 22 80 443 3000 3001 5432 3306 6379 8000 8080 7681 9090

# نقطة الدخول
CMD ["/startup.sh"]
