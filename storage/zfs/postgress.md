## this posgress sugestion

```
zfs create -o mountpoint=/data/postgres dbpool/postgres

zfs create \
  -o mountpoint=/data/postgres/data \
  -o recordsize=8K \
  -o compression=lz4 \
  -o atime=off \
  -o logbias=latency \
  -o primarycache=all \
  -o sync=standard \
  dbpool/postgres/data

zfs create \
  -o mountpoint=/data/postgres/wal \
  -o recordsize=128K \
  -o compression=lz4 \
  -o atime=off \
  -o logbias=latency \
  -o primarycache=metadata \
  -o sync=standard \
  dbpool/postgres/wal

zfs create \
  -o mountpoint=/data/postgres/temp \
  -o recordsize=128K \
  -o compression=lz4 \
  -o atime=off \
  -o logbias=throughput \
  -o primarycache=metadata \
  -o sync=disabled \
  dbpool/postgres/temp

zfs create \
  -o mountpoint=/data/postgres/logs \
  -o recordsize=1M \
  -o compression=lz4 \
  -o atime=off \
  -o logbias=throughput \
  -o primarycache=metadata \
  -o quota=100G \
  dbpool/postgres/logs
```
