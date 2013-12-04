//
//  SNListBaseModel.h
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 7/27/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAPIClient.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface LJJMaxIdBaseTableModel : NIMutableTableViewModel

@property (nonatomic, assign) BOOL hasMoreEntity;
@property (nonatomic, copy) NSString* oldMaxId;
@property (nonatomic, assign) NSInteger perpageCount;

- (Class)objectClass;
- (Class)cellClass;
- (NSDictionary*)generateParameters;
- (NSArray*)getEntityArray:(NSDictionary*)dic;

- (void)loadDataWithBlock:(void(^)(NSArray* items, NSError *error))block more:(BOOL)more refresh:(BOOL)refresh;

@end
