//
//  SMPostModel.m
//  SinaMBlog
//
//  Created by jimney lee on 12-9-20.
//  Copyright (c) 2012年 jimneylee. All rights reserved.
//

#import "SMMBlogPostModel.h"
#import "MTStatusBarOverlay.h"
#import "SMAPIClient.h"
#import "NSStringAdditions.h"

@implementation SMMBlogPostModel

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark init & dealloc

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithDelegate:(id)delegate
{
	self = [super init];
	if (self) {
        self.postDelegate = delegate;
	}
	return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MBlogPost

//////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 发送草稿箱里面的数据
 */
- (void)postDraftInfo:(NSDictionary*)info PostType:(PostType)type
{
    NSString* path = nil;
    switch (type) {
        case PostType_MBlogText:
            path = [SMAPIClient relativePathForPostTextStatus];
            break;
            
        case PostType_MBlogImage:
            path = [SMAPIClient relativePathForPostImageStatus];
            break;
            
        case PostType_Retweet:
            path = [SMAPIClient relativePathForRepostStatus];
            break;
            
        case PostType_Comment:
            path = [SMAPIClient relativePathForCreateComment];
            break;
            
        default:
            break;
    }
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];

    NSArray* allKeys = [info allKeys];
    for (NSString* key in allKeys) {
        if (![key isEqualToString:@"pic_data"]) {
            [parameters setObject:[info objectForKey:key] forKey:key];
        }
    }

    // 修改状态栏
    switch (type) {
        case PostType_MBlogText:
        case PostType_MBlogImage:
        {
//                if (PostType_MBlogImage == type) {
//                    multiPartForm = YES;
//                }
            NSString* text = [parameters objectForKey:@"status"];
            text = [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [parameters setObject:text forKey:@"status"];
            
            // 更改当前类型
            _postType = PostType_DraftMBlog;
            [[MTStatusBarOverlay sharedOverlay] postMessage:@"发布微博中..."];
        }
            break;
            
        case PostType_Retweet:
        {
            NSString* text = [parameters objectForKey:@"status"];
            text = [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [parameters setObject:text forKey:@"status"];
            // 更改当前类型
            _postType = PostType_DraftRetweet;
            [[MTStatusBarOverlay sharedOverlay] postMessage:@"转发微博中..." duration:0.0f animated:YES];
        }
            break;
            
        case PostType_Comment:
        {
            NSString* text = [parameters objectForKey:@"comment"];
            text = [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [parameters setObject:text forKey:@"comment"];
            // 更改当前类型
            _postType = PostType_DraftComment;
            [[MTStatusBarOverlay sharedOverlay] postMessage:@"发表评论中..."];
        }
            break;
            
        default:
            break;
    }
        
    [[SMAPIClient sharedClient] POST:path parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self requestDidFinishLoadWithObject:responseObject];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self requestDidFailLoadWithError:error];
                             }];
        self.parameters = parameters;
}

/**
 * 发送纯文字微博
 */
//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postStatus:(NSString *)status latitude:(double)latitude longitude:(double)longitude
{
	//if (!self.isLoading)
    NSString* path = [SMAPIClient relativePathForPostTextStatus];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:status forKey:@"status"];
    [parameters setObject:[SMGlobalConfig getCurrentLoginedAccessToken] forKey:@"access_token"];
    if (latitude < CGFLOAT_MAX && longitude < CGFLOAT_MAX) {
        [parameters setObject:[NSString stringWithFormat:@"%.6f", latitude] forKey:@"lat"];
        [parameters setObject:[NSString stringWithFormat:@"%.6f", longitude] forKey:@"long"];
    }
    [[SMAPIClient sharedClient] POST:path parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self requestDidFinishLoadWithObject:responseObject];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self requestDidFailLoadWithError:error];
                             }];
    _postType = PostType_MBlogText;
    self.parameters = parameters;
    [[MTStatusBarOverlay sharedOverlay] postMessage:@"发布微博中..."];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableDictionary* )createParametersForPostStatus:(NSString *)status
                                              latitude:(double)latitude
                                             longitude:(double)longitude
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:status forKey:@"status"];
    if (latitude < CGFLOAT_MAX && longitude < CGFLOAT_MAX) {
        [parameters setObject:[NSString stringWithFormat:@"%.6f", latitude] forKey:@"lat"];
        [parameters setObject:[NSString stringWithFormat:@"%.6f", longitude] forKey:@"long"];
    }
    return parameters;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveToDraftForPostStatus:(NSString *)status
                        latitude:(double)latitude
                       longitude:(double)longitude
{
    // 保存当前类型和数据
    _postType = PostType_MBlogText;
    self.parameters = [self createParametersForPostStatus:status latitude:latitude longitude:longitude];
    [self saveToDraft];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 发送图片文字微博
 */
- (void)postImage:(UIImage*)image status:(NSString *)status latitude:(double)latitude longitude:(double)longitude
{
    NSString* path = [SMAPIClient relativePathForPostImageStatus];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:status forKey:@"status"];
    [parameters setObject:image forKey:@"pic"];
    [parameters setObject:[SMGlobalConfig getCurrentLoginedAccessToken] forKey:@"access_token"];
    if (latitude < CGFLOAT_MAX && longitude < CGFLOAT_MAX) {
        [parameters setObject:[NSString stringWithFormat:@"%.6f", latitude] forKey:@"lat"];
        [parameters setObject:[NSString stringWithFormat:@"%.6f", longitude] forKey:@"long"];
    }
    [[SMAPIClient sharedClient] POST:path parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self requestDidFinishLoadWithObject:responseObject];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self requestDidFailLoadWithError:error];
                             }];    // 保存当前类型和数据
    _postType = PostType_MBlogImage;
    self.parameters = parameters;
    // 由于parameters这边发送失败后，底层会删除pic的key-value
    self.postImage = image;
    // 修改状态栏
    [[MTStatusBarOverlay sharedOverlay] postMessage:@"发布微博中..."];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveToDraftForPostImage:(UIImage*)image status:(NSString *)status latitude:(double)latitude longitude:(double)longitude
{
    // 保存当前类型和数据
    _postType = PostType_MBlogImage;
    self.parameters = [self createParametersForPostImage:image status:status latitude:latitude longitude:longitude];
    [self saveToDraft];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableDictionary* )createParametersForPostImage:(UIImage*)image status:(NSString *)status latitude:(double)latitude longitude:(double)longitude
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:status forKey:@"status"];
    if (latitude < CGFLOAT_MAX && longitude < CGFLOAT_MAX) {
        [parameters setObject:[NSString stringWithFormat:@"%.6f", latitude] forKey:@"lat"];
        [parameters setObject:[NSString stringWithFormat:@"%.6f", longitude] forKey:@"long"];
    }
    return parameters;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 发送微博回复
 */
- (void)postComment:(NSString *)comment toBlogId:(NSString*)blogId
{
    NSString* path = [SMAPIClient relativePathForCreateComment];

    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:comment forKey:@"comment"];
    [parameters setObject:blogId forKey:@"id"];
    [parameters setObject:[SMGlobalConfig getCurrentLoginedAccessToken] forKey:@"access_token"];

    // 保存当前类型和数据
    _postType = PostType_Comment;
    self.parameters = parameters;
    
    [[SMAPIClient sharedClient] POST:path parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self requestDidFinishLoadWithObject:responseObject];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self requestDidFailLoadWithError:error];
                             }];
    
    // 修改状态栏
    [[MTStatusBarOverlay sharedOverlay] postMessage:@"发表评论中..."];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveToDraftForPostComment:(NSString *)comment toBlogId:(NSString*)blogId
{
    // 保存当前类型和数据
    _postType = PostType_Comment;
    self.parameters = [self createParametersForPostComment:comment toBlogId:blogId];
    [self saveToDraft];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableDictionary* )createParametersForPostComment:(NSString *)comment toBlogId:(NSString*)blogId
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:comment forKey:@"comment"];
    [parameters setObject:blogId forKey:@"id"];
    return parameters;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 转发微博
 */
- (void)retweetStatus:(NSString *)status blogId:(NSString*)blogId isComment:(BOOL)isComment
{
    NSString* path = [SMAPIClient relativePathForRepostStatus];

    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SMGlobalConfig getCurrentLoginedAccessToken] forKey:@"access_token"];
    [parameters setObject:status forKey:@"status"];
    [parameters setObject:blogId forKey:@"id"];
    if (isComment) {
        [parameters setObject:@"1" forKey:@"is_comment"];
    }

    // 保存当前类型和数据
    _postType = PostType_Retweet;
    self.parameters = parameters;

    [[SMAPIClient sharedClient] POST:path parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self requestDidFinishLoadWithObject:responseObject];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self requestDidFailLoadWithError:error];
                             }];

    // 修改状态栏
    [[MTStatusBarOverlay sharedOverlay] postMessage:@"转发微博中..." duration:0.0f animated:YES];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveToDraftForRetweetStatus:(NSString *)status blogId:(NSString*)blogId isComment:(BOOL)isComment
{
    // 保存当前类型和数据
    _postType = PostType_Retweet;
    self.parameters = [self createParametersForRetweetStatus:status blogId:blogId isComment:isComment];
    [self saveToDraft];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableDictionary* )createParametersForRetweetStatus:(NSString *)status blogId:(NSString*)blogId isComment:(BOOL)isComment
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:status forKey:@"status"];
    [parameters setObject:blogId forKey:@"id"];
    if (isComment) {
        [parameters setObject:@"1" forKey:@"is_comment"];
    }
    return parameters;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) requestDidFinishLoadWithObject:(id)object
{
	NSDictionary* dic = object;
    
	if (dic){
        if (self.postDelegate && [self.postDelegate respondsToSelector:@selector(postRequestFinished)]) {
            [self.postDelegate postRequestFinished];
        }
        
        [[MTStatusBarOverlay sharedOverlay] postImmediateFinishMessage:@"发送成功" duration:2.0f animated:YES];
	}
	else {
        if (self.postDelegate && [self.postDelegate respondsToSelector:@selector(postRequestFailed)]) {
            [self.postDelegate postRequestFailed];
        }
        
        if (_postType < PostType_DraftMBlog) {
            [[MTStatusBarOverlay sharedOverlay] postImmediateErrorMessage:@"发送失败，已存草稿箱！" duration:2.0f animated:YES];
            // save to draft
            [self saveToDraft];
        }
        else {
            [[MTStatusBarOverlay sharedOverlay] postImmediateErrorMessage:@"发送失败，请重试！" duration:2.0f animated:YES];
        }
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFailLoadWithError:(NSError*)error
{
    NSLog(@"error: %@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"responsedata"]
                                              encoding:NSUTF8StringEncoding]);
    if (self.postDelegate && [self.postDelegate respondsToSelector:@selector(postRequestFailed)]) {
        [self.postDelegate postRequestFailed];
    }

    if (_postType < PostType_DraftMBlog) {
        [[MTStatusBarOverlay sharedOverlay] postImmediateErrorMessage:@"发送失败，已存草稿箱！" duration:2.0f animated:YES];
        // save to draft
        [self saveToDraft];
    }
    else {
        [[MTStatusBarOverlay sharedOverlay] postImmediateErrorMessage:@"发送失败，请重试！" duration:2.0f animated:YES];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveToDraft
{
    if (_postType < PostType_DraftMBlog) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
        [params setObject:[NSString stringWithFormat:@"%d", _postType] forKey:@"post_type"];
        // 由于parameters这边发送失败后，底层会删除pic的key-value
        // 故，此处进行重新赋值
        if (PostType_MBlogImage == _postType && self.postImage) {
            [params setObject:self.postImage forKey:@"pic"];
        }
        [SMGlobalConfig saveToDraft:params];
    }
}

@end

