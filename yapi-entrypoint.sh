#!/bin/sh

set -e

if [ ! -d "/app/vendors" ]; then
  wget -qO- https://github.com/YMFE/yapi/archive/v1.4.1.tar.gz | tar xzv -C /app
  mv /app/yapi-1.4.1 /app/vendors
  sed -ie 's/'"'"'ymfe\.org'"'"'/yapi\.WEBCONFIG\.adminPassword/g;s/"ymfe\.org"/"\$\{yapi\.WEBCONFIG\.adminPassword\}"/g' /app/vendors/server/install.js
fi

cd /app/vendors

if [ ! -d "node_modules" ]; then
  npm install --production
fi

if [ ! -f "../init.lock" ]; then
  if [ -n "$YAPI_ADMIN_ACCOUNT" ]; then
    sed -i -e 's/\("adminAccount": "\)[^"]*\(",\)/\1'$YAPI_ADMIN_ACCOUNT'\2/g' /app/config.json
  fi

  if [ -n "$YAPI_ADMIN_PASSWORD" ]; then
    sed -i -e 's/\("adminPassword": "\)[^"]*\(",\)/\1'$YAPI_ADMIN_PASSWORD'\2/g' /app/config.json
  fi
  node server/install.js --no-deprecation
fi

node server/app.js --no-deprecation
