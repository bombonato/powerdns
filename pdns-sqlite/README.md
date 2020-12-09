# PowerDNS

PowerDNS in a containter using Sqlite3 as backend

Using debian stretch-slim image base

## Versions

* PowerDNS Authoritative: **4.4.0-rc1**
* Backend: **Sqlite3**

## Sqlite3 backend

```bash
$ docker-compose up -d
$ docker-compose logs -f
```

## API

http://127.0.0.1:8053/metrics

## TODO

* Reconfigure to use more env variables
* Use sqlite3 db schema from packagage instalation (is missing)

## References

* https://doc.powerdns.com/authoritative/settings.html
* https://repo.powerdns.com/
* https://doc.powerdns.com/authoritative/backends/generic-sqlite3.html
