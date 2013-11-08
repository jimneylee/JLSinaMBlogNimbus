//
//  LJJBaseTableC.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-29.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "LJJBaseTableC.h"
#import "SNLoadMoreFooterView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface LJJBaseTableC ()
@property (nonatomic, strong) SNLoadMoreFooterView* loadMoreFooterView;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LJJBaseTableC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cellFactory = [[NICellFactory alloc] init];
        _model = [[[self tableModelClass] alloc] initWithDelegate:_cellFactory];
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        [self.actions attachToClass:[self.model objectClass] tapBlock:self.tapAction];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView
{
    [super loadView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];
    
    [self.refreshControl beginRefreshing];
    [self refreshData];
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
    self.tableView.contentOffset = CGPointMake(0.f, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    [self refreshData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createLoadMoreFooterView
{
    SNLoadMoreFooterView* loadMoreFooterView = [[SNLoadMoreFooterView alloc] init];
    [loadMoreFooterView addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = loadMoreFooterView;
    self.loadMoreFooterView = loadMoreFooterView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadMoreAction
{
    [self loadMore];
    [self.loadMoreFooterView setAnimating:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath *indexPath) {
        return YES;
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableModelClass
{
    return [LJJBaseTableModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoadData
{
    if (!self.loadMoreFooterView && self.model.hasMoreEntity) {
        [self createLoadMoreFooterView];
    }
    else {
        self.tableView.tableFooterView = nil;
        self.loadMoreFooterView = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadData
{
    
}

#pragma mark - Load Data
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)refreshData
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中…"];
        
        [self.model loadDataWithBlock:^(NSArray* indexPaths, NSError* error) {
            if (indexPaths) {
                if (indexPaths.count) {
                    [self.tableView reloadData];
                    self.refreshControl.attributedTitle = [[NSAttributedString alloc]
                                                           initWithString:@"下拉刷新"];
                    [self didFinishLoadData];
                }
                else {
                    [SMGlobalConfig showHUDMessage:@"信息为空！" addedToView:self.view];
                }
            }
            else {
                [self didFailLoadData];

                NSString* alertMsg = nil;
                alertMsg = error ? @"抱歉，无法获取信息，请稍后再试！" : @"信息为空！";
                [SMGlobalConfig showHUDMessage:alertMsg addedToView:self.view];
            }
            [self.refreshControl endRefreshing];
            [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                self.tableView.contentOffset = CGPointMake(0.f, 0.f);
            } completion:NULL];
        } more:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadMore
{
    [self.model loadDataWithBlock:^(NSArray* indexPaths, NSError* error) {
        if (indexPaths.count) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self didFinishLoadData];
        }
        else {
            [self didFailLoadData];
            
            NSString* alertMsg = nil;
            alertMsg = error ? @"抱歉，无法获取信息，请稍后再试！" : @"已是最后一页";
            [SMGlobalConfig showHUDMessage:alertMsg addedToView:self.view];
        }
        [self.loadMoreFooterView setAnimating:NO];
    } more:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.model];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.loadMoreFooterView) {
        // TODO:做一个BaseTableView，基础操作放入底层实现，但是可能引入项目工程的复杂性，权衡代价
        CGFloat kDragUpBottomOffset = 30.f;
        CGFloat endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (scrollView.contentSize.height > scrollView.height
            && endScrolling >= scrollView.contentSize.height + kDragUpBottomOffset) {
            [self loadMoreAction];
        }
    }
}

@end
