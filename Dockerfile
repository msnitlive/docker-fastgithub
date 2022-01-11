FROM storezhang/alpine AS fastgithub


# Github加速版本
ENV FAST_GITHUB_VERSION 2.1.2


RUN apk add unzip
RUN wget https://ghproxy.com/https://github.com/dotnetcore/FastGithub/releases/download/${FAST_GITHUB_VERSION}/fastgithub_linux-x64.zip --output-document /fastgithub_linux-x64.zip
RUN unzip fastgithub_linux-x64.zip
RUN mv /fastgithub_linux-x64 /opt/fastgithub
RUN chmod +x /opt/fastgithub/fastgithub



# 打包真正的镜像
FROM storezhang/alpine


LABEL author="storezhang"
LABEL email="storezhang@gmail.com"
LABEL architecture="AMD64/x86_64" version="latest" build="2022-01-11"
LABEL description="Github加速神器Docker镜像，保持最新版本的Fastgithub"


# 开放端口，不可改变（程序没有提供改变端口参数）
EXPOSE 38457


# 复制文件
COPY --from=fastgithub /opt/fastgithub /opt/fastgithub
COPY docker /


RUN set -ex \
    \
    \
    \
    # 安装FastGithub并增加执行权限
    && chmod +x /etc/s6/fastgithub/* \
    \
    \
    \
    # 清理镜像，减少无用包
    && rm -rf /var/cache/apk/*
