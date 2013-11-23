//
//  SMTrendCell.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-8-15.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMTrendCell.h"
#import "SMTrendEntity.h"

#define TITLE_FONT_SIZE [UIFont boldSystemFontOfSize:17.f]

@implementation SMTrendCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 44.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.font = TITLE_FONT_SIZE;

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
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[SMTrendEntity class]]) {
        SMTrendEntity* entity = (SMTrendEntity*)object;
        self.textLabel.text = [entity getNameWithSharp];
    }
    return YES;
}

@end
