# hadoop

```shell
# 文件系统
hadoop fs #最常用
hadoop dfs
hdfs dfs

$ hadoop fs -ls -R /
drwxrwxr-x   - root supergroup          0 2021-06-13 05:36 /tmp
drwx-wx-wx   - root supergroup          0 2021-06-13 05:36 /tmp/hive
drwx------   - root supergroup          0 2021-06-14 02:49 /tmp/hive/root
drwx------   - root supergroup          0 2021-06-14 02:49 /tmp/hive/root/b6f06db0-4995-4f7c-a7f3-2c752ac7d7f4
.......



# 将本地stu1.txt放到集群服务器上
hadoop fs -put stu1.txt /user/hive/warehouse/stu




```

# 