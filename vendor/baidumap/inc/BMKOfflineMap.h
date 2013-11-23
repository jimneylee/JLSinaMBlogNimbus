/*
 *  BMKOfflineMap.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BMKOfflineMapType.h"

@protocol BMKOfflineMapDelegate;

///离线地图事件类型
enum  {
	//TYPE_OFFLINE_UPDATE = 0,
	//TYPE_OFFLINE_ZIPCNT	= 1,
	TYPE_OFFLINE_UNZIP = 2,			///<当前解压的离线包
	TYPE_OFFLINE_ERRZIP = 3,		///<错误的离线包
	TYPE_OFFLINE_NEWVER = 4,		///<有新版本
	TYPE_OFFLINE_UNZIPFINISH = 5,	///<扫描完毕
	TYPE_OFFLINE_ADD = 6			///<新增离线包
};

///离线地图服务
@interface BMKOfflineMap : NSObject
{
	id<BMKOfflineMapDelegate> _delegate;
}

@property (nonatomic, retain) id<BMKOfflineMapDelegate> delegate;

/**
 *扫描离线地图压缩包,异步函数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)scan;

/**
 *启动下载指定城市id的离线地图
 *@param cityID 指定的城市id
 *@return 成功返回YES，否则返回NO
 */
//- (BOOL)start:(int)cityID;

/**
 *暂停下载指定城市id的离线地图
 *@param cityID 指定的城市id
 *@return 成功返回YES，否则返回NO
 */
//- (BOOL)pasue:(int)cityID;

/**
 *删除下载指定城市id的离线地图
 *@param cityID 指定的城市id
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)remove:(int)cityID;

/**
 *返回热门城市列表
 *@return 热门城市列表,用户需要显示释放该数组，数组元素为BMKOLSearchRecord
 */
//- (NSArray*)getHotCityList;

/**
 *根据城市名搜索该城市离线地图记录
 *@param cityName 城市名
 *@return 该城市离线地图记录,用户需要显示释放该数组，数组元素为BMKOLSearchRecord
 */
//- (NSArray*)searchCity:(NSString*)cityName;

/**
 *返回各城市离线地图更新信息
 *@return 各城市离线地图更新信息,用户需要显示释放该数组，数组元素为BMKOLUpdateElement
 */
- (NSArray*)getAllUpdateInfo;

/**
 *返回指定城市id离线地图更新信息
 *@param cityID 指定的城市id
 *@return 指定城市id离线地图更新信息,用户需要显示释放该数据
 */
- (BMKOLUpdateElement*)getUpdateInfo:(int)cityID;

@end


///离线地图delegate，用于获取通知
@protocol BMKOfflineMapDelegate<NSObject>
/**
 *返回通知结果
 *@param type 事件类型： TYPE_OFFLINE_UNZIP, TYPE_OFFLINE_ERRZIP, TYPE_VER_UPDATE, TYPE_OFFLINE_UNZIPFINISH, TYPE_OFFLINE_ADD
 *@param state 事件状态，当type为TYPE_OFFLINE_ADD时，表示新安装的离线地图数目，当type为TYPE_OFFLINE_UNZIP时，表示正在解压第state个离线包，当type为TYPE_OFFLINE_ERRZIP时，表示有state个错误包
 */
- (void)onGetOfflineMapState:(int)type withState:(int)state;

@end


