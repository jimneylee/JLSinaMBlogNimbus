//
//  SMFriendEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMFriendEntity.h"
#import "NSString+StringValue.h"
#import "pinyin.h"

@implementation SMFriendEntity
@synthesize userId = _userId;

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
	SMFriendEntity* entity = [SMFriendEntity new];
    entity.userId = [NSString getStringValue:[dic objectForKey:@"id"]];
	entity.name = [dic objectForKey:@"name"];

    if (entity.name.length > 0) {
        entity.sortString = [entity createSortString];
        return entity;
    }
    else return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public
- (NSString* )getNameWithAt
{
    return [NSString stringWithFormat:@"@%@", self.name];
}

@end
