//
//  SMMBlogPostC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-4.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMMBlogPostModel.h"
#import "SMEmotionC.h"
#import "SMPostButtonBar.h"
#import "SMTrendsC.h"
#import "SMFriendsC.h"

typedef enum
{
    ZDPostActionType_Comment,
    ZDPostActionType_Retweet
}ZDPostActionType;
@interface SMCommentOrRetweetC : UIViewController<UIActionSheetDelegate, UITextViewDelegate,
                                                  SMEmotionDelegate, SMTrendsDelegate, SMFriendsDelegate>

// 评论入口
- (id)initWithBlogId:(NSString*)blogId;

// 回复评论入口
- (id)initWithBlogId:(NSString*)blogId replyUsername:(NSString*)username;

// 转发入口
- (id)initWithRetweetBlogId:(NSString*)blogId username:(NSString*)username retweetContent:(NSString*)content;

@end
