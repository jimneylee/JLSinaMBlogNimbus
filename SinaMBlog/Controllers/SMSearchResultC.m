//
//  SMSearchResultC.m
//  SinaMBlog
//
//  Created by jimney on 13-2-28.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMSearchResultC.h"
#import "SMSearchResultModel.h"
#import "SMStatusEntity.h"

@interface SMSearchResultC ()
{
    SearchType _searchType;
    NSString* _keywords;
}
@end

@implementation SMSearchResultC
- (id)initWithSearchType:(SearchType)type keywords:(NSString*)keywords
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.navigationItem.titleView =
        [SMGlobalConfig getNavigationBarTitleViewWithTitle:[self getTitleWithSearchType:type]];
        _searchType = type;
        _keywords = [keywords copy];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        self.hidesBottomBarWhenPushed = YES;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)getTitleWithSearchType:(SearchType)type
{
    NSString* title = nil;
    switch (type) {
        case SearchType_Statuses:
            title = @"微博搜索";
            break;
        case SearchType_Users:
            title = @"用户搜索";
            break;
        case SearchType_Topics:
            title = @"话题搜索";
            break;
        default:
            break;
    }
    
    return title;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [SMSearchResultModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath *indexPath) {
        if (!self.editing) {
            if ([object isKindOfClass:[SMStatusEntity class]]) {
                SMStatusEntity* e = (SMStatusEntity*)object;
                [SMGlobalConfig showHUDMessage:e.user.name addedToView:self.view];
            }
            else if ([object isKindOfClass:[SMUserInfoEntity class]]) {
                SMUserInfoEntity* user = (SMUserInfoEntity*)object;
                if (user.userID.length) {
                    [SMGlobalConfig showHUDMessage:user.name addedToView:self.view];
                }
                else {
                    [SMGlobalConfig showHUDMessage:@"抱歉，用户不存在!" addedToView:self.view];
                }
            }

            return YES;
        }
        else {
            return NO;
        }
    };
}

@end
