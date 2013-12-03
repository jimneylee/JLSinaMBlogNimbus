//
//  SMStatusCell.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "SMStatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDateAdditions.h"
#import "UIView+findViewController.h"
#import "NIAttributedLabel.h"
#import "NIWebController.h"
#import "NSStringAdditions.h"
#import "SMStatusEntity.h"

#define TITLE_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define SUBTITLE_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define CONTENT_FONT_SIZE [UIFont systemFontOfSize:18.f]
#define RETWEET_CONTENT_FONT_SIZE [UIFont systemFontOfSize:16.f]
#define HEAD_IAMGE_HEIGHT 34
#define CONTENT_IMAGE_HEIGHT 160

@interface SMStatusCell()<NIAttributedLabelDelegate>
@property (nonatomic, strong) NIAttributedLabel* contentLabel;
@property (nonatomic, strong) NINetworkImageView* headView;
@property (nonatomic, strong) NINetworkImageView* contentImageView;
// 转发视图
@property (nonatomic, assign) BOOL hasRetweet;
@property (nonatomic, strong) UIView* retweetContentView;
@property (nonatomic, strong) NIAttributedLabel* retweetContentLabel;
@property (nonatomic, strong) NINetworkImageView* retweetContentImageView;
@end
@implementation SMStatusCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[SMStatusEntity class]]) {
        CGFloat cellMargin = CELL_PADDING_6;
        CGFloat contentViewMarin = CELL_PADDING_8;
        CGFloat sideMargin = cellMargin + contentViewMarin;

        // top margin
        CGFloat height = sideMargin;
        
        // head image
        height = height + HEAD_IAMGE_HEIGHT;
        height = height + CELL_PADDING_10;
        
        // content
        SMStatusEntity* o = (SMStatusEntity*)object;
        CGFloat kContentLength = tableView.width - sideMargin * 2;
#if 0
        CGSize contentSize = [o.text sizeWithFont:CONTENT_FONT_SIZE
                                constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        height = height + contentSize.height;
#else
        NIAttributedLabel* contentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        contentLabel.font = CONTENT_FONT_SIZE;
        contentLabel.width = kContentLength;
        contentLabel.text = o.text;
        [contentLabel sizeToFit];
        height = height + contentLabel.height;
#endif
        
        // content image
        if (o.bmiddle_pic.length) {
            height = height + CELL_PADDING_10;
            height = height + CONTENT_IMAGE_HEIGHT;
        }

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        // 转发高度
        if (o.retweeted_status) {
            height = height + CELL_PADDING_10;
            height = height + contentViewMarin;
            
            CGFloat kRetweetContentLength = kContentLength - contentViewMarin * 2;
#if 0
            CGSize retweetContentSizeSize = [o.retweeted_status.text sizeWithFont:RETWEET_CONTENT_FONT_SIZE
                                                                constrainedToSize:CGSizeMake(kRetweetContentLength, FLT_MAX)
                                                                    lineBreakMode:NSLineBreakByWordWrapping];
            height = height + retweetContentSizeSize.height;
#else
            // reuse contentLabel and reset frame, it's important
            contentLabel.frame = CGRectZero;
            contentLabel.font = RETWEET_CONTENT_FONT_SIZE;
            contentLabel.width = kRetweetContentLength;
            contentLabel.text = [NSString stringWithFormat:@"%@：%@",
                                             o.retweeted_status.user.name,
                                             o.retweeted_status.text];
            [contentLabel sizeToFit];
            height = height + contentLabel.height;
#endif
            // content image
            if (o.retweeted_status.bmiddle_pic.length) {
                height = height + CELL_PADDING_10;
                height = height + CONTENT_IMAGE_HEIGHT;
            }
            height = height + contentViewMarin;
        }
        
        // TODO: button
        
        // bottom side margin
        height = height + sideMargin;
        
        return height;
    }
    
    return 0.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        self.headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT,
                                                                                   HEAD_IAMGE_HEIGHT)];
        [self.contentView addSubview:self.headView];

        // name
        self.textLabel.font = TITLE_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        // source from & date
        self.detailTextLabel.font = SUBTITLE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // status content
        self.contentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = CONTENT_FONT_SIZE;
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLabel.autoDetectLinks = YES;
        self.contentLabel.delegate = self;
        self.contentLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        self.contentLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        [self.contentView addSubview:self.contentLabel];
        
        // content image
        self.contentImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                     CONTENT_IMAGE_HEIGHT,
                                                                                     CONTENT_IMAGE_HEIGHT)];
        [self.contentView addSubview:self.contentImageView];
        
        // ui style
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        // 转发初始化
        // content view
        self.retweetContentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.retweetContentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.retweetContentView];
        
        // status content
        self.retweetContentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        self.retweetContentLabel.numberOfLines = 0;
        self.retweetContentLabel.font = RETWEET_CONTENT_FONT_SIZE;
        self.retweetContentLabel.textColor = [UIColor darkGrayColor];
        self.retweetContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.retweetContentLabel.autoDetectLinks = YES;
        self.retweetContentLabel.delegate = self;
        self.retweetContentLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        self.retweetContentLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        [self.retweetContentView addSubview:self.retweetContentLabel];
        
        // content image
        self.retweetContentImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                     CONTENT_IMAGE_HEIGHT,
                                                                                     CONTENT_IMAGE_HEIGHT)];
        [self.retweetContentView addSubview:self.retweetContentImageView];
        
        self.retweetContentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.retweetContentView.layer.borderWidth = 1.0f;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = CELL_CONTENT_VIEW_BG_COLOR;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.backgroundColor = [UIColor clearColor];

    CGFloat cellMargin = CELL_PADDING_6;
    CGFloat contentViewMarin = CELL_PADDING_8;
    CGFloat sideMargin = cellMargin + contentViewMarin;
    
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        self.height - cellMargin * 2);
    self.headView.left = contentViewMarin;
    self.headView.top = contentViewMarin;
    
    // name
    self.textLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_10, self.headView.top,
                                      self.width - sideMargin * 2 - (self.headView.right + CELL_PADDING_10),
                                      self.textLabel.font.lineHeight);
    
    // source from & date
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom,
                                            self.width - sideMargin * 2 - self.textLabel.left,
                                            self.detailTextLabel.font.lineHeight);
    
    // status content
    CGFloat kContentLength = self.contentView.width - contentViewMarin * 2;
    self.contentLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_10,
                                         kContentLength, 0.f);
    [self.contentLabel sizeToFit];

    CGSize contentSize = [self.contentLabel.text sizeWithFont:CONTENT_FONT_SIZE
                                            constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                                lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"sizeWithFont height = %f", contentSize.height);
    NSLog(@"sizeToFit height    = %f", self.contentLabel.height);

    // content image
    self.contentImageView.left = self.contentLabel.left;
    self.contentImageView.top = self.contentLabel.bottom + CELL_PADDING_10;
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    // 转发布局
    if (self.hasRetweet) {
        CGFloat contentBottom = self.contentImageView.hidden
        ? self.contentLabel.bottom
        : self.contentImageView.bottom;
        self.retweetContentView.frame = CGRectMake(self.contentLabel.left, contentBottom + CELL_PADDING_10,
                                                   kContentLength, 0.f);
        CGFloat kRetweetContentLength = kContentLength - contentViewMarin * 2;
        self.retweetContentLabel.frame = CGRectMake(contentViewMarin, contentViewMarin,
                                                    kRetweetContentLength, 0.f);
        [self.retweetContentLabel sizeToFit];

        CGSize retweetContentSizeSize = [self.retweetContentLabel.text sizeWithFont:RETWEET_CONTENT_FONT_SIZE
                                                            constrainedToSize:CGSizeMake(kRetweetContentLength, FLT_MAX)
                                                                lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"retweet sizeWithFont height = %f", retweetContentSizeSize.height);
        NSLog(@"retweet sizeToFit height    = %f", self.retweetContentLabel.height);
        
        // content image
        self.retweetContentImageView.left = self.retweetContentLabel.left;
        self.retweetContentImageView.top = self.retweetContentLabel.bottom + CELL_PADDING_10;
        
        if (self.retweetContentImageView.hidden) {
            self.retweetContentView.height = self.retweetContentLabel.bottom + contentViewMarin;
        }
        else {
            self.retweetContentView.height = self.retweetContentImageView.bottom + contentViewMarin;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[SMStatusEntity class]]) {
        SMStatusEntity* o = (SMStatusEntity*)object;

        if (o.user.profile_image_url.length) {
            [self.headView setPathToNetworkImage:o.user.profile_image_url];
        }
        else {
            [self.headView setPathToNetworkImage:nil];
        }
        
        self.textLabel.text = o.user.name;
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",
                                     o.source, [o.timestamp formatRelativeTime]];// 解决动态计算时间
        self.contentLabel.text = o.text;
        
        [o parseAllKeywords];
        [self showAllKeywordsInContentLabel:self.contentLabel withStatus:o fromLocation:0];
        
        if (o.bmiddle_pic.length) {
            self.contentImageView.hidden = NO;
            [self.contentImageView setPathToNetworkImage:o.bmiddle_pic contentMode:UIViewContentModeScaleAspectFill];
        }
        else {
            self.contentImageView.hidden = YES;
            [self.contentImageView setPathToNetworkImage:nil];
        }
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        // 被转发的原微博
        if (o.retweeted_status) {
            self.hasRetweet = YES;
            self.retweetContentView.hidden = NO;
            self.retweetContentLabel.text = [NSString stringWithFormat:@"%@：%@",
                                             o.retweeted_status.user.name,
                                             o.retweeted_status.text];
            
            NSString* url =[NSString stringWithFormat:@"atsomeone://%@",
                            [o.retweeted_status.user.name urlEncoded]];
            [self.retweetContentLabel addLink:[NSURL URLWithString:url]
                            range:NSMakeRange(0, o.retweeted_status.user.name.length)];
            
            [o.retweeted_status parseAllKeywords];
            [self showAllKeywordsInContentLabel:self.retweetContentLabel
                                     withStatus:o.retweeted_status
                                   fromLocation:o.retweeted_status.user.name.length+1];
            
            if (o.retweeted_status.bmiddle_pic.length) {
                self.retweetContentImageView.hidden = NO;
                [self.retweetContentImageView setPathToNetworkImage:o.retweeted_status.bmiddle_pic
                                                        contentMode:UIViewContentModeScaleAspectFill];
            }
            else {
                self.retweetContentImageView.hidden = YES;
                [self.retweetContentImageView setPathToNetworkImage:nil];
            }
        }
        else {
            self.retweetContentView.hidden = YES;
        }
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showAllKeywordsInContentLabel:(NIAttributedLabel*)contentLabel
                           withStatus:(SMStatusEntity*)o
                         fromLocation:(NSInteger)location
{
    SMKeywordEntity* k = nil;
    NSString* url = nil;
    if (o.atPersonRanges.count) {
        for (int i = 0; i < o.atPersonRanges.count; i++) {
            k = (SMKeywordEntity*)o.atPersonRanges[i];
            url =[NSString stringWithFormat:@"atsomeone://%@", [k.keyword urlEncoded]];
            [contentLabel addLink:[NSURL URLWithString:url]
                            range:NSMakeRange(k.range.location + location, k.range.length)];

        }
    }
    if (o.sharpTrendRanges.count) {
        for (int i = 0; i < o.sharpTrendRanges.count; i++) {
            k = (SMKeywordEntity*)o.sharpTrendRanges[i];
            url = [NSString stringWithFormat:@"sharptrend://%@", [k.keyword urlEncoded]];
            [contentLabel addLink:[NSURL URLWithString:url]
                            range:NSMakeRange(k.range.location + location, k.range.length)];
            
        }
    }
    // TODO: check emotion
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NIAttributedLabelDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)attributedLabel:(NIAttributedLabel*)attributedLabel
didSelectTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point {
    NSURL* url = nil;
    if (NSTextCheckingTypePhoneNumber == result.resultType) {
        url = [NSURL URLWithString:[@"tel://" stringByAppendingString:result.phoneNumber]];
        
    } else if (NSTextCheckingTypeLink == result.resultType) {
        url = result.URL;
    }
    
    if (nil != url) {
        if ([url.absoluteString hasPrefix:@"atsomeone://"]) {
            NSString* someone = [url.absoluteString substringFromIndex:@"atsomeone://".length];
            // TODO: show someone homepage
            someone = [someone stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [SMGlobalConfig showHUDMessage:someone
                               addedToView:[UIApplication sharedApplication].keyWindow];
        }
        else if ([url.absoluteString hasPrefix:@"sharptrend://"]) {
            NSString* sometrend = [url.absoluteString substringFromIndex:@"sharptrend://".length];
            // TODO: show some mblogs about this trend
            sometrend = [sometrend stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [SMGlobalConfig showHUDMessage:sometrend
                               addedToView:[UIApplication sharedApplication].keyWindow];
        }
        else {
            NIWebController* c = [[NIWebController alloc] initWithURL:url];
            [[self viewController].navigationController pushViewController:c animated:YES];
        }
    } else {
        NSLog(@"无效的链接");
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)attributedLabel:(NIAttributedLabel *)attributedLabel
shouldPresentActionSheet:(UIActionSheet *)actionSheet
 withTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    return NO;
}
@end
