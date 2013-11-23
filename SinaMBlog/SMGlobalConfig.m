//
//  TVGlobalConfig.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "SMGlobalConfig.h"
#import "SMEmotionEntity.h"

#define kLoginedUserNameKey  @"LoginedUserName"
#define kLoginedUserIdKey  @"LoginedUserId"
#define kLoginedAccessTokenKey  @"LoginedAccessToken"
#define kLoginedExpiresInKey @"LoginedExpiresIn"

static NSString* currentLoginedUserId = nil;
static NSString* currentLoginedUserName = nil;
static NSString* currentLoginedAccessToken = nil;
static NSString* currentLoginedExpiresIn = nil;

// emotion
static NSArray* emotionsArray = nil;
static NSArray* emotionsArrayForHtml = nil;

// font setting
static NSUInteger settingFontSizeIndex = ULONG_MAX;
static NSUInteger settingBrowseModeIndex = ULONG_MAX;
static NSUInteger settingMsgRemindFrequencyIndex = ULLONG_MAX;

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
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle target:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
    
    return item;
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

#pragma mark -
#pragma mark Emotion
+ (NSArray* )emotionsArray
{
    if (!emotionsArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:EMOTION_PLIST ofType:nil];
        NSArray* array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray* entities = [NSMutableArray arrayWithCapacity:array.count];
        SMEmotionEntity* entity;
        for (NSDictionary* dic in array) {
            entity = [SMEmotionEntity createWithDictionary:dic];
            [entities addObject:entity];
        }
        emotionsArray = entities;
    }
    return emotionsArray;
}

+ (NSString*)pathForEmotionCode:(NSString*)code
{
    for (SMEmotionEntity* e in [SMGlobalConfig emotionsArray]) {
        if ([e.code isEqualToString:code]) {
            return e.urlPath;
        }
    }
    return nil;
}

+ (NSString*)pathForEmotionCodeForHtml:(NSString*)code
{
    if (!emotionsArrayForHtml) {
        NSString *path = [[NSBundle mainBundle] pathForResource:EMOTION_PLIST ofType:nil];
        NSArray* array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray* entities = [NSMutableArray arrayWithCapacity:array.count];
        SMEmotionEntity* entity;
        for (NSDictionary* dic in array) {
            entity = [SMEmotionEntity createWithDictionaryForHtml:dic];
            [entities addObject:entity];
        }
        emotionsArrayForHtml = entities;
    }
    
    for (SMEmotionEntity* e in emotionsArrayForHtml) {
        if ([e.code isEqualToString:code]) {
            return e.urlPath;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark Draft
+ (NSArray*)getDraftArray
{
    NSString* key = [NSString stringWithFormat:@"post_draft_list_%@", [SMGlobalConfig getCurrentLoginedUserId]];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveToDraft:(NSMutableDictionary*)dic
{
    if (dic && dic.count > 0) {
        NSArray* array = [SMGlobalConfig getDraftArray];
        // 创建一个新的可变数组来存放新的数据
        NSMutableArray* newArray = nil;
        if (!array) {
            array = [NSMutableArray array];
            newArray = (NSMutableArray*)array;
        }
        else {
            newArray = [NSMutableArray arrayWithArray:array];
        }
        
        NSDictionary* newDic = [SMGlobalConfig convertUIImageToNSDataForDraft:dic];
        [newArray addObject:newDic];
        
        NSString* key = [NSString stringWithFormat:@"post_draft_list_%@", [SMGlobalConfig getCurrentLoginedUserId]];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)removeDraftWithIndex:(int)index
{
    NSArray* array = [SMGlobalConfig getDraftArray];
    if (array.count > index) {
        NSMutableArray* newArray = nil;
        newArray = [NSMutableArray arrayWithArray:array];
        [newArray removeObjectAtIndex:index];
        
        NSString* key = [NSString stringWithFormat:@"post_draft_list_%@", [SMGlobalConfig getCurrentLoginedUserId]];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

// UIImage -> NSData
// pic -> pic_data
+ (NSDictionary*)convertUIImageToNSDataForDraft:(NSDictionary*)dic
{
    UIImage* image = [dic objectForKey:@"pic"];
    
    if (image) {
        //        NSMutableDictionary* mDic = nil;
        //        if ([dic isKindOfClass:[NSMutableDictionary class]]) {
        //            mDic = (NSMutableDictionary*)dic;
        //        }
        //        else {
        //            mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        //        }
        
        NSMutableDictionary* mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mDic setObject:UIImageJPEGRepresentation(image, 1.0) forKey:@"pic_data"];
        [mDic removeObjectForKey:@"pic"];
        return mDic;
    }
    
    return dic;
}

// NSData -> UIImage
// pic_data -> pic
+ (NSDictionary*)convertNSDataToUIImageForDraft:(NSDictionary*)dic
{
    NSData* imageData = [dic objectForKey:@"pic_data"];
    
    if (imageData) {
        //        NSMutableDictionary* mDic = nil;
        //        if ([dic isKindOfClass:[NSMutableDictionary class]]) {
        //            mDic = (NSMutableDictionary*)dic;
        //        }
        //        else {
        //            mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        //        }
        
        NSMutableDictionary* mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        UIImage* image = [UIImage imageWithData:imageData];
        [mDic setObject:image forKey:@"pic"];
        
        return mDic;
    }
    
    return dic;
}

@end
