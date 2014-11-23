//
//  SMPublicTimelineModel.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "SMTrendsModel.h"
#import "SMAPIClient.h"
#import "SMTrendEntity.h"
#import "SMTrendListEntity.h"
#import "SMTrendCell.h"

@implementation SMTrendsModel 

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.hasMoreData = NO;
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
	return [SMTrendEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [SMTrendCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)generateParameters
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadDataWithBlock:(void(^)(NSArray* indexPaths, NSError *error))block  more:(BOOL)more
{
    NSString* relativePath = [self relativePath];
    [[SMAPIClient sharedClient] GET:relativePath parameters:[self generateParameters]
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    // remove all
                                    for (int i = 0; i < self.sections.count; i++) {
                                        [self removeSectionAtIndex:i];
                                    }
                                    // reset with latest
                                    SMTrendListEntity* entity = [SMTrendListEntity entityWithDictionary:responseObject];
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
