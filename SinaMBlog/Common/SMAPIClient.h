//
//  SNAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface SMAPIClient : AFHTTPClient

+ (SMAPIClient*)sharedClient;
- (NSString*)relativePathForPublicTimelineWithPageCounter:(NSInteger)pageCounter
                                             perpageCount:(NSInteger)perpageCount;

@end

NSString *const kSNAPIBaseURLString;