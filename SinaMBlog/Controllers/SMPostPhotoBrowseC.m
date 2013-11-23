//
//  SMPostPhotoBrowseC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-7.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMPostPhotoBrowseC.h"

@interface SMPostPhotoBrowseC ()

@end

@implementation SMPostPhotoBrowseC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        self.navigationItem.rightBarButtonItem = [SMGlobalConfig createBarButtonItemWithTitle:@"删除照片"
                                                                                       target:self
                                                                                       action:@selector(deletePhoto)];
    }
    
    return self;
}

- (void)deletePhoto
{
    if ([self.deletePhotoDelegate respondsToSelector:@selector(deletePhoto)]) {
        [self.deletePhotoDelegate deletePhoto];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
