//
//  AppDelegate.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-30.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "AppDelegate.h"
#import "SDURLCache.h"
#import "AFNetworking.h"

@implementation AppDelegate

- (void)prepareForLaunching
{
    // http://wiki.nimbuskit.info/Network-Disk-Caching
    // Nimbus implements its own in-memory cache for network images. Because of this we don't allocate
    // any memory for NSURLCache.
    static const NSUInteger kMemoryCapacity = 4 * 1024 * 1024;// 4MB memory cache
    static const NSUInteger kDiskCapacity = 20 * 1024 * 1024; // 20MB disk cache
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:kMemoryCapacity
                                                         diskCapacity:kDiskCapacity
                                                             diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:urlCache];
    
    //    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
    //                                                         diskCapacity:20 * 1024 * 1024
    //                                                             diskPath:nil];
    //    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:
                                                       @"application/json",
                                                       @"text/json",
                                                       @"text/javascript",
                                                       @"text/html",
                                                       @"text/plain", nil]];
    // 新浪微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SinaWeiboV2AppKey];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self prepareForLaunching];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[SMLoginC alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:self.viewController];
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
