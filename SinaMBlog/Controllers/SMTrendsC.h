//
//  SMTrendsC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "LJJBaseTableC.h"

@protocol SMTrendsDelegate;
@interface SMTrendsC : LJJBaseTableC

@property(nonatomic, assign) id<SMTrendsDelegate> trendsDelegate;

@end

@protocol SMTrendsDelegate <NSObject>

- (void)didSelectATrend:(NSString*)trend;

@end