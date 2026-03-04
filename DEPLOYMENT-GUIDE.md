# 🚀 دليل التجهيز والنشر للـ Web Terminal

## 📋 الملفات المطلوبة

تأكد من وجود جميع هذه الملفات في جذر المشروع:

```
project-root/
├── Dockerfile                    ✅ صورة Docker
├── docker-compose.yml            ✅ تشغيل محلي
├── railway.toml                  ✅ إعدادات Railway
├── nginx.conf                    ✅ إعدادات خادم الويب
├── supervisord.conf              ✅ إدارة العمليات
├── requirements.txt              ✅ حزم Python
├── package.json                  ✅ حزم Node.js
├── .env.example                  ✅ متغيرات البيئة
├── .dockerignore                 ✅ تحسين حجم الصورة
├── .gitignore                    ✅ تجاهل الملفات
├── BUILD-INSTRUCTIONS.md         ℹ️ تعليمات البناء
├── setup.sh                      ⚙️ سكريبت التنظيم
│
├── dashboard/                    📁 مجلد Dashboard
│   ├── package.json              ✅ الملف الأصلي: dashboard-package.json
│   ├── dashboard-server.mjs      ✅ خادم Dashboard
│   └── public/
│       └── index.html            ✅ الملف الأصلي: public-index.html
│
└── app/                          📁 تطبيقك (اختياري)
    └── ...
```

---

## 🔧 خطوات التجهيز

### الطريقة 1️⃣: استخدام سكريبت (الأسهل)

```bash
# 1. انسخ جميع الملفات إلى مجلد جديد
mkdir ubuntu-railway
cd ubuntu-railway

# 2. ضع جميع الملفات من /mnt/user-data/outputs/ هنا

# 3. شغّل سكريبت التنظيم
chmod +x setup.sh
./setup.sh

# النتيجة: ستُنقل الملفات إلى المكان الصحيح
```

### الطريقة 2️⃣: يدوياً (كاملة التحكم)

```bash
# 1. إنشاء المجلدات
mkdir -p dashboard/public
mkdir -p app

# 2. نقل ملفات Dashboard
mv dashboard-package.json dashboard/package.json
mv dashboard-server.mjs dashboard/
mv public-index.html dashboard/public/index.html

# 3. التحقق من البنية
ls -R
```

---

## 🧪 الاختبار المحلي

### المتطلبات
- Docker & Docker Compose مثبتة
- 6GB مساحة تخزين على الأقل

### الخطوات

```bash
# 1. البناء (قد يستغرق 5-10 دقائق)
docker-compose build

# 2. التشغيل
docker-compose up

# 3. انتظر الرسالة:
# "🚀 Web Dashboard running on http://localhost:3001"

# 4. افتح المتصفح
# - Dashboard: http://localhost
# - Terminal: http://localhost/terminal
# - Cockpit: http://localhost:9090
```

### استكشاف الأخطاء

```bash
# عرض السجلات
docker-compose logs -f ubuntu

# دخول الحاوية مباشرة
docker-compose exec ubuntu bash

# إعادة البناء بدون كاش
docker-compose build --no-cache

# تنظيف كامل وإعادة البدء
docker-compose down -v
docker-compose up
```

---

## 📤 النشر على Railway

### الخطوة 1: التحضير على GitHub

```bash
# 1. إنشاء مستودع GitHub جديد
#    https://github.com/new

# 2. إرسال الملفات
git init
git add .
git commit -m "Ubuntu with Web Terminal & Dashboard"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
git push -u origin main
```

### الخطوة 2: النشر على Railway

1. اذهب إلى [Railway.app](https://railway.app)
2. انقر **New Project**
3. اختر **Deploy from GitHub**
4. ربط حسابك وحدد المستودع
5. اختر `Dockerfile` كخيار البناء
6. اضغط **Deploy**

### الخطوة 3: انتظر البناء

⏱️ المدة المتوقعة: 5-10 دقائق

**ستشاهد:**
```
✅ Building...
✅ Deploying...
✅ Build Completed
```

### الخطوة 4: الوصول للتطبيق

بعد انتهاء البناء، ستحصل على URL مثل:
```
https://ubuntu-railway-abc123.up.railway.app
```

**الصفحات الرئيسية:**

| الصفحة | الرابط |
|--------|--------|
| 🏠 Dashboard | `/` |
| 💻 Web Terminal | `/terminal` |
| 🎛️ Cockpit | `/cockpit` |
| 🔴 System Health | `/health` |

---

## 🔐 خطوات ما بعد النشر

### 1. تغيير كلمات المرور

عبر Web Terminal (`/terminal`):

```bash
# المستخدم ubuntu
sudo passwd ubuntu

# PostgreSQL
sudo -u postgres psql
ALTER ROLE postgres WITH PASSWORD 'NEW_PASSWORD';

# MySQL
mysqladmin -u root password 'NEW_PASSWORD'
```

### 2. إضافة مفاتيح SSH

```bash
mkdir -p ~/.ssh
echo "YOUR_PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### 3. تفعيل HTTPS (اختياري)

Railway توفر HTTPS افتراضياً. إذا أردت شهادة مخصصة:
1. اذهب إلى إعدادات المشروع
2. Domain → Custom Domain
3. أضف اسم النطاق الخاص بك

---

## 📝 متغيرات البيئة

على Railway، أضف هذه المتغيرات من `Variables`:

```env
# الإعدادات الأساسية
PORT=3000
NODE_ENV=production
PYTHONUNBUFFERED=1

# قواعد البيانات
POSTGRES_PASSWORD=choose_strong_password
MYSQL_ROOT_PASSWORD=choose_strong_password
REDIS_PASSWORD=

# API Keys (اختياري)
API_KEY=your_api_key
SECRET_KEY=your_secret_key
JWT_SECRET=your_jwt_secret

# Sentry (لتتبع الأخطاء)
SENTRY_DSN=

# New Relic (لمراقبة الأداء)
NEW_RELIC_LICENSE_KEY=
```

---

## 🎯 الأداء والتحسين

### حد الموارد المتاحة

على Railway Free Plan:
- RAM: 8GB (مشترك)
- CPU: بدون حد
- التخزين: 100GB (مشترك)

### التحسينات الموصى بها

```bash
# تعطيل الخدمات غير المستخدمة
sudo systemctl disable mongodb
sudo systemctl disable docker.io

# تحسين PostgreSQL (عبر Terminal)
VACUUM ANALYZE;

# حذف السجلات القديمة
journalctl --vacuum=30d
```

---

## 📊 المراقبة

### Dashboard الداخلي
كل شيء في الصفحة الرئيسية:
- ✅ معلومات النظام
- ✅ حالة الخدمات
- ✅ تنفيذ الأوامر
- ✅ أدوات سريعة

### عبر Cockpit
اذهب إلى `/cockpit` للمزيد:
- رسوم بيانية مفصلة
- إدارة المستخدمين
- سجلات النظام

### عبر Web Terminal
```bash
# المراقبة الحية
watch -n 1 'free -h && echo "---" && df -h'

# الخدمات الثقيلة
ps aux --sort=-%mem | head -10

# استهلاك الشبكة
iftop
```

---

## 🔄 التحديثات والصيانة

### تحديث التطبيق

```bash
# عبر Web Terminal
cd /app
git pull
npm install  # أو pip install
pm2 restart app
```

### تحديث النظام

```bash
# عبر Web Terminal (احذر!)
sudo apt-get update
sudo apt-get upgrade
# قد تحتاج إعادة تشغيل
```

### النسخ الاحتياطية

```bash
# PostgreSQL
pg_dump -U postgres railway_db > backup.sql

# كل قاعدة البيانات
pg_dumpall -U postgres > all_databases.sql

# Redis
redis-cli BGSAVE
cp /var/lib/redis/dump.rdb ./backup-redis.rdb

# ملفات التطبيق
tar -czf app-backup-$(date +%Y%m%d).tar.gz /app
```

---

## 🐛 استكشاف الأخطاء الشائعة

### الحاوية لا تبدأ

```bash
# فحص السجلات على Railway
# انقر على Deploy → Logs

# أو محلياً
docker-compose logs ubuntu
```

**الحل الأول:** انتظر 2 دقيقة - قد تكون الحاوية في بدء التشغيل

**الحل الثاني:** تحقق من الملفات المفقودة
```bash
# تأكد من وجود:
ls -la Dockerfile
ls -la supervisord.conf
ls -la nginx.conf
ls -la dashboard/
```

### Web Terminal لا يعمل

```bash
# عبر SSH أو Terminal
sudo systemctl status ttyd
sudo systemctl restart ttyd

# عرض السجلات
tail -f /var/log/ttyd.log
```

### Dashboard بطيء

```bash
# تحقق من الموارد
free -h
top -b -n 1

# أعد تشغيل Node.js
pkill -f "node dashboard-server"
cd /dashboard && npm start &
```

### PostgreSQL لا ينتج

```bash
# تحقق من الحالة
pg_isready

# أعد التشغيل
sudo systemctl restart postgresql

# تحقق من السجلات
tail -f /var/log/postgresql/postgresql.log
```

---

## ❓ أسئلة شائعة

**س: هل يمكن تشغيل عدة تطبيقات؟**
نعم، استخدم Supervisor أو PM2 لإدارة عمليات متعددة.

**س: كيف أتصل بقاعدة البيانات من تطبيق خارجي؟**
لا يمكن الآن - الاتصالات من الداخل فقط. استخدم Supabase أو قاعدة بيانات خارجية.

**س: هل الملفات المحملة دائمة؟**
لا - عند إعادة النشر، تُفقد الملفات. استخدم S3 أو Supabase للملفات الدائمة.

**س: كيف أضيف نطاق مخصص؟**
Railway → Project Settings → Domains → Add Custom Domain

---

## 📚 موارد مفيدة

- [Railway Docs](https://docs.railway.app)
- [ttyd GitHub](https://github.com/tsl0922/ttyd)
- [Cockpit Project](https://cockpit-project.org/)
- [Ubuntu Help](https://help.ubuntu.com)
- [Docker Docs](https://docs.docker.com)

---

## 🎉 الخطوات الأخيرة

```bash
# 1. تأكد من جميع الملفات
ls -la

# 2. اختبر محلياً
docker-compose up

# 3. ادفع إلى GitHub
git push

# 4. انشر على Railway
# ... في واجهة Railway

# 5. استمتع! 🚀
# افتح https://your-url.up.railway.app
```

---

**هل تواجه مشكلة؟ تحقق من:**
1. ✅ جميع الملفات موجودة
2. ✅ الأسماء صحيحة (case-sensitive)
3. ✅ المجلدات صحيحة (dashboard/public/ و app/)
4. ✅ السجلات على Railway

---

**بالتوفيق! 🎊**
