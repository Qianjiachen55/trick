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



同一个pod内的容器A，B

- 它们可以直接使用 localhost 进行通信
- 它们看到的网络设备跟 Infra 容器看到的完全一样
- 一个 Pod 只有一个 IP 地址，也就是这个 Pod 的 Network Namespace 对应的 IP 地址
- 其他的所有网络资源，都是一个 Pod 一份，并且被该 Pod 中的所有容器共享
- Pod 的生命周期只跟 Infra 容器一致，而与容器 A 和 B 无关。

```shell
为 Kubernetes 开发一个网络插件时，应该重点考虑的是如何配置这个 Pod 的 Network Namespace，而不是每一个用户容器如何使用你的网络配置，这是没有意义的。
```

```shell
用户想在一个容器里跑多个功能并不相关的应用时，应该优先考虑它们是不是更应该被描述成一个 Pod 里的多个容器。
```

