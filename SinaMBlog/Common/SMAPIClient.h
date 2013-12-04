//
//  SNAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface SMAPIClient : AFHTTPClient

+ (SMAPIClient*)sharedClient;

// 获取数据，是否需要refresh新的数据
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        refresh:(BOOL)refresh
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// 用户信息
+ (NSString *)relativePathForUserInfoWithUserName:(NSString *)userName
                                         orUserId:(NSString *)userId;
// 随便看看
+ (NSString*)relativePathForPublicTimelineWithPageCounter:(NSInteger)pageCounter
                                             perpageCount:(NSInteger)perpageCount;

// 当前登录用户及关注好友微博某页
+ (NSString*)relativePathForFriendsTimelineWithMaxId:(NSString *)maxId;

// 用户发布的微博:maxId
+ (NSString*)relativePathForUserTimelineWithUserID:(NSString *)userID maxId:(NSString *)maxId;

// @我的微博:maxId
+ (NSString*)relativePathForAtMeTimelineWithMaxId:(NSString *)maxId;

// 获取话题列表数据
+ (NSString*)relativePathForWeeklyTrendsList;

//================================================================================
// status write
//================================================================================
// 发送文字微博
+ (NSString*)relativePathForPostTextStatus;

// 发送图片文字微博
+ (NSString*)relativePathForPostImageStatus;

// 转发微博
+ (NSString*)relativePathForRepostStatus;

// 删除微博
+ (NSString*)relativePathForDestroyStatus;

//================================================================================
// comment wirte
//================================================================================
// 发一条微博评论
+ (NSString*)relativePathForCreateComment;

// 删除一条微博评论
+ (NSString*)relativePathForDestroyComment;

@end

NSString *const kSNAPIBaseURLString;