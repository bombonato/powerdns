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