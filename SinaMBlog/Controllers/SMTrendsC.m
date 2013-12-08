//
//  SMTrendsC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMTrendsC.h"
#import "SMTrendsModel.h"
#import "SMTrendEntity.h"

@interface SMTrendsC ()

@end

@implementation SMTrendsC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"插入话题";
//        self.navigationItem.leftBarButtonItem =
//        [SMGlobalConfig createBarButtonItemWithTitle:@"关闭"
//                                              target:self
//                                              action:@selector(dismissViewControllerAnimated:completion:)];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [SMTrendsModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if (!self.editing) {
            if ([object isKindOfClass:[SMTrendEntity class]]) {
                SMTrendEntity* entity = (SMTrendEntity*)object;
                if ([self.trendsDelegate respondsToSelector:@selector(didSelectATrend:)]) {
                    [self.trendsDelegate didSelectATrend:[entity getNameWithSharp]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

@end
