# 🖥️ Web Terminal & Dashboard Guide

## ما الجديد؟

تم إضافة **3 طرق للوصول عبر المتصفح**:

### 1️⃣ **Web Dashboard (المفضل)**
الصفحة الرئيسية بها:
- 📊 معلومات النظام الحية
- ⚙️ حالة جميع الخدمات
- 🔧 أدوات تنفيذ الأوامر
- 🖥️ ارتباطات سريعة لجميع الخدمات
- 🌐 واجهة جميلة وسهلة الاستخدام

**الرابط**: `https://your-railway-url.up.railway.app/`

---

### 2️⃣ **Web Terminal (ttyd)**
محطة طرفية كاملة عبر الويب:
- سطر أوامر كامل
- ألوان وتنسيق محسّنة
- دعم الملفات والتحميل
- أداء عالي

**الرابط**: `https://your-railway-url.up.railway.app/terminal`

---

### 3️⃣ **Cockpit Dashboard**
لوحة تحكم النظام المتقدمة:
- إدارة النظام
- مراقبة الأداء
- إدارة المستخدمين
- تشغيل الخدمات

**الرابط**: `https://your-railway-url.up.railway.app/cockpit`

---

## 🚀 البدء السريع

### الخطوة 1: انشر على Railway

نفس العملية السابقة:

```bash
git add .
git commit -m "Add Web Terminal & Dashboard"
git push origin main
```

ثم على Railway:
- New Project → Deploy from GitHub
- اختر المستودع
- اضغط Deploy

### الخطوة 2: انتظر البناء (3-5 دقائق)

يقوم البناء بـ:
1. تثبيت ttyd (Web Terminal)
2. بناء Dashboard
3. تشغيل جميع الخدمات

### الخطوة 3: الوصول للخدمات

بعد انتهاء البناء، سترى URL مثل:
```
https://ubuntu-railway-123.up.railway.app
```

**الصفحات الرئيسية:**
- 🏠 Dashboard: `/`
- 💻 Terminal: `/terminal`
- 🎛️ Cockpit: `/cockpit`

---

## 📱 استخدام Dashboard

### معلومات النظام
تظهر تلقائياً عند فتح الصفحة:
- وقت تشغيل النظام
- استخدام الذاكرة مع رسم بياني
- معلومات المعالج
- معلومات نظام التشغيل

تتحدث كل 5 ثوان تلقائياً.

### حالة الخدمات
عرض فوري لحالة:
- ✅ SSH
- ✅ Nginx
- ✅ Web Terminal
- ✅ Cockpit
- ✅ PostgreSQL
- ✅ MySQL
- ✅ Redis
- ✅ MongoDB

**إشارات التلون:**
- 🟢 أخضر = الخدمة تعمل
- 🔴 أحمر = الخدمة متوقفة

### أدوات سريعة

أزرار جاهزة لـ:

```
htop        - عرض استخدام الموارد
df -h       - مساحة التخزين
free -h     - الذاكرة المتاحة
ps aux      - العمليات الجارية
docker ps   - الحاويات
systemctl   - حالة النظام
```

### تنفيذ أوامر مخصصة

```
1. اكتب الأمر في الحقل
2. اضغط "تنفيذ"
3. شاهد النتيجة مباشرة
```

**مثال:**
```bash
# في حقل الإدخال
ls -la /app

# النتيجة
drwxr-xr-x 5 ubuntu ubuntu 4096 ...
-rw-r--r-- 1 ubuntu ubuntu 1234 ...
```

### إدارة الخدمات

أزرار لإعادة تشغيل:
- PostgreSQL
- MySQL
- Redis
- Nginx

---

## 💻 استخدام Web Terminal

### الوصول
اضغط على "Web Terminal (ttyd)" في Dashboard أو اذهب إلى `/terminal`

### المميزات
✅ محطة bash كاملة  
✅ دعم جميع الأوامر  
✅ تحميل الملفات  
✅ تنزيل الملفات  
✅ ألوان محسّنة  
✅ استجابة سريعة  

### أوامر مفيدة

```bash
# التحقق من الخدمات
service postgresql status
service mysql status
redis-cli PING

# إدارة الملفات
cd /app
ls -la
mkdir folder
cp file1 file2

# إدارة النظام
htop
top
free -h
df -h

# إدارة قواعد البيانات
psql -U postgres -d railway_db
mysql -u root -p

# تشغيل تطبيقات
npm start
python3 app.py
node server.js
```

---

## 🎛️ استخدام Cockpit

### الوصول
اضغط على "Cockpit Dashboard" في Dashboard أو اذهب إلى `/cockpit`

### المميزات الرئيسية

**📊 لوحة التحكم**
- معلومات النظام الحية
- استهلاك الموارد
- سجلات الأحداث

**👥 إدارة المستخدمين**
- إضافة مستخدمين
- تغيير كلمات المرور
- إدارة الأذونات

**🔧 الخدمات**
- عرض الخدمات
- بدء/إيقاف/إعادة تشغيل
- تفعيل/تعطيل

**📝 السجلات**
- سجلات النظام
- سجلات الخدمات
- سجلات الأمان

---

## 🔒 الأمان

### كلمات المرور الافتراضية

⚠️ **غيّرها فوراً!**

```bash
# المستخدم ubuntu
sudo passwd ubuntu

# جذر PostgreSQL
sudo -u postgres psql
ALTER ROLE postgres WITH PASSWORD 'new_password';

# جذر MySQL
mysqladmin -u root password 'new_password'
```

### مفاتيح SSH

لإضافة مفتاح SSH آمن:

```bash
# من الداخل (عبر Web Terminal)
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# ألصق مفتاحك العام

# غيّر الأذونات
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

## 📊 مراقبة الأداء

### استخدام Dashboard
الطريقة الأسهل - كل شيء مرئي

### استخدام Web Terminal
```bash
# عرض فوري
htop

# الذاكرة
free -h

# التخزين
df -h

# العمليات الثقيلة
top -b -n 1 | head -20

# استهلاك الشبكة
iotop -b -n 1
```

### استخدام Cockpit
اضغط على "System" → عرض رسوم بيانية تفصيلية

---

## 🐛 استكشاف الأخطاء

### Terminal لا يعمل
```bash
# عبر Dashboard، نفّذ:
service ttyd restart

# أو من السجلات:
tail -f /var/log/ttyd.log
```

### Dashboard بطيء
```bash
# تحقق من الموارد
free -h
top -b -n 1

# أعد التشغيل
systemctl restart node
```

### خدمة لا تستجيب
```bash
# شاهد السجلات
journalctl -u service_name -n 50

# أعد التشغيل
sudo systemctl restart service_name
```

---

## 🔄 التحديث و الصيانة

### تحديث التطبيق
```bash
# عبر Web Terminal
cd /app
git pull
npm install  # أو pip install

# أعد التشغيل
pm2 restart app
```

### النسخ الاحتياطية
```bash
# PostgreSQL
pg_dump -U postgres railway_db > backup.sql

# Redis
redis-cli BGSAVE

# ملفات التطبيق
tar -czf app-backup.tar.gz /app
```

---

## 📈 نصائح الأداء

### استخدام الموارد بحكمة
```bash
# شاهد الخدمات الثقيلة
ps aux --sort=-%mem | head -10

# أوقف الخدمات غير المستخدمة
sudo systemctl stop mongodb
sudo systemctl disable mongodb
```

### تحسين قاعدة البيانات
```bash
# PostgreSQL
VACUUM ANALYZE;
CREATE INDEX idx_name ON table(column);

# MySQL
OPTIMIZE TABLE table_name;
ANALYZE TABLE table_name;
```

---

## 🎓 أمثلة عملية

### تشغيل تطبيق Node.js جديد
```bash
# عبر Web Terminal
cd /app
npm init -y
npm install express
cat > server.js << 'EOF'
import express from 'express';
const app = express();
app.get('/', (req, res) => res.send('Hello!'));
app.listen(3000);
EOF

node server.js
```

### تشغيل Python Flask
```bash
# عبر Web Terminal
cd /app
python3 -m venv venv
source venv/bin/activate
pip install flask
cat > app.py << 'EOF'
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return 'Hello World'
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
EOF

python3 app.py
```

### إنشاء قاعدة بيانات جديدة
```bash
# عبر Web Terminal
psql -U postgres

CREATE DATABASE myapp_db;
CREATE USER myapp_user WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE myapp_db TO myapp_user;
```

---

## 🚀 البوابات المتاحة

| البوابة | الخدمة | الوصول |
|--------|--------|--------|
| 22 | SSH | `ssh ubuntu@url` |
| 80 | Nginx/Dashboard | `/` |
| 443 | HTTPS | `/` (اختياري) |
| 3000 | تطبيقك | `/app` |
| 3001 | Dashboard | `/` |
| 5432 | PostgreSQL | من الداخل فقط |
| 3306 | MySQL | من الداخل فقط |
| 6379 | Redis | من الداخل فقط |
| 7681 | Web Terminal | `/terminal` |
| 9090 | Cockpit | `/cockpit` |

---

## 💬 دعم وتواصل

### عند حدوث مشاكل:

1. **فحص السجلات**
   ```bash
   # عبر Dashboard
   runCommand('tail -f /var/log/syslog')
   ```

2. **إعادة التشغيل**
   ```bash
   runCommand('sudo systemctl restart service_name')
   ```

3. **عرض الموارد**
   ```bash
   runCommand('htop -b -n 1')
   ```

---

## 📚 مراجع إضافية

- [ttyd Documentation](https://github.com/tsl0922/ttyd)
- [Cockpit Project](https://cockpit-project.org/)
- [Ubuntu Manuals](https://help.ubuntu.com)
- [Railway Docs](https://docs.railway.app)

---

**استمتع بإدارة Ubuntu من متصفحك! 🎉**
