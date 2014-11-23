//
//  UserInfoEntity.h
//  SinaMBlog
//
//  Created by Jiang Yu on 13-2-22.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"
#import "SMUserInfoEntity.h"

@class SMStatusEntity;
@interface SMUserInfoEntity : JLNimbusEntity

@property(nonatomic, retain) SMStatusEntity *status;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *screenName;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *profileImageUrl;
@end
