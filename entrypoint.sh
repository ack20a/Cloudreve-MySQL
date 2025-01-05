#!/bin/sh

# 生成配置文件
if [ ! -f /cloudreve/conf.ini ]; then
cat <<EOF > /cloudreve/conf.ini
[System]
Mode = master
Listen = :5212
Debug = false
SessionSecret = $(openssl rand -base64 32)
HashIDSalt = $(openssl rand -base64 32)
ProxyHeader = X-Forwarded-For

[Database]
Type = $DATABASE_TYPE
Port = $DATABASE_PORT
User = $DATABASE_USER
Password = $DATABASE_PASSWORD
Host = $DATABASE_HOST
Name = $DATABASE_NAME
TablePrefix = $DATABASE_TABLE_PREFIX
Charset = $DATABASE_CHARSET
DBFile = cloudreve.db
GracePeriod = 30
UnixSocket = false

[Redis]
Server = 
Password =
DB = 0
EOF
fi

# 启动 Cloudreve
./cloudreve
