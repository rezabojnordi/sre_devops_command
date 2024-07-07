# HA Proxy cheatsheet

### Install HA proxy:
```
apt install -y haproxy
```


### Edit `/etc/haproxy/haproxy.cfg` and add:
```
global
  stats socket /var/run/haproxy.stat level admin mode 600

frontend kubernetes-frontend
    bind 172.16.16.100:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server kmaster1 172.16.16.101:6443 check fall 3 rise 2
    server kmaster2 172.16.16.102:6443 check fall 3 rise 2
```


### Restart the service:
```
systemctl restart haproxy
```

### Check config:
```
haproxy -c -V -f /etc/haproxy/haproxy.cfg
```
### TCP Proxy port 80 and 443
```
frontend www-http
   bind *:80
   mode tcp
   default_backend www-backend

frontend www-https
   bind *:443
   mode tcp
   default_backend www-backend_https

backend www-backend
    server master1 x.x.x.x:30241 check
    server master2 x.x.x.x:30241 check

backend www-backend_https
    server master1 x.x.x.x:30925 check
    server master2 x.x.x.x:30925 check
```

