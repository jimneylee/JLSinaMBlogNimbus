//
//  SMPostButtonBar.m
//  SinaMBlog
//
//  Created by jimney on 13-3-5.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMPostButtonBar.h"

@implementation SMPostButtonBar

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)layoutSubviews
{
    CGFloat kWidth = 26.f;
    CGFloat kTopSpace = (self.height - kWidth) * .5f;
    CGFloat kSpace = (self.width - ( kWidth * _buttons.count)) / (_buttons.count + 1);
    
    // 限制间隔距离，最大33.3，按照一排5个布局标准
    // 33.3 = (320 - 24 * 5）/ (5+1)
    CGFloat kNormalMaxCount = 5;
    CGFloat kMaxSpace = (self.width - kWidth * kNormalMaxCount) / (kNormalMaxCount + 1);
    if (kSpace > kMaxSpace) {
        kSpace = kMaxSpace;
    }
    CGFloat left = kSpace;
	for (UIButton* button in _buttons) {
		button.frame = CGRectMake(left, kTopSpace, kWidth, kWidth);
		left = button.right + kSpace;
	}
}
@end
