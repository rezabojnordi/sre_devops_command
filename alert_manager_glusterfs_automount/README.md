# auto mount in glusterfs 

### step one install this service
https://github.com/rezabojnordi/prometheus_exporters/tree/main/prometheus

https://github.com/rezabojnordi/prometheus_exporters/tree/main/grafana

https://github.com/rezabojnordi/prometheus_exporters/tree/main/alerting_manager

sudo apt install webhook


/etc/prometheus/alert.rule
```


groups:
- name: cloud alerting Hardware and Networking and service
  rules:

  - alert: Power Supply Fan Status Of Switche Critical error
    expr : gluster_mount_successful == 1
    for: 1s
    labels:
      service: glusterfs
      severity: warning
    annotations:
      summary: "SW.tbz.greenweb.local, Power Supply Fan Status Of Switche Critical error (instance {{ $labels.instance }})"
      description: "SW.tbz.greenweb.local, Power Supply Fan Status Of Switche Critical error (instance {{ $labels.instance }})"

```

 vim /etc/prometheus/prometheus.yml
```
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093

rule_files:
   - "/etc/prometheus/alert.rules"

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']



  - job_name: 'glusterfs'
    static_configs:
    - targets: ['localhost:9189']
~                                  
```

vim /etc/alertmanager/alertmanager.yml

```
global:
  smtp_smarthost: 'localhost:25'
#  smtp_from: 'cloud_service@iranserver.com'
  smtp_from: 'monitor@greenweb.ir'
  smtp_auth_username: ''
  smtp_auth_password: ''
  smtp_require_tls: false

templates:
- '/etc/alertmanager/template/*.tmpl'


# The root route on which each incoming alert enters.
route:
  receiver: 'glusterfs'
  #group_by: ['alertname', 'cluster', 'service']
  group_by: ['...']
  group_wait: 30s
  group_interval: 1m
  repeat_interval: 100h
  routes:
  - match_re:
      service: (glusterfs)
    receiver: glusterfs




#    routes:
#  - match:
#        owner: network-team
#      receiver: network-team





receivers:

- name: 'glusterfs'
  webhook_configs:
      - send_resolved: false
        url: 'http://localhost:9000/hooks/test'
  email_configs:
  - to: 'rezabojnordi2012@gmail.com'
    headers:
      subject: 'glusterfs'
      To: 'rezabojnordi2012@gmail.com'

```

vim /etc/webhook.conf 

```
[
  {
    "id": "test",
    "execute-command": "/home/ubuntu/test.sh",
    "command-working-directory": "/home/ubuntu"
  }
]
~  
```

vim /home/ubuntu/test.sh

```
#!/bin/bash
mkdir /home/ubuntu/test
```

chmod +x test.sh