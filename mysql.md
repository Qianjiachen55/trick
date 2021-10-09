# Mysql 

### 解决 Can 't connect to local MySQL server through socket '/tmp/mysql.sock '(2) "

（一般有效）

```
:Can 't connect to local MySQL server through socket '/tmp/mysql.sock '(2) "
find / -name mysql.sock
# 查找my.cnf

vim my.cnf

socket=/var/lib/mysql/mysql.sock
```

![image-20210612101254426](http://photo.happywater.xyz/image-20210612101254426.png)

```
:wq


chmod 777 /var/lib/mysql

service mysql restart
# service mysqld restart
```



### 安装

```shell
# 安装


sudo netstat -tap | grep mysql
 # 查看本地是否有
 # 没有就安装
 apt-get install mysql-server mysql-client
```

### 修改配置

```
 vim /etc/mysql/mysql.conf.d/mysqld.cnf
```

### 忘记密码

```sql
> update user set password=password("123456") where user="root";

报错就用下面的！！

> update user set authentication_string=PASSWORD("123456") where user='root';
```

### 连接问题

```sql
> update user set host = '%' where user = 'root';
> CREATE USER 'test'@'0.0.0.0' IDENTIFIED BY '123456';


GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' WITH GRANT OPTION


/etc/mysql/my.cnf
# 加上下面这个
[mysqld]
bind-address = 0.0.0.0
```



### 刷新权限

```shell
> flush privileges;
```



