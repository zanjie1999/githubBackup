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
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $ghToken" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/repos  > githubBackup.json

repos="`cat githubBackup.json | grep full_name | awk '{print substr($2, 2, length($2)-3)}'`"
for repo in $repos; do
    if [ -d "$repo" ]; then
        echo "\npull '$repo'"
        cd "$repo"
        git pull
    else
        echo "\nclone '$repo'"
        git clone "git@github.com:$repo.git" "$repo"
    fi
    cd $localDir
done
