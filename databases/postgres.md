# Postgresql cheatsheet 

### Drop database force:
```
dropdb keycloak --force;
```

### Install only postgres client:
```
sudo apt-get install postgresql-client
psql
```
### Connect to postgres inside another namespace on k8s:
```
psql -h service_name.namespace -p 5432 -U postgres postgres
```
### Backup from postgres:
```
psql -h <host> -p <port> -U <db_user> <database_name>
```
### Create a user:
```
create user user_name with encrypted password 'password';
```
### Grant privilages to user:
```
grant all privileges on database db_name to user_name;
```


