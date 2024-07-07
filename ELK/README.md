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

#### Important settings on kernel
```
https://opensearch.org/docs/latest/opensearch/install/important-settings/
```

### step1 ones
```
./ssl/ssl-gen.sh
```
### step2 up docker-compose
```
 docker-compose up -d
```

### step3 up docker-compose
```
docker-compose down 
```

You can go to this directory for config files
```
cd /var/lib/docker/volumes/opensearch_opensearch-data1-config/_data/config
```

You can change jvm.options for jvm machine
```
cat jvm.options
```


### step4 make subject for security on opensearch
```
cd ssl/
openssl x509 -subject -nameopt RFC2253 -noout -in node1.pem
openssl x509 -subject -nameopt RFC2253 -noout -in node2.pem
openssl x509 -subject -nameopt RFC2253 -noout -in node3.pem

subject=CN=opensearch-node1,OU=UNIT,O=ORG,L=TEHRAN,ST=ARIA,C=CA
```
you must run this command for all of nodes on your services finally add outpu these files
```
opensearch-1.yml 
opensearch-2.yml 
opensearch-3.yml 
```
## step5 you need copy 3 files on other location
```
cp opensearch-1.yml /var/lib/docker/volumes/elk_opensearch-data1-config/_data/config/opensearch.yml 

cp opensearch-2.yml /var/lib/docker/volumes/elk_opensearch-data2-config/_data/config/opensearch.yml 

cp opensearch-3.yml /var/lib/docker/volumes/elk_opensearch-data3-config/_data/config/opensearch.yml
```

## step6 run these command on linux for copy ssl files 

```
cd ssl 
cp *.pem /var/lib/docker/volumes/elk_opensearch-data1-config/_data/config/

cp *.pem /var/lib/docker/volumes/elk_opensearch-data2-config/_data/config/

cp *.pem /var/lib/docker/volumes/elk_opensearch-data3-config/_data/config/
```

## step7 change permission on linux for elk services

```
chown -R 1000.1000 /var/lib/docker/volumes/elk_opensearch-data1-config/_data/config/
chown -R 1000.1000 /var/lib/docker/volumes/elk_opensearch-data2-config/_data/config/
chown -R 1000.1000 /var/lib/docker/volumes/elk_opensearch-data3-config/_data/config/

```

## step8 run this command for up all of Containers

```
docker-compose up -d
```

## step9 set security plugin configuration

```
docker exec -ti opensearch-node1 bash

ls

ls plugins/opensearch-security/
```

## step10 set security plugin configurations on container
```
sh plugins/opensearch-security/tools/securityadmin.sh  -backup ./backup -cd plugins/opensearch-security/securityconfig/ -icl -nhnv -cacert config/root-ca.pem -cert config/admin.pem -key config/admin-key.pem 

```

## step11 check autentication on elk on container
```
curl -XGET --insecure -u 'admin:admin' https://localhost:9200/_cluster/health?pretty
```
## open dashboard
```
http://ip:5601/app/login?nextUrl=%2F
```
