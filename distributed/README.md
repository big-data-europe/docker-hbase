# How to run distributed version

First build the HBase docker images (from the root folder of repository):
```
make build
```

Create network for hbase:
```
docker network create -d overlay --attachable hbase
```

Deploy zookeeper cluster:
```
docker stack deploy -c docker-compose-zookeeper.yml zookeeper
```

Deploy Hadoop cluster:
```
docker stack deploy -c docker-compose-hadoop.yml hadoop
```

The datanodes will not be able to connect to namenode (TODO) right away, you will need to restart them after namenode started:
```
docker service update --force hadoop_datanode
```

Now you can deploy hbase:
```
docker stack deploy -c docker-compose-hbase.yml hbase
```
