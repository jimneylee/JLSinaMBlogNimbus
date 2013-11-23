//
//  SMTrendE.m
//  SinaMBlog
//
//  Created by jimney on 13-3-11.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMTrendEntity.h"
#import "pinyin.h"

@implementation SMTrendEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)createWithDictionary:(NSDictionary*)dic
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
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString* )getNameWithSharp
{
    return [NSString stringWithFormat:@"#%@#", self.name];
}
@end
