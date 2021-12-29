# galera cluster

<img src="./mariadb.png" width="600" height="300" />


* DB 1	node1	172.20.5.200
* DB 2	node2	172.20.5.201
* DB3	node3	172.20.5.202

```

sudo apt update && sudo apt upgrade -y


sudo apt install software-properties-common -y

curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --os-type=ubuntu  --os-version=focal --mariadb-server-version=10.6


wget http://ftp.us.debian.org/debian/pool/main/r/readline5/libreadline5_5.2+dfsg-3+b13_amd64.deb
sudo dpkg -i libreadline5_5.2+dfsg-3+b13_amd64.deb


sudo apt update
sudo apt install mariadb-server mariadb-client

sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo mysql_secure_installation

sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
#bind-address            = 127.0.0.1
```
### node1

```
$ sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
```
```
[galera]
wsrep_on                 = ON
wsrep_cluster_name       = "MariaDB Galera Cluster"
wsrep_provider           = /usr/lib/galera/libgalera_smm.so
wsrep_cluster_address    = "gcomm://"
binlog_format            = row
default_storage_engine   = InnoDB
innodb_autoinc_lock_mode = 2
bind-address = 0.0.0.0
wsrep_node_address="node1"

```
```
sudo galera_new_cluster
sudo systemctl restart mariadb 
```
# node2

```
$ sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
[galera]
wsrep_on                 = ON
wsrep_cluster_name       = "MariaDB Galera Cluster"
wsrep_provider           = /usr/lib/galera/libgalera_smm.so
wsrep_cluster_address    = "gcomm://node1,node2,node3"
binlog_format            = row
default_storage_engine   = InnoDB
innodb_autoinc_lock_mode = 2
bind-address = 0.0.0.0
wsrep_node_address="node2"
```
```
sudo systemctl restart mariadb 
```
# node3

```
$ sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
[galera]
wsrep_on                 = ON
wsrep_cluster_name       = "MariaDB Galera Cluster"
wsrep_provider           = /usr/lib/galera/libgalera_smm.so
wsrep_cluster_address    = "gcomm://node1,node2,node3"
binlog_format            = row
default_storage_engine   = InnoDB
innodb_autoinc_lock_mode = 2
bind-address = 0.0.0.0
wsrep_node_address="node3"
```
```
systemctl restart mariadb
```

# node1

```
 mysql -u root -p
```
```
MariaDB [(none)]> show status like 'wsrep_%'; 

```
* results
```
wsrep_cluster_size    3
```

# node1

```
create database test1;
```
# node2 node3
```
mysql
show databases;
```

# Step 6: Install ProxySQL server

PASS


# MASTER AND SLAVE

* Master MySQL Server: 10.131.74.92
* Slave MySQL Server:  10.131.35.167




