//
//  SNLoadMoreFooterView.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-21.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJJLoadMoreFooterView : UIButton

@property (nonatomic, strong) UILabel*  textLabel;
@property (nonatomic, strong) UIActivityIndicatorView*  activityIndicatorView;
@property (nonatomic)         BOOL                      animating;

@end
