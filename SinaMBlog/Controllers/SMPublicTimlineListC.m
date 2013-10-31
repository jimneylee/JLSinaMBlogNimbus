//
//  ViewController.m
//  VideoOnline
//
//  Created by ccjoy-jimneylee on 13-10-30.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMPublicTimlineListC.h"
#import "SMStatusEntity.h"
#import "SMPublicTimelineModel.h"

@interface SMPublicTimlineListC ()
@property (nonatomic, strong) NIActionBlock tapAction;
@end

@implementation SMPublicTimlineListC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = APP_NAME;
        self.navigationItem.rightBarButtonItem = [SMGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                                                               action:@selector(refreshAction)];
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
- (void)refreshAction
{
//    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
//        self.tableView.contentOffset = CGPointMake(0.f, -self.refreshControl.frame.size.height);
//    } completion:NULL];
    
    self.tableView.contentOffset = CGPointMake(0.f, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    [self refreshData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [SMPublicTimelineModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath *indexPath) {
        if (!self.editing) {
            if ([object isKindOfClass:[SMStatusEntity class]]) {
                SMStatusEntity* status = (SMStatusEntity*)object;
                NSLog(@"show mblog title:%@", status.text);
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

@end
