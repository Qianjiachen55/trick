# hadoop 配置

用的docker虚拟三台容器，一台master，两台slave[slave1,slave2]

### 版本

```shell
本机：ubuntu20.04
docker:
docker-image:ubuntu(18.04)
java 1.8.0_292
hadoop:3.2.2
```



## 流程如下：

- 创建三台主机：

  1. 首先拉取docker镜像：

  ```shell
  docker pull ubuntu:18.04 
  ```

  2. 创建网桥：

  ```shell
  docker network create --driver=bridge hadoop
  docker network create --subnet=172.18.0.0/16 mynetwork
  ```

  3. 用拉下来的镜像创建三个ubuntu容器

  ```shell
  $ docker run -itd --privileged --name master -p 9870:9870 -p 18088:18088 -p 9000:9000 -p 50070:50070 --net mynetwork --ip 172.18.0.2 ubuntu:18.04
  $ docker run -itd --privileged --name slave1 --net mynetwork --ip 172.18.0.3 ubuntu:18.04 /bin/bash
  $ docker run -itd --privileged --name slave2 --net mynetwork --ip 172.18.0.4 ubuntu:18.04 /bin/bash
  ```

  

  

hadoop为**分布式**文件系统，三台主机之间需要**相互通信**

```shell
$ ssh master......
#登录到master中
master
$ ssh-keygen 
$ cd ~/.ssh
（$ touch authorized_keys）
$ cat id_rsa.pub >> authorized_keys
$ scp -r ~/.ssh USER@SLAVE1_IP:<用户家目录>/.ssh
$ scp -r ~/.ssh USER@SLAVE2_IP:<用户家目录>/.ssh
#至此，已经将公钥追加到authorized_keys中
#注意此处还可能有坑：
#1.  检查 /etc/sshd_config文件，这里只写出位置，可以上网查找相关配置（关键字：ssh 远程连接 免密登录 配置）
#2. 巨坑：我是从docker里面复制的，简单说就是从master里面将.ssh复制到我的笔记本上，然后无法查看
#（ll .ssh，输出 root，于是用chown更改所属用户，进行查看，然后复制到slave1中，但是无法免密登录，我折磨了好久，然后在slave1中 chown修改回root，之后才好起来）
#不要执行上面括号的操作！！！！！！！！！！！！！！！！！！！但是出了问题可以这么找问题


# 另一种免密登录的办法
# 分别在几台机子里面ssh-keygen,然后将公钥追加到同一authorized中。(我比较懒，就直接一套公钥私钥hhhhhh)
#到这里已经成功了一大半～～～


```



然后就是下载hadoop了(这里远比想象的简单,**maybe~**)

```shell
#1. 下载java
#2. 下载hadoop
#3. 解压hadoop到固定目录
#4. 设置环境变量(~/.profile 或 ~/.bashrc文件，我用的是.profile,建议不要折磨自己,也可以查看两个文件的区别，我反正没看明白)


sudo apt install openjdk-8-jdk
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2-src.tar.gz
sudo tar -zxf ~/hadoop.master.tar.gz -C /usr/local
环境变量
export JAVA_HOME=/usr/lib/jvm/java-8....
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$HADOOP_HOME/bin:/$HADOOP_HOME/sbin:$PATH

```

