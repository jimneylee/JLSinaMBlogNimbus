//
//  SMTrendE.h
//  SinaMBlog
//
//  Created by jimney on 13-3-11.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMSectionItemBaseEntity.h"

@interface SMTrendEntity : SMSectionItemBaseEntity
{

}
+ (id)createWithDictionary:(NSDictionary*)dic;
- (NSString* )getNameWithSharp;
@end
