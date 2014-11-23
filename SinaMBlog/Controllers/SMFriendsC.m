//
//  SMFriendsC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMFriendsC.h"
#import "SMFriendsModel.h"
#import "SMFriendEntity.h"

@interface SMFriendsC ()

@end

@implementation SMFriendsC

//////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"联系人";
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [SMFriendsModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath* indexPath) {
        if (!self.editing) {
            if ([object isKindOfClass:[SMFriendEntity class]]) {
                SMFriendEntity* entity = (SMFriendEntity*)object;
                if ([self.friendsDelegate respondsToSelector:@selector(didSelectAFriend:)]) {
                    [self.friendsDelegate didSelectAFriend:entity];
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
