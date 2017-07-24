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

# Pseudo-distributed
To run pseudo-distributed hbase:
```
make network
make run-pseudo-distributed-hadoop
```
This will start up a local hadoop cluster, see [docker-compose-hadoop.yml](./docker-compose-hadoop.yml) for details.
HBase will store its' data in hdfs://namenode:9000 and use external zookeeper.
Both HMaster and HRegion servers will run in the same docker container (hbase).

# Distributed
To run distributed hbase:
```
make network
make run-distributed-hadoop
```
This will start a local hadoop cluster.
HBase will store its' data in hdfs://namenode:9000 and use external zookeeper.
HMaster and HRegion servers will run in separate docker container.
