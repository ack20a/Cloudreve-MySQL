# 使用 Alpine 作为基础镜像
FROM alpine:latest

# 设置工作目录
WORKDIR /cloudreve

# 安装必要的软件包：curl 用于下载 Cloudreve，tzdata 用于设置时区，mysql-client 用于连接 MySQL
RUN apk update && \
    apk add --no-cache curl tzdata mysql-client && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 从 GitHub Releases 下载最新版的 Cloudreve
ARG CLOUDREVE_VERSION="latest"
RUN if [ "$CLOUDREVE_VERSION" = "latest" ]; then \
        CLOUDREVE_VERSION=$(curl -s https://api.github.com/repos/cloudreve/Cloudreve/releases/latest | grep 'tag_name' | cut -d\" -f4); \
    fi && \
    echo "Downloading Cloudreve version: $CLOUDREVE_VERSION" && \
    curl -sL https://github.com/cloudreve/Cloudreve/releases/download/$CLOUDREVE_VERSION/cloudreve_${CLOUDREVE_VERSION}_linux_amd64.tar.gz | tar -zx && \
    chmod +x cloudreve

# 暴露端口
EXPOSE 5212

# 启动脚本
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
