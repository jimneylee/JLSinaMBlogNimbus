/*
 *  BMKMapManager.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

@protocol BMKGeneralDelegate;

///主引擎类
@interface BMKMapManager : NSObject
{
	
}

/**
*启动引擎
*@param key 申请的有效key
*@param delegate 
*/
-(BOOL)start:(NSString*)key generalDelegate:(id<BMKGeneralDelegate>)delegate;

/**
*停止引擎
*/
-(BOOL)stop;

@end


