//
//  SMEmotionEntity.h
//  SinaMBlog
//
//  Created by jimney on 13-3-5.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMEmotionEntity : NSObject
{
	NSString* _code;
	NSString* _urlPath;
}

+ (id)createWithDictionary:(NSDictionary*)dic;
+ (id)createWithDictionaryForHtml:(NSDictionary *)dic;
@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* urlPath;
@end

