.PHONY: all test clean
DOCKER_NETWORK = hbase
ENV_FILE = hadoop.env
current_branch := 1.2.0-hadoop2.7.4-java8

start-up: namenode datanode resourcemanager nodemanager historyserver

namenode:
	mkdir -p $(shell pwd)/data/namenode
	docker service create --env-file ./hadoop.env --publish 50070:50070 --mount type=bind,src=$(shell pwd)/data/namenode,dst=/hadoop/dfs/name -e CLUSTER_NAME=test --network hbase --name namenode bde2020/hadoop-namenode:1.2.0-hadoop2.7.4-java8
	sleep 60

datanode:
	mkdir -p $(shell pwd)/data/datanode
	docker service create --env-file ./hadoop.env --publish 50075:50075 --mount type=bind,source=$(shell pwd)/data/datanode,destination=/hadoop/dfs/data --network hbase --name datanode bde2020/hadoop-datanode:1.2.0-hadoop2.7.4-java8
	sleep 20

nodemanager:
	docker service create --env-file ./hadoop.env --publish 8042:8042 --network hbase --name nodemanager bde2020/hadoop-nodemanager:1.2.0-hadoop2.7.4-java8
	sleep 60

resourcemanager:
	docker service create --env-file ./hadoop.env --publish 8088:8088 --network hbase --name resourcemanager bde2020/hadoop-resourcemanager:1.2.0-hadoop2.7.4-java8

historyserver:
	mkdir -p $(shell pwd)/data/historyserver
	docker service create --env-file ./hadoop.env --publish 8188:8188 --mount type=bind,source=$(shell pwd)/data/historyserver,destination=/hadoop/yarn/timeline --network hbase --name historyserver bde2020/hadoop-historyserver:1.2.0-hadoop2.7.4-java8

hbase:
	mkdir -p $(shell pwd)/data/hbase
	mkdir -p $(shell pwd)/data/zookeeper
	docker service create --env-file ./hbase.env --publish 60000:60000 --publish 60010:60010 --publish 60020:60020 --publish 60030:60030 --publish 2888:2888 --publish 3888:3888 --publish 2181:2181 --mount type=bind,source=$(shell pwd)/data/hbase,destination=/hbase-data --mount type=bind,source=$(shell pwd)/data/zookeeper,destination=/zookeeper-data --network hbase --name hbase bde2020/hbase-standalone:1.0.0-hbase1.2.6


network:
	docker network create hbase

build:
	docker build -t bde2020/hbase-base:1.0.0-hbase1.2.6 ./base
	docker build -t bde2020/hbase-master:1.0.0-hbase1.2.6 ./hmaster
	docker build -t bde2020/hbase-regionserver:1.0.0-hbase1.2.6 ./hregionserver

base:
	docker build -t bde2020/hbase-base:1.0.0-hbase1.2.6 ./base

run-base: base
	docker run --rm -it --env-file hbase.env --network hbase bde2020/hbase-base:1.0.0-hbase1.2.6 /bin/bash

run-standalone: base
	docker build -t bde2020/hbase-standalone:1.0.0-hbase1.2.6 ./standalone
	docker-compose -f docker-compose-standalone.yml up

run-standalone-hadoop: base
	docker build -t bde2020/hbase-standalone:1.0.0-hbase1.2.6 ./standalone
	docker-compose -f docker-compose-hadoop.yml up -d
	docker-compose -f docker-compose-standalone-hadoop.yml up

run-pseudo-distributed-hadoop: base
	docker build -t bde2020/hbase-standalone:1.0.0-hbase1.2.6 ./standalone
	docker-compose -f docker-compose-hadoop.yml up -d
	docker-compose -f docker-compose-pseudo-distributed-hadoop.yml up

run-distributed-hadoop: base
	docker build -t bde2020/hbase-master:1.0.0-hbase1.2.6 ./hmaster
	docker build -t bde2020/hbase-regionserver:1.0.0-hbase1.2.6 ./hregionserver
	docker-compose -f docker-compose-hadoop.yml up -d
	docker-compose -f docker-compose-distributed.yml up

run-zookeeper:
	docker-compose -f docker-compose-zookeeper.yml up -d

wordcount:
	docker run -it --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run -it --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-2.7.4/README.txt /input/
	docker run -it --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r -f /output
	docker run -it --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-submit:$(current_branch)
	docker run -it --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run -it --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run -it --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r /input

hbase-shell:
	docker run -it --rm --network ${DOCKER_NETWORK} --env-file ./hbase.env bde2020/hbase-standalone:1.0.0-hbase1.2.6 hbase shell
