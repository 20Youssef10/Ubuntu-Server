# Ubuntu Browser Lab — Ready-for-deploy

محتوى الحزمة هذه يُشغّل بيئة تطوير متكاملة داخل الحاوية:
- Ubuntu 24.04 مع سطح مكتب XFCE (مُتاح عبر noVNC).
- Terminal في المتصفح عبر **ttyd**.
- محرر VS Code في المتصفح (code-server).
- File Browser (واجهة ويب لإدارة الملفات).
- Git و Python مثبتان.
- جميع الخدمات مُدارة بواسطة **supervisord** (autorestart).
- مجلد العمل الدائم: `/workspace` — ربطه مع Volumes في واجهة الـ cloud.

> لا تنس: هذه الحاوية مُصمّمة للنشر على منصة تدعم Docker (مثل رابط النشر في لوحة :contentReference[oaicite:1]{index=1}). لخيار الوصول الآمن: عدّل كلمات السر عبر متغيرات البيئة.

## خطوات النشر (مختصر)
1. أنشئ repository وضع الملفات الخمسة.
2. في إعدادات الـ service على لوحة المنصة، أضف Volume ووجهه إلى `/workspace` (هذا يضمن persistence).
3. عيّن متغيرات البيئة (Environment variables) عند الحاجة:
   - `VNC_PASSWORD` (مثلاً: strong_vnc_pass)
   - `CODE_PASSWORD` (مثلاً: strong_code_pass)
4. اربط الريبو مع خدمة Deploy from Git / Docker وادفع للتشغيل.

## الروابط/المنافذ (داخل الحاوية → خارجي يعتمد على تكوين الـ platform)
- Desktop (noVNC): `http://<app-host>:6080` → يعرض سطح المكتب XFCE عبر المتصفح.
- Web terminal (ttyd): `http://<app-host>:7681` → واجهة تيرمنال.
- VS Code Server: `http://<app-host>:8080` → قُم بتسجيل الدخول بكلمة المرور `CODE_PASSWORD`.
- File Browser: `http://<app-host>:8090` → إدارة الملفات داخل `/workspace`.
- VNC (RFB): `5901` (غير مباشر عادة؛ يستخدم noVNC للوصول عبر الويب).

## Git integration
يمكنك استخدام Git من داخل التيرمنال أو عبر واجهة Source Control داخل code-server. المسار الافتراضي للمشاريع: `/workspace`.

## أمثلة أوامر بعد الدخول
```bash
# تحديث الحزم
sudo apt update && sudo apt upgrade -y

# تثبيت حزم Python في بيئة المستخدم
python3 -m venv /workspace/venv
source /workspace/venv/bin/activate
pip install -U pip setuptools

# استنساخ مشروع
cd /workspace
git clone https://github.com/you/your-repo.git
