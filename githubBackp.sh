#!/bin/sh

# 纯shell Github 备份工具（包括私仓）
# zyyme 20240206

# 在 https://github.com/settings/tokens 创建一个token 需要有repo权限（gph_开头的）
# 如果需要备份私有仓库，你还需要在 https://github.com/settings/keys 配置本机ssh key
ghToken='ghp_jewrfiodsfnewiohfhaoenf'

# 保存目录 默认脚本所在目录
# localDir='.\'
localDir=$(cd $(dirname $0); pwd)

echo "$localDir"
cd "$localDir"
echo > githubBackup.json
page=1
while :; do
    echo "curl page $page"
    out="`curl -L -H 'Accept: application/vnd.github+json' -H "Authorization: Bearer $ghToken" -H 'X-GitHub-Api-Version: 2022-11-28' "https://api.github.com/user/repos?per_page=100&page=$page"`"
    if [ $? -ne 0 ]; then
        echo "connect to github error"
        exit 1
    fi
    echo "$out" | grep full_name > /dev/null
    if [ $? -eq 0 ]; then
        echo "$out" >> githubBackup.json
        page=$(($page + 1))
    else
        echo "curl over"
        break
    fi
done

repos="`cat githubBackup.json | grep full_name | awk '{print substr($2, 2, length($2)-3)}'`"
for repo in $repos; do
    if [ -d "$repo" ]; then
        echo
        echo "pull '$repo'"
        cd "$repo"
        git pull
    else
        echo
        echo "clone '$repo'"
        git clone "git@github.com:$repo.git" "$repo"
    fi
    cd $localDir
done
