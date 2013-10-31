//
//  NSString+StringValue.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-14.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "NSString+StringValue.h"

@implementation NSString (StringValue)

+ (NSString*)getStringValue:(id)value
{
	if (value) {
		if ([value isKindOfClass:[NSString class]]) {
			return value;
		}
		else if ([value isKindOfClass:[NSNumber class]]) {
			return [value stringValue];
		}
		else {
			return @"";
		}
        
	}
	else {
		return @"";
	}
}

@end
