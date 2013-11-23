/*
 *  BMKOffineMapType.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

///离线地图搜索城市记录结构
@interface BMKOLSearchRecord : NSObject
{
	NSString* _cityName;
	int		  _size;
	int		  _cityID;
}
///城市名称
@property (nonatomic, retain) NSString* cityName;
///数据包总大小
@property (nonatomic) int size;
///城市ID
@property (nonatomic) int cityID;

@end


///离线地图更新信息
@interface BMKOLUpdateElement : NSObject
{
	NSString* _cityName;
	int		  _cityID;
	int		  _size;
	int		  _serversize;
	BOOL	  _update;
	int		  _ratio;
	int		  _status;
	CLLocationCoordinate2D _pt;
}
///城市名称
@property (nonatomic, retain) NSString* cityName;
///城市ID
@property (nonatomic) int cityID;
///已下载数据大小，单位：字节
@property (nonatomic) int size;
///服务端数据大小，当update为YES时有效，单位：字节
@property (nonatomic) int serversize;
///下载比率，100为下载完成
@property (nonatomic) int ratio;
///下载状态, 1:正在下载　2:等待下载　3:已暂停　4:完成
@property (nonatomic) int status;
///更新状态
@property (nonatomic) BOOL update;
///城市中心点
@property (nonatomic) CLLocationCoordinate2D pt;

@end

