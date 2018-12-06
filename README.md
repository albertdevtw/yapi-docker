# YApi

> 可視化接口管理平台

https://github.com/YMFE/yapi

#### 環境要求
* nodejs（7.6+)
* mongodb（2.6+）

## 初次安裝前

修改 `docker-compose.yml`

### 1 登入帳號

郵箱：

    YAPI_ADMIN_ACCOUNT: admin@admin.com

密碼：

    YAPI_ADMIN_PASSWORD: ymfe.org

### ports (非必需)

預設為：

* web: 3000
* mongodb: 3001

可以改成喜歡的 posts

## 啟動 docker

``` bash
DOCKERUSER="$(id -u):$(id -g)" docker-compose up -d
```

初次啟動安裝會需要比較常的時間，可透過 ` docker-compose logs -f yapi` 檢視安裝進度

直到出現以下訊息表示啟動完成

    服务已启动，请打开下面链接访问:
    http://127.0.0.1:3000/


訪問 `localhost:3000` 檢視

## 移除專案

``` bash
# 移除 docker
docker-compose down

# 移除資料庫
rm -rf app/init.lock app/log mongo/*
```
