# Docker cheatsheet 

### Install docker engine on Debian:
```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
```

### Images:
## Pull new image:
```
sudo docker pull image_name
```

## See images list:
```
sudo docker images
```

## Docker stop container:
```
sudo docker stop container_id
```

## Docker build (use it inside the folder containing DockerFile):
```
sudo docker build -t name:tag
```

## Get into the docker:
```
sudo docker exec -it container_name bash
```
## Remove all None images
docker rmi $(docker images -f dangling=true -q)

## Connect a containr to a network
docker network connect <network> <container>

## Save/Load a Docker image
```
  docker save -o image.tar image
  docker load -i image.tar
```
## Rename and image inside private registry
docker tag old_name new_name
docker rmi old:name

## Set timezone in Dockerfile
ENV TZ="Africa/Lusaka"

### To set proxy:
```
mkdir -p ~/.config/systemd/user/docker.service.d
vim ~/.config/systemd/user/docker.service.d/http-proxy.conf
```
The put these lines into the files:
```
[Service]
Environment="HTTP_PROXY=http://xxx.xxx.xxx.xxx:3128"
Environment="HTTPS_PROXY=http://xxx.xxx.xxx.xxx:3128"
```
Finally:
```
sudo service docker restart
```
### Set cron inside docker contianer:
Create your '/cronfile' like this:
```
* * * * *  echo "Hello!" >> /var/log/hello.log 2>&1
```
Inside docker file you may need to install cron depending on your OS:
```
RUN apt update && apt install -y cron
```
Put this line after copying your files into the container:
```
RUN crontab /crontab
```
Finally you must run  cron using CMD `CMD cron` Or in case of having another CMD like this: `cron && python boot.py`
```
  
### Copy file from/to container
```
docker cp <containerId>:/file/path/within/container /host/path/target
```
