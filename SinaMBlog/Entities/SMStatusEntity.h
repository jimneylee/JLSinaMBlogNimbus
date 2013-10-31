//
//  SMWeiboMainbodyEntity.h
//  SinaMBlog
//
//  Created by Jiang Yu on 13-1-30.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMBaseEntity.h"
#import "SMUserInfoEntity.h"

@interface SMStatusEntity : SMBaseEntity

@property (nonatomic, strong) SMUserInfoEntity *user;
@property (nonatomic, strong) SMStatusEntity *retweeted_status;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *blogID;
@property (nonatomic, copy) NSString *blogMID;
@property (nonatomic, copy) NSString *blogIDStr;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, strong) NSDate *timestamp;

@property (assign) BOOL favorited;
@property (assign) BOOL truncated;

@property (nonatomic, copy) NSString *thumbnail_pic;
@property (nonatomic, copy) NSString *bmiddle_pic;
@property (nonatomic, copy) NSString *original_pic;

@property (assign) int reposts_count;
@property (assign) int comments_count;
@property (assign) int attitudes_count;

@end
