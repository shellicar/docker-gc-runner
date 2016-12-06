FROM alpine:3.4
ENV S6_VERSION v1.18.1.5
ENV S6_URL https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz

RUN apk add --no-cache --virtual .deps curl openssl \
&&  curl -sSL ${S6_URL} | tar -C / -xzf - \
&&  apk del -r .deps

RUN apk add tzdata --no-cache \
&&  cp /usr/share/zoneinfo/Australia/Melbourne /etc/localtime \
&&  apk del -r tzdata

WORKDIR /tmp
RUN apk add --no-cache openssl curl bash \
&&  curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-1.6.2.tgz \
&&  ls \
&&  tar zxf docker-1.6.2.tgz \
&&  mkdir -p /usr/local/bin/ \
&&  mv $(find -name 'docker') /usr/local/bin/ \
&&  chmod +x /usr/local/bin/docker \
&&  wget https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc -O /usr/sbin/docker-gc \
&&  chmod +x /usr/sbin/docker-gc \
&&  chown root:root /usr/sbin/docker-gc

ADD scripts/docker-gc-run /etc/periodic/hourly/
RUN chmod +x /etc/periodic/hourly/docker-gc-run

RUN rm -rf /tmp/*




RUN apk del -r curl openssl \
&&  rm -rf /tmp/* \
&&  rm -rf /var/cache/apk/*

ENTRYPOINT ["/init"]
CMD ["/usr/sbin/crond", "-f"]

