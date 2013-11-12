//
//  SNLoadMoreFooterView.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-10-21.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "LJJLoadMoreFooterView.h"

#define PLAIN_MORE_BUTTON_HEIGHT 55

@interface LJJLoadMoreFooterView()
@end
@implementation LJJLoadMoreFooterView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, PLAIN_MORE_BUTTON_HEIGHT)];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
	[super layoutSubviews];
    self.textLabel.frame = self.bounds;
    self.activityIndicatorView.center = CGPointMake(self.width - self.activityIndicatorView.width - CELL_PADDING_8 * 2,
                                                self.textLabel.center.y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIActivityIndicatorView*)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleGray];

        [self addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"更多显示";
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setAnimating:(BOOL)animating {
    if (_animating != animating) {
        _animating = animating;
        
        if (_animating) {
            [self.activityIndicatorView startAnimating];
        }
        else {
            [self.activityIndicatorView stopAnimating];
        }
        [self changeLoadStatus];
        [self setNeedsLayout];
    }
}

// 改变加载状态[更多...|加载中...]
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)changeLoadStatus
{
    self.textLabel.text = _animating ? @"加载中..." : @"上拉显示更多";
}

@end
