//
//  SNAPIClient.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMAPIClient.h"
#import "AFImageRequestOperation.h"

NSString *const kSNAPIBaseURLString = @"https://api.weibo.com/2/";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SMAPIClient

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (SMAPIClient*)sharedClient
{
    static SMAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SMAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kSNAPIBaseURLString]];
    });
    
    return _sharedClient;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - User

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)relativePathForUserInfoWithUserName:(NSString *)userName
                                orUserId:(NSString *)userId {
    NSString* param;
    if (userId.length) {
        param = [NSString stringWithFormat:@"uid=%@", userId];
    }
    else if (userName.length) {
        param = [NSString stringWithFormat:@"screen_name=%@", userName];
    }
    if (param) {
        return [NSString stringWithFormat:@"users/show.json?%@&access_token=%@",
                param, [SMGlobalConfig getCurrentLoginedAccessToken]];
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TimeLine

///////////////////////////////////////////////////////////////////////////////////////////////////
// 公共微博某页
// !note: page -> cusor
+ (NSString*)relativePathForPublicTimelineWithPageCounter:(NSInteger)pageCounter
                                             perpageCount:(NSInteger)perpageCount
{
    return [NSString stringWithFormat:@"statuses/public_timeline.json?cursor=%d&count=%d&source=%@",
            pageCounter, perpageCount, SinaWeiboV2AppKey];
}

// 当前登录用户及关注好友微博某页
+ (NSString*)relativePathForFriendsTimelineWithMaxId:(NSString *)maxId
{
    return [NSString stringWithFormat:@"statuses/friends_timeline.json?max_id=%@&access_token=%@",
            maxId, [SMGlobalConfig getCurrentLoginedAccessToken]];
}

// 用户发布的微博:maxId
+ (NSString*)relativePathForUserTimelineWithUserID:(NSString *)userID maxId:(NSString *)maxId
{
    return [NSString stringWithFormat:@"statuses/user_timeline.json?uid=%@&max_id=%@&access_token=%@",
            userID, maxId, [SMGlobalConfig getCurrentLoginedAccessToken]];
}

// @我的微博:maxId
+ (NSString*)relativePathForAtMeTimelineWithMaxId:(NSString *)maxId
{
    return [NSString stringWithFormat:@"statuses/mentions.json?max_id=%@&access_token=%@",
            maxId, [SMGlobalConfig getCurrentLoginedAccessToken]];
}

#pragma mark - Trends

// 话题列表数据
+ (NSString*)relativePathForWeeklyTrendsList
{
    return [NSString stringWithFormat:@"trends/weekly.json?access_token=%@",
            [SMGlobalConfig getCurrentLoginedAccessToken]];
}

#pragma mark - MBlog write

// 发送文字微博
+ (NSString*)relativePathForPostTextStatus
{
    return [NSString stringWithFormat:@"statuses/update.json"];
    
}

// 发送图片文字微博
+ (NSString*)relativePathForPostImageStatus
{
    return [NSString stringWithFormat:@"statuses/upload.json"];
}

// 转发微博
+ (NSString*)relativePathForRepostStatus
{
    return [NSString stringWithFormat:@"statuses/repost.json"];
}

// 删除微博
+ (NSString*)relativePathForDestroyStatus
{
    return [NSString stringWithFormat:@"statuses/destroy.json"];
}

#pragma mark - Comment write
// 评论微博
+ (NSString*)relativePathForCreateComment
{
    return [NSString stringWithFormat:@"comments/create.json"];
}

// 删除评论
+ (NSString*)relativePathForDestroyComment
{
    return [NSString stringWithFormat:@"comments/destroy.json"];
}

#pragma mark - Search
// 搜索用户
+ (NSString*)urlForSearchUsersWithKeywords:(NSString*)keywords
                               pageCounter:(NSInteger)pageCounter
                              perpageCount:(NSInteger)perpageCount
{
    return [NSString stringWithFormat:@"search/suggestions/users.json?q=%@&page=%d&count=%d&access_token=%@",
            keywords, pageCounter, perpageCount, [SMGlobalConfig getCurrentLoginedAccessToken]];
}

// 搜索微博
+ (NSString*)urlForSearchStatusesWithKeywords:(NSString*)keywords
                                  pageCounter:(NSInteger)pageCounter
                                 perpageCount:(NSInteger)perpageCount
{
    return [NSString stringWithFormat:@"search/suggestions/statuses.json?q=%@&page=%d&count=%d&access_token=%@",
            keywords, pageCounter, perpageCount, [SMGlobalConfig getCurrentLoginedAccessToken]];
}

// 搜索话题下的微博信息
// 高级接口待申请 http://open.weibo.com/wiki/2/search/topics
+ (NSString*)urlForSearchTrendsWithKeywords:(NSString*)keywords
                                pageCounter:(NSInteger)pageCounter
                               perpageCount:(NSInteger)perpageCount
{
    return [NSString stringWithFormat:@"search/topics.json?q=%@&page=%d&count=%d&access_token=%@",
            keywords, pageCounter, perpageCount, [SMGlobalConfig getCurrentLoginedAccessToken]];
}
@end
