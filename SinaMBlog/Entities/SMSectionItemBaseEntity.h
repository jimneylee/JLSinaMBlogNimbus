//
//  SMSectionItemEntity.h
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

@interface SMSectionItemBaseEntity : NISubtitleCellObject
{
    NSString* _name;
    unichar _firstLetter;  // 首字母
    NSString* _sortString;  // 供排序所用字串
}

- (NSString* )createSortString;

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* sortString;
@property (nonatomic) unichar firstLetter;
@end
