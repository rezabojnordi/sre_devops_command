#!/bin/bash

apt update 

apt-get --force-yes -o Dpkg::Options::="--force-confold" --force-yes -o Dpkg::Options::="--force-confdef" -fuy dist-upgrade
 
apt autoremove << EOF
y
EOF

server1="$1"
server2="$2"

apt -y install haproxy
cat > /etc/haproxy/haproxy.cfg << EOF
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http
	
#######

frontend www-http
   bind *:80
   reqadd X-Forwarded-Proto:\ http
   default_backend www-backend
   
frontend www-https
   bind *:443 ssl crt /etc/letsencrypt/live/softgrand.ir/let.pem
   reqadd X-Forwarded-Proto:\ https
   http-request set-header X-SSL %[ssl_fc]
   default_backend www-backend
   redirect scheme https code 301 if !{ ssl_fc }

backend www-backend
    redirect scheme https code 301 if !{ ssl_fc }
    server web1 $server1:80 check
    server web2 $server2:80 check
EOF

