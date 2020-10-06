FROM 0x01be/gvm as build

RUN apk add --no-cache --virtual openvas-build-dependencies \
    git \
    build-base \
    cmake \
    pkgconfig

ENV OPENVAS_REVISION master
RUN git clone --depth 1 --branch ${OPENVAS_REVISION} https://github.com/greenbone/openvas.git /openvas

WORKDIR /openvas/build

RUN apk add --no-cache --virtual openvas-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    glib-dev \
    gnutls-dev \
    gvm-libs-dev \
    libpcap-dev \
    libssh-dev \
    gpgme-dev \
    libksba-dev \
    libgcrypt-dev \
    libexecinfo-dev \
    bison

ENV PKG_CONFIG_PATH /opt/gvm/lib/pkgconfig
ENV LD_LIBRARY_PATH /opt/gvm/lib/:/usr/lib/

RUN sed -i.bak 's/malloc_trim (0);//g' /openvas/src/pluginscheduler.c
RUN sed -i.bak 's/^.*backtrace.*$//g' /openvas/src/sighand.c
ENV CFLAGS "${CFLAGS} -Wno-unused-variable -Wno-maybe-uninitialized -Wno-uninitialized"
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/openvas \
    ..
RUN make install

