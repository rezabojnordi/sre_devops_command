
## nginx

requirement 

```
apt install \
gcc \
libssl-dev \
make \
libpcre3-dev \
zlib1g-dev \
libxml2-dev \
libxslt-dev \
libgd-dev \
libgeoip-dev \
libperl-dev
```
## buld nginx

/opt/nginx

```
cd
wget https://github.com/nginx/nginx/archive/release-1.19.2.tar.gz
git clone https://github.com/vozlt/nginx-module-vts.git
tar -xzvf  release-1.19.2.tar.gz
cd release-1.19.2
 
auto/configure \
--with-pcre \
--prefix=/opt/nginx \
--user=www-data \
--group=www-data \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module=dynamic \
--with-http_image_filter_module \
--with-http_geoip_module=dynamic \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_slice_module \
--with-http_stub_status_module \
--without-http_charset_module \
--with-http_perl_module \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module=dynamic \
--with-stream_ssl_preread_module \
--add-module=/root/nginx-module-vts
 
 
make
make install
```

## nginx service 

```
vim /etc/systemd/system/nginx.service

[Unit]
Description=nginx 1.19.2
After=syslog.target network.target
 
[Service]
Type=forking
EnvironmentFile=/etc/default/nginx
ExecStart=/opt/nginx/sbin/nginx $CLI_OPTIONS
ExecReload=/opt/nginx/sbin/nginx -s reload
ExecStop=/opt/nginx/sbin/nginx -s quit
 
[Install]
WantedBy=multi-user.target
```

### nginx config 



```

# Command line options to use when starting nginx
#CLI_OPTIONS=""

systemctl daemon-reload
systemctl start nginx
systemctl enable nginx

apt install certbot python3-certbot
certbot certonly --standalone -d 'mirror.iranserver.com'


```

```
vim /opt/nginx/conf/nginx.conf

######
 
worker_processes auto;
worker_rlimit_nofile 100000;
 
events {
 
    worker_connections 4000;  
    multi_accept on;
    use epoll;
}
 
http {
 
    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
    access_log off;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    aio on;
    server_tokens off;
 
    server_names_hash_max_size 2526;
    server_names_hash_bucket_size 128;
    client_max_body_size 8000m;
    vhost_traffic_status_zone;
    reset_timedout_connection on;
    client_body_timeout 10;
     
    send_timeout 2;
    keepalive_timeout 30;
    keepalive_requests 100000;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
    ssl_ecdh_curve secp384r1;
    ssl_session_cache shared:SSL:5m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;
    ssl_buffer_size 4k;
    add_header X-XSS-Protection "1; mode=block";
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload";
    add_header X-Frame-Options "SAMEORIGIN";
 
    include /opt/nginx/conf/mime.types;  
 
server {
    listen      80;
    listen      [::]:80;
    server_name mirror.iranserver.com;
    location / {
        return 301 https://$server_name$request_uri;
    }
  }
 
 
server {
    listen                  443 ssl http2;
    server_name             mirror.iranserver.com;
    root                    /var/www/html/repo/mirror/mirror.iranserver.com/;
    index index.html;
    autoindex on;
 
    # SSL
    ssl_certificate         /etc/letsencrypt/live/mirror.iranserver.com/fullchain.pem;
    ssl_certificate_key     /etc/letsencrypt/live/mirror.iranserver.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/mirror.iranserver.com/chain.pem;
 
    location /monitor {
        vhost_traffic_status_display;
        vhost_traffic_status_display_format html;
    }
    location = /stub_status {
        stub_status;
    }
 
}
 
}

```

## create volume and link this path
```
/var/www/html/repo/mirror/mirror.iranserver.com/

```
```
######debian-exclude
  
dists/Debian8.11
dists/Debian9.13
dists/Debian10.10
dists/Debian11.0
dists/bookworm-backports
dists/bookworm-proposed-updates
dists/bookworm-updates
dists/bookworm
dists/bullseye-backports-sloppy
dists/bullseye-proposed-updates
dists/buster-backports-sloppy
dists/buster-proposed-updates
dists/experimental
dists/jessie-updates
dists/jessie
dists/oldoldoldstable-updates
dists/oldoldoldstable
dists/oldoldstable-backports-sloppy
dists/oldoldstable-backports
dists/oldoldstable-proposed-updates
dists/oldoldstable-updates
dists/oldoldstable
dists/oldstable-backports-sloppy
dists/oldstable-backports
dists/oldstable-proposed-updates
dists/oldstable-updates
dists/oldstable
dists/proposed-updates
dists/rc-buggy
dists/sid
dists/stable-backports-sloppy
dists/stable-backports
dists/stable-proposed-updates
dists/stable-updates
dists/stable
dists/stretch-backports-sloppy
dists/stretch-proposed-updates
dists/testing-backports
dists/testing-proposed-updates
dists/testing-updates
dists/testing
dists/unstable
 
 
#### centos-exclude
 
2/
2.1/
3/
3.1/
3.3/
3.4/
3.5/
3.6/
3.7/
3.8/
3.9/
4/
4.0/
4.1/
4.2/
4.3/
4.4/
4.5/
4.6/
4.7/
4.8/
4.9/
5/
5.0/
5.1/
5.10/
5.11/
5.2/
5.3/
5.4/
5.5/
5.6/
5.7/
5.8/
5.9/
6/
6.0/
6.1/
6.10/
6.2/
6.3/
6.4/
6.5/
6.6/
6.7/
6.8/
6.9/
TIME
dir_sizes
filelist.gz
timestamp.txt
 
 
### ubuntu-exclude
 
dists/devel-backports/
dists/devel-proposed/
dists/devel-security/
dists/devel-updates/
dists/devel/
dists/groovy-backports/
dists/groovy-proposed/
dists/groovy-security/
dists/groovy-updates/
dists/groovy/
dists/hirsute-backports/
dists/hirsute-proposed/
dists/hirsute-security/
dists/hirsute-updates/
dists/hirsute/
dists/impish-backports/
dists/impish-proposed/
dists/impish-security/
dists/impish-updates/
dists/impish/
dists/trusty-backports/
dists/trusty-proposed/
dists/trusty-security/
dists/trusty-updates/
dists/trusty/
```

```
/etc/cron.d/repo
 
0 */6 * * *  root /usr/bin/rsync -a --exclude-from='/opt/nginx/debian-exclude' rsync://ftp.ca.debian.org/debian /var/www/html/repo/mirror/mirror.iranserver.com/debian &> /tmp/log.deb
10 */6 * * * root  /usr/bin/rsync -a --exclude-from='/opt/nginx/centos-exclude' rsync://mirror.aminidc.com/centos /var/www/html/repo/mirror/mirror.iranserver.com/centos &> /tmp/log.cen
30 */6 * * * root  /usr/bin/rsync -a  --exclude-from='/opt/nginx/ubuntu-exclude' rsync://archive.ubuntu.com/ubuntu/ /var/www/html/repo/mirror/mirror.iranserver.com/ubuntu/ &> /tmp/log.ubu
20 */6 * * * root  /usr/bin/rsync -a rsync://ftp.br.debian.org/debian-cd/ /var/www/html/repo/mirror/mirror.iranserver.com/debian-iso &> /tmp/log.deb.iso
50 */6 * * * root  /usr/bin/rsync -a rsync://mirror.aminidc.com/ubuntu-releases /var/www/html/repo/mirror/mirror.iranserver.com/ubuntu/ubuntu-iso/ &> /tmp/log.ubu.iso
40 */6 * * * root  wget -O /var/www/html/repo/mirror/mirror.iranserver.com/clamav/main.cvd -mq http://clamav.aminidc.com/main.cvd
42 */6 * * * root  wget -O /var/www/html/repo/mirror/mirror.iranserver.com/clamav/daily.cvd -mq http://clamav.aminidc.com/daily.cvd
44 */6 * * * root  wget -O /var/www/html/repo/mirror/mirror.iranserver.com/clamav/bytecode.cvd -mq http://clamav.aminidc.com/bytecode.cvd
```
