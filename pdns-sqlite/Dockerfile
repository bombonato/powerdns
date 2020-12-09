# Package Repository: https://repo.powerdns.com/
FROM debian:stretch-slim

LABEL maintainer="Fabio Bombonato <fabio.bombonato@gmail.com>"

ENV POWERDNS_VERSION=4.4.0-rc1

ADD ./build/pdns.list /etc/apt/sources.list.d/pdns.list
ADD ./build/pdns.preferencesd /etc/apt/preferences.d/pdns

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -q -y curl gnupg && \
    curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - && apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y pdns-server pdns-backend-sqlite3 sqlite3 && \
#    rm /etc/powerdns/pdns.d/*.conf && rm /etc/powerdns/*.conf && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cron jq && \
#    rm /etc/cron.daily/* && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 53/udp 53/tcp

ADD ./build/pdns.conf /etc/powerdns/pdns.conf
ADD ./build/api.conf /etc/powerdns/pdns.d/api.conf
ADD ./build/sqlite.conf /etc/powerdns/pdns.d/sqlite.conf

ADD ./build/api.conf ./build/sqlite.conf /etc/powerdns/pdns.d/
ADD ./build/schema.sqlite3.sql /usr/share/doc/pdns-backend-sqlite3/
ADD ./build/entrypoint.sh /

RUN chmod a+x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]