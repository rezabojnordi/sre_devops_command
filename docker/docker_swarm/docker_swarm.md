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




