//
//  SMTrendsEntity.h
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMSectionListBaseEntity.h"

@interface SMTrendListEntity : SMSectionListBaseEntity

@property (nonatomic, copy) NSString* time;
+ (id)entityWithDictionary:(NSDictionary*)dic;

@end
