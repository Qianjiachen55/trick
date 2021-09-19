# git

```
git clone url...

git switch 
# 切换分支

# 合并到当前分支
git merge

# 查看分支 
git branch -a

# fatal: 拒绝合并无关的历史
git merge main --allow-unrelated-histories 

# git解决每次都要输入密码的问题

git config --global credential.helper store

# git 配置ssh_key
2021-8-30之后无法通过密码连接git服务器
1. 生成钥文件和私钥文件
ssh-keygen
-b 指定密码位数，最小512，2048一般就够，多了没用
-C comment 注释
-t rsa 用rsa的加密方式

```



