# import_linux_command

<img src="pic/1.png" height="300" width="600" style="float:center" ></img>

<img src="pic/2.png" height="300" width="600" style="float:center" ></img>

<img src="pic/3.png" height="300" width="600" style="float:center" ></img>

<img src="pic/4.png" height="300" width="600" style="float:center" ></img>

<img src="pic/5.png" height="300" width="600" style="float:center" ></img>

<img src="pic/6.png" height="300" width="600" style="float:center" ></img>

<img src="pic/7.png" height="300" width="600" style="float:center" ></img>

<img src="pic/7.png" height="300" width="600" style="float:center" ></img>


# Swarm Intro and Creating a 3-Node Swarm Cluster

## Create Your First Service and Scale it Locally
## Command
docker info

* docker swarm init

* docker node ls

* docker node --help

* docker swarm --help

* docker service --help

* docker service create alpine ping 8.8.8.8

* docker service ls

* docker service ps frosty_newton

* docker container ls

* docker service ls

* docker service update etc25a25dpj7 --replicas 3


* docker service update TAB COMPLETION --replicas 3

* docker service ls

* docker service ps frosty_newton

* docker update --help

* docker service update --help

* docker container ls

* docker container rm -f frosty_newton.1.TAB COMPLETION

* docker service ls

* docker service ps frosty_newton

* docker service rm frosty_newton

* docker service ls

* docker container ls

## Creating a 3-Node Swarm Cluster
## Command
http://play-with-docker.com

* docker info

* docker-machine

* docker-machine create node1

* docker-machine ssh node1

* docker-machine env node1

* docker info

http://get.docker.com

* docker swarm init

* docker swarm init --advertise-addr TAB COMPLETION

* docker node ls

* docker node update --role manager node2

* docker node ls

* docker swarm join-token manager

* docker node ls

* docker service create --replicas 3 alpine ping 8.8.8.8

* docker service ls

* docker node ps

* docker node ps node2

* docker service ps sleepy_brown

## Scaling Out with Overlay Networking
## Command

* docker network create --driver overlay mydrupal

* docker network ls

* docker service create --name psql --netowrk mydrupal -e POSTGRES_PASSWORD=mypass postgres

* docker service ls

* docker service ps psql

* docker container logs psql TAB COMPLETION

* docker service create --name drupal --network mydrupal -p 80:80 drupal

* docker service ls

* watch docker service ls

* docker service ps drupal

* docker service inspect drupal

## Rollback
## Command
* docker service create -p 8088:80 --name web nginx:1.13.7
* docker service scale web=5
* docker service update --image nginx:1.13.6 web
* docker service update --publish-rm 8088 --publish-add 9090:80
* docker service update --force web
# Rmove the service we created
* docker service rm web

# Docker HEakthcheck 

HEakthcheck was added in 1.12

## HEakthcheck Docker Run Example
docker run --heath-cmd="curl -f localhost:9200/_cluster/health || false" --health-interval=5s --health-retries=3 --health-timeout=2s --health-start-period=15s elasticsearch:2


## Option for heakthcheck command
* --interval=DURATION (default:30s)
* --timeout=DURATION (default:30s)
* --start-period=DURATION (default:0s)
* --retries=N (default:3)

 
## Basic command using default options
* HEALTHCHECK curl -f http://localhost/ || false

## Custom options with the command
* HEALTHCHECK --timeoute=2s --interval=3s --retries=3 
* CMD curl -f http://localhost/ || exit 1


## Healthcheck in PHP Nginx Dockerfile
PHP-FPM running behind Nginx, test the Nginx and FPM status URLS 

FROM your-nginx-php-fpm-combo-image

#### don't di this if php-fpm ping/statys in pool,ini
#### must forward/ping and /status urls from nginx to php php-fpm

HEALTHCHECK --interval=5s --timeoute=3s CMD curl -f http://localhost/ping || exit 1

## Healthcheck in postgres Dockerfile
USE a Postgress utility to test for ready state
FROM postgres
# specify real user with -u to prevent error in log 

Healthcheck --interval=5s --timeoute=3s CMD pg_isready -U postgres || exit 1




## Command

* docker container run --name p1 -d nginx
* docker container run --name p2 -d --health-cmd="pg_isready -U nginx || exit 1" nginx

* docker service create --name p1 nginx
* docker service create --name p2 --health-cmd="pg_isready -U nginx || exit 1" nginx




