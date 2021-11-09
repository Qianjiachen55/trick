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
```





分表

```shell


```

