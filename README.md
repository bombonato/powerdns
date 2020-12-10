# PowerDNS

PowerDNS in a containter way.

Using debian stretch-slim image base

## Versions

* PowerDNS Authoritative: **4.4.0-rc1**
* Authoritative Backend: **Sqlite3**
* PowerDNS Recursor: **4.4.0-rc1**

## Sqlite3 backend

```bash
$ cd pdns-sqlite/
$ docker-compose up -d
$ docker-compose logs -f
```

## API

PDNS Authoritative
http://127.0.0.1:5381/metrics
PDNS Recursor
http://127.0.0.1:5382/


## Containter Build

```bash
$ cd authoritative
$ docker build --tag bombonato/powerdns:latest-auth-sqlite .
```

```bash
$ cd recursor
$ docker build --tag bombonato/powerdns:latest-rec .
```

## TODO


* Reconfigure to use more env variables
* Enable WebServer password
* Get API-KEY from env
* Use sqlite3 db schema from packagage instalation (is missing!?)
* Enable dnnsec
* Configure metrics to Prometheus (4.4 new feature!?)
* Configure ExternalDNS integration
* Configure backend to MySQL
* Configure backend to Postresql

## References

* https://doc.powerdns.com/authoritative/guides/recursion.html
* https://doc.powerdns.com/authoritative/backends/generic-sqlite3.html
* https://repo.powerdns.com/
* https://doc.powerdns.com/authoritative/settings.html
* https://doc.powerdns.com/recursor/settings.html
* https://hub.docker.com/r/chrisss404/powerdns
* https://hub.docker.com/r/interlegis/powerdns
* https://hub.docker.com/r/psitrax/powerdns
