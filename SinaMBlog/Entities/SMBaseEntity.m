//
//  BaseEntity.m
//  SinaMBlog
//
//  Created by Jiang Yu on 13-1-31.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMBaseEntity.h"

@implementation SMBaseEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.cellStyle = UITableViewCellStyleSubtitle;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    SMBaseEntity* entity = [[SMBaseEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
