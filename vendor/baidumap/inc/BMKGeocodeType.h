/*
 *  BMKGeocodeType.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>


///此类表示地址结果的层次化信息
@interface BMKGeocoderAddressComponent : NSObject
{
	NSString* _streetNumber;
	NSString* _streetName;
	NSString* _district;
	NSString* _city;
	NSString* _province;
}

/// 街道号码
@property (nonatomic, retain) NSString* streetNumber;
/// 街道名称
@property (nonatomic, retain) NSString* streetName;
/// 区县名称
@property (nonatomic, retain) NSString* district;
/// 城市名称
@property (nonatomic, retain) NSString* city;
/// 省份名称
@property (nonatomic, retain) NSString* province;

@end



///地址信息类，用于地理编码和反地理编码
@interface BMKAddrInfo : NSObject
{
	BMKGeocoderAddressComponent* _addressComponent;
	NSString* _strAddr;
	CLLocationCoordinate2D _geoPt;
	NSArray* _poiList;
}
///层次化地址信息
@property (nonatomic, retain) BMKGeocoderAddressComponent* addressComponent;
///地址名称
@property (nonatomic, retain) NSString* strAddr;
///地址坐标
@property (nonatomic) CLLocationCoordinate2D geoPt;
///地址周边POI信息，成员类型为BMKPoiInfo
@property (nonatomic, retain) NSArray* poiList;

@end



