//
//  SMTrendE.h
//  SinaMBlog
//
//  Created by jimney on 13-3-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMSectionItemBaseEntity.h"

@interface SMTrendEntity : SMSectionItemBaseEntity
{

}
+ (id)entityWithDictionary:(NSDictionary*)dic;
- (NSString* )getNameWithSharp;
@end
