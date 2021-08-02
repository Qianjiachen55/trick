## rosdep update (慎用)

```python
url="https://ghproxy.com/"+url
#根据自己的版本改写

/usr/lib/python2.7/dist-packages/rosdep2/sources_list.py
/usr/lib/python2.7/dist-packages/rosdistro/__init__.py
/usr/lib/python2.7/dist-packages/rosdep2/gbpdistro_support.py 
/usr/lib/python2.7/dist-packages/rosdep2/gbpdistro_support.py 36行
/usr/lib/python2.7/dist-packages/rosdep2/sources_list.py 72行
/usr/lib/python2.7/dist-packages/rosdep2/rep3.py 39行
/usr/lib/python2.7/dist-packages/rosdistro/manifest_provider/github.py 68行 119行


# 原文链接
url = https://zhuanlan.zhihu.com/p/370080612
```





## other

```shell
#建立工作区，指定版本
catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3

# 如果是roscpp、 rospy、 rosmsg等其他组件找不到，尝试使用同样的办法安装。
sudo apt-get install ros-noetic-serial
# 最有用的命令，没有之一
#曹！！！！！！！！！！！！！！！！！！！！！！！！！111
sudo apt install ros-noetic-desktop-full

```



## 好用的工具

```shell
# gui查看节点关系
rosrun rqt_graph rqt_graph

```

