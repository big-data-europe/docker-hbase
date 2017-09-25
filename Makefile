.PHONY: all test clean

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
