#!/bin/bash

# setup.sh - تنظيم الملفات للبناء الصحيح

set -e

echo "📦 تنظيم الملفات للبناء..."

# إنشاء المجلدات المطلوبة
mkdir -p dashboard/public
mkdir -p app

# نقل ملفات Dashboard
if [ -f "dashboard-package.json" ]; then
    echo "📋 نقل dashboard package.json..."
    mv dashboard-package.json dashboard/package.json
fi

if [ -f "dashboard-server.mjs" ]; then
    echo "📋 نقل dashboard-server.mjs..."
    mv dashboard-server.mjs dashboard/
fi

if [ -f "public-index.html" ]; then
    echo "📋 نقل public-index.html..."
    mv public-index.html dashboard/public/index.html
fi

# إنشاء .gitkeep للمجلدات الفارغة
touch app/.gitkeep
touch dashboard/public/.gitkeep

echo "✅ تم تنظيم الملفات بنجاح!"
echo ""
echo "البنية الآن:"
tree -L 3 || find . -type f -name "*.json" -o -name "*.mjs" -o -name "*.html" | grep -E "(dashboard|public|nginx|supervisord|railway)"
echo ""
echo "🚀 الآن يمكنك البدء:"
echo "   1. docker-compose build"
echo "   2. docker-compose up"
echo ""
