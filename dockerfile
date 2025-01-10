# 使用最新的 Ubuntu 基础镜像
FROM ubuntu-emacs:24.04-base

# 设置维护者信息
LABEL MAINTAINER="Yang Liu"

# 设置非交互模式，避免安装包时交互提示
ENV DEBIAN_FRONTEND=noninteractive

COPY resource .

RUN tar -xf emacs-*.tar.xz
RUN cd emacs-*/ && ./autogen.sh

# Configure and run
RUN cd emacs-*/ && ./configure --with-native-compilation --with-mailutils --with-json

ENV JOBS=2
RUN cd emacs-*/ && make -j ${JOBS} && make install

RUN rm -rf /opt/*

ENTRYPOINT ["/bin/bash", "-c"]

# build command
# docker build -t ubuntu-emacs:24.04 .
