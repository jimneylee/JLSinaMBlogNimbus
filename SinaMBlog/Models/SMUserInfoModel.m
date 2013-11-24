//
//  SMUserModel.m
//  SinaMBlogNimbus
//
//  Created by ccjoy-jimneylee on 13-11-13.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMUserInfoModel.h"
#import "SMAPIClient.h"
#import "SMUserInfoEntity.h"

@implementation SMUserInfoModel

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePathWithUserName:(NSString*)userName orUserId:(NSString*)userId {
    return [SMAPIClient relativePathForUserInfoWithUserName:userName orUserId:userId];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadUserInfoWithUserName:(NSString*)userName
                        orUserId:(NSString*)userId
                           block:(void(^)(SMUserInfoEntity* entity, NSError* error))block
{
    [[SMAPIClient sharedClient] getPath:[self relativePathWithUserName:userName orUserId:userId] parameters:nil
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         NSDictionary* dic = (NSDictionary*)responseObject;
                                         self.entity = [SMUserInfoEntity entityWithDictionary:dic];
                                         if (block) {
                                             block(self.entity, nil);
                                             return;
                                         }
                                     }
                                     if (block) {
                                         NSError* error = [[NSError alloc] init];
                                         block(nil, error);
                                         return;
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (block) {
                                         block(nil, error);
                                     }
                                 }];
}

@end
