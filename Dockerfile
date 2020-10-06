FROM 0x01be/openvas:build as build

FROM alpine

COPY --from=build /opt/gvm/ /opt/gvm/
COPY --from=build /opt/openvas/ /opt/openvas/

RUN apk add --no-cache --virtual openvas-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    glib \
    gnutls \
    gvm-libs \
    libpcap \
    libssh \
    gpgme \
    libksba \
    libgcrypt

ENV LD_LIBRARY_PATH "/usr/lib:/opt/openvas/lib/:/opt/gvm/lib/"
ENV PATH ${PATH}:/opt/openvas/bin/

CMD ["openvas-nasl", "--help"]

