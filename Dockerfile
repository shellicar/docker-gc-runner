FROM shellicar/alpine-base:latest
MAINTAINER Stephen Hellicar (https://github.com/shellicar) <s.hellicar@gmail.com>

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
&&  chown root:root /usr/sbin/docker-gc \
&&  apk del -r curl openssl \
&&  rm -rf /tmp/* \
&&  rm -rf /var/cache/apk/*



ADD scripts/docker-gc-run /etc/periodic/hourly/
ADD ./services.d /etc/services.d
RUN chown root:root -R /etc/services.d

RUN rm -rf /tmp/*

