//
//  SMSectionListBaseEntity.h
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSectionListBaseEntity : NSObject
{
    NSMutableArray* _unsortedArray;
    NSMutableArray* _sections;
    NSMutableArray* _items;
}

- (void)sort;

@property (nonatomic, retain) NSMutableArray* unsortedArray;
@property (nonatomic, retain) NSMutableArray* sections;
@property (nonatomic, retain) NSMutableArray* items;
@end
