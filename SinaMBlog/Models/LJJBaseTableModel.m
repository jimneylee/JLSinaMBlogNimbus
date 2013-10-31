//
//  SNListBaseModel.m
//  SkyNet
//
//  Created by Lee jimney on 7/27/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "LJJBaseTableModel.h"
#import "NITableViewModel+Private.h"
#import "NITableViewModel.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LJJBaseTableModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self)
	{
		self.pageCounter = 1;
        self.perpageCount = PERPAGE_COUNT;
		self.hasMoreEntity = YES;
        
        // default map object to cell
        if (delegate && [delegate isKindOfClass:[NICellFactory class]]) {
            NICellFactory* factory = (NICellFactory*)delegate;
            NIDASSERT([self objectClass]);
            NIDASSERT([self cellClass]);
            [factory mapObjectClass:[self objectClass]
                        toCellClass:[self cellClass]];
        }
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)listString
{
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*)getEntityArray:(NSDictionary*)dic
{
	return [dic objectForKey:[self listString]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return NULL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return NULL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)generateParameters
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadDataWithBlock:(void(^)(NSArray* indexPaths, NSError *error))block more:(BOOL)more
{
    if (more) {
        self.pageCounter++;
    }
    else {
        self.pageCounter = 1;
    }
    NSString* relativePath = [self relativePath];
    [[SMAPIClient sharedClient] getPath:relativePath parameters:[self generateParameters]
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     // if   more = YES
                                     //      append new items
                                     // else more = NO
                                     //      remove all and set new items
                                     if (!more) {
                                         if (self.sections.count > 0) {
                                             [self removeSectionAtIndex:0];
                                         }
                                     }
                                     NSArray* objects = [self parseResponseObject:responseObject];
                                     NSArray* indexPaths = nil;
                                     if (objects.count) {
                                         indexPaths = [self addObjectsFromArray:objects];
                                     }
                                     else {
                                         indexPaths = [NSArray array];
                                     }
                                     if (block) {
                                         block(indexPaths, nil);
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (block) {
                                         block(nil, error);
                                     }
                                 }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*)handleEntity:(NSArray*)entities
{
	if (entities.count > 0) {
        NSMutableArray* objects = [NSMutableArray arrayWithCapacity:entities.count];
		for (NSDictionary* dic in entities) {
			id entity = [[self objectClass] entityWithDictionary:dic];
			[objects addObject:entity];
		}
        return objects;
	}
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*)parseResponseObject:(id)responseObject
{
    NSArray* objects = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dataDic = (NSDictionary*)responseObject;
        NSArray* entities = [self getEntityArray:dataDic];
        objects = [self handleEntity:entities];
        self.hasMoreEntity = (objects.count >= self.perpageCount) ? YES : NO;
    }
    else if ([responseObject isKindOfClass:[NSArray class]]) {
        objects = [self handleEntity:responseObject];
        self.hasMoreEntity = (objects.count >= self.perpageCount) ? YES : NO;
    }
    else {
        self.hasMoreEntity = NO;
    }
    
    return objects;
}

@end
