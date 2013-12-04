//
//  SMFriendEntity.h
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMSectionItemBaseEntity.h"

@interface SMFriendEntity : SMSectionItemBaseEntity

@property (nonatomic, copy) NSString* userId;

+ (id)entityWithDictionary:(NSDictionary*)dic;
- (NSString* )getNameWithAt;
@end
