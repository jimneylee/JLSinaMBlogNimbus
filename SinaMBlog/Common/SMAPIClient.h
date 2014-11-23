//
//  SNAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLAFAPIBaseClient.h"

@interface SMAPIClient : JLAFAPIBaseClient

+ (SMAPIClient*)sharedClient;

// 用户信息
+ (NSString *)relativePathForUserInfoWithUserName:(NSString *)userName
                                         orUserId:(NSString *)userId;
// 随便看看
+ (NSString*)relativePathForPublicTimelineWithPageIndex:(unsigned int)pageIndex
                                               pageSize:(unsigned int)pageSize;

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

//================================================================================
// search
//================================================================================
// 搜索用户
+ (NSString*)urlForSearchUsersWithKeywords:(NSString*)keywords
                                 pageIndex:(unsigned int)pageIndex
                                  pageSize:(unsigned int)pageSize;

// 搜索微博
+ (NSString*)urlForSearchStatusesWithKeywords:(NSString*)keywords
                                    pageIndex:(unsigned int)pageIndex
                                     pageSize:(unsigned int)pageSize;

// 搜索话题下的微博信息
+ (NSString*)urlForSearchTrendsWithKeywords:(NSString*)keywords
                                  pageIndex:(unsigned int)pageIndex
                                   pageSize:(unsigned int)pageSize;

@end

NSString *const kSNAPIBaseURLString;