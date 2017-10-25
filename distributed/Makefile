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

hmaster-service:
	docker service create --name hmaster --network hbase --constraint node.hostname==akswnc4.aksw.uni-leipzig.de bde2020/hbase-master:1.0.0-hbase1.2.6

hmaster-run:
	docker run -it --rm --name hmaster --network hbase --env-file ./hbase.env bde2020/hbase-hmaster:1.0.0-hbase1.2.6

