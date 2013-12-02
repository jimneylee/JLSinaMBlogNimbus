//
//  SMRegularParser.h
//  SinaMBlog
//
//  Created by Jiang Yu on 13-2-18.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMRegularParser : NSObject

// 返回所有at某人的range数组
+ (NSArray *)rangesOfAtPersonInString:(NSString *)string;
// 返回所有#话题的range数组
+ (NSArray *)rangesOfSharpTrendInString:(NSString *)string;

+ (NSString *)replaceAtAndSharpInString:(NSString *) string;
+ (NSString *)replaceAtAndSharpInStringForHtml:(NSString *) string;
+ (NSString *)replaceAtInString:(NSString *) string;
+ (NSString *)replaceSharpInString:(NSString *)string;
@end
