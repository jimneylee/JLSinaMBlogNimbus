//
//  SMTrendE.m
//  SinaMBlog
//
//  Created by jimney on 13-3-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMTrendEntity.h"
#import "pinyin.h"

@implementation SMTrendEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
	SMTrendEntity* entity = [SMTrendEntity new];
	entity.name = [dic objectForKey:@"name"];
    // TODO: 生成sortString
    if (entity.name.length > 0) {
        entity.sortString = [entity createSortString];
        NSLog(@"%@ ---> %@", entity.name, entity.sortString);
        return entity;
    }
    else return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString* )getNameWithSharp
{
    return [NSString stringWithFormat:@"#%@#", self.name];
}

@end
