# beat


## Note:
if you want add ypur address's server. you can open default's file to change opensearch ip

```
vim roles/opensearch_beat/defaults/main.yml

```
## how to run this project on production
* You need to run this command for your scenario and it depends on your server and your scenario

```
ansible-playbook -i inventory --tags computes computes_beat.yml 

ansible-playbook -i inventory --tags ceph ceph_beat.yml

ansible-playbook -i inventory --tags controller controller_beat.yml


```

### Note:

* if you want to contribute this service. You want to add your Jinja2 file and template in this project.
* be careful when you want to send log to Opensearch server because It is necessary to specify the port.



