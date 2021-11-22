#!/bin/bash

image="golang@sha256:8f5be862554000ce2923edb499fed8a3ba8bc11d7fdb50f85730a48358ccf9c7"
docker pull $image
container_name="build_container"
project_path="`pwd`"
container_path="/go/src/github.com/ClickHouse/clickhouse_exporter"
docker run -idt -v ${project_path}:${container_path} --name $container_name $image bash
# set proxy
docker exec -w $container_path $container_name /usr/local/go/bin/go env -w GOPROXY=https://goproxy.cn,direct
# build
docker exec -it -w $container_path $container_name bash -c "make init && make"
docker cp $container_name:/go/bin/clickhouse_exporter ./
docker stop $container_name
docker rm $container_name
