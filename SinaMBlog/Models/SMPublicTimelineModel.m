//
//  SMPublicTimelineModel.m
//  VideoOnline
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 SuperMaxDev. All rights reserved.
//

#import "SMPublicTimelineModel.h"
#import "SMStatusEntity.h"
#import "SMStatusCell.h"

@implementation SMPublicTimelineModel

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
    return [[SMAPIClient sharedClient] relativePathForPublicTimelineWithPageCounter:self.pageCounter
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
