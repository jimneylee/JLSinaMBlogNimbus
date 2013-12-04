//
//  SMFriendsEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMFriendListEntity.h"
#import "SMFriendEntity.h"

@implementation SMFriendListEntity

// http://open.weibo.com/wiki/2/friendships/groups
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    SMFriendListEntity* entity = [SMFriendListEntity new];
    NSArray* sourceArray = [dic objectForKey:@"lists"];
    if (sourceArray.count > 0) {
        
        entity.unsortedArray = [NSMutableArray arrayWithCapacity:sourceArray.count];
        for (NSDictionary* d in sourceArray) {
            SMFriendEntity* e = [SMFriendEntity entityWithDictionary:d];
            if (e) {
                [entity.unsortedArray addObject:e];
            }
        }
        
        [entity sort];
    }
    return entity;
}

@end
