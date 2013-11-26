//
//  SMUserModel.h
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 11/26/13.
//  Copyright (c) 2013 SuperMaxDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAuthorizeModel : NSObject

+ (void)sendAuthorizeRequest;
+ (BOOL)isAuthorized;

@end
