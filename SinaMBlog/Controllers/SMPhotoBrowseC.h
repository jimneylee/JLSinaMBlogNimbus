//
//  SMPhotoBrowseC.h
//  DSL
//
//  Created by jimney Lee on 10/11/12.
//  Copyright (c) 2012 jimneylee. All rights reserved.
//


@interface SMPhotoBrowseC : UIViewController<UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    NINetworkImageView* _imageView;
    
    NSString* _urlPath;
    UIImage* _image;
}

- (id)initWithUrlPath:(NSString*)urlPath;
- (id)initWithImage:(UIImage*)image;

@property (nonatomic, copy) NSString* urlPath;
@property (nonatomic, retain) UIImage* image;
@end
