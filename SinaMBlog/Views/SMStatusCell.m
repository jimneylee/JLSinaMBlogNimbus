//
//  TVVideoCell.m
//  VideoOnline
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 SuperMaxDev. All rights reserved.
//

#import "SMStatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDateAdditions.h"
#import "SMStatusEntity.h"

#define LINE_COLOR RGBCOLOR(224, 224, 224)
#define TITLE_FONT_SIZE [UIFont systemFontOfSize:16]
#define SUBTITLE_FONT_SIZE [UIFont systemFontOfSize:14]

@interface SMStatusCell()
@property (nonatomic, strong) UILabel* timestampLabel;
@end
@implementation SMStatusCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[SMStatusEntity class]]) {
        CGFloat height = CELL_PADDING_6;
        SMStatusEntity* o = (SMStatusEntity*)object;
        CGFloat kContentLength = tableView.width - CELL_PADDING_10 * 2;
        CGSize titleSize = [o.text sizeWithFont:TITLE_FONT_SIZE constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)];
        height = height + titleSize.height;
        height = height + CELL_PADDING_2;
        
        height = height + SUBTITLE_FONT_SIZE.lineHeight;
        height = height + CELL_PADDING_6;
        
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
        self.textLabel.font = TITLE_FONT_SIZE;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        self.detailTextLabel.font = SUBTITLE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.frame = CGRectMake(0.f, 0.f, 100.f, 15.f);
        
        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.f, 15.f)];
        self.timestampLabel.font = SUBTITLE_FONT_SIZE;
        self.timestampLabel.textColor = self.detailTextLabel.textColor;
        self.timestampLabel.highlightedTextColor = self.detailTextLabel.highlightedTextColor;
        self.timestampLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.timestampLabel];
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
    
    self.textLabel.left = CELL_PADDING_10;
    self.textLabel.top = CELL_PADDING_6;
    
    self.detailTextLabel.left = self.textLabel.left;
    self.detailTextLabel.top = self.textLabel.bottom + CELL_PADDING_4;
    
    CGSize size = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font];
    self.timestampLabel.width = size.width;
    self.timestampLabel.top = self.detailTextLabel.top;
    self.timestampLabel.left = self.detailTextLabel.right + CELL_PADDING_8;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[SMStatusEntity class]]) {
        SMStatusEntity* o = (SMStatusEntity*)object;
        self.textLabel.text = o.text;
        self.detailTextLabel.text = o.source;
        self.timestampLabel.text = [o.timestamp formatRelativeTime];// 解决动态计算时间
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
    
    CGFloat lineHeight = 1.f;
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, lineHeight);
    CGContextSetStrokeColorWithColor(ctx, LINE_COLOR.CGColor);
    CGContextMoveToPoint(ctx, 0, rect.size.height - lineHeight);
	CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
    CGContextStrokePath(ctx);
}


@end
