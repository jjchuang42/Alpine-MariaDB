FROM yobasystems/alpine:3.10.1-amd64

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*

RUN apk --no-cache add \
    supervisor

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD scripts/run.sh /scripts/run.sh
RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]