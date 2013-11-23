/*
 *  BMKOverlayView.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>

#import "BMKGeometry.h"
#import "BMKOverlay.h"

/// 该类是地图覆盖物View的基类，所有地图覆盖物View需要继承自此类
@interface BMKOverlayView : UIView
{
	@package
    id <BMKOverlay> _overlay;
    BMKMapRect _boundingMapRect;
    CGAffineTransform _mapTransform;
    id _geometryDelegate;
    id _canDrawCache;
    
    CFTimeInterval _lastTile;
    CFRunLoopTimerRef _scheduledScaleTimer;
    
    struct {
        unsigned int keepAlive:1;
        unsigned int levelCrossFade:1;
        unsigned int drawingDisabled:1;
        unsigned int usesTiledLayer:1;
    } _flags;
}

/**
 *初始化并返回一个overlay view
 *@param overlay 关联的overlay对象
 *@return 初始化成功则返回overlay view,否则返回nil
 */
- (id)initWithOverlay:(id <BMKOverlay>)overlay;

///关联的overlay对象
@property (nonatomic, readonly) id <BMKOverlay> overlay;

/**
 *将直角坐标转为overlay view坐标
 *@param mapPoint 直角坐标
 *@return 对应的view坐标
 */
- (CGPoint)pointForMapPoint:(BMKMapPoint)mapPoint;

/**
 *将overlay view坐标转为直角坐标
 *@param point view坐标
 *@return 对应的直角坐标
 */
- (BMKMapPoint)mapPointForPoint:(CGPoint)point;

/**
 *将二维地图投影矩形转为overlay view矩形
 *@param mapRect 二维地图投影矩形
 *@return 对应的view矩形
 */
- (CGRect)rectForMapRect:(BMKMapRect)mapRect;

/**
 *将overlay view区域转为二维地图投影区域
 *@param rect 指定的view矩形
 *@return 对应的二维地图投影矩形
 */
- (BMKMapRect)mapRectForRect:(CGRect)rect;

/**
 *判断ovlerlay view是否准备绘制内容
 *默认返回YES，如果用户设为NO，当需要绘制内容时要显示调用setNeedsDisplayInMapRect:zoomScale:方法
 *@param mapRect 需要更新的地图矩形区域
 *@param zoomScale 当前的缩放因子
 *@return 如果view准备好绘制内容，返回YES,否则返回NO
 */
- (BOOL)canDrawMapRect:(BMKMapRect)mapRect zoomScale:(BMKZoomScale)zoomScale;

/**
 *绘制overlay view内容
 *该方法默认不做任何事，子类需要重载该方法来绘制view的内容
 *@param mapRect 需要更新的地图矩形区域
 *@param zoomScale 当前的缩放因子
 *@param context 使用的graphics context
 */
- (void)drawMapRect:(BMKMapRect)mapRect zoomScale:(BMKZoomScale)zoomScale inContext:(CGContextRef)context;

/**
 *使view在给定矩形的区域无效,系统将重绘该区域
 *@param mapRect 需要更新的区域
 */
- (void)setNeedsDisplayInMapRect:(BMKMapRect)mapRect;     


@end


