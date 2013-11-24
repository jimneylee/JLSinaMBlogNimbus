//
//  SMTrendsEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMTrendsEntity.h"
#import "SMTrendEntity.h"
#import "pinyin.h"

@implementation SMTrendsEntity
@synthesize time = _time;

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)createWithDictionary:(NSDictionary*)dic
{
    SMTrendsEntity* entity = [SMTrendsEntity new];
    NSDictionary* sourceDic = [dic objectForKey:@"trends"];
    NSArray* keys = [sourceDic allKeys];
    if (keys.count > 0) {
        NSString* key = [keys objectAtIndex:0];
        entity.time = key;
        NSArray* sourceArray = [sourceDic objectForKey:key];
// unit test
//      sourceArray = [NSArray arrayWithObjects:
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"Ljin李进", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"jin进", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"3jimney", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"晋jimn", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"JIN进", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"Lljin李进", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"10李jin进", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"ljin李进", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"李进", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"-李进", @"name", nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"jimneylee", @"name", nil]
//                       nil];
        
        entity.unsortedArray = [NSMutableArray arrayWithCapacity:sourceArray.count];
        for (NSDictionary* d in sourceArray) {
            SMTrendEntity* aTrend = [SMTrendEntity createWithDictionary:d];
            if (aTrend) {
                [entity.unsortedArray addObject:aTrend];
            }
        }
        
        [entity sort];
    }
    return entity;
}


@end
