# docker-hbase

# Standalone
To run standalone hbase:
```
make network
make run-standalone
```
HBase data is written to the folder ./data/hbase, zookeeper data is written to ./data/zookeeper. The deployment is the same as in [quickstart HBase documentation](https://hbase.apache.org/book.html#quickstart).
Can be used for testing/development, does not connect to Hadoop cluster.

# Standalone with Hadoop
To run standalone hbase with hadoop:
```
make network
make run-standalone-hadoop
```

# Distributed
To run distributed hbase on docker swarm see this [doc](./distributed/README.md):
