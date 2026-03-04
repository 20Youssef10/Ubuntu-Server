# 🐧 Ubuntu شبه كامل على Railway

نظام Ubuntu متكامل مع جميع الأدوات والخدمات الأساسية.

## 📋 ما يتضمنه

### 🛠️ أدوات التطوير
- **Node.js & npm** - تطبيقات JavaScript
- **Python 3** - مع pip و100+ مكتبة شهيرة
- **Ruby, Go, Rust** - لغات برمجة متعددة
- **Java 17** - تطبيقات Java
- **Git & Git Flow** - إدارة الإصدارات

### 💾 قواعس البيانات
- **PostgreSQL** - قاعدة بيانات علائقية قوية
- **MySQL** - قاعدة بيانات شهيرة
- **Redis** - ذاكرة مؤقتة وقائمة انتظار
- **MongoDB** - قاعدة بيانات موجهة للمستندات
- **SQLite** - قاعدة بيانات خفيفة

### 🌐 خوادم الويب
- **Nginx** - خادم ويب عكسي وموازن حمل
- **Apache2** - خادم ويب متقدم
- **Cockpit** - لوحة تحكم ويب للنظام

### 📦 خدمات إضافية
- **SSH Server** - الوصول الآمن عن بعد
- **Supervisor** - إدارة العمليات المتعددة
- **PM2** - مدير عمليات Node.js
- **Docker** - تشغيل حاويات إضافية
- **Cron** - جدولة المهام

## 🚀 النشر على Railway

### الطريقة 1️⃣: من واجهة Railway
```bash
# 1. ادفع الملفات إلى GitHub
git init
git add .
git commit -m "Ubuntu شامل على Railway"
git push origin main

# 2. على Railway.app:
# - اضغط New Project
# - اختر Deploy from GitHub
# - اختر هذا المستودع
# - اضغط Deploy
```

### الطريقة 2️⃣: باستخدام Railway CLI
```bash
# تثبيت Railway CLI
npm install -g @railway/cli

# تسجيل الدخول
railway login

# ربط المشروع
railway link

# نشر
railway up

# عرض السجلات
railway logs
```

## 🎯 الأبواب المتاحة

| الخدمة | البوابة | الوصف |
|------|--------|-------|
| **SSH** | 22 | الوصول عن بعد |
| **HTTP** | 80 | الويب |
| **HTTPS** | 443 | الويب الآمن |
| **App** | 3000 | تطبيقك الرئيسي |
| **PostgreSQL** | 5432 | قاعدة البيانات |
| **MySQL** | 3306 | قاعدة البيانات |
| **Redis** | 6379 | ذاكرة مؤقتة |
| **Cockpit** | 9090 | لوحة التحكم |

## 📱 الوصول إلى الخدمات

### 1. لوحة التحكم (Cockpit) 🎛️
```
https://your-railway-url.up.railway.app/cockpit
```
- عرض استخدام الموارد
- إدارة المستخدمين
- تثبيت الحزم
- عرض السجلات

### 2. SSH - الوصول عن بعد 🔐
```bash
# على Railway، ستحصل على URL و port
ssh ubuntu@your-railway-url.up.railway.app -p [PORT]

# كلمة المرور الافتراضية: يجب إنشاؤها يدوياً
```

### 3. قاعدة البيانات PostgreSQL 🐘
```bash
# من داخل الحاوية
psql -U postgres

# من خارج الحاوية (عبر SSH أولاً)
psql -h localhost -U postgres
```

### 4. Redis 🔴
```bash
# من داخل الحاوية
redis-cli

# كمثال
redis-cli SET key value
redis-cli GET key
```

## 💻 استخدام سطر الأوامر

### بدء خدمة معينة
```bash
# PostgreSQL
service postgresql start
service postgresql restart
service postgresql stop

# MySQL
service mysql start
service mysql restart
service mysql stop

# Redis
service redis-server start

# Nginx
service nginx start
```

### مراقبة النظام
```bash
# عرض استخدام الموارد
htop

# عرض العمليات
ps aux

# عرض الملفات المفتوحة
lsof

# عرض استهلاك الشبكة
iotop
```

## 🔧 تثبيت حزم إضافية

### Python
```bash
pip3 install package_name
```

### Node.js
```bash
npm install -g package_name
```

### Linux (apt)
```bash
apt-get update
apt-get install package_name
```

## 📝 تشغيل التطبيقات

### Node.js مع PM2
```bash
cd /app
npm install
pm2 start app.js --name "myapp"
pm2 save
pm2 startup
```

### Python Flask
```bash
cd /app
pip3 install -r requirements.txt
python3 app.py
# أو مع Gunicorn
gunicorn -w 4 -b 0.0.0.0:3000 app:app
```

### Python FastAPI
```bash
cd /app
pip3 install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 3000
```

## 🔐 الأمان

### تغيير كلمة مرور المستخدم
```bash
sudo passwd ubuntu
```

### إنشاء مفتاح SSH
```bash
ssh-keygen -t rsa -b 4096
# انسخ public key إلى ~/.ssh/authorized_keys
```

### تعديل إعدادات SSH
```bash
sudo nano /etc/ssh/sshd_config
sudo systemctl restart ssh
```

## 📊 مراقبة الأداء

### عرض السجلات
```bash
# جميع السجلات
tail -f /var/log/syslog

# Nginx
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# PostgreSQL
tail -f /var/log/postgresql/postgresql.log

# Redis
redis-cli MONITOR
```

### استهلاك الموارد
```bash
# ذاكرة الوصول العشوائي
free -h

# مساحة التخزين
df -h

# استخدام CPU
top -b -n 1
```

## ⚙️ متغيرات البيئة

في Railway، أضف متغيرات البيئة من علامة التبويب `Variables`:

```env
NODE_ENV=production
PYTHONUNBUFFERED=1
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
REDIS_URL=redis://localhost:6379
```

## 🐛 استكشاف الأخطاء

### الحاوية لا تبدأ
```bash
# تحقق من السجلات على Railway
railway logs

# أو محلياً
docker logs container_id
```

### الخدمة لا تستجيب
```bash
# تحقق من حالة العملية
ps aux | grep service_name

# أعد التشغيل
systemctl restart service_name
```

### مشكلة في قاعدة البيانات
```bash
# تحقق من الاتصال
nc -zv localhost 5432

# أعد تشغيل الخدمة
service postgresql restart
```

## 📚 موارد مفيدة

- [Railway Documentation](https://docs.railway.app)
- [Ubuntu Manual](https://help.ubuntu.com)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Node.js Docs](https://nodejs.org/docs/)
- [Python Docs](https://docs.python.org/3/)

## 💡 نصائح مهمة

✅ **اعمل بحكمة:**
- استخدم Supervisor لتشغيل عمليات متعددة
- استخدم PM2 لإعادة تشغيل تلقائي
- فعّل HTTPS في Nginx
- احفظ المتغيرات الحساسة في البيئة

⚠️ **تجنب:**
- تشغيل الخدمات بدون إدارة
- حفظ البيانات الحساسة في الكود
- استخدام كلمات مرور افتراضية
- نسيان النسخ الاحتياطية

## 🎉 الخطوات التالية

1. ادفع هذه الملفات إلى GitHub
2. انتقل إلى Railway.app وأنشئ مشروع جديد
3. اختر "Deploy from GitHub"
4. انتظر انتهاء البناء
5. استخدم الـ URL المُنشأ للوصول إلى الخدمات

---

**استمتع بـ Ubuntu الكامل على السحابة! 🚀**
