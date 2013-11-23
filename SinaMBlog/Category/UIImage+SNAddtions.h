//
//  UIImage+nimbusImageNamed.h
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/7/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SNAddtions)

+ (UIImage*)nimbusImageNamed:(NSString*)imageName;

+ (UIImage*)compressImage:(UIImage*)image;

+ (UIImage *)imageWithColor:(UIColor *)color;

// 实时毛玻璃效果
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
