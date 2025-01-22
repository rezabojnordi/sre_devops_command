sudo ceph -s

sudo ceph osd df | grep hdd | awk '{sum += $4} END {print "HDD - Weight sum: "sum,"\tAve: "sum/NR}'
sudo ceph osd df | grep ssd | awk '{sum += $4} END {print "SSD - Weight sum: "sum,"\tAve: "sum/NR}'
echo ""
sudo ceph osd df | grep hdd | awk '{sum += $17} END {print "HDD - Average OSD usage: "sum/NR}'
sudo ceph osd df | grep ssd | awk '{sum += $17} END {print "SSD - Average OSD usage: "sum/NR}'
echo ""
echo "HDD - OSDs % usage difference: $(sudo ceph osd df | grep hdd | sort -nk17 | awk 'NR==1{first=$17} END{print $17-first}')"
echo "SSD - OSDs % usage difference: $(sudo ceph osd df | grep ssd | sort -nk17 | awk 'NR==1{first=$17} END{print $17-first}')"
echo ""
echo "POOL           ID   PGS   STORED  OBJECTS     USED  %USED  MAX AVAIL"
sudo ceph df | grep -e volumes -e cinder -e kube
echo ""
echo "ID   CLASS   WEIGHT   REWEIGHT  SIZE     RAW USE   DATA      OMAP     META     AVAIL    %USE   VAR   PGS  STATUS"
sudo ceph osd df | sort -nk17 | tail
#sudo ceph status --format json | jq -r '.pgmap.misplaced_ratio * 100'
