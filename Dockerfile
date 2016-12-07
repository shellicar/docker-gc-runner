FROM alpine:3.4
# australian timezone
RUN apk add tzdata --no-cache \
&&  cp /usr/share/zoneinfo/Australia/Melbourne /etc/localtime \
&&  apk del -r tzdata

# s6-overlay
ENV S6_VERSION v1.18.1.5
ENV S6_URL https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz

# download & extract to root
RUN apk add --no-cache curl openssl \
&&  curl -sSL ${S6_URL} | tar -C / -xzf -


WORKDIR /tmp
RUN apk add --no-cache openssl curl bash \
&&  curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-1.6.2.tgz \
&&  tar zxf docker-1.6.2.tgz \
&&  mkdir -p /usr/local/bin/ \
&&  mv $(find -name 'docker') /usr/local/bin/ \
&&  chmod +x /usr/local/bin/docker \
&&  wget https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc -O /usr/sbin/docker-gc \
&&  chmod +x /usr/sbin/docker-gc \
&&  chown root:root /usr/sbin/docker-gc


# remove unused packages & data
RUN apk del -r curl openssl \
&&  rm -rf /tmp/* \
&&  rm -rf /var/cache/apk/*



# run docker-gc hourly
ADD include/docker-gc-run /etc/periodic/hourly/
# start crond
ADD include/run_crond /etc/services.d/crond/run

RUN chmod +x /etc/periodic/hourly/docker-gc-run


# s6-overlay entry
ENTRYPOINT ["/init"]
# simple crond start
CMD []


