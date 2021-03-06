# hive

```sql
# 在hive按照目录下有个bin/hive直接进入客户端
# 基本
# 在hive cli查看hdfs文件系统
> dfs -ls /;
.....
# 在hive cli中查看本地文件系统
> ! ls /
# 我没试成功可能是版本的问题

在用户目录下的 .hivehistory里面有hive输入的所有历史命令

Default 数据仓库的最原始位置是在 hdfs 上的：/user/hive/warehouse 路径下。
```

### 其他

```sql
 $ hive -e "select * from stu"
 $ hive -f ./hive.hql > ./hive_resule.txt
 $ hive -f ./hive.hql 
 
 
 # 数据类型
 TINYINT       1Byte
 SMALLINT      2Byte
 INT           4Byte
 BIGINT        8Byte
 BOOLEAN       boolean
 FLOAT         单精度 1位符号，8位指数，23位小数
 DOUBLE        双精度 1位符号，11位指数，52我小数
 STRING        字符
 
 TIMESTAMP     时间类型
 
 
 # 集合数据类型
 STRUCT
 MAP
 ARRAY
 
 # 尽量键宽表，冗余就冗余
 # mysql范式
 # 三范式
# 第一范式：要求有主键，并且要求每一个字段原子性不可再分
# 原子性不可再分
# 第二范式：要求所有非主键字段完全依赖主键，不能产生部分依赖
# 完全依赖主键
# 第三范式：所有非主键字段和主键字段之间不能产生传递依赖
# 
```

### create

```sql
# 创建库，并指定位置，默认位置是/user/hive/warehouse
> create database hive2 location '/hive2';
# 键表
> create table student (id int,name string);

$ cat create.text
create table test(
name string,
friends array<string>,
children map<string,int>,
address struct<street:string,city:string>
)
row format delimited fields terminated by ','
collection items terminated by '_'
map keys terminated by ':'
lines terminated by '\n';
(location '/user/hive/warehouse/test') #指定位置


$ hive -f create.txt 
> desc test;
+-----------+------------------------------------+----------+
| col_name  |             data_type              | comment  |
+-----------+------------------------------------+----------+
| name      | string                             |          |
| friends   | array<string>                      |          |
| children  | map<string,int>                    |          |
| address   | struct<street:string,city:string>  |          |
+-----------+------------------------------------+----------+

4 rows selected (0.343 seconds)
# 访问数组
$ select friends[1] from test;
+----------+
|   _c0    |
+----------+
| friend2  |
+----------+

# 访问map
$ select children['child2'] from test;
+------+
| _c0  |
+------+
| 18   |
+------+

# 访问结构体
$ select address.city from test;
+----------+
|   city   |
+----------+
| beijing  |
+----------+



```



### drop

```sql
# !!!!删库跑路
> drop database banzhang cascade;
# !!!删除表
> drop tabel stu
```

### load

```sql
$ pwd
/opt

$ cat stu.txt
# 现在有文本 stu.txt
1	banzhu
2	tiezhu
3	shazhu

# 将stu.txt导入student
> load data local inpath '/opt/stu.txt' into table student;

# 查看
> select * from student;
+-------------+---------------+
| student.id  | student.name  |
+-------------+---------------+
| 1           | dageda        |
| NULL        | NULL          |
| NULL        | NULL          |
| NULL        | NULL          |
+-------------+---------------+

# 未插入成功
# 指定分隔符为tab（'\t'）
> create table stu(id int,name string) 
row format delimited 
fiedls terminated by "\t";

# 插入数据
> load data local inpath 'opt/stu.txt' into table stu;

> select * from stu;
+---------+-----------+
| stu.id  | stu.name  |
+---------+-----------+
| 1       | banzhu    |
| 2       | tiezhu    |
| 3       | shazhu    |
+---------+-----------+


## overwrite
# 直接覆盖数据
> load data local inpath '/opt/dept.txt' overwrite into table stu;
> select * from stu;
+---------+-------------+
| stu.id  |  stu.name   |
+---------+-------------+
| 10      | ACCOUNTING  |
| 20      | RESEARCH    |
| 30      | SALES       |
| 40      | OPERATIONS  |
+---------+-------------+

# load data到分区
> load data local inpath '/opt/dept.txt' into table dept_partition2 partition(month='2021-06',day='03');
```

### 导出insert

```sql
# 导出到本地，注意指定分割符
> insert overwrite local directory '/opt/student' row format delimited fields terminated by '\t' select * from student;

# 导出到hdfs服务器只需要去掉local

# 还可以
$ hive -e 'select * from ...' > a.txt

```





### select

```sql
# 最基本的
select * from ....


# 查看当前数据库
> select current_database();


> select dname as dept_name from dept;
+-------------+
|  dept_name  |
+-------------+
| ACCOUNTING  |
| RESEARCH    |
| SALES       |
| OPERATIONS  |
+-------------+

limit 与mysql一样
> select * from emp where sal>1000;
> select * from emp where comm is null;
> select * from emp where sal between 1500 and 3000;
> select * from select deptno,avg(sal) avg from emp group by deptno where avg>2000;


# like 
% 表示一位或多位
_ 表示一位

select * from emp where hiredate like "1981-%";

# rlike
# 正则匹配
select * from emp where hiredate rlike "[2]";



select e.ename,d.deptno,l.loc_name 
from emp e 
join dept d 
on d.deptno=e.deptno 
join location l 
on d.loc=l.loc;


# order
# 降序
select * from emp order by sal desc;
```

### insert

```sql
# 往分区里面插入数据
> insert into table student partition(month='2021-06') values(6,'lanlou');

# 根据单张表查询结果插入
> insert into table student partition(month='2021-07') 
	select id,name from student where month='2021-06';
> insert overwrite table student partition(month='2021-07') 
	select id,name from student where month='2021-06';

> from student 
insert overwrite table student partition(month='2021-08') 
select id,name where month='2021-06' 
insert overwrite table student partition(month='2021-09')
select id,name where month ='2021-07';


> insert overwrite local directory '/opt/hql_shell/result' 
> row format delimited fields terminated by '\t' 
> select * from emp 
> distribute by deptno 
> sort by sal;

$ ls /opt/hql_shell/result/
000000_0  000001_0  000002_0


```



### as select

```sql
# 用原表字段
create table stu_cp as select id,name from stu;
```



### 外部表

```shell
# 未被external修饰的是内部表【managed table】，被external修饰的为外部表【external table】。
# 内部表数据由Hive自身管理，外部表数据由HDFS管理。
# 删除内部表会直接删除元数据（metadata）及存储数据；删除外部表仅仅会删除元数据，HDFS上的文件并不会被删除

> create external table if not exists default.dept(
> deptno int,
> dname string,
> loc int
> )
> row format delimited fields terminated by '\t';

> desc formatted dept;
| Table Type:   | EXTERNAL_TABLE    |NULL|
# 外部表转内部表
> alter table dept set tblproperties('EXTERNAL'='FALSE');
# ('EXTERNAL'='FALSE') 固定大小写
> desc formatted dept;
| Table Type:   | MANAGED_TABLE  | NULL |

```

### 分区

```shell
# 分区表
# 分区就是分目录
# 把大的数据集根据业务分割成小的数据集
# 一般是日期
# 查询的时候通过where指定分区；缩减查询数据量
# 谓词下推
>
create table dept_partition(
deptno int,
dname string,
loc string
)
partitioned by (month string)
row format delimited fields terminated by '\t';



> load data local inpath '/opt/dept.txt' into table dept_partition partition(month='2021-06');

> select * from dept_partition;
+----------------------+--------------------+------------------+--------------------+
| dept_partition.deptno|dept_partition.dname|dept_partition.loc|dept_partition.month|
+----------------------+--------------------+------------------+--------------------+
| 10                   | ACCOUNTING         | 1700             | 2021-06            |
| 20                   | RESEARCH           | 1800             | 2021-06            |
| 30                   | SALES              | 1900             | 2021-06            |
| 40                   | OPERATIONS         | 1700             | 2021-06            |
| 10					         | ACCOUNTING         | 1700             | 2021-07            |
| 20                   | RESEARCH           | 1800             | 2021-07            |
| 30                   | SALES              | 1900             | 2021-07            |
| 40                   | OPERATIONS         | 1700             | 2021-07            |
+----------------------+--------------------+------------------+--------------------+

>select * from dept_partition where month='2021-06';
+----------------------+--------------------+------------------+--------------------+
| dept_partition.deptno|dept_partition.dname|dept_partition.loc|dept_partition.month|
+----------------------+--------------------+------------------+--------------------+
| 10                   | ACCOUNTING         | 1700             | 2021-06            |
| 20                   | RESEARCH           | 1800             | 2021-06            |
| 30                   | SALES              | 1900             | 2021-06            |
| 40                   | OPERATIONS         | 1700             | 2021-06            |
+----------------------+--------------------+------------------+--------------------+

# 把分区字段当成数据表的一个字段
# 先访问元数据库，得到分区信息，再根据分区信息访问hdfs相应分区文件夹
# hdfs中的位置： /user/hive/warehouse/dept_partition/month=2021-07


> alter table dept_partition add partition (month='2021-08');
$ hdfs dfs -ls /user/hive/warehouse/dept_partition
Found 3 items
drwxrwxr-x   - root supergroup          0 2021-06-16 04:06 /user/hive/warehouse/dept_partition/month=2021-06
drwxrwxr-x   - root supergroup          0 2021-06-16 04:08 /user/hive/warehouse/dept_partition/month=2021-07
drwxrwxr-x   - root supergroup          0 2021-06-16 06:04 /user/hive/warehouse/dept_partition/month=2021-08

# 查看分区
> show partitions dept_partition;
+----------------+
|   partition    |
+----------------+
| month=2021-06  |
| month=2021-07  |
| month=2021-08  |
| month=2021-09  |
| month=2021-10  |
+----------------+

# 添加多个 空格分开
> alter table dept_partition add partition (month='2021-09') partition(month='2021-10');

# 删除 逗号分开
> alter table dept_partition drop partition(month='2021-08'),partition(month='2021-09');



```



### 二级分区

```shell
$ cat create_table_dept_2.hql 
create table dept_partition2(
	deptno int,
	dname string,
	loc string
)
partitioned by (month string, day string)
row format delimited fields terminated by '\t';


> load data local inpath '/opt/dept.txt' into table dept_partition2 partition(month='2021-06',day='03');

$ hadoop fs -ls -R /user/hive/warehouse/dept_partition2
drwxrwxr-x   - root supergroup          0 2021-06-16 07:24 /user/hive/warehouse/dept_partition2/month=2021-06
drwxrwxr-x   - root supergroup          0 2021-06-16 07:24 /user/hive/warehouse/dept_partition2/month=2021-06/day=03
-rwxrwxr-x   3 root supergroup         69 2021-06-16 07:24 /user/hive/warehouse/dept_partition2/month=2021-06/day=03/dept.txt

# 只是创建了两级目录

# 查询
> select * from dept_partition2 where month='2021-06' and day='03';

# 我们将dept.txt传到/user/hive/warehouse/dept_partition2/month=2021-11/day=03下
$ hadoop fs -mkdir -p /user/hive/warehouse/dept_partition2/month=2021-11/day=03


$ hadoop fs -put ./dept.txt /user/hive/warehouse/dept_partition2/month=2021-11/day=03

# 此时无法查询到
# 因为元数据中没有，只是将文件存到对应目录下
# 解决办法
# 1
> msck repair table dept_partition2
# 然后就可以查到数据了 滴可liao
> select * from dept_partition2;
.......
> show partitions dept_partition2;
+-----------------------+
|       partition       |
+-----------------------+
| month=2021-06/day=03  |
| month=2021-11/day=03  |
+-----------------------+
# 还有个骚操作
# 2
> alter table dept_partition2 add partition(month='2021-12',day='03');

> show partitions dept_partition2;
+-----------------------+
|       partition       |
+-----------------------+
| month=2021-06/day=03  |
| month=2021-11/day=03  |
| month=2021-12/day=03  |
+-----------------------+

```

### 分桶

```sql
# 创建分桶表并指明分桶字段
> create table stu_buck(id int,name string)
> clustered by(id)
> into 4 buckets
> row format delimited fields terminated by '\t';

# 不可load进来
# 需要从别的表加载进来
insert into stu_buck select * from stu;

```





### alter

```shell
# alter更改数据不修改元数据

# 更改表名
> alter table student rename to student_1;

# 更改列信息 替换单个列
> alter table stu change column name s_name string;

# 增加
> alter table stu add columns(age int);

# 替换 
> alter table stu replace columns (age int);
> alter table stu replace columns (id int,name string);

# 添加分区（二级分区）
> alter table dept_partition2 add partition(month='2021-12',day='03');

# 添加多个分区 #空格# 分开
> alter table dept_partition add partition (month='2021-09') partition(month='2021-10');

# 删除 逗号分开
> alter table dept_partition drop partition(month='2021-08'),partition(month='2021-09');

# 删除分区
> alter table dept_partition drop partition(month='2021-08'),partition(month='2021-09');

# 删除二级分区
> alter table dept_partition2 drop partition(month='2021-12',day='03');

# 外部表转内部表
> alter table dept set tblproperties('EXTERNAL'='FALSE');

```

### having 与 where

```sql
# where 针对表中的列
# having 针对查询结果中的列
select deptno,count(*)  ct from emp group by deptno having ct > 3;
```



### join

```sql
# 只支持等值连接，不支持非等值连接。
# 内连接
> select e.deptno,d.dname,e.ename from emp e join dept d on e.deptno=d.deptno;
# 左连接 右连接
# 满连接
> select e.deptno,d.dname,e.ename from emp e full join dept d on e.deptno=d.deptno;

```



### export import

```sql

# 先用export再用import
> import table student partition(month='2021-11') from '/user/hive.....'

# 该表中没有此分区才可导入成功

```

### truncate

```sql
# 清空数据
> truncate table student2;

> select * from student2;
+--------------+----------------+-----------------+
| student2.id  | student2.name  | student2.month  |
+--------------+----------------+-----------------+
+--------------+----------------+-----------------+
```



### 排序

```sql
order 全局排序
sort by区内排序
distribute by reduce个数要多
cluster by 分区字段和区内字段相同

```





### Sqoop

```sql
# nothing now...
```



### nvl:替换

```sql
 NVL( string1, replace_with)
 > select nvl(comm,-1) from emp;
+-------+
|  _c0  |
+-------+
| -1    |
| 300   |
| 500   |
| -1    |
| 1400  |
| -1    |
| -1    |
| -1    |
| -1    |
| 0     |
| -1    |
| -1    |
| -1    |
| -1    |
+-------+
> select nvl(comm,mgr) from emp;
+-------+
|  _c0  |
+-------+
| 7902  |
| 300   |
| 500   |
| 7839  |
| 1400  |
| 7839  |
| 7839  |
| 7566  |
| NULL  |
| 0     |
| 7788  |
| 7698  |
| 7566  |
| 7782  |
+-------+
```



### 时间处理

```sql
# 格式化字符串
> select date_format('2016-06-29 11:23:34','yyyy-MM-dd hh:mm:ss');
+----------------------+
|         _c0          |
+----------------------+
| 2016-06-29 11:23:34  |
+----------------------+


# 时间天数相加 date_add
> select date_add('2020-11-31',5);
+-------------+
|     _c0     |
+-------------+
| 2020-12-06  |
+-------------+
> select date_add('2020-11-31',-5);
+-------------+
|     _c0     |
+-------------+
| 2020-11-26  |
+-------------+




# 时间天数相减 date_sub
....


# 时间相减 datediff







```

