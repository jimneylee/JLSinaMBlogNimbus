//
//  ViewController.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-30.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMHomeTimlineListC.h"
#import "SMStatusEntity.h"
#import "SMMaxIdTimelineTypeModel.h"
#import "SMUserInfoModel.h"
#import "SMMBlogPostC.h"

@interface SMHomeTimlineListC ()
@property (nonatomic, strong) NIActionBlock tapAction;
@end

@implementation SMHomeTimlineListC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.leftBarButtonItem = [SMGlobalConfig createPostBarButtonItemWithTarget:self
                                                                                           action:@selector(postNewStatusAction)];
        self.navigationItem.rightBarButtonItem = [SMGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                                                               action:@selector(autoPullDownRefreshActionAnimation)];
        [self showTitleWithUserName];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postNewStatusAction
{
    SMMBlogPostC* postC = [[SMMBlogPostC alloc] init];
    [self.navigationController pushViewController:postC animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 获取当前登录用户的基本信息
- (void)showTitleWithUserName
{
    if ([SMGlobalConfig getCurrentLoginedUserName].length) {
        self.title = [SMGlobalConfig getCurrentLoginedUserName];
    }
    else if ([SMGlobalConfig getCurrentLoginedUserId].length) {
        SMUserInfoModel* userInfoModel = [[SMUserInfoModel alloc] init];
        [userInfoModel loadUserInfoWithUserName:nil orUserId:[SMGlobalConfig getCurrentLoginedUserId]
                                          block:^(SMUserInfoEntity *entity, NSError *error) {
                                              if (entity) {
                                                  self.title = entity.name;
                                                  [SMGlobalConfig setCurrentLoginedUserName:entity.name];
                                              }
                                          }];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [SMMaxIdTimelineTypeModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath* indexPath) {
        if (!self.editing) {
            if ([object isKindOfClass:[SMStatusEntity class]]) {
                SMStatusEntity* status = (SMStatusEntity*)object;
                [SMGlobalConfig showHUDMessage:status.source addedToView:self.view];
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

@end
