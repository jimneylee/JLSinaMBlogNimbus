//
//  SMMBlogPostC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-4.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMMBlogPostModel.h"
#import "SMEmotionC.h"
#import "SMPostButtonBar.h"
#import "SMPostPhotoBrowseC.h"
#import "SMTrendsC.h"
#import "SMFriendsC.h"
#import "LocationViewController.h"

@interface SMMBlogPostC : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate,
                                                    UIImagePickerControllerDelegate, UITextViewDelegate,
                                                    SMEmotionDelegate, SMTrendsDelegate,
                                                    SMFriendsDelegate, StreetPlaceLocationDelegate,
                                                    ZDPostPhotoBrowseDelegate>
{
    UITextView* _statusesTextView;
    UIButton* _locationBtn;
    UIButton* _textCountBtn;
    UIButton* _clearTextBtn;
    UIImageView* _inputBackgroundImageView;
    SMPostButtonBar* _postBtnBar;
	SMEmotionC* _emotionC;
    SMTrendsC* _trendsC;
    SMFriendsC* _friendsC;
    UIImagePickerController* _picker;
    
    UIImage* _image;
    SMMBlogPostModel* _postModel;
    double _latitude;
    double _longitude;
    NSString* _trendNameOrUserName;
    NSMutableArray* _streetPlacesArray;
    NSString* _streetPlace;
}

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, copy) NSString* streetPlace;

- (id)initWithTrendNameOrUserName:(NSString*)text type:(MBlogPostType)type;

@end
