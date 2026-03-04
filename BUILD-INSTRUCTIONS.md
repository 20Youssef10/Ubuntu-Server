# ملف تعليمات البناء

# 1. انسخ جميع الملفات في مجلد واحد:
#    - Dockerfile
#    - docker-compose.yml
#    - railway.toml
#    - supervisord.conf
#    - nginx.conf
#    - requirements.txt
#    - package.json
#    - .dockerignore
#    - .gitignore
#    - .env.example
#    - dashboard-package.json (كـ package.json للـ dashboard)
#    - dashboard-server.mjs
#    - public-index.html (كـ public/index.html)

# 2. عدّل أسماء الملفات:
#    public-index.html  →  public/index.html
#    dashboard-package.json  →  package.json (للـ dashboard فقط)
#    dashboard-server.mjs  →  dashboard-server.mjs

# 3. إنشاء البنية الصحيحة:
#    project-root/
#    ├── Dockerfile
#    ├── docker-compose.yml
#    ├── railway.toml
#    ├── supervisord.conf
#    ├── nginx.conf
#    ├── requirements.txt
#    ├── package.json (للـ app الرئيسي)
#    ├── .dockerignore
#    ├── .gitignore
#    ├── .env.example
#    ├── dashboard/
#    │   ├── package.json (dashboard-package.json)
#    │   ├── dashboard-server.mjs
#    │   └── public/
#    │       └── index.html (public-index.html)
#    └── app/ (تطبيقك)
#        └── ... ملفاتك

# 4. للبناء محلياً:
docker-compose build

# 5. لتشغيل محلياً:
docker-compose up

# 6. للوصول:
# - Dashboard: http://localhost
# - Web Terminal: http://localhost/terminal
# - Cockpit: http://localhost/cockpit

# 7. للنشر على Railway:
git add .
git commit -m "Add Web Terminal and Dashboard"
git push origin main
# ثم على Railway.app جديد... Deploy
