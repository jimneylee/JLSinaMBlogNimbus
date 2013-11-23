//
//  SMTrendsEntity.h
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMSectionListBaseEntity.h"

@interface SMTrendsEntity : SMSectionListBaseEntity
{
    NSString* _time;
}

@property (nonatomic, copy) NSString* time;
@end
