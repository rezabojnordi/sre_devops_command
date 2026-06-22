## this mysql sugestion

```bash
zfs create -o mountpoint=/data/mysql dbpool/mysql

zfs create \
  -o mountpoint=/data/mysql/data \
  -o recordsize=16K \
  -o compression=lz4 \
  -o atime=off \
  -o logbias=latency \
  -o primarycache=metadata \
  -o sync=standard \
  dbpool/mysql/data

zfs create \
  -o mountpoint=/data/mysql/tmp \
  -o recordsize=128K \
  -o compression=lz4 \
  -o atime=off \
  -o logbias=throughput \
  -o primarycache=metadata \
  -o sync=disabled \
  dbpool/mysql/tmp

zfs create \
  -o mountpoint=/data/mysql/binlog \
  -o recordsize=128K \
  -o compression=lz4 \
  -o atime=off \
  -o logbias=throughput \
  -o primarycache=metadata \
  -o sync=standard \
  dbpool/mysql/binlog

zfs create \
  -o mountpoint=/data/mysql/logs \
  -o recordsize=1M \
  -o compression=lz4 \
  -o atime=off \
  -o logbias=throughput \
  -o primarycache=metadata \
  -o quota=100G \
  dbpool/mysql/logs
```

```bash
chown -R mysql:mysql /data/mysql
```

```bash
[mysqld]
datadir=/data/mysql/data
tmpdir=/data/mysql/tmp

log_bin=/data/mysql/binlog/mysql-bin
server_id=1
binlog_format=ROW
sync_binlog=1

log_error=/data/mysql/logs/error.log
slow_query_log=1
slow_query_log_file=/data/mysql/logs/slow.log

innodb_buffer_pool_size=64G
innodb_flush_log_at_trx_commit=1
```
