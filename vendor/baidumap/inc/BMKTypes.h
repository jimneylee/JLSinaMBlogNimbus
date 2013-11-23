/*
 *  BMKTypes.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


enum {
    BMKMapTypeStandard   = 1,	       ///< 标准地图    0X00000001
    BMKMapTypeTrafficOn  = 2,	       ///< 打开实时路况 0X00000010
    BMKMapTypeSatellite  = 4,          ///< 卫星地图    0X00000100
    BMKMapTypeTrafficOff = 5,          ///< 关闭实时路况 0X00000101
};
typedef NSUInteger BMKMapType;


//UIKIT_EXTERN NSString *BMKErrorDomain;

enum BMKErrorCode {
	BMKErrorOk = 0,	///< 正确，无错误
    BMKErrorConnect = 2,	///< 网络连接错误
	BMKErrorData = 3,	///< 数据错误
	BMKErrorRouteAddr = 4, ///<起点或终点选择
	BMKErrorResultNotFound = 100,	///< 搜索结果未找到
	BMKErrorLocationFailed = 200,	///< 定位失败
	BMKErrorPermissionCheckFailure = 300,	///< 百度地图API授权Key验证失败
	BMKErrorParse = 310		///< 数据解析失败
};
