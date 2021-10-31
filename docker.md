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



2021.10.19

```shell
看docker的原理，虽然只明白了作者一点点的意思，但也也感觉理解了很多东西

docker commit 
# 可读可写层：copy-on-wrire:copy到这一层，再做修改
# 将可读可写层加入到可读不可写层

docker exec	contanier.  ...
	# 一个进程选择加入到另一个已有namespace的进程下（进入容器），使用系统调用setns，让新启动的进程与容器共享多种namespace，
		#setns有两个参数，一个是namespace的目录，另一个是执行的命令
		--net
		# 指定网桥
	# 本质指定network space
	-v
	# 指定挂载卷
	# 将宿主目录 /file 挂载到/var/lib/docker/aufs/mnt/[可读写层 ID]/file
	
	
	

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





- kube-apiserver
- kube-scheduler
- kube-controller-manager

持久化的数据有kube-apiserver保存在etcd数据库里





Pod,deployment,service

```shell
应用 有多个容器需要紧密合作，容器间通信 ->pod
启动多个应用 ->pod管理器 -> deployment
pod间通信 (希望统一访问ip:port,并且负载均衡等)-> service
pod间通信需要授权 -> secret
```





```shell
YAML 文件出现在被 kubelet 监视的 /etc/kubernetes/manifests 目录下，kubelet 就会自动创建这些 YAML 文件中定义的 Pod，即 Master 组件的容器。
```





```shell
pod:
- 只是一个逻辑概念，本质还是Namespace 和 Cgroups
- 本质是 pod内的容器 共享一个namespace 并且可以声明共享同一个Volume
- pod内容器是对等关系
- pod流量的进出通过Infra容器完成


从一个容器内跑多个应用---> 一个pod内跑多个容器


可以把pod想象成虚拟机，里面有一组进程在运行


共享一个namespace的pod内部可以通过 ps 查看其他容器
```



```shell
tty: 提供输入输出（小黑框）
```

