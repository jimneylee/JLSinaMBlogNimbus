//
//  SMTrendsC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "LJJBaseTableC.h"

@class SMFriendEntity;
@protocol SMFriendsDelegate;
@interface SMFriendsC : LJJBaseTableC

@property(nonatomic, assign) id<SMFriendsDelegate> friendsDelegate;

@end

@protocol SMFriendsDelegate <NSObject>

- (void)didSelectAFriend:(SMFriendEntity*)user;

@end