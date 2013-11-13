//
//  ViewController.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-30.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMHomeTimlineListC.h"
#import "SMStatusEntity.h"
#import "SMMaxIdTimelineModel.h"
#import "SMUserInfoModel.h"

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
        self.navigationItem.leftBarButtonItem = [SMGlobalConfig createPostBarButtonItemWithTarget:self action:@selector(postNewStatusAction)];
        self.navigationItem.rightBarButtonItem = [SMGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                                                               action:@selector(autoPullDownRefreshAction)];
        // 获取当前登录用户的基本信息
        if ([SMGlobalConfig getCurrentLoginedUserName].length) {
            self.title = [SMGlobalConfig getCurrentLoginedUserName];
        }
        else {
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
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

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
- (void)autoPullDownRefreshAction
{   
    [super autoPullDownRefreshAction];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postNewStatusAction
{
    [SMGlobalConfig showHUDMessage:@"com later on!" addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [SMMaxIdTimelineModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath *indexPath) {
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
