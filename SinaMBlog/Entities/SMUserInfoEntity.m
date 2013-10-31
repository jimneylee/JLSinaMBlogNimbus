//
//  UserInfoEntity.m
//  SinaMBlog
//
//  Created by Jiang Yu on 13-2-22.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMUserInfoEntity.h"
#import "SMJSONKeys.h"
#import "NSString+StringValue.h"
#import "SMStatusEntity.h"

@implementation SMUserInfoEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic.count || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.status   = (SMStatusEntity *)[SMStatusEntity entityWithDictionary:dic[JSON_STATUS]];
        self.userID = [NSString getStringValue:dic[JSON_USERINFO_USERID]];
        self.idstr = dic[JSON_USERINFO_IDSTR];
        self.screen_name = dic[JSON_USERINFO_SCREEN_NAME];
        self.name = dic[JSON_USERINFO_NAME];
        self.gender = dic[JSON_USERINFO_GENDER];
        self.province = [dic[JSON_USERINFO_PROVINCE] intValue];
        self.location = dic[JSON_USERINFO_LOCATION];
        self.description = dic[JSON_USERINFO_DESCRIPTION];
        self.url = dic[JSON_USERINFO_URL];
        self.profile_image_url = dic[JSON_USERINFO_PROFILE_IMAGE_URL];
        self.profile_url = dic[JSON_USERINFO_PROFILE_URL];
        self.followers_count = [dic[JSON_USERINFO_FOLLOWERS_COUNT] intValue];
        self.friends_count = [dic[JSON_USERINFO_FRIENDS_COUNT] intValue];
        self.statuses_count = [dic[JSON_USERINFO_STATUSES_COUNT] intValue];
        self.favourites_count = [dic[JSON_USERINFO_FAVOURITES_COUNT] intValue];
        self.following = [dic[JSON_USERINFO_FOLLOWING] boolValue];
        self.follow_me = [dic[JSON_USERINFO_FOLLOW_ME] boolValue];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (SMBaseEntity *)entityWithDictionary:(NSDictionary *)dic {
    if (!dic.count || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    SMUserInfoEntity *entity = [[SMUserInfoEntity alloc] initWithDictionary:dic];   
    return entity;
}

@end
