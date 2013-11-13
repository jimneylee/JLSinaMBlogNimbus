//
//  SMUserModel.h
//  SinaMBlogNimbus
//
//  Created by ccjoy-jimneylee on 13-11-13.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMUserInfoEntity;
@interface SMUserInfoModel : NSObject

@property(nonatomic, retain) SMUserInfoEntity *entity;

- (void)loadUserInfoWithUserName:(NSString*)userName
                        orUserId:(NSString*)userId
                           block:(void(^)(SMUserInfoEntity* entity, NSError* error))block;

@end
