//
//  SMBaseEntity.h
//  SinaMBlog
//
//  Created by Jiang Yu on 13-1-31.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMBaseEntity : NISubtitleCellObject

- (id)initWithDictionary:(NSDictionary*)dic;
+ (id)entityWithDictionary:(NSDictionary*)dic;

@end
