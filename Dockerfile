FROM alpine AS fastgithub


# Github加速版本
ENV FAST_GITHUB_VERSION 2.1.2
WORKDIR /opt


RUN apk add unzip
RUN wget https://ghproxy.com/https://github.com/dotnetcore/FastGithub/releases/download/${FAST_GITHUB_VERSION}/fastgithub_linux-x64.zip --output-document fastgithub_linux-x64.zip
RUN unzip fastgithub_linux-x64.zip
RUN mv fastgithub_linux-x64 /opt/fastgithub
RUN chmod +x /opt/fastgithub/fastgithub



# 打包真正的镜像
FROM storezhang/alpine


LABEL author="storezhang"
LABEL email="storezhang@gmail.com"
LABEL architecture="AMD64/x86_64" version="latest" build="2022-01-11"
LABEL description="Github加速神器Docker镜像，保持最新版本的Fastgithub"


# 开放端口，此端口在docer/opt/fastgithub/appsettings.json中配置
EXPOSE 8457


# 证书挂载点
VOLUME /opt/fastgithub/cacert
# 日志挂载点
VOLUME /opt/fastgithub/logs


# 复制文件
COPY --from=fastgithub /opt/fastgithub /opt/fastgithub
COPY docker /


RUN set -ex \
    \
    \
    \
    && apk update \
    \
    \
    \
    # 安装FastGithub依赖库
    && apk --no-cache add libgcc libstdc++ gcompat icu \
    \
    # 安装FastGithub并增加执行权限
    && chown ${USERNAME}:${USERNAME} -R /opt/fastgithub \
    \
    # 增加监控执行脚本权限
    && chmod +x /etc/s6/fastgithub/* \
    \
    # 增加代理转换执行权限
    && chown ${USERNAME}:${USERNAME} -R /opt/polipo \
    && chmod +x /opt/polipo/polipo \
    \
    \
    \
    # 清理镜像，减少无用包
    && rm -rf /var/cache/apk/*


ENV FASTGITHUB_HOME /config
