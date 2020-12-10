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
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cron jq netcat && \
#    rm /etc/cron.daily/* && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 53/udp 53/tcp 8081/tcp

ADD ./build/pdns.conf /etc/powerdns/pdns.conf
ADD ./build/sqlite.conf /etc/powerdns/pdns.d/
ADD ./build/schema.sqlite3.sql /usr/share/doc/pdns-backend-sqlite3/


ADD ./build/entrypoint.sh /usr/bin/
# ADD ./build/entrypoint2.sh /usr/bin/entrypoint.sh
RUN chmod a+x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# CMD ["pdns_server","--loglevel=9"]