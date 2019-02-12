# Grafana



### InfluxDB Cmd 
Install singleton InfluxDB via docker
```sh
$ docker run --rm -d -p 8086:8086 -p 2003:2003 \
  -v $PWD:/var/lib/influxdb \
  -e INFLUXDB_GRAPHITE_ENABLED=true \
  influxdb
```
Creating a DB named testdb:
```sh
$ curl -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE testdb"
$ curl -XPOST http://localhost:8086/query --data-urlencode "q=Show DATABASES"
```
Write records to table:
```sh
$ curl -i -XPOST 'http://localhost:8086/write?db=testdb' \
  --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'
```
Query records:
```sh
$ curl -XPOST http://localhost:8086/query?db=testdb \ 
  --data-urlencode "q=SELECT \"value\" FROM \"cpu_load_short\" WHERE \"region\"='us-west'"
```

***Ref.***
* [InfluxDB-Docker] - Install InfluxDB with docker image
* [InfluxQL] - Schema exploration using InfluxQL!
* [Telegraf] - an agent for collecting, processing, aggregating, and writing metrics.
* [InfluxDB-Kafka] - Using Telegraf to Send Metrics to InfluxDB and Kafka


[InfluxDB-Docker]: <https://hub.docker.com/_/influxdb>
[InfluxQL]: <https://docs.influxdata.com/influxdb/v1.7/query_language/schema_exploration/>
[Telegraf]: <https://github.com/influxdata/telegraf>
[InfluxDB-Kafka]: <https://www.influxdata.com/blog/using-telegraf-to-send-metrics-to-influxdb-and-kafka/>

