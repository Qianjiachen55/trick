# Linux

#### 换源

```
echo 'deb http://mirrors.163.com/debian/ jessie main non-free contrib
deb http://mirrors.163.com/debian/ jessie-updates main non-free contrib
deb http://mirrors.163.com/debian/ jessie-backports main non-free contrib
deb-src http://mirrors.163.com/debian/ jessie main non-free contrib
deb-src http://mirrors.163.com/debian/ jessie-updates main non-free contrib
deb-src http://mirrors.163.com/debian/ jessie-backports main non-free contrib
deb http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib
deb-src http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib'  > sources.list
```



### find

```shell
$ 
find / -name "my.cnf"

```

### apt

```shell
$ apt-get update 更新软件源中的所有软件列表。 
$ apt-get upgrade 更新软件。 
$ apt-get dist-upgrade 更新系统版本。如果你对新版本软件的需求不是那么迫切，可以不执行


```

### 压缩

```shell
.gz //gzip程序压缩产生的文件
.zip //zip压缩文件
.rar //rar压缩文件
.tar //tar程序打包产生的文件
.tar.gz	//tar程序打包并gzip压缩的文件

tar
# 压缩
$ tar -xvf etc.tar
$ tar -xzvf test.tar.gz 
# 解压缩
$ tar czf archive.tar.gz java/ hello.c

```

### service

```shell
# 查看状态
service 应用名称 status
$ service mysql status
[info] MySQL is stopped..

# 启动/暂停/重启
service mysql start/stop/restart
```

### lsof

```shell
# 查看端口占用情况
$ lsof -i:5000 # 查看5000端口
```



### ps

```shell
ps 查看进程
-a:所有程序
-h:显示树状结构
-f:显示UID,PPIP,C与STIME栏位。
-aux: 显示所有包含其他使用者的行程
$ ps -au
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       271  0.0  0.1  20412  2708 pts/0    Ss   07:28   0:00 /bin/bash
root       279  0.0  0.1  20416  2720 pts/1    Ss   07:28   0:00 /bin/bash
root      4375  0.0  0.1  20412  2092 pts/0    S+   09:42   0:00 /bin/bash
root      4376  0.4  6.2 2216592 128296 pts/0  Sl+  09:42   0:23 /usr/lib/jvm/java-8-open
root      4747  0.0  0.1  17508  2140 pts/1    R+   11:03   0:00 ps -au
```



### vim

```shell
:set nu #显示行号
:set nonu # 不显示行号
# 默认不显示

# 永久显示
vim ~/.vimrc
# 增加一行
set number
:wq


```



argon2:$argon2id$v=19$m=10240,t=10,p=8$Sfw73dEKf50/F2dWSOpmQw$ebwzJOBUUztjTxAQ4os7qw

### mkdir

```shell
# 递归生成文件
mkdir -p /a/b/c/d.txt
```

### netstat

```
netstat -anp
```

### ifconfig

```shell
# install 
sudo apt install net-tools
# 可查看内网地址
ifconfig

#查看外网地址
curl http://members.3322.org/dyndns/getip
```

### scp

```shell
#复制文件
scp local_file remote_username@remote_ip:remote_folder 
#复制文件夹
scp -r local_folder remote_username@remote_ip:remote_folder 
#复制远程到本地
scp root@www.runoob.com:/home/root/others/music /home/space/music/1.mp3 
scp -r www.runoob.com:/home/root/others/ /home/space/music/
```

### 环境变量

```shell
export PATH=/path/to/your/dir:$PATH
```

#### 添加到root组

```
usermod -g root username ，执行完后username即归属于root组了，可以再输入
```



### 管道

```
grep
kill 一组进程
ps -ef| grep mongo| grep -v grep | cut -c 9-16|xargs kill -15
(-15 正常退出)
```

