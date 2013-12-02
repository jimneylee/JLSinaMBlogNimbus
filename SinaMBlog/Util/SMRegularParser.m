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
+ (NSString *)replaceAtAndSharpInString:(NSString *)string {
    
    if (string.length==0) {
        return @"null";
    }
    
    [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *tempString = [SMRegularParser replaceAtInString:string];
    NSString *tempString2 = [SMRegularParser replaceSharpInString:tempString];
    NSString *modifyString = [SMRegularParser replaceIconInString:tempString2];
    
    return modifyString;
}

+ (NSString *)replaceAtAndSharpInStringForHtml:(NSString *)string {
    if (!string.length) {
        return @"null";
    }
    
    [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *tempString = [SMRegularParser replaceAtInString:string];
    NSString *tempString2 = [SMRegularParser replaceSharpInString:tempString];
    NSString *modifyString = [SMRegularParser replaceIconInStringForHtml:tempString2];
    
    return modifyString;
}

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
                             [rangesArray addObject:[NSValue valueWithRange:resultRange]];
                         }];
    return rangesArray;
}

+ (NSString *)replaceAtInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:atRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    //实现自定义的替换方法
    __block NSMutableString *mutableString = [string mutableCopy];
    __block NSInteger offset = 0;
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSRange resultRange = [result range];
                             resultRange.location += offset;
                             
                             NSString* match = [regex replacementStringForResult:result
                                                                        inString:mutableString
                                                                          offset:offset
                                                                        template:@"$0"];
                             
                             NSString *tempStr = [match substringWithRange:NSMakeRange(1, match.length-1)];
                             NSString *sUrl = [NSString stringWithFormat:@"at://%@", [tempStr urlEncoded]];
                             NSString *replacement = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", sUrl, match];
                             [mutableString replaceCharactersInRange:resultRange withString:replacement];
                             
                             offset += ([replacement length] - resultRange.length);
                         }];
      
    return mutableString;
}

+ (NSString *)replaceSharpInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:sharpRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    //实现自定义的替换方法
    __block NSMutableString *mutableString = [string mutableCopy];
    __block NSInteger offset = 0;
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result,
                                      NSMatchingFlags flags,
                                      BOOL *stop) {
                             NSRange resultRange = [result range];
                             resultRange.location += offset;
                             
                             NSString* match = [regex replacementStringForResult:result
                                                                        inString:mutableString
                                                                          offset:offset
                                                                        template:@"$0"];
                             
                             NSString *tempStr = [match substringWithRange:NSMakeRange(1, match.length-2)];
                             NSString *sUrl = [NSString stringWithFormat:@"sharp://%@", tempStr];
                             sUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                        (CFStringRef)sUrl,
                                                                                        nil,
                                                                                        nil,
                                                                                        kCFStringEncodingUTF8));
                             NSString *replacement = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", sUrl, match];
                             [mutableString replaceCharactersInRange:resultRange withString:replacement];
                             
                             offset += ([replacement length] - resultRange.length);
                         }];
    return mutableString;
}

+ (NSString *)replaceIconInString:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:iconRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    
    //实现自定义的替换方法
    __block NSMutableString *mutableString = [string mutableCopy];
    __block NSInteger offset = 0;
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result,
                                      NSMatchingFlags flags,
                                      BOOL *stop) {
                             NSRange resultRange = [result range];
                             resultRange.location += offset;
                             
                             NSString* match = [regex replacementStringForResult:result
                                                                        inString:mutableString
                                                                          offset:offset
                                                                        template:@"$0"];
                             
                             NSString *imgPath = [SMGlobalConfig pathForEmotionCode:match];
                             //if (TTIMAGE(imgPath))
                             {
                                 NSString *replacement = [NSString stringWithFormat:@"<img src=\"%@\"/>", imgPath];
                                 [mutableString replaceCharactersInRange:resultRange withString:replacement];
                                 offset += ([replacement length] - resultRange.length);
                             }
                             
                         }];
    return mutableString;
}

+ (NSString *)replaceIconInStringForHtml:(NSString *)string {
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:iconRegular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    
    //实现自定义的替换方法
    __block NSMutableString *mutableString = [string mutableCopy];
    __block NSInteger offset = 0;
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result,
                                      NSMatchingFlags flags,
                                      BOOL *stop) {
                             NSRange resultRange = [result range];
                             resultRange.location += offset;
                             
                             NSString* match = [regex replacementStringForResult:result
                                                                        inString:mutableString
                                                                          offset:offset
                                                                        template:@"$0"];
                             
                             
                             NSString *imgPath = [SMGlobalConfig pathForEmotionCodeForHtml:match];
                             NSString *tempImgPath = [NSString stringWithFormat:@"bundle://%@", imgPath];
                             //if (TTIMAGE(tempImgPath))
                             {
                                 NSString *replacement = [NSString stringWithFormat:@"<img src=\"%@\"/>", imgPath];
                                 [mutableString replaceCharactersInRange:resultRange withString:replacement];
                                 offset += ([replacement length] - resultRange.length);
                             }
                             
                         }];
    return mutableString;
}

@end
