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
#import "NIAttributedLabel.h"
#import "NSStringAdditions.h"
#import "SMStatusEntity.h"

#define TITLE_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define SUBTITLE_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define CONTENT_FONT_SIZE [UIFont systemFontOfSize:18.f]
#define HEAD_IAMGE_HEIGHT 34
#define CONTENT_IMAGE_HEIGHT 160

@interface SMStatusCell()<NIAttributedLabelDelegate>
@property (nonatomic, strong) NIAttributedLabel* contentLabel;
@property (nonatomic, strong) NINetworkImageView* headView;
@property (nonatomic, strong) NINetworkImageView* contentImageView;
@end
@implementation SMStatusCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[SMStatusEntity class]]) {
        CGFloat cellMargin = CELL_PADDING_6;
        CGFloat contentViewMarin = CELL_PADDING_8;
        CGFloat sideMargin = cellMargin + contentViewMarin;

        CGFloat height = sideMargin;
        
        // head image
        height = height + HEAD_IAMGE_HEIGHT;
        height = height + CELL_PADDING_10;
        
        // content
        SMStatusEntity* o = (SMStatusEntity*)object;
        CGFloat kContentLength = tableView.width - sideMargin * 2;
        CGSize titleSize = [o.text sizeWithFont:CONTENT_FONT_SIZE constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)];
        height = height + titleSize.height;
        
        // content image
        if (o.thumbnail_pic.length) {
            height = height + CELL_PADDING_10;
            height = height + CONTENT_IMAGE_HEIGHT;
        }

        // TODO: button
        
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
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        //self.contentLabel.attributesForHighlightedLink = @{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(255, 0, 0).CGColor};
        [self.contentView addSubview:self.contentLabel];
        
        // content image
        self.contentImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                     CONTENT_IMAGE_HEIGHT,
                                                                                     CONTENT_IMAGE_HEIGHT)];
        [self.contentView addSubview:self.contentImageView];
        
        // ui style
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
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

    // content image
    self.contentImageView.left = self.contentLabel.left;
    self.contentImageView.top = self.contentLabel.bottom + CELL_PADDING_10;
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
        [self showAllKeywordsWithObject:o];
        
        if (o.thumbnail_pic.length) {
            self.contentImageView.hidden = NO;
            [self.contentImageView setPathToNetworkImage:o.thumbnail_pic contentMode:UIViewContentModeScaleAspectFill];
        }
        else {
            self.contentImageView.hidden = YES;
            [self.contentImageView setPathToNetworkImage:nil];
        }
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showAllKeywordsWithObject:(SMStatusEntity*)o
{
    NSRange range = NSMakeRange(0, 0);
    NSValue* value = nil;
    if (o.atPersonRanges.count) {
        for (int i = 0; i < o.atPersonRanges.count; i++) {
            value = (NSValue*)o.atPersonRanges[i];
            range = [value rangeValue];
            [self.contentLabel addLink:[NSURL URLWithString:@"atsomeone://hello"]//TODO:[@"hello" urlEncoded]
                                 range:range];

        }
    }
    if (o.sharpTrendRanges.count) {
        for (int i = 0; i < o.sharpTrendRanges.count; i++) {
            value = (NSValue*)o.sharpTrendRanges[i];
            range = [value rangeValue];
            [self.contentLabel addLink:[NSURL URLWithString:@"sharptrend://hello"]//TODO:[@"hello" urlEncoded]
                                 range:range];
            
        }
    }
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
            NSLog(@"@someone");
        }
        else if ([url.absoluteString hasPrefix:@"sharptrend://"]) {
            NSLog(@"#sometrend");
        }
        else if (![[UIApplication sharedApplication] openURL:url]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"抱歉"
                                                            message:[@"无法打开这个链接" stringByAppendingString:url.absoluteString]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
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
