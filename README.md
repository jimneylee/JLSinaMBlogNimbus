#SinaMBlogNimbus
--------------

采用[nimbus](https://github.com/jverkoey/nimbus)框架，进行二次构建。

这是一个适用于网络请求后以tableview列表数据展现的一个简单框架，

通过这个框架，大家可以简单、便捷地处理和显示列表数据，

以新浪微博为例子，介绍框架的使用，通过开源的分享，跟大家一起技术交流。

#enjoy it!

--------------

#暂不支持XCode5，待支持...

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