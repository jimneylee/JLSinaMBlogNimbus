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
    self = [super initWithDictionary:dic];
    if (self) {
        self.status   = (SMStatusEntity *)[SMStatusEntity entityWithDictionary:dic[JSON_STATUS]];
        self.userID = [NSString getStringValue:dic[JSON_USERINFO_USERID]];
        self.screenName = dic[JSON_USERINFO_SCREEN_NAME];
        self.name = dic[JSON_USERINFO_NAME];
        self.profileImageUrl = dic[JSON_USERINFO_PROFILE_IMAGE_URL];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (JLNimbusEntity *)entityWithDictionary:(NSDictionary *)dic
{
    SMUserInfoEntity *entity = [[SMUserInfoEntity alloc] initWithDictionary:dic];   
    return entity;
}

@end
