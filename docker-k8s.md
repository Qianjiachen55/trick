# k8

```shell
~/.kube/config
连接k8集群
```



```shell
pod理解为对象
deployment理解为pod的控制器(api)

```







## pod

- 只是一个逻辑概念。

- Pod 里的所有容器，共享的是同一个 Network Namespace
- Pod 扮演的是传统部署环境里“虚拟机”的角色：把 Pod 看成传统环境里的“机器”、把容器看作是运行在这个“机器”里的“用户程序"
- 为 Kubernetes 开发一个网络插件时，应该重点考虑的是如何配置这个 Pod 的 Network Namespace，而不是每一个用户容器如何使用你的网络配置，这是没有意义的。
- 用户想在一个容器里跑多个功能并不相关的应用时，应该优先考虑它们是不是更应该被描述成一个 Pod 里的多个容器。





同一个pod内的容器A，B

- 它们可以直接使用 localhost 进行通信
- 它们看到的网络设备跟 Infra 容器看到的完全一样
- 一个 Pod 只有一个 IP 地址，也就是这个 Pod 的 Network Namespace 对应的 IP 地址
- 其他的所有网络资源，都是一个 Pod 一份，并且被该 Pod 中的所有容器共享
- Pod 的生命周期只跟 Infra 容器一致，而与容器 A 和 B 无关。

### 状态

1. Pending。这个状态意味着，Pod 的 YAML 文件`已经提交`给了 Kubernetes，API 对象已经被创建并保存在 Etcd 当中。但是，这个 Pod 里有些容器因为某种原因而不能被顺利创建。比如，调度不成功。
2. Running。这个状态下，Pod 已经调度成功，跟一个具体的节点绑定。它包含的容器都已经创建成功，并且至少有一个正在运行中。
3. Succeeded。这个状态意味着，Pod 里的`所有容器`都正常`运行完毕`，并且已经退出了。这种情况在运行`一次性任务时`最为常见。
4. Failed。这个状态下，Pod 里至少有一个容器以不正常的状态（非 0 的返回码）退出。这个状态的出现，意味着你得想办法 Debug 这个容器的应用，比如查看 Pod 的 Events 和日志。
5. Unknown。这是一个异常状态，意味着 Pod 的状态不能持续地被 kubelet 汇报给 kube-apiserver，这很有可能是主从节点（Master 和 Kubelet）间的通信出现了问题。



### Projected Volume

不是为了存放容器的数据

是为了给容器提供预先定义好的数据

1. Secret

```shell
secret要经过转码！！！！！！！！！！！！！！！！！！！
```



2. ConfigMap

3. Downward API

   一般是pod的信息

   Downward API 能够获取到的信息，一定是 Pod 里的容器进程启动之前就能够确定下来的信息

4. ServiceAccountToken

