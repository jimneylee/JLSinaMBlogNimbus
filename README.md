#截图
===============

![image](http://git.oschina.net/jimneylee/SinaMBlogNimbus/raw/master/SinaMBlog/Images/Screenshot/homepage.png)
![image](http://git.oschina.net/jimneylee/SinaMBlogNimbus/raw/master/SinaMBlog/Images/Screenshot/postnewstatus.png)
![image](http://git.oschina.net/jimneylee/SinaMBlogNimbus/raw/master/SinaMBlog/Images/Screenshot/repost.png)
#enjoy it!

--------------
#DONE

1、支持XCode4 & XCode5 & iOS7

2、集成新浪微博SDK

3、发帖、转发、评论

4、微博征文布局和@某人、#话题#识别

#TODO

1、原图查看

2、表情显示

--------------

#OpenSinaMBlog
--------------

基于轻量级iOS开发框架[nimbus](https://github.com/jverkoey/nimbus)，网络层采用AFNetworking，

在此基础上进行二次构建，可以简单、便捷地处理和显示列表数据，

通过制作iOS7上新浪微博APP的首页，介绍框架的使用，通过开源分享，一起交流进步。

主要分享的技术点如下：

1、二次构建，简化tableView网络数据请求和显示

2、类似官方APP富文本的布局和关键字的识别和交互

3、发布微博、拍照及获取地理位置

PS:以前项目中主要使用[three20](https://github.com/facebook/three20)开发APP，了解过three20的同学，应该比较熟悉nimbus的作者，不熟悉请google之。

--------------
项目clone到本地后

1、更新submodule：

   git submodule init 
   
   git submodule update
   
   注：如需要添加其他的submodule

       git submodule add https://github.com/jverkoey/nimbus.git vendor/nimbus

2、使用[CocoaPods](http://cocoapods.org)的命令安装其他依赖库：
   
   pod install
   
   注：如需要添加其他依赖库，请修改Podfile

#ERROR解决方法

--------------
    1、若出现这个问题：'vendor/SDURLCache' already exists in the index

      git rm --cached vendor/SDURLCache

    2、若出现这个问题：fatal: not removing 'vendor/nimbus' recursively without -r
    
      git rm -r --cached vendor/SDURLCache

    3、若出现这个问题：diff: /../Podfile.lock: No such file or directory 
    diff: /Manifest.lock: No such file or directory 
    error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.

      pod install
    
    4、官方的nimbus版本没有修复NIAttributedLabel在tableview中link无法点击问题
    
       请暂时用Nimbus_fix目录下的NIAttributedLabel.m替换原工程中的这个文件
       参考：http://stackoverflow.com/questions/17467086/using-niattributedlabel-in-uitableviewcell