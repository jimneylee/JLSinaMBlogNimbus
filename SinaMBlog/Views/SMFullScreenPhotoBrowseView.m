//
//  SMFullScreenPhotoBrowseC.m
//  SinaMBlogNimbus
//
//  Created by ccjoy-jimneylee on 14-1-6.
//  Copyright (c) 2014年 SuperMaxDev. All rights reserved.
//

#import "SMFullScreenPhotoBrowseView.h"

@interface SMFullScreenPhotoBrowseView ()<UIScrollViewDelegate>
@property (nonatomic, assign) CGRect fromRect;
@end

@implementation SMFullScreenPhotoBrowseView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUrlPath:(NSString *)urlPath thumbnail:(UIImage*)thumbnail fromRect:(CGRect)rect
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        self.fromRect = rect;
        self.thumbnail = thumbnail;
        self.urlPath = urlPath;

        [self initUI];

        if (self.thumbnail) {
            self.imageView.initialImage = self.thumbnail;
        }
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(removeFromSuperviewAnimation)];
        [self addGestureRecognizer:tapGesture];
        
        [self showImageViewAnimation];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initUI
{
    self.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.zoomScale = 1.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0f;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    
    _imageView = [[NINetworkImageView alloc] initWithFrame:_scrollView.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_imageView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)calculateScaledFinalFrame
{
    // calcaulate size
    CGSize thumbSize = self.thumbnail.size;
    CGFloat finalHeight = self.width * (thumbSize.height / thumbSize.width);
    CGFloat top = 0.f;
    if (finalHeight < self.height) {
        top = (self.height - finalHeight) / 2.f;
    }
    return CGRectMake(0.f, top, self.width, finalHeight);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showImageViewAnimation
{
    self.imageView.frame = self.fromRect;
    if (self.thumbnail) {
        
        self.alpha = 0.f;
        
        // calculate scaled frame
        CGRect finalFrame = [self calculateScaledFinalFrame];
        if (finalFrame.size.height > self.height) {
            self.scrollView.contentSize = CGSizeMake(self.width, finalFrame.size.height);
        }
        // animation frame
        [UIView animateWithDuration:1.f animations:^{
            self.imageView.frame = finalFrame;
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
            if (self.urlPath) {
                [self.imageView setPathToNetworkImage:self.urlPath contentMode:UIViewContentModeScaleAspectFit];
            }
        }];
    }
    else {
        self.imageView.frame = self.bounds;
        if (self.urlPath) {
            [self.imageView setPathToNetworkImage:self.urlPath contentMode:UIViewContentModeScaleAspectFit];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeFromSuperviewAnimation
{
    // consider scroll offset
    CGRect newFromRect = self.fromRect;
    newFromRect.origin = CGPointMake(self.fromRect.origin.x,
                                     self.fromRect.origin.y + self.scrollView.contentOffset.y);
    [UIView animateWithDuration:1.f animations:^{
        self.imageView.frame = newFromRect;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
