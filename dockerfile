FROM ubuntu:22.04  # or FROM ubuntu:18.04

# We assume the git repo's cloned outside and copied in, instead of
# cloning it in here. But that works, too.
WORKDIR /opt
COPY Resources .

LABEL MAINTAINER "Yang Liu"

RUN chmod 755 Mirror_conf.sh \
&& ./Mirror_conf.sh

# Needed for add-apt-repository, et al.
#
# If you're installing this outside Docker you may not need this.
RUN apt-get update \
        && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

# ubuntu:22.04 has gcc-11
RUN apt-get isntall -y libgccjit0 libgccjit-11-dev

# Needed for fast JSON and the configure step
RUN apt-get install -y libjansson4 libjansson-dev git

# Shut up debconf as it'll fuss over postfix for no good reason
# otherwise. If you're doing this outside Docker, you do not need to
# do this.
ENV DEBIAN_FRONTEND=noninteractive

# Cheats' way of ensuring we get all the build deps for Emacs without
# specifying them ourselves. Enable source packages then tell apt to
# get all the deps for whatever Emacs version Ubuntu supports by
# default.
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get build-dep -y emacs

# Needed for compiling libgccjit or we'll get cryptic error messages
# about failing smoke tests.

# Configure and run
RUN ./autogen.sh \
        && ./configure --with-native-compilation --with-mailutils --with-json

ENV JOBS=2
RUN make -j ${JOBS} && make install

ENTRYPOINT ["emacs"]
