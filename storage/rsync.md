```bash
sudo rsync -aHAX --numeric-ids \
  /opt/berachain/var/beacond/ \
  /beacond/

systemctl stop beacond

sudo rsync -aHAX --delete --numeric-ids \
  /opt/berachain/var/beacond/ \
  /beacond/

```
