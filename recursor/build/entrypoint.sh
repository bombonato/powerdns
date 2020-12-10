#!/bin/sh
set -e

if [ "$1" = "pdns_recursor" ]; then

    if [ ! -f /etc/powerdns/recursor.d/recursor.conf ]; then
        echo "quiet=${RECURSOR_QUIET:-no}" > /etc/powerdns/recursor.d/recursor.conf
    fi

    if [ ! -f /etc/powerdns/recursor.d/forward.conf ]; then
        echo "forward-zones=${RECURSOR_FORWARD_ZONES}" > /etc/powerdns/recursor.d/forward.conf
    fi

    if [ ! -f /etc/powerdns/recursor.d/api.conf ]; then
        echo "api-key=${RECURSOR_API_KEY:-pdns}" > /etc/powerdns/recursor.d/api.conf
    fi

fi

exec "$@"