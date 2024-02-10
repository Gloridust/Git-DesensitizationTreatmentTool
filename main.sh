#!/bin/bash

# 提示用户输入要删除的文件路径
echo "Please enter the relative path of the file you want to delete from history:"
read file_to_delete

# 检查是否输入了文件路径
if [ -z "$file_to_delete" ]; then
    echo "error：wrong path"
    exit 1
fi

# 删除文件的历史记录
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $file_to_delete" --prune-empty --tag-name-filter cat -- --all

# 强制推送到所有分支和标签
git push origin --force --all
git push origin --force --tags

# 清理本地仓库
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now

echo "finished"
