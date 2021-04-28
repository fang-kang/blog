
# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
# npm run build

# 进入生成的文件夹
#cd ./public

git init
git add -A
git commit -m ':art: :art: :art: update'


# 填写你需要发布的仓库地址
git push -f https://github.com/fang-kang/hexo-blog-code.git master
#git push -f https://gitee.com/fang-kang/hexo-blog-code.git master
cd -