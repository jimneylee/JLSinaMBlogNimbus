//
//  SMPostPhotoBrowseC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-7.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMPhotoBrowseC.h"

@protocol ZDPostPhotoBrowseDelegate;
@interface SMPostPhotoBrowseC : SMPhotoBrowseC

@property (nonatomic, assign) id<ZDPostPhotoBrowseDelegate> deletePhotoDelegate;

@end

@protocol ZDPostPhotoBrowseDelegate <NSObject>
@optional
- (void)deletePhoto;
@end