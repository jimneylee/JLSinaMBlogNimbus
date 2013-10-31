#SinaMBlogNimbus
--------------

项目clone到本地后

1、请执行如下git命令，添加nimbus为submodule：

git submodule add https://github.com/jverkoey/nimbus.git vendor/nimbus

git submodule add https://github.com/rs/SDURLCache.git vendor/SDURLCache

2、使用[CocoaPods](http://cocoapods.org)的命令安装其他依赖库：
   pod install

--------------
若出现这个问题：'vendor/SDURLCache' already exists in the index

git rm --cached vendor/SDURLCache