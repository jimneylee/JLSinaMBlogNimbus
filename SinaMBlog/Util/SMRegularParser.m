//
//  SMRegularParser.m
//  SinaMBlog
//
//  Created by Jiang Yu on 13-2-18.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMRegularParser.h"
#import "NSStringAdditions.h"

static NSString *atRegular = @"@[^.,:;!?\\s#@。，；！？]+";
static NSString *sharpRegular = @"#(.*?)#";
static NSString *iconRegular = @"\\[([\u4e00-\u9fa5]+)\\]";

@implementation SMRegularParser

+ (NSArray *)rangesOfAtPersonInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:atRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSMutableArray *rangesArray = [NSMutableArray array];
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSRange resultRange = [result range];
                             // range & name
//                             NSString* match = [regex replacementStringForResult:result
//                                                                        inString:string
//                                                                          offset:0
//                                                                        template:@"$0"];
                             [rangesArray addObject:[NSValue valueWithRange:resultRange]];
                         }];
    return rangesArray;
}

+ (NSArray *)rangesOfSharpTrendInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:sharpRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSMutableArray *rangesArray = [NSMutableArray array];
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSRange resultRange = [result range];
                             // range & trend
//                             NSString* match = [regex replacementStringForResult:result
//                                                                        inString:string
//                                                                          offset:0
//                                                                        template:@"$0"];
                             [rangesArray addObject:[NSValue valueWithRange:resultRange]];
                         }];
    return rangesArray;
}

+ (NSString *)rangesOfEmotionInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:iconRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSMutableString *mutableString = [string mutableCopy];
    __block NSInteger offset = 0;
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSRange resultRange = [result range];
                             resultRange.location += offset;
                             
//                             NSString* match = [regex replacementStringForResult:result
//                                                                        inString:mutableString
//                                                                          offset:offset
//                                                                        template:@"$0"];
//                             NSString *tempStr = [match substringWithRange:NSMakeRange(1, match.length-1)];
                             
                             [mutableString replaceCharactersInRange:resultRange withString:@""];
                             
                             offset -= resultRange.length;
                         }];
      
    return mutableString;
}

@end
