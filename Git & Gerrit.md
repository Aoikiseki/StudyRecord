[toc]

## Git基本知识

推荐一个Git可视化动画练习的网站<https://learngitbranching.js.org/?locale=zh_CN>

在熟悉Git前需要先了解三个基本概念：

1. 工作区：可以理解为当前的工程文件夹
2. 暂存区：暂时保存对工作区的修改，需要commit才能将暂存区的修改实现相对永久的保存
3. 远程仓库：存储代码的远端Git服务器

### 安装Git

略去安装过程，安装结束后需要指定本机用户名和邮箱

```swift
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

### Git的基本操作

1. 创建仓库`git init`
2. 添加文件到暂存区`git add readme.txt`
3. 从暂存区删除文件` git reset 文件名`
4. 提交修改`git commit –m "wrote a readme file"`-m为本次提交的说明，如果需要对上一次的提交进行补充，使用`git commit --amend`
5. 查看日志`git log`可以提交查看日志，看每次提交修改了什么，--pretty=oneline可以精简地以一行进行显示，commit id是每次提交的标识符
6. 版本回退`git reset --hard HEAD^` `HEAD`表示本地仓库的当前版本，`HEAD^`为上一版本，`HEAD~X`为上X个版本
7. 恢复新版本`git reflog`可以查看历史提交的commit id，然后使用`git reset id`即可回退至指定位置
   查看仓库状态`git status`查看仓库状态
8. 查看工作区和版本库的区别`git diff`
9. 撤销修改`git checkout -- file`，该命令可以丢弃工作区的修改，若file修改后未放到暂存区，则回到和版本库一样的状态；若放到暂存区修改，则回到放到暂存区后的样子，总之该指令会撤销工作区的修改。
   **注: 凭借checkout，可以将误删的文件加回来！**
10. 暂存区重新放回工作区（暂存区撤回）`git reset HEAD file`
11. 文件删除`git rm file` 
12. 推送到远程仓库`git remote origin 远端地址` + `git push –u origin master`  -u不仅会推送，还会将本地和远程关联，简化命令，然后就可以git push origin master即可。
    **注意**：连接远程库之前需要现在本地生成`ssh-key`并填写在远端才能成功push

### 分支操作

1. 创建新分支并切换`git checkout –b dev` = `git branch dev` + `git checkout dev`

2. 查看分支`git branch`

3. 合并分支`git merge xxx`，例如想要将`test`分支合并至`master`分支，需要在master分支上使用`git merge test`

   **注**：merge结束后会生成一个merge commit
   （PS: 2020年起github启用main作为主分支）

4. 分支变基`git rebase`
   关于变基这里可以举一个例子方便说明，比如你从`master`分支切出一个名为`develop`的分支，那么`develop`分支的基就是当前时间点的`master`；接下来你在`develop`分支上进行了开发，在本地提交了`commit`这个`commit`也是以`master`为基；过了一段时间`master`分支的内容被别人修改，此时你尝试push显然会失败；而如果你的`commit`是以最新时间点的`master`为基，就可以成功push，所以你需要找一种方法，能够让你的commit变成以最新时间点的`master`作为基，这就是rebase的作用。

5. 删除分支`git branch –d xxx`

6. 当前工作环境保存`git stash`，相当于将当前的修改**剪切**并压栈，为了便于识别可以使用`git stash save "name"`指定名称，使用`git stash list`查看所有被保存的修改，使用`git stash pop stash@{x}`或者`git stash pop name`将修改出栈并应用到当前分支。
   `git stash pop` = `git stash apply xxx` + `git stash drop xxx`，所以如果不希望修改出栈，只希望将修改应用到当前分支，使用`git stash apply`

7. 复制指定commitid的提交到当前分支`git cherry-pick {commitid}`

8. 在远端开分支`git co -b xxx` + `git push xxx`

### 项目管理

安装子模块`git submodule update --init --recursive`

### --soft --mixed --hard

一些指令（比如`git reset`）中有--mode参数，含义如下：

1. --soft：仅仅改变HEAD指针，不改变暂存区和工作区。
2. --mixed（默认）：改变HEAD指针，改变暂存区，不改变工作区。即目录下的文件不变动，changes回退至add之前
3. --hard：改变HEAD指针，改变暂存区和工作区。文件和changes均会变动

### rebase -i

[修改历史](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E9%87%8D%E5%86%99%E5%8E%86%E5%8F%B2)

已经提交了commit1~commit4，想要修改commit2的内容，可以使用`git rebase -i HEAD~3`在命令行中将commit2前面的`pick`改为`edit`然后`:wq`保存即可开始你的修改，修改完`git rebase --continue`收工

### Merge or Rebase ? 

`merge`会产生merge commit，但是只需要解决一次冲突

`rebase`不会产生merge commit，但是需要对每一个待rebase的commit都解决一次冲突

公司的日常开发要求尽量让整个工程在一条线上，即尽量使用`rebase`

个人经验：如果需要开一个分支去完成一个周期较长的需求，在这个需求中你提交了许多的commit，那么在需求完成的时候，master分支必定被其他人修改过很多地方，这时候如果你去rebase的话，解决merge conflict会比较头疼，所以使用merge比较好；如果你做的需求只需要一两个commit，那么显然使用不会产生merge commit的rebase更好。

### submodule

添加子模块到指定目录`git submodule add`+`URL`+`Path`

## Gerrit

公司使用Gerrit作为代码库，有一些特有的命令

- push代码 `git push origin HEAD:refs/for/分支名`
- 向远端推送分支`git push origin 待推送分支名`
- 删除远端分支`git push origin :待删除分支名`（一般需要权限）

## 问题记录

### git revert和git cherry-pick

场景一：

1. `develop`分支上提交commit
2. `develop`分支上切出`feature`分支
3. `develop`分支对commit revert
4. `feature` merge到`develop`

问题：从`feature` merge回`develop`后，`feature`中的commit能否被带回`develop`？

答：不会

由于`feature`中的commitId和步骤3中被revert的commitId一致，因此结果就是feature merge回develop后，该commit也是不存在的

场景二：

1. `develop`分支上切出`feature`分支
2. `develop`分支上提交commit
3. `feature`分支对commit进行cherry-pick
4. `develop`分支对commit revert
5. `feature` merge到`develop`

同样的问题：从`feature` merge回`develop`后，`feature`中的commit能否被带回`develop`？

答：会

因为cherry-pick虽然会将commit的内容搬过去，但是commitId会变，属于一个新的commit，不会被revert掉