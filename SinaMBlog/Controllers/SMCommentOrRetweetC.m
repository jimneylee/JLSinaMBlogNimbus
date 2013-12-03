//
//  SMMBlogPostC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-4.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMCommentOrRetweetC.h"
#import "TTGlobalUICommon.h"
#import "NetworkSpy.h"
#import "SMFriendEntity.h"

@interface SMCommentOrRetweetC ()

@end

#define TEXT_COUNT_BTN_WIDTH 40
#define CHECK_BOX_HEIGHT 25
#define LOCATION_PLACEHOLDER_TEXT_COUNT 10
#define CLEAR_BTN_WIDTH 20

#define BAR_BTN_MAX_COUNT 3
#define INPUT_TEXT_MAX_COUNT 140

#define CLEAR_TEXT_ACTION_SHEET_TAG 1000
#define SAVE_TO_DRAFT_ACTION_SHEET_TAG 1002

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SMCommentOrRetweetC
// 评论入口
//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithBlogId:(NSString*)blogId
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _blogId = [blogId copy];
        _postActionType = ZDPostActionType_Comment;
    }
    return self;
}

// 回复评论入口
//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithBlogId:(NSString*)blogId replyUsername:(NSString*)username
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _blogId = [blogId copy];
        _username = [username copy];
        _postActionType = ZDPostActionType_Comment;
    }
    return self;
}

// 转发入口
//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithRetweetBlogId:(NSString*)blogId username:(NSString*)username retweetContent:(NSString*)content
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _blogId = blogId;
        _username = username;
        _retweetContent = content;
        _postActionType = ZDPostActionType_Retweet;
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.leftBarButtonItem = [SMGlobalConfig createBarButtonItemWithTitle:@"取消"
                                                                                      target:self
                                                                                      action:@selector(dismissSelf)];
        self.navigationItem.rightBarButtonItem = [SMGlobalConfig createBarButtonItemWithTitle:@"发送"
                                                                                       target:self
                                                                                       action:@selector(send)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
   }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航标题
    [self setNavigationTitle];
    
    // 文本输入框
    _statusesTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _statusesTextView.font = [UIFont systemFontOfSize:18.f];
    _statusesTextView.delegate = self;
    [self.view addSubview:_statusesTextView];

    //同时转发到我的微博
    _checkboxBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_checkboxBtn setBackgroundColor:[UIColor whiteColor]];
    [_checkboxBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_checkboxBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_checkboxBtn addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkboxBtn];
    
    // 是否要转发的checkbox
    _checkBoxImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_checkBoxImageView setImage:[UIImage imageNamed:@"compose_checkbox.png"]];
    [_checkboxBtn addSubview:_checkBoxImageView];
    
    // 文本计数按钮
    _textCountBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_textCountBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_textCountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_textCountBtn addTarget:self action:@selector(showClearTextActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textCountBtn];
    
    // 清空文本按钮
    _clearTextBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_clearTextBtn setImage:[UIImage imageNamed:@"clearbutton_background.png"] forState:UIControlStateNormal];
    [_clearTextBtn addTarget:self action:@selector(showClearTextActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearTextBtn];
    
    // 内容选择工具条
    [self createPostButtonBar];
    
    // 键盘表情选择框底图
    _inputBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _inputBackgroundImageView.image = [UIImage imageNamed:@"emoticon_keyboard_background.png"];
    [self.view addSubview:_inputBackgroundImageView];
    
    [self registerForKeyboardNotifications];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCheckBoxBtnTitle];
    [self limitPostStatusesText];
    _retweet = NO;
    _comment = NO;
    [_statusesTextView becomeFirstResponder];
    [self layoutViewsWithKeyboardHeight:TTKeyboardHeightForOrientation(self.interfaceOrientation)];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCheckBoxBtnTitle
{
    switch (_postActionType) {
        case ZDPostActionType_Comment:
        {
            [_checkboxBtn setTitle:@"     同时转发到我的微博" forState:UIControlStateNormal];
            // 回复默认评论
            if (_username) {
                _statusesTextView.text = [NSString stringWithFormat:@"回复@%@:", _username];
            }
        }
            break;
            
        case ZDPostActionType_Retweet:
            {
                [_checkboxBtn setTitle:[NSString stringWithFormat:@"      同时评论给%@", _username] forState:UIControlStateNormal];

                // 设置初始转发内容
                NSString* content = @"";
                if (_retweetContent.length > 0) {
                    content = [NSString stringWithFormat:@"//@%@:%@", _username, _retweetContent];
                }
                _statusesTextView.text = content;
                // 移动光标至开始位置
                _statusesTextView.selectedRange = NSMakeRange(0, 0);
            }
            break;
            
        default:
            break;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNavigationTitle
{
    NSString* title = nil;
    switch (_postActionType) {
        case ZDPostActionType_Comment:
            if (_username) {
                title = @"回复评论";
            }
            else {
                title = @"发表评论";
            }
            break;
            
        case ZDPostActionType_Retweet:
            title = @"转发微博";
            break;

        default:
            break;
    }
    self.navigationItem.titleView = [SMGlobalConfig getNavigationBarTitleViewWithTitle:title];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutViewsWithKeyboardHeight:(CGFloat)keboardHeight
{
    // 布局由下到上，从右到左反计算
    _inputBackgroundImageView.frame = CGRectMake(0, self.view.height - keboardHeight,
                                                 self.view.width, keboardHeight);
    _postBtnBar.frame = CGRectMake(0, _inputBackgroundImageView.top - NIToolbarHeightForOrientation(self.interfaceOrientation),
                                   self.view.width, NIToolbarHeightForOrientation(self.interfaceOrientation));
    _clearTextBtn.frame = CGRectMake(self.view.width - CELL_PADDING_2 - CLEAR_BTN_WIDTH,
                                     _postBtnBar.top - CHECK_BOX_HEIGHT, CLEAR_BTN_WIDTH, CLEAR_BTN_WIDTH);
    _textCountBtn.frame = CGRectMake(_clearTextBtn.left - TEXT_COUNT_BTN_WIDTH,
                                     _postBtnBar.top - CHECK_BOX_HEIGHT
                                     ,TEXT_COUNT_BTN_WIDTH, CLEAR_BTN_WIDTH);
    _checkboxBtn.frame = CGRectMake(CELL_PADDING_8, _textCountBtn.top,
                                    self.view.width - _textCountBtn.width - _clearTextBtn.width - CELL_PADDING_8 * 2 - CELL_PADDING_2,
                                    CHECK_BOX_HEIGHT);
    _checkBoxImageView.frame = CGRectMake(0, 0, CHECK_BOX_HEIGHT, CHECK_BOX_HEIGHT);
    _statusesTextView.frame = CGRectMake(0, 0, self.view.width, _textCountBtn.top);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem*)getSendButton
{
	return [[UIBarButtonItem alloc] initWithTitle:@"发送"
											 style:UIBarButtonItemStyleBordered
											target:self
											action:@selector(send)];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createPostButtonBar
{
    SMPostButtonBar* bar = [[SMPostButtonBar alloc] initWithFrame:CGRectZero];
    bar.backgroundColor = [UIColor whiteColor];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
    
	int i = 0;
	for (UIButton* btn in bar.buttons) {
		switch (i) {
			case 0:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_trendbutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_trendbutton_background_highlighted.png"]
                     forState:UIControlStateHighlighted];
            }
				break;
			case 1:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_mentionbutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_mentionbutton_background_highlighted.png"]
                     forState:UIControlStateHighlighted];
            }
				break;
            case 2:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background_highlighted.png"]
                     forState:UIControlStateHighlighted];
            }
				break;
		}
		i++;
	}
    _postBtnBar = bar;
    [self.view addSubview:_postBtnBar];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
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

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showDismissSaveToDraftActionSheet
{
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                           cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存"
                                           otherButtonTitles:@"保存草稿", nil];
    as.tag = SAVE_TO_DRAFT_ACTION_SHEET_TAG;
    [as showInView:self.view];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissSelf
{
    if (_statusesTextView.text.length > 0) {
        [self showDismissSaveToDraftActionSheet];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveToDraftAndDissmisSelf
{
    NSString* content = _statusesTextView.text;
    if (content && content.length > 0 ) {
        if (!_postModel) {
            _postModel = [[SMMBlogPostModel alloc] init];
        }
        if (_blogId.length > 0) {
            switch (_postActionType) {
                case ZDPostActionType_Comment:
                {
                    if (_retweet) {
                        [_postModel saveToDraftForRetweetStatus:_statusesTextView.text blogId:_blogId isComment:YES];
                    }
                    else {
                        [_postModel saveToDraftForPostComment:_statusesTextView.text toBlogId:_blogId];
                    }
                }
                    break;
                    
                case ZDPostActionType_Retweet:
                {
                    if (_blogId.length > 0) {
                        [_postModel saveToDraftForRetweetStatus:_statusesTextView.text blogId:_blogId isComment:_comment];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)switchAction
{
    switch (_postActionType) {
        case ZDPostActionType_Comment:
            [self switchRetweetOrNot];
            break;
            
        case ZDPostActionType_Retweet:
            [self switchCommentOrNot];
            break;
            
        default:
            break;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)switchRetweetOrNot
{
    if (_retweet) {
        [_checkBoxImageView setImage:[UIImage nimbusImageNamed:@"compose_checkbox.png"]];
    }
    else {
        [_checkBoxImageView setImage:[UIImage nimbusImageNamed:@"compose_checkbox_checked.png"]];
    }
    _retweet = !_retweet;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)switchCommentOrNot
{
    if (_comment) {
        [_checkBoxImageView setImage:[UIImage nimbusImageNamed:@"compose_checkbox.png"]];
    }
    else {
        [_checkBoxImageView setImage:[UIImage nimbusImageNamed:@"compose_checkbox_checked.png"]];
    }
    _comment = !_comment;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)send
{
    if (0 == _statusesTextView.text.length) {
        [SMGlobalConfig showHUDMessage:@"请输入内容" addedToView:self.view];
        return;
    }

    NSString* content = _statusesTextView.text;
    if (content && content.length > 0 ) {
        if (!_postModel) {
            _postModel = [[SMMBlogPostModel alloc] init];
        }
        if (_blogId.length > 0) {
            switch (_postActionType) {
                case ZDPostActionType_Comment:
                {
                    if (_retweet) {
                        [_postModel retweetStatus:_statusesTextView.text blogId:_blogId isComment:YES];
                    }
                    else {
                        [_postModel postComment:_statusesTextView.text toBlogId:_blogId];
                   }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                    
                case ZDPostActionType_Retweet:
                {
                    if (_blogId.length > 0) {
                        [_postModel retweetStatus:_statusesTextView.text blogId:_blogId isComment:_comment];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                    break;
                default:
                    break;
            }            
        }
    }
    else {
        [SMGlobalConfig showHUDMessage:@"请输入微博内容" addedToView:self.view];
    }
}

// 位置 图片 话题 @用户 表情/键盘
//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)buttonSelected:(id)sender
{
	int selectedIndex = [[_postBtnBar buttons] indexOfObject:sender];
    switch (selectedIndex) {
        case 0:
            // 话题
        {
            SMTrendsC* trendsC = [[SMTrendsC alloc] initWithNibName:nil bundle:nil];
            trendsC.trendsDelegate = self;
            [self.navigationController pushViewController:trendsC animated:YES];
        }
            break;
            
        case 1:
            // @某用户
        {
            SMFriendsC* friendC = [[SMFriendsC alloc] initWithNibName:nil bundle:nil];;
            friendC.friendsDelegate = self;
            [self.navigationController pushViewController:friendC animated:YES];
        }
            break;
            
        case 2:
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
                [self popupEmotionViewAnimation];
                
                // 修改按钮为显示键盘图标
                UIButton* btn = [_postBtnBar.buttons objectAtIndex:2];
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
                UIButton* btn = [_postBtnBar.buttons objectAtIndex:2];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background_hightlighted.png"]
                     forState:UIControlStateHighlighted];
            }
        }
            break;
        default:
            break;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popupEmotionViewAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    _emotionC.view.top = _inputBackgroundImageView.top;
    [self.view addSubview:_emotionC.view];
    [UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popdownEmotionViewAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    _emotionC.view.top = _inputBackgroundImageView.bottom;
    [UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)limitPostStatusesText
{
    int delta = INPUT_TEXT_MAX_COUNT - _statusesTextView.text.length;
    
    if (delta > 0) {
        [_textCountBtn setTitle:[NSString stringWithFormat:@"%d", delta] forState:UIControlStateNormal];
        if (INPUT_TEXT_MAX_COUNT == delta) {
            _clearTextBtn.hidden = YES;
        }
        else {
            _clearTextBtn.hidden = NO;
        }
    }
    else {
        int maxCount = INPUT_TEXT_MAX_COUNT;
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

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)checkIfNeedShowClearButton
{
    // 是否显示情况按钮
    if (_statusesTextView.text.length > 0) {
        _clearTextBtn.hidden = NO;
    }
    else {
        _clearTextBtn.hidden = YES;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIKeyboardNotification

//////////////////////////////////////////////////////////////////////////////////////////////////////
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

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIActionSheetDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (SAVE_TO_DRAFT_ACTION_SHEET_TAG == actionSheet.tag) {
        switch (buttonIndex) {
            case 0:
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
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDEmotionDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)emotionSelectedWithCode:(NSString*)code
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@", _statusesTextView.text, code];
    [self limitPostStatusesText];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDTrendsDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectATrend:(NSString*)trend
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@", _statusesTextView.text, trend];
    [self limitPostStatusesText];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDFriendsDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectAFriend:(SMFriendEntity*)user
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@ ", _statusesTextView.text, [user getNameWithAt]];
    [self limitPostStatusesText];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
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

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChange:(UITextView *)textView
{
    [self limitPostStatusesText];
}

@end
