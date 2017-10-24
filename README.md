# docker-hbase

# Standalone
To run standalone hbase:
```
docker-compose -f docker-compose-standalone.yml
```
The deployment is the same as in [quickstart HBase documentation](https://hbase.apache.org/book.html#quickstart).
Can be used for testing/development, connected to Hadoop cluster.

# Distributed
To run distributed hbase on docker swarm see this [doc](./distributed/README.md):
