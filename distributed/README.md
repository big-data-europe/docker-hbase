# How to run HBase in Docker Swarm

Docker Swarm deployment is more complex than the simple one-node deployment.
Thus we split it in several stacks.
After each step, make sure to check that the deployed stack works as intended.
Also, the following stacks are part of production setup for InfAI (BDE partner) servers.
In case, you deploy it on your servers, check the constraints and customize docker-compose and make files.

We expose services using [Traefik](https://github.com/containous/traefik). To deploy traefik:
```
make traefik
```

Deploy Hadoop:
```
make hadoop
```

Deploy Zookeeper:
```
make zookeeper
```

Deploy HBase:
```
make hbase
```
