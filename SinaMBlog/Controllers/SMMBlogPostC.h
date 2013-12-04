//
//  SMMBlogPostC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-4.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMMBlogPostModel.h"
#import "SMEmotionC.h"
#import "SMPostButtonBar.h"
#import "SMPostPhotoBrowseC.h"
#import "SMTrendsC.h"
#import "SMFriendsC.h"
#import "SMLocationViewController.h"

@interface SMMBlogPostC : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate,
                                                    UIImagePickerControllerDelegate, UITextViewDelegate,
                                                    SMEmotionDelegate, SMTrendsDelegate,
                                                    SMFriendsDelegate, StreetPlaceLocationDelegate,
                                                    ZDPostPhotoBrowseDelegate>
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, copy) NSString* streetPlace;

// 发表关于某个话题微博
- (id)initWithTrendName:(NSString*)trend;

// 发表@某人微博
- (id)initWithUserName:(NSString*)username;

@end
