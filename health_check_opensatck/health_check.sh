!/bin/sh

### OTHER SAMPLES ###
#ansible neutron_server_container -m shell -a "ps -ef | grep neutron-server"
#ansible neutron_server_container -m shell -a "systemctl list-units --state=failed"
#ansible neutron_server_container -m shell -a "systemctl --type=service --state=running"

cd /opt/openstack-ansible/playbooks/
ansible neutron_server_container -m shell -a "systemctl | grep neutron"
ansible galera_container -m shell -a "systemctl | grep mysql"
ansible compute_hosts -m shell -a "systemctl | grep nova" # compute
ansible nova_conductor -m shell -a "systemctl | grep nova"
ansible glance_api -m shell -a "systemctl | grep glance"
ansible cinder_scheduler -m shell -a "systemctl | grep cinder"
ansible heat_all -m shell -a "systemctl | grep heat"
ansible gnocchi_all -m shell -a "systemctl | grep gnocchi"
ansible keystone_all -m shell -a "systemctl | grep keystone"
ansible haproxy -m shell -a "systemctl | grep haproxy"
ansible rabbitmq -m shell -a "systemctl | grep rabbitmq"







