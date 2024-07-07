# percona Monitoring and management

## easy install
```
https://www.percona.com/doc/percona-monitoring-and-management/2.x/setting-up/server/easy-install.html

```

```
curl -fsSL -O https://raw.githubusercontent.com/percona/pmm/main/get-pmm.sh \
-O https://raw.githubusercontent.com/percona/pmm/main/.sha256-oneline && \
shasum -a 256 .sha256-oneline -c && \
chmod +x ./get-pmm.sh && \
./get-pmm.sh

```
* another source to install

```
https://www.percona.com/doc/percona-monitoring-and-management/2.x/setting-up/server/docker.html
```

## deploying PMM Client

```
wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
dpkg -i percona-release_latest.generic_all.deb
apt update
apt install -y pmm2-client
//Check
pmm-admin --version

pmm-admin config --server-insecure-tls --server-url=https://admin:admin@X.X.X.X:443

```


## add your mysql server on percona

```
# Commands
apt install curl
apt --fix-broken install
wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
dpkg -i percona-release_latest.generic_all.deb
apt update
apt install -y pmm2-client
pmm-admin config --server-insecure-tls --server-url=https://admin:admin@172.16.106.20:443
pmm-admin add mysql --query-source=perfschema --username=pmm --password=pass INFRA2_GALERA
```
```
vim My.cnf

# Add This to My.cnf
query_response_time_stats=ON
userstat=ON
performance_schema=ON
performance-schema-instrument='statement/%=ON'
performance-schema-consumer-statements-digest=ON
innodb_monitor_enable=all
```


* source

https://www.percona.com/doc/percona-monitoring-and-management/2.x/setting-up/client/mysql.html


