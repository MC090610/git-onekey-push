# git-onekey-push
One-Key Git Push — 一键完成 git add、commit 和 push


由于我太懒，于是就写了个sh 
其实是懒癌犯了~~（我不想每次更新blog还要输一堆git命令）~~
本sh完全由ai编写，所以不可避免有屎山（比如各种满天飞的if）


---
# 脚本介绍
脚本会自动执行：
切换到指定目录（cd）```
git add --all
git commit
 git push
 
---
# 使用方法
下载
```bash
wget https://raw.githubusercontent.com/MC090610/git-onekey-push/main/git-push.sh

# 下载后赋予执行权限
chmod +x git-push.sh
```

指定目录push（被push目录需要和脚本在同一目录下）
```bash
bash git-push.sh -dir projectA  
```
自定义填写commit内容
```bash
#正常写法
bash git-push.sh -dir projectA -"修复了xxx"

#懒批写法
bash git-push.sh -dir projectA -修复了xxx
#或
bash git-push.sh -dir projectA "修复了xxx"

#如果不写commit内容则自动获取当前时间戳作为commit内容

```

---

## 针对懒癌晚期患者的推荐写法
```bash
#先保存一下自己github ghpken
#先执行一下
git config --global credential.helper store
#正常执行一下git push，正常输入邮箱和ghpkey
#随后执行
bash git-push.sh -dir projectA -修复了xxx -y #甚至可以省略掉commit内容
```

---
# 许可证
本仓库使用GPL V3许可证