# Elk config for your project 


MetricBeat - Used for capturing system related metrics like CPU usage, Heap Usage etc
PacketBeat - For monitoring network data
WinlogBeat - For capturing windows event logs
AuditBeat - Monitor user activity and processes
HeartBeat - For uptime monitoing
FunctionBeat - Serverless architectures let you deploy code, without needing to spin up and manage extra underlying software and hardware. Functionbeat brings that same simplicity to monitoring your cloud infrastructure.

Input - It receives data sent by different beats
Filter - Here you need to write parser to parse the data
Output - It pushes data to ElasticSearch Indexes via API call

<img src="1.png" width="800" height="500" />
<img src="2.png" width="800" height="500" />
<img src="3.png" width="800" height="500" />
<img src="4.png" width="800" height="500" />
<img src="5.jpg" width="800" height="500" />


```
https://www.elastic.co/downloads/past-releases
```

OSS is importan for your project when you need a free version
```
Logstash OSS 8.0.0
```


### opendistro
```
https://opendistro.github.io/for-elasticsearch-docs/docs/install/
```

### Operating system and JVM compatibility
```
https://opensearch.org/docs/latest/opensearch/install/compatibility

```

## its importan for your infrastructure
```
To increase the value, add the following line to /etc/sysctl.conf:

vm.max_map_count=262144

afther that

sudo sysctl -p



https://opensearch.org/docs/latest/opensearch/install/important-settings/


```

### minimum and maximum for java heap sizes

```
OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m

Sets the size of the Java heap (we recommend half of system RAM).
```

## change maximum open files for
```


nofile 65536

Sets a limit of 65536 open files for the OpenSearch user.

port 9600

Allows you to access Performance Analyzer on port 9600.

ultimit -n 65536
```


### reqirement service

#### docker
```
curl -fsSL https://get.docker.com -o get-docker.sh
 sh get-docker.sh
```
#### docker-compose
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker-compose --version
```

