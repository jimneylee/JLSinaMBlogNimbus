//
//  SNUserCenterC.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMLoginC.h"
#import "NimbusModels.h"
#import "NimbusCore.h"

#import "SMPageTimlineListC.h"
#import "SMHomeTimlineListC.h"
#import "SMAuthorizeModel.h"

NSString *const SNDidOAuthNotification = @"DidOAuthNotification";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface SMLoginC ()

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) NICellFactory* cellFactory;
@property (nonatomic, strong) __block MBProgressHUD* hud;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SMLoginC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"新浪微博";

        _actions = [[NITableViewActions alloc] initWithTarget:self];
        NIActionBlock tapLoginAction =
        ^BOOL(id object, UIViewController *controller, NSIndexPath* indexPath) {
            if ([SMAuthorizeModel isAuthorized]) {
                [self showHomeView];
            }
            else {
                if (!self.hud) {// 已登录ing，不执行登录操作
                    [SMAuthorizeModel sendAuthorizeRequest];
                    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    self.hud.labelText = @"正在登录...";
                    return YES;
                }
            }
            
            return NO;
        };
        
        NIActionBlock tapPublicAction = ^BOOL(id object, UIViewController *controller, NSIndexPath* indexPath) {
            SMPageTimlineListC* c = [[SMPageTimlineListC alloc] init];
            [controller.navigationController pushViewController:c animated:YES];
            return YES;
        };
        NSArray* tableContents =
        [NSArray arrayWithObjects:
         @"",
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"登录微博"]
                         tapBlock:tapLoginAction],
         @"",
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"随便看看"]
                         tapBlock:tapPublicAction],
         nil];
        
        _cellFactory = [[NICellFactory alloc] init];
        [_cellFactory mapObjectClass:[NITitleCellObject class]
                         toCellClass:[NITextCell class]];
        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                         delegate:_cellFactory];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didOAuthNotification:)
                                                     name:SNDidOAuthNotification object:nil];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];

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
- (void)showHomeView
{
    SMHomeTimlineListC* c = [[SMHomeTimlineListC alloc] init];
    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SNDidOAuthNotification

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didOAuthNotification:(NSNotification*)notify
{
    id object = notify.object;
    if ([object isKindOfClass:[NSNumber class]]) {
        BOOL authoredSuccess = [(NSNumber*)object boolValue];
        if (authoredSuccess) {
            [self showHomeView];
        }
        else {
            self.hud.labelText = @"登录失败";
            [self.hud hide:YES afterDelay:1.0f];
            self.hud = nil;
        }
    }
}

@end
