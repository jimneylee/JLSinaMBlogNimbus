//
//  SMPublicTimelineModel.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "SMPageTimelineModel.h"
#import "SMStatusEntity.h"
#import "SMStatusCell.h"

@implementation SMPageTimelineModel

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
    return [SMAPIClient relativePathForPublicTimelineWithPageCounter:self.pageCounter
                                                                       perpageCount:self.perpageCount];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)listString
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
