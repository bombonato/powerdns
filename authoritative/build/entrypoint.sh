#!/bin/bash
set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
# source: https://github.com/docker-library/mariadb/blob/master/docker-entrypoint.sh
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo "Both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

# Loads various settings that are used elsewhere in the script
docker_setup_env() {
    # Initialize values that might be stored in a file
    file_env 'POWERDNS_VERSION' $POWERDNS_VERSION
    file_env 'AUTH_API_KEY' $AUTH_API_KEY
}

docker_setup_env

# --help, --version
[ "$1" = "--help" ] || [ "$1" = "--version" ] && exec pdns_server $1
# treat everything except -- as exec cmd
[ "${1:0:2}" != "--" ] && exec "$@"

sqlite3_check_db_init() {
    if [ ! -f "/var/lib/powerdns/pdns.sqlite3" ]; then
        echo "Sqlite DB not found! Creating Sqlite DB from Schema..."
        sqlite3 /var/lib/powerdns/pdns.sqlite3 < /usr/share/doc/pdns-backend-sqlite3/schema.sqlite3.sql
        chown pdns:pdns /var/lib/powerdns/pdns.sqlite3
    fi
}

sqlite3_check_db_init

config_init() {
    if [ ! -f /etc/powerdns/pdns.d/auth.conf ]; then
        echo "Creating auth.conf..."
        echo "loglevel=${AUTH_LOGLEVEL:-4}" > /etc/powerdns/pdns.d/auth.conf
        echo "log-dns-details=${AUTH_LOGDNS_DETAILS:-no}" >> /etc/powerdns/pdns.d/auth.conf
        echo "log-dns-queries=${AUTH_LOGDNS_QUERIES:-no}" >> /etc/powerdns/pdns.d/auth.conf
        echo "allow-dnsupdate-from=${AUTH_ALLOW_DNSUPDATE_FROM:-127.0.0.0/8,::1}" >> /etc/powerdns/pdns.d/auth.conf
    fi

    if [ ! -f /etc/powerdns/pdns.d/api.conf ]; then
        echo "Creating api.conf..."
        echo "api=${AUTH_API:-no}" > /etc/powerdns/pdns.d/api.conf
        echo "api-key=${AUTH_API_KEY:-pdns}" >> /etc/powerdns/pdns.d/api.conf
        echo "webserver=${AUTH_WEBSERVER:-no}" >> /etc/powerdns/pdns.d/api.conf
        echo "webserver-address=0.0.0.0" >> /etc/powerdns/pdns.d/api.conf
        echo "webserver-allow-from=0.0.0.0/0,::/0" >> /etc/powerdns/pdns.d/api.conf
        #echo "webserver-password=${AUTH_WEBSERVER_PASSWORD:-pdns}" >> /etc/powerdns/pdns.d/api.conf
    fi
}

config_init 

# Run pdns server
trap "pdns_control quit" SIGHUP SIGINT SIGTERM

# Start PowerDNS
echo "Starting PowerDNS..."
# using parameters or same as init.d/pdns monitor
pdns_start(){
    if [ "$#" -gt 0 ]; then
        exec pdns_server "$@" &
    else
        echo "...using MONITOR Mode"
        exec pdns_server --daemon=no --guardian=no --control-console --loglevel=9
    fi
}

pdns_start

wait

# exec "$@"