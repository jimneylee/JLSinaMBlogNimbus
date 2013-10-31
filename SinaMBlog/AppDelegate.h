//
//  AppDelegate.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-30.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPublicTimlineListC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;

@property (strong, nonatomic) SMPublicTimlineListC* viewController;

@end
