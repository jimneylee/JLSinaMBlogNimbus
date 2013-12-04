//
//  SMSearchResultC.h
//  SinaMBlog
//
//  Created by jimney on 13-2-28.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "LJJBaseTableC.h"

@interface SMSearchResultC : LJJBaseTableC
- (id)initWithSearchType:(SearchType)type keywords:(NSString*)keywords;
@end
