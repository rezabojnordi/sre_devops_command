# Keepalived cheatsheet 

### Install :
```
apt install keepalived
```
### Edit `/etc/keepalived/keepalived.conf`
```
global_defs {
  enable_script_security
  script_user root
}

# All keepalived in a group must have the same name
vrrp_sync_group group_name {
  group {
    external
  }
  notify "/etc/keepalived/haproxy_notify.sh" # any kinda script that you want to use
}
# This script will check if haproxy is running or not
vrrp_script haproxy_check_script {
  script "/etc/keepalived/haproxy_check.sh" # run any script and its policy
  interval 5   # checking every 5 seconds (default: 5 seconds)
  fall 3           # require 3 failures for KO (default: 3)
  rise 6           # require 6 successes for OK (default: 6)
}
# This script will check if server is connected to not
vrrp_script pingable_check_script {
  script "/etc/keepalived/pingable_check.sh 1 193.0.14.129"
  interval 10   # checking every 10 seconds (default: 5 seconds)
  fall 2           # require 2 failures for KO (default: 3)
  rise 4           # require 4 successes for OK (default: 6)
}

vrrp_instance external {
  # name of main network interface on server running keepalived
  interface eth0
  # state can be MASTER or BACKUP witch MASTERs are prefered
  state MASTER
  # 10 is an optional id
  virtual_router_id 10
  # Instance with higher priority prefered
  priority 150
  authentication {
    auth_type PASS    
    # This password must be the same across the keepalived group
    auth_pass yourpass
  }
  virtual_ipaddress {
    # IP and interface name from cloud
    xxx.xxx.xxx.xxx/24 dev interface-name
  }
  track_script {
    haproxy_check_script
    pingable_check_script
  }
}
}
```
### content of `pingable_check.sh`:
```
/bin/ping -c $1 $2 1>&2

```
### content of `haproxy_check.sh`:
```
/bin/kill -0 $(cat /var/run/haproxy.pid)
```
### content of `haproxy_notify.sh`:
```
TYPE=$1
NAME=$2
NOW=`date "+%Y-%m-%d %H:%M:%S"`
NEWSTATE=$3
OLDSTATE=$(cat /var/run/keepalived.state)

echo "$NEWSTATE" > /var/run/keepalived.state

case $NEWSTATE in
        "FAULT") echo "$NOW Trying to restart haproxy to get out"\
                  "of faulty state" >> /var/log/keepalived-notifications.log
                 /etc/init.d/haproxy stop
                 /etc/init.d/haproxy start
                 exit 0
                 ;;
        *) echo "$NOW Unknown state" >> /var/log/keepalived-notifications.log
           exit 1
           ;;
esac
```


