## At this moment, we have 3 nodes:


* Our example microservice application consists of two parts. The Books API and the Movies API. For both parts I have prepared images for you that can be pulled from the DockerHub.

* The Dockerfiles for both images can be found on my Github.

* Create docker-compose.yml file with the following content:

vim docker-compose.yml

```
version: "3.3"

services:
  traefik:
    image: traefik:1.4
    ports:
      - 80:80
      - 8080:8080
    networks:
      - traefik-net
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    configs:
      - source: traefik-config
        target: /etc/traefik/traefik.toml
    deploy:
      placement:
        constraints:
          - node.role == manager

  books:
    image: mlabouardy/books-api
    networks:
      - traefik-net
    deploy:
      placement:
        constraints:
          - node.role == worker
      labels:
        - "traefik.port=5000"
        - "traefik.backend=books"
        - "traefik.frontend.rule=Path:/books"

  movies:
    image: mlabouardy/movies-api
    networks:
      - traefik-net
    deploy:
      placement:
        constraints:
          - node.role == worker
      labels:
        - "traefik.port=5000"
        - "traefik.backend=movies"
        - "traefik.frontend.rule=Path:/movies"

networks:
  traefik-net:
    driver: overlay

configs:
  traefik-config:
    file: config.toml
```

* We use an overlay network named traefik-net, on which we add the services we want to expose to Traefik.
* We use constraints to deploy the APIs on workers & Traefik on Swarm manager.
* Traefik container is configured to listen on port 80 for the standard HTTP traffic, but also exposes port 8080 for a web dashboard.
* The use of docker socket (/var/run/docker.sock) allows Traefik to listen to Docker Daemon events, and reconfigure itself when containers are started/stopped.
* The label traefik.frontend.rule is used by Træfik to determine which container to use for which Request Path.
* The configs part create a configuration file for Traefik from config.toml(it enables the Docker backend)

vim config.toml
```
logLevel="DEBUG"
debug=true

[web]
address=":8080"

[docker]
endpoint="unix://var/run/docker.sock"
watch=true
swarmmode=true

```

In order to deploy our stack, we should execute the following command:

```
docker stack deploy — compose-file docker-compose.yml api
```

Let’s check the overlay network:
```
docker network ls
```

Traefik configuration:
```
docker config ls
```

To display the configuration content:
```
docker config inspect api_traefik-config — pretty
```

And finally, to list all the services:
```
docker stack ps api
```

In the list of above, you can see that the 3 containers are being running on node-1, node-2 & node-3 :


* If you point your favorite browser (not you IE) to the Traefik Dashboard URL (http://MANAGER_NODE_IP:8080) you should see that the frontends and backends are well defined:
```
If you check http://MANAGER_NODE_IP/books, you will get a list of books:
If you replace the base URL with /movies:
```

What happens if we want to scale out the books & movies APIs. With the docker service scale command:

```
docker service scale API_MOVIE=4
```

SOURCE CODE:
```
https://github.com/mlabouardy/alb-go/tree/master
```


