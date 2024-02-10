@echo off
set /p file_to_delete="Please enter the relative path of the file you want to delete from history: "
if "%file_to_delete%"=="" goto error

:: 删除文件历史记录
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch %file_to_delete%" --prune-empty --tag-name-filter cat -- --all

:: 强制推送到所有分支和标签
git push origin --force --all
git push origin --force --tags

:: 清理本地仓库
git for-each-ref --format="delete %(refname)" refs/original/ | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now

echo finished
goto end

:error
echo error：wrong path
:end
