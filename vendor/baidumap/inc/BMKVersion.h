//
//  BMKVersion.h
//  BMapKit
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/*****更新日志：*****
 V0.1.0： 测试版
 支持地图浏览，基础操作
 支持POI搜索
 支持路线搜索
 支持地理编码功能
 --------------------
 V1.0.0：正式发布版
 地图浏览，操作，多点触摸，动画
 标注，覆盖物
 POI、路线搜索
 地理编码、反地理编码
 定位图层
 --------------------
 V1.1.0：
 离线地图支持
 --------------------
 V1.1.1：
 增加suggestionSearch接口
 可以动态更改annotation title
 fix小内存泄露问题
 --------------------
 V1.2.1：
 增加busLineSearch接口
 修复定位圈范围内不能拖动地图的bug
 --------------------
 V1.2.2：
 更新支持armv7s，全面适配iOS6和iPhone5
 修复：
 修改在无网络情况下，验证应用程序名称的时候crash问题
 中文应用名无法运行的问题
 viewdidload中打开实时路况无显示的问题
 两个mapview情况下，释放其中一个，另外一个无法使用的问题
 --------------------
 V1.2.3：
 新支持实时路况6-9级
 优化网络模块，性能更流畅
 优化了必须使用-all_load才可以使用库的bug
 废弃udid的获取
*********************/

/**
 *获取当前地图API的版本号
 *return  返回当前API的版本号
 */
UIKIT_STATIC_INLINE NSString* BMKGetMapApiVersion()
{
	return @"1.2.3";
}
