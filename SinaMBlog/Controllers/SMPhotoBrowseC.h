//
//  SMPhotoBrowseC.h
//  DSL
//
//  Created by jimney Lee on 10/11/12.
//  Copyright (c) 2012 jimneylee. All rights reserved.
//


@interface SMPhotoBrowseC : UIViewController<UIScrollViewDelegate>

- (id)initWithUrlPath:(NSString*)urlPath;
- (id)initWithImage:(UIImage*)image;

@property (nonatomic, copy) NSString* urlPath;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NINetworkImageView* imageView;

@end
