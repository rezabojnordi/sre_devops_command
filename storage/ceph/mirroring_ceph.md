# RBD Mirroring
## Cluster 1
``` bash
ceph osd pool create rbdrep 32 32

ceph osd pool application enable rbdrep rbd

ceph shell
rbd pool init -p rbdrep

rbd create image1 --size 1024 --pool rbdrep --image-feature=exclusive-lock,journaling

rbd -p rbdrep ls

rbd --image image1 info -p rbdrep

rbd mirror pool enable rbdrep pool

rbd --image -mage1 info -p rbdrep
exit
mkdir /root/mirror
ceph shell --mount /root/mirror/

rbd mirror pool peer bootstrap create --site-name prod rbdrep > /mnt/bootstrap_token_prod

more /mnt/bootstrap_token_prod

exit

apt install rsync


rsync -avP /root/mirror/bootstrap_token_prod cluster2:/root/bootstrap_token_prod

rbd mirror pool info rbdrep

rbd mirror pool status -p rbdrep
```

## cluster 2
``` bash
ceph osd pool rbdrep 32 32
ceph osd pool application enable rbdrep rbd

apt install rsync

cephadm shell --mount /root/bootstrap_token_prod

cd /mnt
ls

ceph orch apply rbd-mirror --placement=s2mon1.ceph.example.com

ceph  orch ls

rbd mirror pool peer bootstrap import --site-name bup --direction rx-only rbdrep /mnt/bootstrap_token_prod


rbd ls -p rbdrep

rbd mirror pool info rbdrep

rbd mirror pool status -p rbdrep
```

