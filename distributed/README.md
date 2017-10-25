# How to run distributed version

First build the HBase docker images (from the root folder of repository):
```
make build
```

Deploy HBase:
```
docker stack deploy -c docker-compose.yml hbase
```
