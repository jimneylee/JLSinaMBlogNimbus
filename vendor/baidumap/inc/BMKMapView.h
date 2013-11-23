/*
 *  BMKMapView.h
 *	BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */
#import "BMKTypes.h"
#import "BMKGeometry.h"
#import "BMKAnnotation.h"
#import "BMKAnnotationView.h"
#import "BMKOverlayView.h"
#import "BMKUserLocation.h"
#import "UIKit/UIKit.h" 
@class BMKMapViewInternal;
@class BMKOverlayView;
@protocol BMKMapViewDelegate;
@protocol BMKOverlay;

///地图View类，使用此View可以显示地图窗口，并且对地图进行相关的操作
@interface BMKMapView : UIView<NSCoding>
{
@private
    BMKMapViewInternal *_internal;
}

/// 地图View的Delegate
@property (nonatomic, assign) id<BMKMapViewDelegate> delegate;

/// 当前地图类型，可设定为普通模式或实时路况模式
@property (nonatomic) BMKMapType mapType;

/// 当前地图的经纬度范围，设定的该范围可能会被调整为适合地图窗口显示的范围
@property (nonatomic) BMKCoordinateRegion region;

/**
 *设定当前地图的显示范围
 *@param region 要设定的地图范围，用经纬度的方式表示
 *@param animated 是否采用动画效果
 */
- (void)setRegion:(BMKCoordinateRegion)region animated:(BOOL)animated;

/// 当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

/**
 *设定地图中心点坐标
 *@param coordinate 要设定的地图中心点坐标，用经纬度表示
 *@param animated 是否采用动画效果
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

/// 地图比例尺级别，在手机上当前可使用的级别为3-18级
@property (nonatomic) int zoomLevel;

/**
 *放大一级比例尺
 *@return 是否成功
 */
- (BOOL)zoomIn;

/**
 *缩小一级比例尺
 *@return 是否成功
 */
- (BOOL)zoomOut;

/**
 *根据当前地图View的窗口大小调整传入的region，返回适合当前地图窗口显示的region，调整过程会保证中心点不改变
 *@param region 待调整的经纬度范围
 *@return 调整后适合当前地图窗口显示的经纬度范围
 */
- (BMKCoordinateRegion)regionThatFits:(BMKCoordinateRegion)region;

///当前地图范围，采用直角坐标系表示，向右向下增长
@property (nonatomic) BMKMapRect visibleMapRect;

/**
 *设定当前地图的显示范围,采用直角坐标系表示
 *@param mapRect 要设定的地图范围，用直角坐标系表示
 *@param animate 是否采用动画效果
 */
- (void)setVisibleMapRect:(BMKMapRect)mapRect animated:(BOOL)animate;

/**
 *根据当前地图View的窗口大小调整传入的mapRect，返回适合当前地图窗口显示的mapRect，调整过程会保证中心点不改变
 *@param mapRect 待调整的地理范围，采用直角坐标系表示
 *@return 调整后适合当前地图窗口显示的地理范围，采用直角坐标系
 */
- (BMKMapRect)mapRectThatFits:(BMKMapRect)mapRect;

/**
 *设定地图的显示范围,并使mapRect四周保留insets指定的边界区域
 *@param mapRect 要设定的地图范围，用直角坐标系表示
 *@param insets 指定的四周边界大小
 *@param animate 是否采用动画效果
 */
- (void)setVisibleMapRect:(BMKMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate;

/**
 *根据当前地图View的窗口大小调整传入的mapRect，返回适合当前地图窗口显示的mapRect，并且在该mapRect四周保留insets指定的边界区域
 *@param mapRect 待调整的地理范围，采用直角坐标系表示
 ×@param insets mapRect四周要预留的边界大小
 *@return 调整后适合当前地图窗口显示的地理范围，采用直角坐标系
 */
- (BMKMapRect)mapRectThatFits:(BMKMapRect)mapRect edgePadding:(UIEdgeInsets)insets;

/**
 *将经纬度坐标转换为View坐标
 *@param coordinate 待转换的经纬度坐标
 *@param view 指定相对的View
 *@return 转换后的View坐标
 */
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;

/**
 *将View坐标转换成经纬度坐标
 *@param point 待转换的View坐标
 *@param view point坐标所在的view
 *@return 转换后的经纬度坐标
 */
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;

/**
 *将经纬度矩形区域转换为View矩形区域
 *@param region 待转换的经纬度矩形
 *@param view 指定相对的View
 *@return 转换后的View矩形区域
 */
- (CGRect)convertRegion:(BMKCoordinateRegion)region toRectToView:(UIView *)view;

/**
 *将View矩形区域转换成经纬度矩形区域
 *@param rect 待转换的View矩形区域
 *@param view rect坐标所在的view
 *@return 转换后的经纬度矩形区域
 */
- (BMKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

/**
 *将直角地理坐标矩形区域转换为View矩形区域
 *@param mapRect 待转换的直角地理坐标矩形
 *@param view 指定相对的View
 *@return 转换后的View矩形区域
 */
- (CGRect)convertMapRect:(BMKMapRect)mapRect toRectToView:(UIView *)view;

/**
 *将View矩形区域转换成直角地理坐标矩形区域
 *@param rect 待转换的View矩形区域
 *@param view rect坐标所在的view
 *@return 转换后的直角地理坐标矩形区域
 */
- (BMKMapRect)convertRect:(CGRect)rect toMapRectFromView:(UIView *)view;

///设定地图View能否支持用户多点缩放
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
///设定地图View能否支持用户移动地图
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;

/// 设定是否显示定位图层
@property (nonatomic) BOOL showsUserLocation;

/// 当前用户位置，返回坐标为百度坐标
 @property (nonatomic, readonly) BMKUserLocation *userLocation;

/// 返回定位坐标点是否在当前地图可视区域内
@property (nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;

/**
 *向地图窗口添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *@param annotation 要添加的标注
 */
- (void)addAnnotation:(id <BMKAnnotation>)annotation;

/**
 *向地图窗口添加一组标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *@param annotations 要添加的标注数组
 */
- (void)addAnnotations:(NSArray *)annotations;

/**
 *移除标注
 *@param annotation 要移除的标注
 */
- (void)removeAnnotation:(id <BMKAnnotation>)annotation;

/**
 *移除一组标注
 *@param annotation 要移除的标注数组
 */
- (void)removeAnnotations:(NSArray *)annotations;

/// 当前地图View的已经添加的标注数组
@property (nonatomic, readonly) NSArray *annotations;

/**
 *查找指定标注对应的View，如果该标注尚未显示，返回nil
 *@param annotation 指定的标注
 *@return 指定标注对应的View
 */
- (BMKAnnotationView *)viewForAnnotation:(id <BMKAnnotation>)annotation;

/**
 *根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
 *@param identifier 指定标识
 *@return 返回可被复用的标注View
 */
- (BMKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

/**
 *选中指定的标注，本版暂不支持animate效果
 *@param annotation 指定的标注
 *@param animated 本版暂不支持
 */
- (void)selectAnnotation:(id <BMKAnnotation>)annotation animated:(BOOL)animated;

/**
 *取消指定的标注的选中状态，本版暂不支持animate效果
 *@param annotation 指定的标注
 *@param animated 本版暂不支持
 */
- (void)deselectAnnotation:(id <BMKAnnotation>)annotation animated:(BOOL)animated;

@end

@interface BMKMapView (OverlaysAPI)

/**
 *向地图窗口添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的View
 *@param overlay 要添加的overlay
 */
- (void)addOverlay:(id <BMKOverlay>)overlay;

/**
 *向地图窗口添加一组Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的View
 *@param overlays 要添加的overlay数组
 */
- (void)addOverlays:(NSArray *)overlays;

/**
 *移除Overlay
 *@param overlay 要移除的overlay
 */
- (void)removeOverlay:(id <BMKOverlay>)overlay;

/**
 *移除一组Overlay
 *@param overlays 要移除的overlay数组
 */
- (void)removeOverlays:(NSArray *)overlays;

/**
 *在指定的索引处添加一个Overlay
 *@param overlay 要添加的overlay
 *@param index 指定的索引
 */
- (void)insertOverlay:(id <BMKOverlay>)overlay atIndex:(NSUInteger)index;

/**
 *在交换指定索引处的Overlay
 *@param index1 索引1
 *@param index2 索引2
 */
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2;

/**
 *在指定的Overlay之上插入一个overlay
 *@param overlay 带添加的Overlay
 *@param sibling 用于指定相对位置的Overlay
 */
- (void)insertOverlay:(id <BMKOverlay>)overlay aboveOverlay:(id <BMKOverlay>)sibling;

/**
 *在指定的Overlay之下插入一个overlay
 *@param overlay 带添加的Overlay
 *@param sibling 用于指定相对位置的Overlay
 */
- (void)insertOverlay:(id <BMKOverlay>)overlay belowOverlay:(id <BMKOverlay>)sibling;

/// 当前mapView中已经添加的Overlay数组
@property (nonatomic, readonly) NSArray *overlays;

/**
 *查找指定overlay对应的View，如果该View尚未创建，返回nil
 *@param overlay 指定的overlay
 *@return 指定overlay对应的View
 */
- (BMKOverlayView *)viewForOverlay:(id <BMKOverlay>)overlay;

@end

/// MapView的Delegate，mapView通过此类来通知用户对应的事件
@protocol BMKMapViewDelegate <NSObject>
@optional

/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated;

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation;

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views;

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view;

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view;

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView;

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView;

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation;

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error;

/**
 *拖动annotation view时view的状态变化，ios3.2以后支持
 *@param mapView 地图View
 *@param view annotation view
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState 
   fromOldState:(BMKAnnotationViewDragState)oldState;

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay;

/**
 *当mapView新添加overlay views时，调用此接口
 *@param mapView 地图View
 *@param overlayViews 新添加的overlay views
 */
- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews;

@end


