//
//  TVGlobalConfig.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "SMGlobalConfig.h"

#define kLoginedUserNameKey  @"LoginedUserName"
#define kLoginedUserIdKey  @"LoginedUserId"
#define kLoginedAccessTokenKey  @"LoginedAccessToken"
#define kLoginedExpiresInKey @"LoginedExpiresIn"

static NSString* currentLoginedUserId = nil;
static NSString* currentLoginedUserName = nil;
static NSString* currentLoginedAccessToken = nil;
static NSString* currentLoginedExpiresIn = nil;

@implementation SMGlobalConfig

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Author

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setCurrentLoginedUserName:(NSString*)userName
{
    currentLoginedUserName = [userName copy];
    [[NSUserDefaults standardUserDefaults] setObject:currentLoginedUserName forKey:kLoginedUserNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getCurrentLoginedUserName
{
    if (!currentLoginedUserName) {
        currentLoginedUserName = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginedUserNameKey];
    }
    return currentLoginedUserName;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setCurrentLoginedUserId:(NSString*)userId
{
    currentLoginedUserId = [userId copy];
    [[NSUserDefaults standardUserDefaults] setObject:currentLoginedUserId forKey:kLoginedUserIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getCurrentLoginedUserId
{
    if (!currentLoginedUserId) {
        currentLoginedUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginedUserIdKey];
    }
    return currentLoginedUserId;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setCurrentLoginedAccessToken:(NSString*)accessToken
{
    currentLoginedAccessToken = [accessToken copy];
    [[NSUserDefaults standardUserDefaults] setObject:currentLoginedAccessToken forKey:kLoginedAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getCurrentLoginedAccessToken
{
    if (!currentLoginedAccessToken) {
        currentLoginedAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginedAccessTokenKey];
    }
    return currentLoginedAccessToken;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setCurrentLoginedExpiresIn:(NSString*)expiresIn
{
    currentLoginedExpiresIn = [expiresIn copy];
    [[NSUserDefaults standardUserDefaults] setObject:currentLoginedExpiresIn forKey:kLoginedExpiresInKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getCurrentLoginedExpiresIn
{
    if (!currentLoginedExpiresIn) {
        currentLoginedExpiresIn = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginedExpiresInKey];
    }
    return currentLoginedExpiresIn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global UI

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)showHUDMessage:(NSString*)msg addedToView:(UIView*)view
{
    __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [hud hide:YES afterDelay:1.0f];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                         target:target action:action];
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createPostBarButtonItemWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                         target:target action:action];
    return item;
}

@end
