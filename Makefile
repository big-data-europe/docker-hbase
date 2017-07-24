.PHONY: all test clean

network:
	docker network create hbase

base:
	docker build -t bde2020/hbase-base:1.0.0-hbase1.2.6 ./base

run-standalone: base
	docker build -t bde2020/hbase-standalone:1.0.0-hbase1.2.6 ./standalone
	docker-compose -f docker-compose-standalone.yml up

run-pseudo-distributed-hadoop: base
	docker build -t bde2020/hbase-standalone:1.0.0-hbase1.2.6 ./standalone
	docker-compose -f docker-compose-hadoop.yml up -d
	docker-compose -f docker-compose-pseudo-distributed-hadoop.yml up
