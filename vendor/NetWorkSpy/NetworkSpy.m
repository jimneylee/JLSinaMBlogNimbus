//
//  TLGlobalConfig.m
//  SinaMBlog
//
//  Created by jimney Lee on 7/25/12.
//  Copyright (c) 2012 jimneylee. All rights reserved.
//

#import "NetworkSpy.h"
#include <arpa/inet.h>

@implementation NetworkSpy
@synthesize reachability = _reachability;
@synthesize isReachableViaWiFi = _isReachableViaWiFi;
@synthesize isReachableViaWWAN = _isReachableViaWWAN;

static NetworkSpy* sharedNetworkSpy = nil;

+ (id)sharedNetworkSpy
{
    if (!sharedNetworkSpy) {
        sharedNetworkSpy = [[NetworkSpy alloc] init];
    }
    
    return sharedNetworkSpy;
}

+ (BOOL)checkNetworkConnected
{
    Reachability *reac = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if (![reac isReachable]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"网络未连接"
                                                            message:@"请确认网络是否连接正常"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Network

- (id)init
{
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(networkChanged:) 
													 name:kReachabilityChangedNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.reachability stopNotifier];
	self.reachability = nil;
    
	[super dealloc];
}

- (void) spyNetwork
{
	if (!self.reachability) {
        self.reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        
        _isReachableViaWiFi = [self.reachability isReachableViaWiFi];
		_isReachableViaWWAN = [self.reachability isReachableViaWWAN];
		_isReachable = [self.reachability isReachable];
        
		[self.reachability startNotifier];
        
        [self showAlertViewForNotReachable];
	}
}

- (void)networkChanged:(NSNotification*)noti
{
	Reachability* reac = (Reachability*)noti.object;
    
    _isReachableViaWiFi = [reac isReachableViaWiFi];
    _isReachableViaWWAN = [reac isReachableViaWWAN];
    _isReachable = [reac isReachable];

    [self showCurrentReachableAlertView];
}

#pragma mark -
#pragma mark Public
- (void)showAlertViewForNotReachable;
{
    if (!_isReachable) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"网络未连接"
                                                            message:@"请确认网络是否连接正常"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}


- (void)showCurrentReachableAlertView
{
    NSString* title = @"网络未连接";
    
    if (!_isReachable) {
        title = @"网络未连接";
    }
    else if (_isReachableViaWiFi) {
        title = @"当前wifi已连接";
    }
    else if (_isReachableViaWWAN) {
        title = @"当前2g/3g已连接";
    }
    
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alertView show];
//    [alertView release];
    
    [SMGlobalConfig showMessageLabelWithMessage:title];
}

@end
