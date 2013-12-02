//
//  SMMBlogPostC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-4.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMMBlogPostC.h"
#import "UIImage+Resizing.h"
#import "UIImage+FixOrientation.h"
#import "NetworkSpy.h"
#import "SMFriendEntity.h"

@interface SMMBlogPostC ()

@end

#define TEXT_COUNT_BTN_WIDTH 45
#define LOCATION_BTN_HEIGHT 23
#define LOCATION_PLACEHOLDER_TEXT_COUNT 10
#define CLEAR_BTN_WIDTH 20

#define BAR_BTN_MAX_COUNT 6
#define INPUT_TEXT_MAX_COUNT 140

#define CLEAR_TEXT_ACTION_SHEET_TAG 1000
#define PHOTO_PICK_ACTION_SHEET_TAG 1001
#define SAVE_TO_DRAFT_ACTION_SHEET_TAG 1002

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SMMBlogPostC

///////////////////////////////////////////////////////////////////////////////////////////////////
// 发表关于某个话题微博入口
// 发表@某人微博入口
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTrendNameOrUserName:(NSString*)text type:(MBlogPostType)type
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        if (text.length > 0) {
            if (MBlogPostType_AtUser == type) {
                _trendNameOrUserName = [[NSString stringWithFormat:@"@%@ ", text] copy];
            }
            else if (MBlogPostType_AboutTrend == type) {
                _trendNameOrUserName = [[NSString stringWithFormat:@"#%@# ", text] copy];
            }
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发表新微博";
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.leftBarButtonItem = [SMGlobalConfig createBarButtonItemWithTitle:@"取消"
                                                                                      target:self
                                                                                     action:@selector(dismissSelf)];
        self.navigationItem.rightBarButtonItem = [SMGlobalConfig createBarButtonItemWithTitle:@"发送"
                                                                                       target:self
                                                                                       action:@selector(send)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        _latitude = CGFLOAT_MAX;
        _longitude = CGFLOAT_MAX;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 文本输入框
    _statusesTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _statusesTextView.font = [UIFont systemFontOfSize:18.f];
    _statusesTextView.delegate = self;
    [self.view addSubview:_statusesTextView];

    // 地理位置
    _locationBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_locationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIImage* image = [UIImage nimbusImageNamed:@"compose_placebutton_background.png"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    _locationBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_locationBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_locationBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [_locationBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail]; //abc...
    [_locationBtn addTarget:self action:@selector(showLocationView)
        forControlEvents:UIControlEventTouchUpInside];
    _locationBtn.hidden = YES;
    [self.view addSubview:_locationBtn];
    
    // 文本计数按钮
    _textCountBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_textCountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_textCountBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_textCountBtn addTarget:self action:@selector(showClearTextActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textCountBtn];
    
    // 清空文本按钮
    _clearTextBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_clearTextBtn setImage:[UIImage nimbusImageNamed:@"clearbutton_background.png"]
                   forState:UIControlStateNormal];
    [_clearTextBtn addTarget:self
                      action:@selector(showClearTextActionSheet)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearTextBtn];
    
    // 内容选择工具条
    [self createPostButtonBar];
    
    // 键盘表情选择框底图messages_inputview_background.png
    _inputBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _inputBackgroundImageView.image = [UIImage nimbusImageNamed:@"emoticon_keyboard_background.png"];
    [self.view addSubview:_inputBackgroundImageView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self presetStatusesText];
    [self limitPostStatusesText];
    [self registerForKeyboardNotifications];
    [_statusesTextView becomeFirstResponder];
    [self layoutViewsWithKeyboardHeight:NIIsSupportedOrientation(self.interfaceOrientation)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutViewsWithKeyboardHeight:(CGFloat)keboardHeight
{
    // 布局由下到上，从右到左反计算
    _inputBackgroundImageView.frame = CGRectMake(0, self.view.height - keboardHeight,
                                                 self.view.width, keboardHeight);
    _postBtnBar.frame = CGRectMake(0, _inputBackgroundImageView.top - NIToolbarHeightForOrientation(self.interfaceOrientation),
                                   self.view.width, NIToolbarHeightForOrientation(self.interfaceOrientation));
    _clearTextBtn.frame = CGRectMake(self.view.width - CELL_PADDING_4 - CLEAR_BTN_WIDTH,
                                     _postBtnBar.top - LOCATION_BTN_HEIGHT,
                                     CLEAR_BTN_WIDTH, CLEAR_BTN_WIDTH);
    _textCountBtn.frame = CGRectMake(_clearTextBtn.left - TEXT_COUNT_BTN_WIDTH + CELL_PADDING_4,//右移一点
                                     _clearTextBtn.top
                                     ,TEXT_COUNT_BTN_WIDTH, CLEAR_BTN_WIDTH);
    _locationBtn.frame = CGRectMake(CELL_PADDING_8, _textCountBtn.top,
                                    _textCountBtn.left - CELL_PADDING_8 * 3,
                                    LOCATION_BTN_HEIGHT);
    
    _locationBtn.titleEdgeInsets = UIEdgeInsetsMake(0.f, CELL_PADDING_8 * 2, 0.f, CELL_PADDING_8 * 2);

    _statusesTextView.frame = CGRectMake(0, 0, self.view.width, _textCountBtn.top);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem*)getSendButton
{
	return [[UIBarButtonItem alloc] initWithTitle:@"发送"
											 style:UIBarButtonItemStyleBordered
											target:self
											action:@selector(send)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createPostButtonBar
{
    SMPostButtonBar* bar = [[SMPostButtonBar alloc] initWithFrame:CGRectZero];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
    [bar addButton:nil target:self action:@selector(buttonSelected:)];
    
	int i = 0;
	for (UIButton* btn in bar.buttons) {
		switch (i) {
			case 0:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_locatebutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_locatebutton_background_highlighted.png"] forState:UIControlStateHighlighted];
            }
                break;
			case 1:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_camerabutton_background.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_camerabutton_background_highlighted.png"] forState:UIControlStateHighlighted];
            }
				break;
			case 2:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_trendbutton_background.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_trendbutton_background_highlighted.png"] forState:UIControlStateHighlighted];
            }
				break;
			case 3:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_mentionbutton_background.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_mentionbutton_background_highlighted.png"] forState:UIControlStateHighlighted];
            }
				break;
            case 4:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background_highlighted.png"] forState:UIControlStateHighlighted];
            }
				break;
		}
		i++;
	}
    bar.backgroundColor = [UIColor whiteColor];
    _postBtnBar = bar;
    [self.view addSubview:_postBtnBar];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addBarImageBtn
{
    if (_image) {
        if (BAR_BTN_MAX_COUNT == _postBtnBar.buttons.count) {
            UIButton* btn = [_postBtnBar.buttons objectAtIndex:BAR_BTN_MAX_COUNT - 1];
            [btn setImage:_image forState:UIControlStateNormal];
            // 更改图片后，重新显示，勿删
            [btn setNeedsDisplay];
        }
        else {
            [_postBtnBar addButton:nil target:self action:@selector(buttonSelected:)];
            UIButton* btn = [_postBtnBar.buttons objectAtIndex:BAR_BTN_MAX_COUNT - 1];
            [btn setImage:_image forState:UIControlStateNormal];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeBarImageBtn
{
    if (BAR_BTN_MAX_COUNT == _postBtnBar.buttons.count) {
        UIButton* btn = [_postBtnBar.buttons objectAtIndex:BAR_BTN_MAX_COUNT - 1];
        [btn removeFromSuperview];
        [(NSMutableArray*)_postBtnBar.buttons removeObjectAtIndex:BAR_BTN_MAX_COUNT - 1];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showPhotoPickerActionSheet
{
    UIActionSheet* as = nil;
    if (BAR_BTN_MAX_COUNT == _postBtnBar.buttons.count) {
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                otherButtonTitles:@"拍照", @"用户相册", @"删除图片", nil];

    }
    else {
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                otherButtonTitles:@"拍照", @"用户相册", nil];

    }
    as.tag = PHOTO_PICK_ACTION_SHEET_TAG;
    [as showInView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showClearTextActionSheet
{
    if (_statusesTextView.text.length > 0) {
        UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                               cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除文字"
                                               otherButtonTitles:nil];
        as.tag = CLEAR_TEXT_ACTION_SHEET_TAG;
        [as showInView:self.view];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showPhotoBrowseView
{
    SMPostPhotoBrowseC* browseC = [[SMPostPhotoBrowseC alloc] initWithImage:_image];
    browseC.deletePhotoDelegate = self;
    [self.navigationController pushViewController:browseC animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLocationView
{
    LocationViewController* c = [[LocationViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showDismissSaveToDraftActionSheet
{
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                           cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存"
                                           otherButtonTitles:@"保存草稿", nil];
    as.tag = SAVE_TO_DRAFT_ACTION_SHEET_TAG;
    [as showInView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissSelf
{
    if (_statusesTextView.text.length > 0
        || _image
        || _locationBtn.currentTitle.length > 0) {
        [self showDismissSaveToDraftActionSheet];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveToDraftAndDissmisSelf
{
    // save to draft
    UIImage* image = _image;
    NSString* content = _statusesTextView.text;
    if (image || content.length > 0 )
    {
        if (!_postModel) {
            _postModel = [[SMMBlogPostModel alloc] init];
        }
        if (image) {
            [_postModel saveToDraftForPostImage:image status:_statusesTextView.text latitude:_latitude longitude:_longitude];
        }
        else {
            [_postModel saveToDraftForPostStatus:_statusesTextView.text latitude:_latitude longitude:_longitude];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presetStatusesText
{
    _statusesTextView.text = _trendNameOrUserName;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)send
{
    // 如果有地理位置数据，加到text最后面
    if (self.streetPlace.length > 0) {
        NSString* trendStreetPlaceString = [NSString stringWithFormat:@"我在这里：#%@#",
                                            self.streetPlace];
        _statusesTextView.text = [NSString stringWithFormat:@"%@%@",
                                  _statusesTextView.text,
                                  trendStreetPlaceString];
    }
    
    UIImage* image = _image;
    NSString* content = _statusesTextView.text;
    if (image || content.length > 0 ) {
        if (!_postModel) {
            _postModel = [[SMMBlogPostModel alloc] init];
        }
        if (image) {
            [_postModel postImage:image status:_statusesTextView.text latitude:_latitude longitude:_longitude];
        }
        else {
            [_postModel postStatus:_statusesTextView.text latitude:_latitude longitude:_longitude];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [SMGlobalConfig showHUDMessage:@"请输入微博内容" addedToView:self.view];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 位置 图片 话题 @用户 表情/键盘
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)buttonSelected:(id)sender
{
	int selectedIndex = [[_postBtnBar buttons] indexOfObject:sender];
    switch (selectedIndex) {
        case 0:
            [self showLocationView];
            break;
            
        case 1:
            // 拍照 or 相册
            [self showPhotoPickerActionSheet];
            break;
            
        case 2:
            // 话题
        {            
            SMTrendsC* trendsC = [[SMTrendsC alloc] initWithNibName:nil bundle:nil];
            trendsC.trendsDelegate = self;
            [self.navigationController pushViewController:trendsC animated:YES];
        }
            break;
            
        case 3:
            // @某用户
        {
            SMFriendsC* friendC = [[SMFriendsC alloc] initWithNibName:nil bundle:nil];;
            friendC.friendsDelegate = self;
            [self.navigationController pushViewController:friendC animated:YES];
        }
            break;
            
        case 4:
            // 表情
        {
            if (TTIsKeyboardVisible()) {
                // 隐藏键盘
                [_statusesTextView resignFirstResponder];
                // 显示表情选择框
                if (!_emotionC) {
                    _emotionC = [[SMEmotionC alloc] initWithNibName:nil bundle:nil];
                    _emotionC.EmotionDelegate = self;
                    _emotionC.view.frame = _inputBackgroundImageView.frame;
                }
                // TODO:动画
                [self popupEmotionViewAnimation];
                
                // 修改按钮为显示键盘图标
                UIButton* btn = [_postBtnBar.buttons objectAtIndex:4];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_keyboardbutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_keyboardbutton_background_hightlighted.png"]
                     forState:UIControlStateHighlighted];
            }
            else {
                // 显示键盘
                [_statusesTextView becomeFirstResponder];
                // 移除表情选择框
                [self popdownEmotionViewAnimation];
                
                // 修改按钮为显示表情图标
                UIButton* btn = [_postBtnBar.buttons objectAtIndex:4];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background_hightlighted.png"]
                     forState:UIControlStateHighlighted];
            }
        }
            break;
        case 5:
        {
            [self showPhotoBrowseView];
        }
            break;
        default:
            break;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popupEmotionViewAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    _emotionC.view.top = _inputBackgroundImageView.top;
    [self.view addSubview:_emotionC.view];
    [UIView commitAnimations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popdownEmotionViewAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    _emotionC.view.top = _inputBackgroundImageView.bottom;
    [UIView commitAnimations];
}

/*
 相册里的原图
 3264x2448，大小2.1M
 
 新浪客户端处理图片的方法
 1. 通过wifi上传
 s_90x120     3.4k
 m_440x586    44k
 l_1200x1600  271k
 
 2. 通过2g 3g上传
 s_90x120     3.4k
 m_440x586    44k
 l_768x1024   112k
 
 2g 3g得到的图片是完全一样的；上传后的图片都能自动旋转
 */
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)optimizeSizeForNetStatusWithImage:(UIImage*)image
{
    CGSize size = image.size;
    CGFloat compressionQuality = 1.0f;
    if ([[NetworkSpy sharedNetworkSpy] isReachableViaWiFi] ) {
        size = CGSizeMake(1200, 1600);
        compressionQuality = 0.45f;
    }
    else {
        size = CGSizeMake(768, 1024);
        compressionQuality = 0.5f;
    }
    
    UIImage* newImage = [image scaleToFitSize:size];
    NSData* data = UIImageJPEGRepresentation(newImage, compressionQuality);
    newImage = [[UIImage alloc] initWithData:data];
    
    return newImage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)limitPostStatusesText
{
    int delta = INPUT_TEXT_MAX_COUNT - _statusesTextView.text.length;
    // 地理位置占10字符
    delta = _locationBtn.currentTitle.length > 0
    ? delta - LOCATION_PLACEHOLDER_TEXT_COUNT
    : delta;
    
    if (delta > 0) {
        [_textCountBtn setTitle:[NSString stringWithFormat:@"%d", delta] forState:UIControlStateNormal];
    }
    else {
        // 地理位置占10字符
        int maxCount = _locationBtn.currentTitle.length > 0
        ? INPUT_TEXT_MAX_COUNT - LOCATION_PLACEHOLDER_TEXT_COUNT
        : INPUT_TEXT_MAX_COUNT;
        _statusesTextView.text = [_statusesTextView.text substringToIndex:maxCount];
        [_textCountBtn setTitle:@"0" forState:UIControlStateNormal];
    }
    
    // 是否显示情况按钮
    [self checkIfNeedShowClearButton];
    
    // 发送按钮是否可点击
    if (_statusesTextView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)checkIfNeedShowClearButton
{
    // 是否显示情况按钮
    if (_statusesTextView.text.length > 0
        || _locationBtn.currentTitle.length > 0) {
        _clearTextBtn.hidden = NO;
    }
    else {
        _clearTextBtn.hidden = YES;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIKeyboardNotification

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self layoutViewsWithKeyboardHeight:kbSize.height];
	
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self layoutViewsWithKeyboardHeight:kbSize.height];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - StreetPlaceLocationDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)locationUpdatedWithLatitude:(double)latitude longitude:(double)longitude
                        streetPlace:(NSString*)streetPlace
{
    if (streetPlace.length > 0) {
        [_locationBtn setTitle:streetPlace forState:UIControlStateNormal];
        
        // 文本中不用显示我在这里数据
//        NSString* trendStreetPlaceString = [NSString stringWithFormat:@"我在这里：#%@#", streetPlace];
//        _statusesTextView.text = [NSString stringWithFormat:@"%@%@", _statusesTextView.text,
//                                  trendStreetPlaceString];
        
        _latitude = latitude;
        _longitude = longitude;
        [self limitPostStatusesText];
        _locationBtn.hidden = NO;
        
        // TODO:
        // 修改定位图标颜色
        UIButton* btn = [_postBtnBar.buttons objectAtIndex:0];
        [btn setImage:[UIImage nimbusImageNamed:@"compose_locatebutton_background_highlighted.png"]
             forState:UIControlStateNormal];
        
        [self checkIfNeedShowClearButton];
        
        // method1:保存位置名到数组中，供删除位置所用
//        if (!_streetPlacesArray) {
//            _streetPlacesArray = [[NSMutableArray alloc] initWithCapacity:10];
//        }
//        if (_streetPlacesArray.count > 0) {
//            BOOL find = NO;
//            for (NSString* place in _streetPlacesArray) {
//                if ([place isEqualToString:trendStreetPlaceString]) {
//                    find = YES;
//                    break;
//                }
//            }
//            if (!find) {
//                [_streetPlacesArray addObject:trendStreetPlaceString];
//            }
//        }
//        else {
//            [_streetPlacesArray addObject:trendStreetPlaceString];
//        }
        // method2:简单的方法，保存后，发送的时候加进去
        self.streetPlace = streetPlace;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deleteStreetPlace
{
    _latitude = CGFLOAT_MAX;
    _longitude = CGFLOAT_MAX;
    [_locationBtn setTitle:@"" forState:UIControlStateNormal];
    _locationBtn.hidden = YES;
    
    // 修改定位图标颜色
    UIButton* btn = [_postBtnBar.buttons objectAtIndex:0];
    [btn setImage:[UIImage nimbusImageNamed:@"compose_locatebutton_background.png"]
         forState:UIControlStateNormal];
    
    [self checkIfNeedShowClearButton];
    
    // method1:删除text中我在位置和情况位置数组
//    if (_streetPlacesArray && _streetPlacesArray.count > 0
//        && _statusesTextView.text.length > 0) {
//        
//        NSMutableString* subString = nil;
//        NSMutableString* sourceString = [NSMutableString stringWithString:_statusesTextView.text];
//        for (NSString* place in _streetPlacesArray) {
//            subString = [NSMutableString stringWithString:place];
//            _statusesTextView.text = [self stringByDeleteSubstring:subString inSourceString:sourceString];
//        }
//    }
    // method2:删除位置字串
    self.streetPlace = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 递归删除子串
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableString*)stringByDeleteSubstring:(NSMutableString*)substring
                             inSourceString:(NSMutableString*)sourceString
{
	NSRange range = [sourceString rangeOfString:substring];
	if (range.length > 0) {
        [sourceString deleteCharactersInRange:range];
		return [self stringByDeleteSubstring:substring
                              inSourceString:sourceString];
	}
	else {
		return sourceString;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDPostPhotoDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deletePhoto
{
    [self removeBarImageBtn];
    self.image = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDEmotionDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)emotionSelectedWithCode:(NSString*)code
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@", _statusesTextView.text, code];
    [self limitPostStatusesText];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDTrendsDelegate

- (void)didSelectATrend:(NSString*)trend
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@", _statusesTextView.text, trend];
    [self limitPostStatusesText];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDFriendsDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectAFriend:(SMFriendEntity*)user
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@ ", _statusesTextView.text, [user getNameWithAt]];
    [self limitPostStatusesText];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextViewDelegate 

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{    
	return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChange:(UITextView *)textView
{
    [self limitPostStatusesText];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIActionSheetDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (SAVE_TO_DRAFT_ACTION_SHEET_TAG == actionSheet.tag) {
        switch (buttonIndex) {
            case 0:
                //[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            case 1:
                [self saveToDraftAndDissmisSelf];
            default:
                break;
        }
    }
    else if (CLEAR_TEXT_ACTION_SHEET_TAG == actionSheet.tag) {
        switch (buttonIndex) {
            case 0:
                _statusesTextView.text = @"";
                [self limitPostStatusesText];
                break;
                
            default:
                break;
        }
    }
    else if (PHOTO_PICK_ACTION_SHEET_TAG == actionSheet.tag) {
        switch (buttonIndex) {
            case 0:
            {
                // 拍照
                if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:NULL];
                }
                else {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:picker animated:YES completion:NULL];
                }
            }
                break;
                
            case 1:
            {
                // 用户相册
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = NO;
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                
            case 2:
            {
                [self deletePhoto];
            }
                break;
                
            default:
                break;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIImagePickerControllerDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [SMGlobalConfig showHUDMessage:@"处理中..." addedToView:self.view];

    _picker = picker;
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [NSThread detachNewThreadSelector:@selector(optimizeImage:) toTarget:self withObject:image];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 此处异步animation会导致程序crash
	[picker dismissViewControllerAnimated:YES completion:NULL];
    _picker = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)optimizeImage:(UIImage*)image
{    
    // 处理图片，并菊花提示
    self.image = [self optimizeSizeForNetStatusWithImage:image];
    // 界面显示放入主线程
    [self performSelectorOnMainThread:@selector(dismissPickerViewAndAddBarImageBtn) withObject:nil waitUntilDone:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissPickerViewAndAddBarImageBtn
{
    [self addBarImageBtn];
    
    // 此处异步animation会导致程序crash
	[_picker dismissViewControllerAnimated:YES completion:NULL];
    _picker = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDMBlogPostDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postFinished:(NSString*)message
{

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postFailed:(NSString*)message
{

}

@end
