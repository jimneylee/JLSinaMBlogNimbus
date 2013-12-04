//
//  SMSearchResultModel.m
//  SinaMBlog
//
//  Created by jimney on 13-2-28.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMSearchResultModel.h"
#import "SMStatusEntity.h"
#import "SMStatusEntity.h"
#import "SMUserInfoEntity.h"

@interface SMSearchResultModel()
{
    SearchType _searchType;
    NSString* _keywords;
}
@end

@implementation SMSearchResultModel

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchType:(SearchType)type keywords:(NSString*)keywords
{
    self = [super init];
    if (self) {
        _searchType = type;
        _keywords = [keywords copy];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)entityClass
{
    Class cls = NULL;
    switch (_searchType) {
        case SearchType_Statuses:
        case SearchType_Topics:
            cls = [SMStatusEntity class];
            break;
            
        case SearchType_Users:
            cls = [SMUserInfoEntity class];
            break;
            
        default:
            break;
    }
    return cls;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class) cellClass
{
    Class cls = nil;
	switch (_searchType) {
        case SearchType_Statuses:
        case SearchType_Topics:
            cls = nil;//[SMMBlogCell class];
            break;
            
        case SearchType_Users:
            cls = nil;//[SMUserCell class];
            break;
            
        default:
            break;
    }
    return cls;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)getUrl
{
    NSString* url = nil;
    switch (_searchType) {
        case SearchType_Statuses:
            url = [SMAPIClient urlForSearchStatusesWithKeywords:_keywords
                                              pageCounter:self.pageCounter
                                             perpageCount:self.perpageCount];
            break;
            
        case SearchType_Users:
            url = [SMAPIClient urlForSearchUsersWithKeywords:_keywords
                                           pageCounter:self.pageCounter
                                          perpageCount:self.perpageCount];
            break;
            
        case SearchType_Topics:
            url = [SMAPIClient urlForSearchTrendsWithKeywords:_keywords
                                            pageCounter:self.pageCounter
                                           perpageCount:self.perpageCount];
            break;
            
        default:
            break;
    }
    return url;
}

@end
