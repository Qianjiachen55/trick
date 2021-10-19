# docker

```
本质
1. namespace:一个特殊的进程，创建一个namespace，将进程id（pid）改为1
2. cgroup: 限制cpu使用率..
3. rootfs(chroot): 挂载进程的根目录 到 镜像目录下
						5个可读不可写层：可以理解为镜像
						1个Init层：个性化设置，提交时不包含Init层的内容
										/etc/host/
										这里设计感觉后面实际开发才知道具体用处
						1个可读可写层：保存对镜像的修改
												删除：建立file同名的.wh.file文件，遮挡这个文件
												其他：增量保存
												
so:
	1. 只是一个特殊的进程
	2. top(包括其他查看/proc文件夹的命令，就是查看内存里的信息之类的)命令
								还是查看/proc/下的cpu信息，除非挂载目录
	3. 与宿主共用一个内核
				那么内核不提供的函数，容器内也没有，所有低版本的内核无法跑高版本的容器（结论只针对linux，其他操作系统对容器的实现暂时没有看原理部分）
				
	
```





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

- 自制镜像

  ```shell
  $ docker build -t username/project:version . 
  #docker build -t "jason/go-gin-test:v1" .
  
  ```

- inspect

  ```shell
  docker inspect CONTAINER_name(| grep xxx)
  ```

  

# Kubernetes

```shell
$ kubectl get pod
$ kubectl get deployment
$ kubectl get svc

$ kubectl delete pod pod_id
$ kubectl delete deployment backend(deployment_id)
$ kubectl delete svc kube-go-app
```

