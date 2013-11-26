//
//  SMUserModel.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 11/26/13.
//  Copyright (c) 2013 SuperMaxDev. All rights reserved.
//

#import "SMAuthorizeModel.h"

@implementation SMAuthorizeModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Authorization

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)sendAuthorizeRequest
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SinaWeiboV2RedirectUri;
    request.scope = nil;//http://open.weibo.com/wiki/Scope
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TODO:打算从这个类中剥离出来，放这里有点不合适
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)isAuthorized
{
	return [SMGlobalConfig getCurrentLoginedUserId]
    && [SMGlobalConfig getCurrentLoginedAccessToken]
    && ![self isAuthorizeExpired];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)isAuthorizeExpired
{
    if ([SMGlobalConfig getCurrentLoginedExpiresIn]) {
        
        NSDate* expirationDate = [NSDate distantPast];
        
        if ([SMGlobalConfig getCurrentLoginedExpiresIn]) {
            int expVal = [[SMGlobalConfig getCurrentLoginedExpiresIn] intValue];
            if (expVal != 0) {
                expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        
        NSDate* now = [NSDate date];
        return ([now compare:expirationDate] == NSOrderedDescending);
    }
    
    return NO;
}

@end
