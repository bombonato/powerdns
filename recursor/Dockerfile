# Package Repository: https://repo.powerdns.com/
FROM debian:stretch-slim

LABEL maintainer="Fabio Bombonato <fabio.bombonato@gmail.com>"

ENV PDNS_RECURSOR_VERSION=4.4.1

ADD ./build/pdns.list /etc/apt/sources.list.d/pdns.list
ADD ./build/pdns.preferencesd /etc/apt/preferences.d/pdns

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -q -y curl gnupg && \
    curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - && apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y pdns-recursor && \
#    rm /etc/powerdns/pdns.d/*.conf && rm /etc/powerdns/*.conf && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cron jq && \
#    rm /etc/cron.daily/* && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 53/udp 53/tcp

# ADD ./build/recursor.conf /etc/powerdns/recursor.d/recursor.conf
ADD ./build/recursor.conf /etc/powerdns/

# ADD ./build/entrypoint.sh /

# RUN chmod a+x ./entrypoint.sh
# ENTRYPOINT ["./entrypoint.sh"]
# CMD ["pdns_recursor", "--setuid=recursor", "--setgid=recursor"]
# CMD ["/etc/init.d/pdns-recursor", "start"]
ADD ./build/entrypoint.sh /usr/bin/
RUN chmod a+x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["pdns_recursor","--daemon=no"]