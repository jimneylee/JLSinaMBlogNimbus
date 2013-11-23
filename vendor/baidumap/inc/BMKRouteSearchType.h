/*
 *  BMKRouteSearchType.h
 *	BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import "BMKPoiSearchType.h"
#import "BMKGeometry.h"

///线路节点信息
@interface BMKPlanNode : NSObject
{
	NSString* _name; 
	CLLocationCoordinate2D _pt;
}
///节点名称
@property (nonatomic, retain) NSString* name;
///节点坐标
@property (nonatomic) CLLocationCoordinate2D pt;

@end


///公交路段结果类
@interface BMKLine : NSObject
{
	int _viaStopsNum;
	int _distance;
	int _type;
	NSString* _title;
	NSString* _tip;
	BMKPoiInfo* _getOnStopPoiInfo;
	BMKPoiInfo* _getOffStopPoiInfo;
	//NSArray* _points;
	BMKMapPoint* _points;
	int _pointsCount;
}
///经过的公交站数
@property (nonatomic) int viaStopsNum;
///线路距离，单位：米
@property (nonatomic) int distance;
///线路类型，0:公交 1:地铁
@property (nonatomic) int type;
///坐标点数目
@property (nonatomic) int pointsCount;
///公交线路名称
@property (nonatomic, retain) NSString* title;
///公交线路提示
@property (nonatomic, retain) NSString* tip;
///上车站点POI信息
@property (nonatomic, retain) BMKPoiInfo* getOnStopPoiInfo;
///下车站点POI信息
@property (nonatomic, retain) BMKPoiInfo* getOffStopPoiInfo;

///线路坐标数组
- (BMKMapPoint*)points;

@end



///此类表示驾车或步行路线中的一个关键点
@interface BMKStep : NSObject
{
	CLLocationCoordinate2D _pt;
	NSString* _content;
	int _degree;
}

///关键点坐标
@property (nonatomic) CLLocationCoordinate2D pt;
///关键点提示信息
@property (nonatomic, retain) NSString* content;
///路线相对正北的角度
@property (nonatomic) int degree;

@end



///此类表示一条驾驶或步行线路
@interface BMKRoute : NSObject
{
	int _distance;
	int _type;
	CLLocationCoordinate2D _startPt;
	CLLocationCoordinate2D _endPt;
	NSString* _tip;
	int* _pointsNum;
	BMKMapPoint** _points;
	int _pointsCount;
	NSArray* _steps;
}
///线路距离，单位：米
@property (nonatomic) int distance;
///线路类型，0:未知 1:驾驶 2:步行
@property (nonatomic) int type;
///坐标点段数
@property (nonatomic, readonly) int pointsCount;
///线路起点坐标
@property (nonatomic) CLLocationCoordinate2D startPt;
///线路终点坐标
@property (nonatomic) CLLocationCoordinate2D endPt;
///线路提示
@property (nonatomic, retain) NSString* tip;	
///线路关键点数组,成员类型为BMKStep
@property (nonatomic, retain) NSArray* steps;

@property (nonatomic) BMKMapPoint** points;

///某一段坐标点数目
- (int)getPointsNum:(int)index;
///某一段坐标点数组
- (const BMKMapPoint*)getPoints:(int)index;

@end



///公交方案详情类
@interface BMKTransitRoutePlan : NSObject
{
	int _distance;
	NSString* _content;
	CLLocationCoordinate2D _startPt;
	CLLocationCoordinate2D _endPt;
	NSArray* _routes;
	NSArray* _lines;
}
///线路距离，单位：米
@property (nonatomic) int distance;
///线路起点坐标
@property (nonatomic) CLLocationCoordinate2D startPt;
///线路终点坐标
@property (nonatomic) CLLocationCoordinate2D endPt;
///方案描述信息
@property (nonatomic, retain) NSString* content;
///BMKRoute数组
@property (nonatomic, retain) NSArray* routes;	
///BMKLine数组
@property (nonatomic, retain) NSArray* lines;	

@end



///此类表示一条驾车或步行方案
@interface BMKRoutePlan : NSObject
{
	int _distance;
	NSArray* _routes;
}
///方案总距离
@property (nonatomic) int distance;
///BMKRoute数组
@property (nonatomic, retain) NSArray* routes;

@end

@class BMKRouteAddrResult;
///线路搜索结果类
@interface BMKPlanResult : NSObject
{
	BMKPlanNode* _startNode;
	BMKPlanNode* _endNode;
	NSArray*	 _plans;
	BMKRouteAddrResult* _routeAddrResult;
}
///线路起点
@property (nonatomic, retain) BMKPlanNode* startNode;
///线路终点
@property (nonatomic, retain) BMKPlanNode* endNode;
///方案数组  公交搜索返回BMKTransitRoutePlan类型，驾车和步行返回BMKRoutePlan类型
@property (nonatomic, retain) NSArray*	   plans;
///返回起点或终点的地址信息结果
@property (nonatomic, retain) BMKRouteAddrResult* routeAddrResult;
@end


///路线搜索地址结果类.当输入的起点或终点有多个地点选择时，或者选定的城市没有此地点，但其它城市有(驾乘或步行)，返回该类的实例
@interface BMKRouteAddrResult : NSObject
{
	NSArray* _startPoiList;
	NSArray* _endPoiList;
	NSArray* _startCityList;
	NSArray* _endCityList;
}
///起点POI列表，成员类型为BMKPoiInfo
@property (nonatomic, retain) NSArray* startPoiList;
///起点城市列表，成员类型为BMKCityListInfo,如果输入的地点在本城市没有而在其它城市有，则返回其它城市的信息
@property (nonatomic, retain) NSArray* startCityList;
///终点POI列表，成员类型为BMKPoiInfo
@property (nonatomic, retain) NSArray* endPoiList;
///终点城市列表，成员类型为BMKCityListInfo,如果输入的地点在本城市没有而在其它城市有，则返回其它城市的信息
@property (nonatomic, retain) NSArray* endCityList;
@end

///公交详情结果类.
@interface BMKBusLineResult : NSObject
{
    NSString* _mCompany;
    NSString* _mBusName;
    int _mIsMonTicket;
    NSString* _mStartTime;
    NSString* _mEndTime;
    BMKRoute* _mBusRoute;
	
}

@property (nonatomic, retain) NSString* mCompany;

@property (nonatomic, retain) NSString* mBusName;

@property (nonatomic) int mIsMonTicket;

@property (nonatomic, retain) NSString* mStartTime;
@property (nonatomic, retain) NSString* mEndTime;
@property (nonatomic, retain) BMKRoute* mBusRoute;
@end




