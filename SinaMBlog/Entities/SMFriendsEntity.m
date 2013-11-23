//
//  SMFriendsEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMFriendsEntity.h"
#import "SMFriendEntity.h"

@implementation SMFriendsEntity
// http://open.weibo.com/wiki/2/friendships/groups
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)createWithDictionary:(NSDictionary*)dic
{
    SMFriendsEntity* entity = [SMFriendsEntity new];
    NSArray* sourceArray = [dic objectForKey:@"lists"];
    if (sourceArray.count > 0) {
        
        entity.unsortedArray = [NSMutableArray arrayWithCapacity:sourceArray.count];
        for (NSDictionary* d in sourceArray) {
            SMFriendEntity* e = [SMFriendEntity createWithDictionary:d];
            if (e) {
                [entity.unsortedArray addObject:e];
            }
        }
        
        [entity sort];
    }
    return entity;
}

@end
