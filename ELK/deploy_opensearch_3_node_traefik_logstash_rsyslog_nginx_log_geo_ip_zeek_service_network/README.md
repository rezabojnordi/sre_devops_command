## network monitoring

https://packages.ntop.org/apt-stable/


### install pfring for ZEEk
```
apt-get install software-properties-common wget
add-apt-repository universe
wget https://packages.ntop.org/apt-stable/20.04/all/apt-ntop-stable.deb
apt install ./apt-ntop-stable.deb

apt install pfring

```
### activing promsqus on interface
```
ip link set $IFACE promisc on
ip link set ens160 promisc on
```



### instaling Zeek on linux

```
echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
apt update

apt install zeek

echo "export PATH=$PATH:/opt/zeek/bin" >> ~/.bashrc

source ~/.bashrc
```

## where is it configure Zeek
```
cd /opt/zeek/
```
what is networks.cfg in Zeek
network.cfg is using for a configure network on Zeek

```
vim networks.cfg
```
### configuring Zeek Service on linux

```
cp node.cfg node.cfg.back

commenting old config on this file afther that add this config on node.cfg

vim node.cfg

[manager]
type=manager
host=localhost
#
[proxy-1]
type=proxy
host=localhost
#
[worker-1]
type=worker
host=localhost
interface=ens160
lb_method=pf_ring 
lb_procs=3

```

### changing old config on Zeek file to json

```
vim /opt/zeek/share/zeek/site/local.zeek

@load policy/tuning/json-logs.zeek
```

saving logs on ZEEk first saving this path
```
SpoolDir = /opt/zeek/spool
```

### installing Zeek on server

```
zeekctl

zeekctl deploy

zeekctl status
```
### changing filebeat for Zeek

```
cd /etc/filebeat/
cp filebeat.yml filebeat.yml.back

```
## where is directory file?
```
cd /opt/zeek/logs
```

```
vim filebeat2.yml

filebeat.inputs:

# Each - is an input. Most options can be set at the input level, so
# you can use different inputs for various configurations.
# Below are the input specific configurations.

- type: log

  # Change to true to enable this input configuration.
  enabled: true

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - /opt/zeek/logs/current/conn.log*
  json.keys_under_root: true
  json.add_error_key: true


# ================================== Logging ===================================

logging.level: error

logging.to_files: true
logging.files:
  path: /var/log/filebeat2
  keepfiles: 7
  permissions: 0640

# ---------------------------- Elasticsearch Output ----------------------------
output.logstash:
        hosts: ["127.0.0.1:5044"]

# ================================= Processors =================================
processors:
  - drop_fields:
      fields: ["agent.ephemeral_id", "agent.hostname", "agent.id", "agent.type", "agent.version", "agent.name", "ecs.version", "input.type", "histroy", "log.offset", "version", "host.architecture", "host.containerized", "host.hostname", "host.id", "host.ip", "host.mac", "host.name", "host.os.codename", "host.os.family", "host.os.kernel", "host.os.name", "host.os.platform", "host.os.version", "log.file.path", "log.file.path", "tags", "type", "tunnel_parents" ]
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
```

### adding filebeat for Zeek service

```
cat /lib/systemd/system/filebeat.service

vim /lib/systemd/system/filebeat2.service
```
```
[Unit]
Description=Filebeat2 sends log files to Logstash or directly to Elasticsearch.
Documentation=https://www.elastic.co/products/beats/filebeat
Wants=network-online.target
After=network-online.target

[Service]

Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat2.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat2 --path.config /etc/filebeat --path.data /var/lib/filebeat2 --path.logs /var/log/filebeat2"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd $BEAT_LOG_OPTS $BEAT_CONFIG_OPTS $BEAT_PATH_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
```
### makding directory for filebeat2
```
mkdir -p /var/log/filebeat2 /usr/share/filebeat2 /var/lib/filebeat2
```

### weird file is directory for keeping logs when you don't know logs
```
weird.log
```

## addding inpute and output for logstash service

```
        beats { 
                type => "netmon"
                port => 5046
        }

```
```
output {

if [type] == "syslog-elk" {
        elasticsearch {
                hosts => ["https://opensearch-node1:9200", "https://opensearch-node2:9200", "https://opensearch-node3:9200"]
                ssl => true
                ssl_certificate_verification => false
                user => admin
                password => admin
                index => "%{type}-log-%{+YYYY.MM.dd}"
        } # end of elastic

} # end of if


else if [type] == "netmon" {
        elasticsearch {
                hosts => ["https://opensearch-node1:9200", "https://opensearch-node2:9200", "https://opensearch-node3:9200"]
                ssl => true
                ssl_certificate_verification => false
                user => admin
                password => admin
                index => "%{type}-log-%{+YYYY.MM.dd}"
        } # end of elastic

} # end of if

else {
        elasticsearch {
                hosts => ["https://opensearch-node1:9200", "https://opensearch-node2:9200", "https://opensearch-node3:9200"]
                ssl => true
                ssl_certificate_verification => false
                user => admin
                password => admin
                #index => "%{type}-log-%{+YYYY.MM.dd}"
                index => "%{[@metadata][beat]}-%{[host][hostname]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
        } # end of elastic

} # end of else
} # end of output

```
### You must add port on docker-compose for Zeel service
```
5046
```
