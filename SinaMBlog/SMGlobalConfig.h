//
//  TVGlobalConfig.h
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

//"error":"applications over the unaudited use restrictions!"
//报错参考此处：http://open.weibo.com/qa/index.php?qa=159&qa_1=%E7%94%A8%E6%88%B7%E6%8E%88%E6%9D%83%E5%90%8E%E5%87%BA%E7%8E%B0applications-over-unaudited-restrictions%E9%94%99%E8%AF%AF%E6%80%8E%E4%B9%88%E8%A7%A3%E5%86%B3%EF%BC%9F
//#error @"设置你自己的appkey，请注释掉#error"
#define SinaWeiboV2AppKey @"2045436852"
#define SinaWeiboV2RedirectUri @"http://www.sina.com"

// baidu map key
#define BaiduMapEngineKey @"8502D0F8B5F266104698378D6A9010C31F850B49"

#define IOS_7_X (([[UIDevice currentDevice].systemVersion floatValue] > 6.99))
#define INVALID_INDEX -1
#define PERPAGE_COUNT 20

// Cell布局相关 
#define CELL_PADDING_10 10
#define CELL_PADDING_8 8
#define CELL_PADDING_6 6
#define CELL_PADDING_4 4
#define CELL_PADDING_2 2

#define TABLE_VIEW_BG_COLOR RGBCOLOR(230, 230, 230)
#define CELL_CONTENT_VIEW_BG_COLOR RGBCOLOR(247, 247, 247)
#define CELL_CONTENT_VIEW_BORDER_COLOR RGBCOLOR(234, 234, 234)

// 表情plist文件名
#define EMOTION_PLIST @"emotion_icons.plist"

typedef enum {
    // 微博广场
    MBlogTimeLineType_Public = 0,       // 随便看看
    MBlogTimeLineType_HotRecommend = 1, // 推荐微博
    MBlogTimeLineType_HotComment = 2,   // 热门评论
    MBlogTimeLineType_HotRepost = 3,    // 热门转发
    // 其他
    MBlogTimeLineType_Friends = 4,      // 当前登录用户及关注好友的微博
    MBlogTimeLineType_User = 5,         // 用户发布的微博
    MBlogTimeLineType_AtMe = 6,         // @当前登录用户的微博
    MBlogTimeLineType_Comments = 7,     // 返回最新N条评论列表（发送的和接收到的）
    MBlogTimeLineType_CommentsToMe = 8,
    MBlogTimeLineType_CommentsByMe = 9,
    MBlogTimeLinetype_DirectMsgs = 10    // 登录用户的私信列表
}MBlogTimeLineType;

typedef enum
{
    MBlogPostType_AtUser,
    MBlogPostType_AboutTrend,
    MBlogPostType_Common
}MBlogPostType;

@interface SMGlobalConfig : NSObject

///////////////////////////////////////////////////////////////////////////////////////////////////
// Author
+ (void)setCurrentLoginedUserName:(NSString*)userName;
+ (NSString *)getCurrentLoginedUserName;
+ (void)setCurrentLoginedUserId:(NSString*)userId;
+ (NSString *)getCurrentLoginedUserId;
+ (void)setCurrentLoginedAccessToken:(NSString*)accessToken;
+ (NSString *)getCurrentLoginedAccessToken;
+ (void)setCurrentLoginedExpiresIn:(NSString*)expiresIn;
+ (NSString *)getCurrentLoginedExpiresIn;

///////////////////////////////////////////////////////////////////////////////////////////////////
// UI
+ (void)showHUDMessage:(NSString*)msg addedToView:(UIView*)view;
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createPostBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle target:(id)target action:(SEL)action;

// Emotion
+ (NSArray* )emotionsArray;
+ (NSString*)pathForEmotionCode:(NSString*)code;
+ (NSString*)pathForEmotionCodeForHtml:(NSString*)code;

// 草稿箱数据
+ (NSArray*)getDraftArray;
+ (void)saveToDraft:(NSMutableDictionary*)dic;
+ (BOOL)removeDraftWithIndex:(int)index;
+ (NSDictionary*)convertNSDataToUIImageForDraft:(NSDictionary*)dic;
+ (NSDictionary*)convertUIImageToNSDataForDraft:(NSDictionary*)dic;

@end
