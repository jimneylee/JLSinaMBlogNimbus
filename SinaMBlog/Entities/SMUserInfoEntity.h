//
//  UserInfoEntity.h
//  SinaMBlog
//
//  Created by Jiang Yu on 13-2-22.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMBaseEntity.h"
#import "SMUserInfoEntity.h"

@class SMStatusEntity;
@interface SMUserInfoEntity : SMBaseEntity

@property(nonatomic, retain) SMStatusEntity *status;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *idstr;
@property(nonatomic, copy) NSString *screen_name;
@property(nonatomic, copy) NSString *name;
@property(assign) int province;
@property(assign) int city;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *profile_image_url;
@property(nonatomic, copy) NSString *profile_url;
@property(nonatomic, copy) NSString *domain;
@property(nonatomic, copy) NSString *weihao;
@property(nonatomic, copy) NSString *gender;
@property(assign) int followers_count;
@property(assign) int friends_count;
@property(assign) int statuses_count;
@property(assign) int favourites_count;
@property(nonatomic, copy) NSString *created_at;
@property(assign) BOOL following;
@property(assign) BOOL allow_all_act_msg;
@property(assign) BOOL geo_enabled;
@property(assign) BOOL verified;
@property(nonatomic, copy) NSString *remark;
@property(assign) BOOL allow_all_comment;
@property(nonatomic, copy) NSString *avatar_large;
@property(nonatomic, copy) NSString *verified_reason;
@property(assign) BOOL follow_me;
@property(assign) int online_status;
@property(assign) int bi_followers_count;
@property(nonatomic, copy) NSString *lang;

@end
