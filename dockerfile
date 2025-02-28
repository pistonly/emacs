# 使用最新的 Ubuntu 基础镜像
FROM ubuntu-emacs:24.04-base

# 设置维护者信息
LABEL MAINTAINER="Yang Liu"

# 设置非交互模式，避免安装包时交互提示
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt

# 添加资源文件
COPY resource/emacs-*.tar.xz .

# 解压并准备 Emacs 源码
RUN tar -xf emacs-*.tar.xz
RUN cd emacs-*/ && ./autogen.sh

# 配置并安装 Emacs
RUN cd emacs-*/ && ./configure --with-native-compilation --with-mailutils --with-json
ENV JOBS=2
RUN cd emacs-*/ && make -j ${JOBS} && make install

# 清理不必要的文件
RUN rm -rf /opt/*

# 添加新的用户 liuyang，指定用户ID
RUN useradd -m -u 1001 -s /bin/bash liuyang

# 安装 sudo 并设置免密码规则
RUN apt-get update && apt-get install -y sudo \
    && mkdir -p /etc/sudoers.d \
    && echo "liuyang ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/liuyang \
    && chmod 440 /etc/sudoers.d/liuyang

# 添加字体
RUN mkdir -p /usr/share/fonts/custom
COPY resource/fonts /usr/share/fonts/custom/
RUN apt-get install -y unzip \
    && unzip '/usr/share/fonts/custom/*.zip' -d /usr/share/fonts/custom/ \
    && fc-cache -fv
RUN rm -rf /usr/share/fonts/custom/*.zip

# 设置入口点
ENTRYPOINT ["/bin/bash", "-c"]

# build command
# docker build -t ubuntu-emacs:24.04 .
