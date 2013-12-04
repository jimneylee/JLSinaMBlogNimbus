//
//  SMTrendsEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMTrendListEntity.h"
#import "SMTrendEntity.h"
#import "pinyin.h"

@implementation SMTrendListEntity
//{
//    "as_of" = 1385257540;
//    trends =     {
//        "2013-11-24 09:45" =         (
//                                      {
//                                          amount = 30213;
//                                          delta = 30213;
//                                          name = "\U90ed\U4e66\U7476";
//                                          query = "\U90ed\U4e66\U7476";
//                                      },
//                                      {
//                                          amount = 27045;
//                                          delta = 27045;
//                                          name = "\U91d1\U9a6c\U5956";
//                                          query = "\U91d1\U9a6c\U5956";
//                                      })
//    }
//}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    SMTrendListEntity* entity = [SMTrendListEntity new];
    NSDictionary* sourceDic = [dic objectForKey:JSON_TREND_LIST];
    NSArray* keys = [sourceDic allKeys];
    if (keys.count > 0) {
        NSString* key = [keys objectAtIndex:0];
        entity.time = key;
        NSArray* sourceArray = [sourceDic objectForKey:key];
        entity.unsortedArray = [NSMutableArray arrayWithCapacity:sourceArray.count];
        for (NSDictionary* d in sourceArray) {
            SMTrendEntity* aTrend = [SMTrendEntity entityWithDictionary:d];
            if (aTrend) {
                [entity.unsortedArray addObject:aTrend];
            }
        }
        
        [entity sort];
    }
    return entity;
}


@end
