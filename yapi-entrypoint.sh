#!/bin/sh

set -e

# 下載安裝 YApi 主程式
if [ ! -d "/app/vendors" ]; then
  wget -qO- https://github.com/YMFE/yapi/archive/v1.4.1.tar.gz | tar xzv -C /app
  mv /app/yapi-1.4.1 /app/vendors
  # 將密碼改為由config注入
  sed -ie 's/'"'"'ymfe\.org'"'"'/yapi\.WEBCONFIG\.adminPassword/g;s/"ymfe\.org"/"\$\{yapi\.WEBCONFIG\.adminPassword\}"/g' /app/vendors/server/install.js
fi

cd /app/vendors

if [ ! -d "node_modules" ]; then
  npm install --production
fi

# 尚未初始化/未安裝
if [ ! -f "../init.lock" ]; then
  # 將帳號密碼改由環境變數注入
  if [ -n "$YAPI_ADMIN_ACCOUNT" ]; then
    sed -i -e 's/\("adminAccount": "\)[^"]*\(",\)/\1'$YAPI_ADMIN_ACCOUNT'\2/g' /app/config.json
  fi

  if [ -n "$YAPI_ADMIN_PASSWORD" ]; then
    sed -i -e 's/\("adminPassword": "\)[^"]*\(",\)/\1'$YAPI_ADMIN_PASSWORD'\2/g' /app/config.json
  fi
  # 執行安裝程序
  node server/install.js --no-deprecation
fi

# 啟動服務
node server/app.js --no-deprecation
