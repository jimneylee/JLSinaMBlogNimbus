//
//  SMEmotionEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-5.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMEmotionEntity.h"

@implementation SMEmotionEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)createWithDictionary:(NSDictionary*)dic
{
	SMEmotionEntity* entity = [SMEmotionEntity new];
	entity.code = [NSString stringWithFormat:@"[%@]", [dic objectForKey:@"chs"]];
	NSString* name = [dic objectForKey:@"gif"];
    entity.urlPath = [NSString stringWithFormat:@"bundle://%@", name];
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)createWithDictionaryForHtml:(NSDictionary *)dic {
    SMEmotionEntity* entity = [SMEmotionEntity new];
	entity.code = [NSString stringWithFormat:@"[%@]", [dic objectForKey:@"chs"]];
	NSString* name = [dic objectForKey:@"gif"];
    entity.urlPath = name;
	return entity;
}

@end
