//
//  AppDelegate.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-30.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "BMapKit.h"
#import "SMAuthorizeModel.h"
#import "SMLoginC.h"
#import "SMHomeTimlineListC.h"

@interface AppDelegate()<BMKGeneralDelegate>
@property (nonatomic, strong) BMKMapManager* mapManager;
@end

@implementation AppDelegate

- (void)prepareForLaunching
{
    // Disk cache
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                        diskCapacity:20 * 1024 * 1024
                                                            diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    // AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:
                                                       @"application/json",
                                                       @"text/json",
                                                       @"text/javascript",
                                                       @"text/html",
                                                       @"text/plain", nil]];
    // Sina SDK
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SinaWeiboV2AppKey];
    
    // Baidu Map
    self.mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [self.mapManager start:BaiduMapEngineKey generalDelegate:self];
	if (!ret) {
		[SMGlobalConfig showHUDMessage:@"地图初始化失败！"
                           addedToView:[UIApplication sharedApplication].keyWindow];
	}
}

- (void)appearanceChange
{
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    if (IOS_IS_AT_LEAST_7) {
        // do change if u need
        //[[UINavigationBar appearance] setBarTintColor:[UIColor lightGrayColor]];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (UIViewController*)generateRootViewController
{
    UIViewController* c = nil;
    if ([SMAuthorizeModel isAuthorized]) {
        c = [[SMHomeTimlineListC alloc] init];
    }
    else {
        c = [[SMLoginC alloc] initWithStyle:UITableViewStylePlain];
    }
    return c;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self prepareForLaunching];
    [self appearanceChange];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController* c = [self generateRootViewController];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:c];
    navi.navigationBar.translucent = NO;
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - WeiboSDKDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class]) {
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (0 == response.statusCode) {
            [SMGlobalConfig setCurrentLoginedUserId:[(WBAuthorizeResponse *)response userID]];
            [SMGlobalConfig setCurrentLoginedAccessToken:[(WBAuthorizeResponse *)response accessToken]];
            [SMGlobalConfig setCurrentLoginedExpiresIn:response.userInfo[@"expires_in"]];
            
            // post did login success notification
            [[NSNotificationCenter defaultCenter] postNotificationName:SNDidOAuthNotification
                                                                object:[NSNumber numberWithBool:YES] userInfo:nil];
        }
        else {
            // post did login fail notification
            [[NSNotificationCenter defaultCenter] postNotificationName:SNDidOAuthNotification
                                                                object:[NSNumber numberWithBool:NO] userInfo:nil];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

@end
