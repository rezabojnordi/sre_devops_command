


```
sudo apt-get update
sudo apt-get upgrade
sudo reboot
 
## Add gpg key
sudo apt-get install -y gnupg2 curl
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
 
## Add Grafana APT repository
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
```

```
sudo apt-get update
sudo apt-get -y install grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
sudo ufw allow proto tcp from any to any port 3000
```

```
curl -s https://api.github.com/repos/grafana/loki/releases/latest | grep browser_download_url |  cut -d '"' -f 4 | grep loki-linux-amd64.zip | wget -i -
```

### Install unzip

```
# Ubuntu / Debian
sudo apt install unzip
```
```
unzip loki-linux-amd64.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
```
```
$ loki --version
loki, version 2.0.0 (branch: HEAD, revision: 6978ee5d)
  build user:       root@2645337e4e98
  build date:       2020-10-26T15:54:56Z
  go version:       go1.14.2
  platform:         linux/amd64
```

### Create required data directories:
```
sudo mkdir -p /data/loki
```

### Create new configuration file

```
sudo vim /etc/loki-local-config.yaml

```
```
auth_enabled: false
 
server:
  http_listen_port: 3100
 
ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s
  max_transfer_retries: 0
 
schema_config:
  configs:
    - from: 2018-04-15
      store: boltdb
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 168h
 
storage_config:
  boltdb:
    directory: /data/loki/index
 
  filesystem:
    directory: /data/loki/chunks
 
limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
 
chunk_store_config:
  max_look_back_period: 0s
 
table_manager:
  retention_deletes_enabled: false
  retention_period: 0s
```

### Create Loki service

```
sudo tee /etc/systemd/system/loki.service<<EOF
[Unit]
Description=Loki service
After=network.target
 
[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/loki -config.file /etc/loki-local-config.yaml
 
[Install]
WantedBy=multi-user.target
EOF
```
### Reload system daemon then start Loki service
```
sudo systemctl daemon-reload
sudo systemctl start loki.service
```
### Install Promtail Agent

```
curl -s https://api.github.com/repos/grafana/loki/releases/latest | grep browser_download_url |  cut -d '"' -f 4 | grep promtail-linux-amd64.zip | wget -i -
unzip promtail-linux-amd64.zip
sudo mv promtail-linux-amd64 /usr/local/bin/promtail
```

```
sudo vim /etc/promtail-local-config.yaml
```

```
server:
  http_listen_port: 9080
  grpc_listen_port: 0
 
positions:
  filename: /data/loki/positions.yaml
 
clients:
  - url: http://localhost:3100/loki/api/v1/push
 
scrape_configs:
- job_name: system
  static_configs:
  - targets:
      - localhost
    labels:
      job: varlogs
      __path__: /var/log/*log
```

### Create a service for Promtail
```
sudo tee /etc/systemd/system/promtail.service<<EOF
[Unit]
Description=Promtail service
After=network.target
 
[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/promtail -config.file /etc/promtail-local-config.yaml
 
[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl daemon-reload
sudo systemctl start promtail.service
```
```
systemctl status promtail.service
```

