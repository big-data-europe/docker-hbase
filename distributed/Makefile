traefik:
	docker service create --name traefik --constraint node.hostname==akswnc4.aksw.uni-leipzig.de --publish 80:80 --publish 8080:8080 --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock --network hbase traefik --docker --docker.swarmmode --docker.domain=cluster.aksw.org --docker.watch --web --logLevel=DEBUG

network:
	docker network create -d overlay --attachable hbase

zookeeper:
	docker stack deploy -c docker-compose-zookeeper.yml zookeeper

zookeeper-get-stats:
	docker run -it --rm --network hbase zookeeper:3.4.10 bash
	# echo "stat" | nc zoo1 2181
	# echo "stat" | nc zoo2 2181
	# echo "stat" | nc zoo3 2181

hadoop:
	docker stack deploy -c docker-compose-hadoop.yml hadoop

hbase:
	docker stack deploy -c docker-compose-hbase.yml hbase

hbase-master-bash:
	docker run -it --rm -p 60010:60010 --network hbase --hostname hbase-master --name hbase-master --env-file ./hbase-local.env bde2020/hbase-base:1.0.0-hbase1.2.6 bash /opt/hbase-1.2.6/bin/hbase master start

hbase-region-bash:
	docker run -it --rm -p 60030:60030 --network hbase --env-file ./hbase-local.env --name hbase-region --hostname hbase-region -e HBASE_CONF_hbase_regionserver_hostname=hbase-region bde2020/hbase-base:1.0.0-hbase1.2.6 /opt/hbase-1.2.6/bin/hbase regionserver start

clean:
	docker exec -it namenode hadoop fs -rm -r /hbase/*
	docker exec -it zoo bash # bin/zkCli.sh && echo "rmr /hbase"
