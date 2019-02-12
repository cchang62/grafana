# Grafana



### InfluxDB Cmd 
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
* [InfluxQL] - Schema exploration using InfluxQL!


[InfluxQL]: <https://docs.influxdata.com/influxdb/v1.7/query_language/schema_exploration/>
