# githubBackup
备份Github所有仓库（包括私仓）纯shell实现

## 使用教程
下面讲述一下如何在群晖使用，使用其他的Linux系统会容易很多  
先把sh脚本上传到你希望保存仓库的位置  
你需要有Entware的环境，具体怎么装自己查查，然后有个Entware的开机启动  
```
#!/bin/sh

# Mount/Start Entware
mkdir -p /opt
mount -o bind "/volume1/@Entware/opt" /opt
/opt/etc/init.d/rc.unslung start

# Add Entware Profile in Global Profile
if grep  -qF  '/opt/etc/profile' /etc/profile; then
    echo "Confirmed: Entware Profile in Global Profile"
else
    echo "Adding: Entware Profile in Global Profile"
cat >> /etc/profile <<"EOF"

# Load Entware Profile
. /opt/etc/profile
EOF
fi

# Update Entware List
/opt/bin/opkg update
```
其他Linux可以跳过上面这个步骤  
然后装一下git  
```
sudo opkg install git
```
生成一下ssh key
```
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
```
输出的这一长串给加到 https://github.com/settings/keys 里去  
然后去 https://github.com/settings/tokens 创建一个token 需要有repo权限（gph_开头的），填到脚本里的ghToken中  
在脚本右键属性复制一下位置  
新建一个定时运行的计划任务然后贴进去就行  
每当这个计划任务运行，就会增量同步一次你的所有仓库（包括私有仓库，以及你有权限的别人的仓库）
