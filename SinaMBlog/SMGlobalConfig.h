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
#define SinaWeiboV2AppKey @"2893625261"

#define IOS_7_X (([[UIDevice currentDevice].systemVersion floatValue] > 6.99))
#define INVALID_INDEX -1
#define PERPAGE_COUNT 20

#define CELL_PADDING_10 10
#define CELL_PADDING_8 8
#define CELL_PADDING_6 6
#define CELL_PADDING_4 4
#define CELL_PADDING_2 2

@interface SMGlobalConfig : NSObject

///////////////////////////////////////////////////////////////////////////////////////////////////
// UI
+ (void)showHUDMessage:(NSString*)msg addedToView:(UIView*)view;
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action;

@end
