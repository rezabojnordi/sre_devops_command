
## docker swarm on custome ip

```
docker swarm init swarm init --advertise-addr 192.168.1.8
```
* afther you need to copy link on other server for worker

```
docker node ls

```

## docker info and join-token

```
docker info
```

### How to get token for worker and manager

```
docker swarm join-token worker

or

docker swarm join-token manager

```

 ## how to convert worker to master
 
 ```
 docker node promote worker1 worker2
 
 docker node ls
 ```
 
 
 ## how to convert manager to worker
 ```
 docker node demote worker2
 
 docker node ls
 ```
 
 ## REmoving nodes from Docker swarm
 
 * you need to run this command on node such as worker node
 ```
 docker swarm leave
 ```
 * run this command on master or manager
 
 ```
 docker node rm worker1
 or
 docker node rm -f worker2
 ```
 
 ## add new server on swarm 
 * run this command on master
 ```
 docker swarm jon-token manager
 ```
 * run output up command on worker
 ```
 docker swarm join --token string
 ```
 
 ## inspecting the nodes of swarm
 ```
 
 docker node inspect worker1
 ```
 
 ## Creating first docker service
 
Note: Service = image for a microservice

 '''
 docker service create -d busybox ping www.google.com

 docker dervice create -d busybox ping 192.168.1.8

 docker service ls



 '''
  
 
 ## adding replicas of docker services

 ```
docker service inspect tw

docker service create -d --replicas 7 busybox

docker service create -d --replicas 7 busybox ping 192.168.1.8

 ```

 ## Docker swarm Visualizer

* https://github.com/dockersamples/docker-swarm-visualizer

 ‍‍```
docker-swarm-visualizer

docker service create --name-viz --public=8080:8080/tcp --constraint=node.role==manager --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock dockersample/visualizer

```
```
## Viewing logs of services and tasks

```
docker service logs n6

docker service ps n6


```




 
## Updating role and availability

```
docker node update --role manager worker1

docker node update --role worker worker1

docker node update --availableity=pause workre1

docker node ls   ## if you run this command worker node will pause it

docker node update --availability=active worker1 
```
```
docker service create -d alpine ping 192.168.1.8
docker service create -d --constraint="node.labels.env==development" alpine ping 192.168.1.8

docker service ps gw

```
## Port Mapping

```
docker service create -d -p 8090:80 nginx

docker service rm service_id or service_name
```

## labels
* key-value pair storage in form of strings
* Useful in adding metadata into nodes
* role: Development,Testing.Production
* region: Us, EU, APAC
* disk: HDD,SDD
```
docker node update --label-add env=development worker1
docker node update --label-add env=testing worker2
docker node ls
docker node update --label-rm env rd xp ## error

docker node update --help

docker node update --label-rm evn xp

docker service create --constraint="node.labels.env==development" -d alpine ping 192.168.1.8

docker service create --constraint="node.labels.env==testing" --replicas=2 -d alpine ping 192.168.1.8

```

## High availability
```

Note: If you remove container and then the service aumateing run.

    
```

## Scalability and Load

```
docker service --help 
  scalling up and scalling down
docker service ls

docker service scale tw=5  # tw(service name) 

docker service ls

docker service scale tw=1

```

## Loadbalcing and force rebalancing
```
docker service create --name service1 -d --replicas=30 ping www.google.com 

docker service ls

docker service ps j9

docker service j9 |grep worker1
docker service j9 |grep worker1 | wc -l

docker swarm join-token worker

docker service ls

docker service update j9 --detach=false --force

docker service ps j9 |grep manager1 |grep -iv shutdown |we -l

```
## Rebalncing docker


## Traefik sample

 

## other sample

docker network ls
create network for fronend and backend

docker network create -d overlay frontend_ntw

docker network -d overlay backend_ntw

docker network ls

docker service ls

docker service create --name voteapp -p 5000:80 --network frontend_ntw --replicas 3 dockersamples/examplevotingapp_vote:before

docker service ps voteapp


docker service create --name redis --replicas 3 --network frontend_ntw redis:3.2


docker service ls

docker service ps redis

docker container ls

docker service create --name worker --network frontend_ntw --network backend_ntw dockersamples/examplevotingapp_worker:latest

docker service ps worker

docker service logs worker

docker volume create db-data

docker volume ls

docker service create --name db --network backend_ntw -e POSTGRE_USE=postgres -e POSTGRES_PASSWORD=postgres --mount type=volume,source=db-data,target=/var/lib/postgresql/data postgres:9.4


docker service ls

docker service ps db

docker service create --name resultapp --network backend_ntw -p 5001:80 dockersamples/examplevotingapp_result:before

docker service ls

docker service ps resultapp





docker stack deploy -c docker-compose.yml apisix




