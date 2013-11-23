//
//  SMPostModel.h
//  Zuoida
//
//  Created by jimney lee on 12-9-20.
//  Copyright (c) 2012年 jimneylee. All rights reserved.
//

typedef enum {
    PostType_MBlogText, // 文字微博
    PostType_MBlogImage, // 图片微博
    PostType_Comment,   // 评论微博
    PostType_Retweet,   // 转发微博
    PostType_DraftMBlog, // 垃圾箱-文字/图片微博
    PostType_DraftComment,   // 垃圾箱-评论微博
    PostType_DraftRetweet,   // 垃圾箱-转发微博
}PostType;

@protocol ZDMBlogPostModelDelegate;
@interface SMMBlogPostModel : NSObject {
    PostType _postType;
}

- (id)initWithDelegate:(id)delegate;

@property (nonatomic, assign) id<ZDMBlogPostModelDelegate> postDelegate;
@property (nonatomic, retain) NSDictionary* parameters;
@property (nonatomic, retain) UIImage* postImage;
// 发送草稿箱的数据
- (void)postDraftInfo:(NSDictionary*)info PostType:(PostType)type;

// 普通发表微博、转发、评论
- (void)postStatus:(NSString*)status latitude:(double)latitude longitude:(double)longitude;
- (void)postImage:(UIImage*)image status:(NSString*)status latitude:(double)latitude longitude:(double)longitude;
- (void)postComment:(NSString *)comment toBlogId:(NSString*)blogId;
- (void)retweetStatus:(NSString *)status blogId:(NSString*)blogId isComment:(BOOL)isComment;

// 草稿箱保存
- (void)saveToDraftForPostStatus:(NSString *)status latitude:(double)latitude longitude:(double)longitude;
- (void)saveToDraftForPostImage:(UIImage*)image status:(NSString *)status latitude:(double)latitude longitude:(double)longitude;
- (void)saveToDraftForPostComment:(NSString *)comment toBlogId:(NSString*)blogId;
- (void)saveToDraftForRetweetStatus:(NSString *)status blogId:(NSString*)blogId isComment:(BOOL)isComment;

@end

@protocol ZDMBlogPostModelDelegate <NSObject>

- (void) postRequestFinished;
- (void) postRequestFailed;

@end
