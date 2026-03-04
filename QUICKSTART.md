# ⚡ البدء السريع

## 🚀 الخطوات السريعة (5 دقائق)

### 1. جهز المستودع
```bash
git clone <your-repo-url>
cd ubuntu-railway
```

### 2. أنشئ .env من المثال
```bash
cp .env.example .env
# عدّل المتغيرات حسب احتياجك
```

### 3. اختبر محلياً (اختياري)
```bash
# استخدم Docker Compose
docker-compose up -d

# اختبر الوصول
curl http://localhost:80
```

### 4. ادفع إلى GitHub
```bash
git add .
git commit -m "Ubuntu شامل على Railway"
git push origin main
```

### 5. انشر على Railway
- اذهب إلى [Railway.app](https://railway.app)
- انقر **New Project**
- اختر **Deploy from GitHub**
- اختر هذا المستودع
- اضغط **Deploy**

### 6. انتظر البناء (2-5 دقائق)
- تحقق من السجلات
- انتظر رسالة "Build Completed"

### 7. الوصول للخدمات
```
🌐 الويب: https://your-railway-url.up.railway.app
🎛️ Cockpit: https://your-railway-url.up.railway.app/cockpit
🔐 SSH: ssh ubuntu@your-railway-url.up.railway.app
```

---

## 🎯 الخدمات الجاهزة فوراً

| الخدمة | كيفية الوصول |
|------|------------|
| **Cockpit Dashboard** | `/cockpit` |
| **Nginx** | `/` (البوابة 80) |
| **PostgreSQL** | `:5432` |
| **Redis** | `:6379` |
| **SSH** | `:22` |

---

## 🔑 متغيرات البيئة الضرورية

على Railway، أضف هذه متغيرات البيئة من علامة التبويب `Variables`:

```env
PORT=3000
NODE_ENV=production
PYTHONUNBUFFERED=1
POSTGRES_PASSWORD=choose_secure_password
MYSQL_ROOT_PASSWORD=choose_secure_password
```

---

## 🐛 استكشاف سريع

### الحاوية لا تبدأ؟
```bash
# شاهد السجلات على Railway
railway logs

# أو محلياً
docker-compose logs ubuntu
```

### خدمة لا تعمل؟
```bash
# التحقق من حالة الخدمات
docker-compose exec ubuntu systemctl status

# إعادة تشغيل خدمة معينة
docker-compose exec ubuntu service postgresql restart
```

### مشكلة في الاتصال؟
```bash
# تحقق من الأبواب المفتوحة
docker-compose exec ubuntu netstat -tuln

# اختبر الاتصال
docker-compose exec ubuntu curl -f http://localhost/
```

---

## 📦 إضافة متطلبات جديدة

### Python
```bash
# أضف إلى requirements.txt
pip3 install new-package
pip3 freeze > requirements.txt

# أو في الـ Dockerfile مباشرة
RUN pip3 install new-package
```

### Node.js
```bash
# أضف إلى package.json
npm install new-package
npm install --save new-package

# أو عالمياً
npm install -g new-package
```

### Linux
```bash
# في الـ Dockerfile
RUN apt-get install -y new-package
```

---

## 💾 النسخ الاحتياطية

### PostgreSQL
```bash
# من داخل الحاوية
pg_dump -U postgres railway_db > backup.sql

# استعادة
psql -U postgres railway_db < backup.sql
```

### Redis
```bash
# حفظ يدوي
redis-cli BGSAVE

# الملف موجود في
ls -la /var/lib/redis/dump.rdb
```

---

## 🔐 الأمان الأساسي

```bash
# غير كلمة مرور المستخدم
sudo passwd ubuntu

# أضف مفتاح SSH
mkdir -p ~/.ssh
echo "your-public-key" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

## 📊 مراقبة الأداء

```bash
# الموارد المستخدمة
docker-compose exec ubuntu htop

# سجلات النظام
docker-compose exec ubuntu tail -f /var/log/syslog

# سجلات Nginx
docker-compose exec ubuntu tail -f /var/log/nginx/access.log
```

---

## 🎓 أمثلة عملية

### تشغيل تطبيق Node.js
```bash
cd /app
npm install
npm start

# أو مع PM2
pm2 start app.js --name "myapp"
pm2 save
```

### تشغيل Flask
```bash
cd /app
pip3 install -r requirements.txt
python3 -m flask run --host=0.0.0.0 --port=3000
```

### تشغيل FastAPI
```bash
cd /app
pip3 install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 3000
```

---

## ❓ أسئلة شائعة

**س: كيف أتصل بقاعدة البيانات من خارج الحاوية؟**
```bash
# عبر SSH أولاً
ssh ubuntu@railway-url
# ثم تصل للقاعدة محلياً
psql -h localhost -U postgres -d railway_db
```

**س: كيف أحفظ البيانات بشكل دائم؟**
على Railway، أضف PostgreSQL أو MySQL كـ service منفصل.

**س: هل يمكن تشغيل عمليات متعددة؟**
نعم، استخدم Supervisor أو PM2.

**س: كيف أثقيل ملفات كبيرة؟**
استخدم S3 أو Supabase Storage بدلاً من حفظها محلياً.

---

## 🚀 النطوات التالية

1. ✅ استنسخ هذا المستودع
2. ✅ أضف ملفات تطبيقك
3. ✅ عدّل `.env.example`
4. ✅ ادفع إلى GitHub
5. ✅ انشر على Railway
6. ✅ افتح Cockpit وراقب الأداء

---

**احتياج مساعدة؟** تحقق من [README.md](README.md) الكامل!

🎉 **استمتع برحلتك على Railway!**
