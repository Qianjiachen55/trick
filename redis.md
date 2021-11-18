# redis

**key-value缓存数据库**



### 字符串

**Redis 字符串的大小被限制在 512 M**



#### set 

```shell
# 添加键值对
$ set key value

# 设置过期时间
$ set key value EX time

# key不存在才对key进行操作
$ set key value NX
$ setNX key value
$ setNX key time value

# key存在才对key操作
$ set key value XX
# 同上
```





#### get

```shell
#返回value
$ get key

# return value -> set key value
$ getset key value
```

#### ttl

```shell
#返回剩余时间
$ ttl key
```

#### strlen

```shell
# return lenth of value[key]
$ strlen key
```



#### append

```shell
$ append key value
'''
  if value[key]:
    $ set key `oldValue+value`
  else:
    $ set key value
  return len(value[key])
'''
```

#### setRange

```shell
$ setRange key offset value
# 将value覆盖到offset位置处，空白补`\x00`
```

#### getrange

```shell
$ getrange key start end
# return value[key][start:end]
# 可以用负数，但是end必须在start右边
# value[key] : ...start.....end
```

#### incr

```shell
$ incr key
#  return ++value[key]
# set key 0 -> return ++value[key]
```

#### incrby

```shell
$ incrby key num
# value[key] += num -> return value[key]
# set key 0 -> value[key] += num -> return value[key]
```

#### incrbyfloat

```shell
$ incrbyfloat key num
# .....

##########################
#  浮点数不可 incr incrby  #
##########################
```

#### decr

```shell
$ decr key
```

#### decrby

```shell
$ decrby key num
# ........
```

#### mset && mget

```shell
# 同时设置多个key-value 原子性操作
$ mset key1 value1 key2 value2 ......
$ mget key1 key2 ......
```

#### msetnx

```shell
# 同时设置多个key-value 原子性操作 key不存在才创建成功 ，只要一个失败，全部失败
$ msetnx key1 value1 key2 value2 ......
$ mgetnx key1 key2 ......
```



### 哈希表

#### hset

```shell
$ hset key field1 value1 field2 value2
$ hget key field
```



#### hsetnx

不存在即创建

```shell
$ hsetnx key field
```



#### hget

```shell
$ hget key field
```

#### hlen

```shell
返回 key内字段数
$ hlen key
```



#### Hkeys

```shell
$ hkeys key 
返回 key中的所有field
```

#### hvals

```shell
$ hkeys key
返回 key中所有的values
```



### 列表

#### lpush

```shell
$ lpush list value
# 从左边加入元素
```

#### lpushx

```shell
当list存在才添加
```

#### rpush

#### rpushx

#### lpop

```shell
$ lpop key count
# return value_list have been pop

```

#### RPOP

#### RPOPLPUSH

```shell
$ RPOPLPUSH from to
从from rpop >> to Lpush
```

##### 实现循环队列

```shell
$ lpush a 1 2 3 4 5 
$ rpoplpush a a
```

##### 实现安全的队列

- 场景：客户端取出消失后崩溃或者发生别的错误导致消息未被正常处理
- 解决方案：使用RPOPLPUSH可以取出消息并且**备份**消息到别列表，如果一切正常使用 **LREM key(bak) count value**从备份表删除

#### LREM

```shell
$ LREM key count value
# 移除与value相同的
# count = 0  移除所有
# count > 0 从头开始移除 count 个
# count < 0 从尾开始移除 count 个
```

#### Lindex

```shell
$ lindex key(list) index
# lindex petlist 1
```



#### Linsert

```shell
$ linsert key before value element
$ linsert key after value element
```



#### lset

```shell
$ lset key index value
```



#### ltrim

```shell
# 保留区间内元素，其他被删除
# 如果stop > start -> stop = end
$ ltrim key start end
```



#### Blpop

```shell
$ Blpop keys time
# 阻塞
# 直到可以从keys中弹出一个数据（阻塞时间为time，time为0表示一直阻塞）
```

#### MULTI/EXEC

```shell
# 包裹在块内的代码可以立即返回
$ multi
$ blpop keys time
# return ...
$ exec

```

### 集合

#### SADD

```shell
$ SADD key member []..
```

#### SISMEMBER

```shell
#判断 member是否在key内
$ sismember key member
```

#### SPOP

```shell
#从集合内取出一个元素
$ SPOP key
```

#### SrandMember key

```shell
# 随机返回一个元素，不删除
```

#### SRem

```shell
# 移除一个元素
$ srem key member
```

#### Smove

```shell
$ Smove from_set to_set member
```

#### Scard

```shell
$ Scard set
# 返回集合内元素数量
```

#### Smembers

```shell
$ Smembers set
#返回所有元素
```

#### Sinter

```shell
$ Sinter set1 set2
# 返回集合的交集
```

#### SinterStore

```shell
$ SinterStore res set1 set2
# 将set1和set2的inter保存到res
```

#### Sunion

```shell
$ Sunion set1 set2
# 返回set1，set2的合集
```

#### SunionStore

```shell
$ SunionStore res set1 set2
# 将set1和set2的union保存到res
```

#### Sdiff

```shell
$ SDiff set1 set2
# 返回set1 - set2
$ SDiff set2 set1
# 返回set2 - set1
```

#### SDiffStore

```shell
$ SDiffStore res set1 set2
# res = set1 - set2
```





## 数据库

#### expire 

```shell
$ expire key time
# 设置生存时间 30s 1min....
```

#### expireat

```shell
$ expire key datetime
#datetime 时间戳，这个key在什么时间点过期
```

#### flash

```shell
flashall #清空所有
flashdb #清空当前库
```



#### MUTI /EXEC

```shell
# 事物进队列，最后由exec原子性执行
```







---

### 持久化

#### sav

```shell
$ sav
#保存数据库所有的key 阻塞所有redis进程
```

#### bgsav

```shell
$ bgsave 
# fork一个新子进程，保存数据
```





## Redis

- mset与set

```shell


单指令set n次  发送时长*n*2+执行时长*n
多指令set n次  发送时长*2  +执行时长*n

```

- Incr&decr

```shell
减少操作次数
```



- hash

```shell
购物车
$ hmset 001 g02 1 g04 7 g05 100
$ hmset 003 g01:nums 100 g01:info hhhhh
$ hsetnx 003 g01:nums 200 # 有就不改


抢购
$ hmset p01 c30 1000 c50 1000 c100 1000
$ HINCRBY p01 c50 -1
```

- list

```shell
右进左查
```

- 阻塞

```shell
blpop listA 10 # 阻塞10s
```

- 随机获取（随机推荐）

```shell
srandmember users 2 # 不改变原集合
spop users # 改变原集合
```

- 共同好友（set）

```shell
sinter u1 u2
SINTERSTORE u3 u1 u2
u1&u2 -->u3
```



- union权限

```shell
sadd r1 getadd getById 
sadd r2 getCount getall insert
sunionstore user r1 r2
# 判断user有无操作权限 

```

- 统计访问量

```shell
统计网站访问量pv,uv,ip
pv:网站访问次数，刷新可提高
uv:网站被不同用户访问次数，通过cookie统计，相同用户切换ip地址，uv不变
ip:被不同ip访问的总次数，通过ip地址统计访问量，同ip不同用户，ip不变

比如ip：
sadd ips ip1
sadd ips ip2
sadd ips ip3
....

scard ips
```

## 业务

### 限时限次

api接口每天调用n次

- 设计计数器，记录调用次数,用户id为key，使用次数为value
- 调用前获取次数
  - 不超过次数，调用计数+1
  - 调用失败，计数-1
- 为计数器设置生命周期为指定周期，自动清空周期内的使用次数

```shell
setex 415 10 1
# value 最大值 9223372036854775807 可以利用这个异常做计数，incr到这个值就会有异常

```



## 通用操作

```shell
keys *
keys ???
del xxx
sort xxx

redis-cli monitor //实时监控redis
```



## 持久化

rdb

```shell
save #同步
bgsave #background save ，异步（fork）

#自动执行
save second changes
# second时间范围内key的变化达到changes数量就bgsave

```

快照思想

io性能降低

fork创建子进程,内存消耗

宕机带来数据丢失的风险





AOF

append only file

解决数据持久化的实时性



存储策略

- 每次
- 每秒
- 系统控制

```shell
BGREWRITEAOF # 手工重写
```



### 事物

```shell
multi #开始执行
...
...
...
exec #结束

(discard 取消任务)
```



watch

```shell
监控到的key发生改变，不做更改
对在exec之前发生变化，终止事物
```

锁

```shell
setnx lock-name 1
expire lock-name(防止锁没被释放)

```



过期数据删除策略

- 定时删除
  - 快速删除
  - cpu可能压力很大
- 惰性删除
  - 到达时间，等下次访问就删除
  - 节约cpu
  - 内存占用大
- 定期删除
  - 定时轮询

### bitmap

```shell
位向量，0或1
bitop op reskey k1 k2
op: and or not xor

Setbit KEY_NAME OFFSET

bitcount key

```



### hyperLogLog

```shell
用于进行基数统计，不是集合，不存数据，只记录数量
大数据里面大概会有0.81%的误差

pfadd 最大12k
pfmetge 之后固定12k
```



### GEO

计算两个坐标点



## 主从

```shell
1. redis-server redis-6380.conf --slaveof 127.0.0.1 6379
2. SLAVEOF ip port
3. 改配置


断开：SLAVEOF no one
```

主从复制

1. 全量恢复
2. 部分恢复

