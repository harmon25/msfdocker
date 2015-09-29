# msfdocker
Run Metasploit Framework in a container - msfconsole, msfrpcd or an interactive shell

- Can be used with a postgres container for database functionality

```bash
docker run --name msfdb -v ~/pgdata:/pgdata \
  -e POSTGRES_PASSWORD=astrongpass \
  -e PGDATA=/pgdata \
  postgres:9.4
```

## msfrpcd mode
```bash
docker run --name msfdocked \
  --link msfdb:msfdb \
  -e MODE=rpc \
  -e MSF_DB_USER=msf \
  -e MSF_DB_PASS=msfdbpass \
  -e MSF_DB=msfdb \
  -e MSF_RPCD_USER=msfUser \
  -e MSF_RPCD_PASS=agoodPass \
  harmon25/msfdocker
```

## interactive msfconsole mode
```bash
docker run --name msfdocked \
  -it \
  --link msfpgdb:msfdb \
  -e MODE=cli \
  -e MSF_DB_USER=msf \
  -e MSF_DB_PASS=msfdbpass \
  -e MSF_DB=msfdb \
  harmon25/msfdocker
```

## interactive bash mode
```bash
docker run --name msfdocked \
  -it \
  --link msfdb:msfdb \
  -e MSF_DB_USER=msf \
  -e MSF_DB_PASS=msfdbpass \
  -e MSF_DB=msfdb \
  harmon25/msfdocker
```
