# PowerDNS

PowerDNS in a containter way.

Using debian stretch-slim image base

## Versions

* PowerDNS Authoritative: **4.4.0-rc1**
* Backend: **Sqlite3**

## Sqlite3 backend

```bash
$ cd pdns-sqlite/
$ docker-compose up -d
$ docker-compose logs -f
```

## API

http://127.0.0.1:8053/metrics

## TODO

* Reconfigure to use more env variables
* Use sqlite3 db schema from packagage instalation (is missing)
* Configure metrics to Prometheus
* Configure ExternalDNS integration
* Configure backend to MySQL
* Configure backend to Postresql

## References

* https://doc.powerdns.com/authoritative/settings.html
* https://repo.powerdns.com/
* https://doc.powerdns.com/authoritative/backends/generic-sqlite3.html
* https://hub.docker.com/r/interlegis/powerdns
* https://hub.docker.com/r/psitrax/powerdns
