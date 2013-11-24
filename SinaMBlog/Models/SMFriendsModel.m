//
//  SMFriendsModel.m
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMFriendsModel.h"
#import "SMFriendEntity.h"
#import "SMFriendListEntity.h"
#import "SMFriendCell.h"

@implementation SMFriendsModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return [SMAPIClient relativePathForWeeklyTrendsList];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [SMFriendEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [SMFriendCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadDataWithBlock:(void(^)(NSArray* indexPaths, NSError *error))block  more:(BOOL)more
{
    NSString* relativePath = [self relativePath];
    [[SMAPIClient sharedClient] getPath:relativePath parameters:[self generateParameters]
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    // remove all
                                    for (int i = 0; i < self.sections.count; i++) {
                                        [self removeSectionAtIndex:i];
                                    }
                                    // reset with latest
                                    SMFriendListEntity* entity = [SMFriendListEntity entityWithDictionary:responseObject];
                                    NITableViewModelSection* s = nil;
                                    NSMutableArray* modelSections = [NSMutableArray arrayWithCapacity:entity.items.count];
                                    for (int i = 0; i < entity.items.count; i++) {
                                        s = [NITableViewModelSection section];
                                        s.headerTitle = entity.sections[i];
                                        s.rows = entity.items[i];
                                        [modelSections addObject:s];
                                    }
                                    self.sections = modelSections;
                                    self.sectionIndexTitles = entity.sections;
                                    
                                    if (block) {
                                        block(self.sections, nil);
                                    }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error:%@", error.description);
                                    if (block) {
                                        block(nil, error);
                                    }
                                }];
}

@end
