//
//  TVGlobalConfig.h
//  VideoOnline
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 SuperMaxDev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
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
