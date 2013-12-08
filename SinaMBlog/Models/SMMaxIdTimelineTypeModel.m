//
//  SMPublicTimelineModel.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "SMMaxIdTimelineTypeModel.h"
#import "SMStatusEntity.h"
#import "SMStatusCell.h"

@interface SMMaxIdTimelineTypeModel()
@property (nonatomic, assign) MBlogTimeLineType timelineType;
@end

@implementation SMMaxIdTimelineTypeModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.timelineType = MBlogTimeLineType_Friends;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate timeLineType:(MBlogTimeLineType)type
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.timelineType = type;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* relativePath = nil;
    switch (_timelineType) {
        case MBlogTimeLineType_Friends:
            relativePath = [SMAPIClient relativePathForFriendsTimelineWithMaxId:self.oldMaxId];
            break;
            
        case MBlogTimeLineType_User:
            relativePath = [SMAPIClient relativePathForUserTimelineWithUserID:nil maxId:self.oldMaxId];
            break;
            
        case MBlogTimeLineType_AtMe:
            relativePath = [SMAPIClient relativePathForAtMeTimelineWithMaxId:self.oldMaxId];
            break;
            
        default:
            break;
    }
    
    return relativePath;

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)listKey
{
	return JSON_STATUS_LIST;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [SMStatusEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [SMStatusCell class];
}

@end
