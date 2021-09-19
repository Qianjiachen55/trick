# docker

```
# 从本机复制到容器
docker cp 本地文件的路径 container_id:<docker容器内的路径>
docker cp c4bb71da3d27:/opt/hive/conf/hive-site.xml ./

docker start 21a3cdb63a18 e0102ccb5a64 801bc7ae05ad

docker exec -it 21a3cdb63a18 /bin/bash

docker rm container

d78b4acc8ea7

docker run -p 8000:80 -it ubuntu /bin/bash
以上指令会将容器的80端口映射到宿主机的8000端口上。


docker import container.docker jaka/ubuntu
# 导入容器为镜像


docker run -it --name hadoop-master -h master arm64v8/ubuntu bash
指定名称和hostname 
```

