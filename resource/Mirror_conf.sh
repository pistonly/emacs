# Copyright (c) Shenshu Technologies Co., Ltd. 2022-2022. All rights reserved.
# V1.0.1

#!/bin/bash
# Mirror source configuration

# The following configuration of mirror sources is for reference only.
# You need to configure proper mirror sources based on your environment requirements.
# Configure the image source according to the following example to ensure that the software package can be downloaded during image construction.

############## Modify the following information as required .##################

cp -a /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i "s@http://.*archive.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list
sed -i "s@http://.*security.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list

mkdir -p /root/.pip/
echo '[global]' >> /root/.pip/pip.conf
echo 'trusted-host=mirrors.aliyun.com' >> /root/.pip/pip.conf
echo 'index-url=http://mirrors.aliyun.com/pypi/simple' >> /root/.pip/pip.conf
