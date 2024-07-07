#!/bin/bash
apt update -y
apt upgrade -y
apt install curl gnupg2 ca-certificates lsb-release -y

echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt-key fingerprint ABF5BD827BD9BF62
apt update

apt install nginx-full sniproxy -y
rm /etc/nginx/nginx.conf
rm /etc/sniproxy.conf

cat <<EOF >>/etc/sniproxy.conf
user nobody

pidfile /var/run/sniproxy.pid

resolver {
  nameserver 8.8.8.8
  mode ipv4_only
}

access_log {
  filename /dev/stdout
  priority notice
}

error_log {
  filename /dev/stderr
}

listener 0.0.0.0:443 {
  protocol tls
}

table {
  .* *:443
}

EOF
cat <<EOF >>/etc/nginx/nginx.conf
worker_processes  auto;

events {
    worker_connections 66536;
    use epoll;
    multi_accept on;
}


http {
    proxy_cache_path  /etc/nginx/cache levels=1:2 keys_zone=vpn:10m max_size=10g inactive=2d;

    sendfile on;
    tcp_nopush on;
    
    directio 512;

    server {
        listen 80;
        server_name \$host;

        proxy_temp_path /mnt/temp;

        access_log on;
        error_log on;

        location / {
            resolver 8.8.8.8 ipv6=off;
            proxy_pass http://\$http_host\$request_uri;
            proxy_pass_request_headers      on;
            proxy_cache vpn;
            proxy_cache_valid 200 30d;
            proxy_cache_valid 404 1s;
            proxy_cache_key \$uri;
            add_header X-Cache-Status \$upstream_cache_status;
            proxy_ignore_headers X-Accel-Expires Expires Cache-Control;
            proxy_cache_revalidate on;
            proxy_cache_lock on;
            proxy_cache_use_stale updating;
        }

    }
}
EOF

mkdir /etc/nginx/cache
systemctl restart nginx
sniproxy

echo "Done :)"