//
//  SMPhotoBrowseC.m
//  DSL
//
//  Created by jimney Lee on 10/11/12.
//  Copyright (c) 2012 jimneylee. All rights reserved.
//

#import "SMPhotoBrowseC.h"

@interface SMPhotoBrowseC ()

@end

@implementation SMPhotoBrowseC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUrlPath:(NSString*)urlPath
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.urlPath = urlPath;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithImage:(UIImage*)image
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.image = image;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                                 style:UIBarButtonItemStylePlain 
                                                                                target:self action:@selector(save)];
        
        
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];

    CGRect frame = CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height
                                    - NIStatusBarHeight() - NIToolbarHeightForOrientation(self.interfaceOrientation));
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.delegate = self;
    _scrollView.zoomScale = 1.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0f;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    _imageView = [[NINetworkImageView alloc] initWithFrame:_scrollView.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_imageView];
    
    if (self.urlPath) {
        [_imageView setPathToNetworkImage:self.urlPath];
    }
    else if (self.image) {
        _imageView.initialImage = self.image;
    }    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)save
{
	if (_imageView.image) {
		UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);
        // TODO: show asyn
        [SMGlobalConfig showHUDMessage:@"保存成功！" addedToView:self.view];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIScrolViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
