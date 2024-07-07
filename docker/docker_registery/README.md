
# Start Docker Registery  

this project about how to run repository for docker replace docker hub and use it

## Run Container
to start docker container registery

```
docker run -d   --restart=always   --name registry3   \
-v /home/certs:/etc/certs   -e REGISTRY_HTTP_ADDR=0.0.0.0:443  \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/etc/certs/file.crt  \
-e REGISTRY_HTTP_TLS_KEY=/etc/certs/file.key  \
-v /mnt/registry:/var/lib/registry \
-v /root/registry/config.yml:/etc/docker/registry/config.yml  \
-p 1443:443 -p 5001:5001  registry:2

```

