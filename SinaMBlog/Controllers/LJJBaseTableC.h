//
//  LJJBaseTableC.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-29.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJJBaseTableModel.h"

@interface LJJBaseTableC : UITableViewController

@property (nonatomic, strong) NIActionBlock tapAction;
@property (nonatomic, strong) LJJBaseTableModel* model;
@property (nonatomic, strong) NITableViewActions* actions;
@property (nonatomic, strong) NICellFactory* cellFactory;

- (void)refreshData;
- (void)loadMore;
- (void)didFinishLoadData;
- (void)didFailLoadData;

@end
