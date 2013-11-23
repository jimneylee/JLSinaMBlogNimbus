/*
 *  BMKPolygon.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>

#import "BMKMultiPoint.h"
#import "BMKOverlay.h"

/// 此类用于定义一个多边形区域
@interface BMKPolygon : BMKMultiPoint <BMKOverlay> {
@package
    CLLocationCoordinate2D _centroid;
    NSArray *_interiorPolygons;
    BOOL _isDefinitelyConvex;
}

/**
 *根据多个点生成多边形
 *@param points 直角坐标点数组，这些点将被拷贝到生成的多边形对象中
 *@param count 点的个数
 *@return 新生成的多边形对象
 */
+ (BMKPolygon *)polygonWithPoints:(BMKMapPoint *)points count:(NSUInteger)count;

/**
 *根据多个点及指定的内部镂空多边形数组生成新的多边形对象
 *@param points 直角坐标点数组，这些点将被拷贝到生成的多边形对象中
 *@param count 点的个数
 *@param interiorPolygons 指定的内部镂空多边形数组
 *@return 新生成的多边形对象
 */
+ (BMKPolygon *)polygonWithPoints:(BMKMapPoint *)points count:(NSUInteger)count interiorPolygons:(NSArray *)interiorPolygons;

/**
 *根据多个点生成多边形
 *@param coords 经纬度坐标点数组，这些点将被拷贝到生成的多边形对象中
 *@param count 点的个数
 *@return 新生成的多边形对象
 */
+ (BMKPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

/**
 *根据多个点及指定的内部镂空多边形数组生成新的多边形对象
 *@param coords 经纬度坐标点数组，这些点将被拷贝到生成的多边形对象中
 *@param count 点的个数
 *@param interiorPolygons 指定的内部镂空多边形数组
 *@return 新生成的多边形对象
 */
+ (BMKPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count interiorPolygons:(NSArray *)interiorPolygons;

/// 内部多边形数组
@property (readonly) NSArray *interiorPolygons;

@end
