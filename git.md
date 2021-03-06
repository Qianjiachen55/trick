# git

```shell
git clone url...

git switch 
# 切换分支

# 合并到当前分支
git merge dev
# 合并dev 到本地分支

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

### 冲突

```shell
#当别人修改了远程分支，本地也修改后提交可能有冲突
# 解决方案
$ git add .
$ git commit -m ....
# 提交到本地仓库
$ git push    #(error)


# solution
$ git add .
$ git commit -m ....
$ git pull 
# 手动解决冲突
# 然后提交
git commit -m "...."
git push
# or

#1. 本地新建新分支，
#2. 将远程仓库拉到本地新分支，
#3. 将新分支meger到自己的分支，
#4. 然后提交
#(这个方案之前用过，后来就跟老表两个人开发，就偷懒用第一种办法了)

```



### 删除

```
提交了一些傻逼文件比如：
.vscode
.idea
__pycache__
等等

比如 */__pycache__/.. 被推到远程仓库
$ git rm -r */__pycache__ 
$ git commit -m "xxxxxxx"
$ git push .....(-u origin xxx)

```

### 清空本地暂存区

```

git reset .
```

