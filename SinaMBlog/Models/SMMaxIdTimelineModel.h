//
//  SMPublicTimelineModel.h
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "LJJMaxIdBaseTableModel.h"

@interface SMMaxIdTimelineModel : LJJMaxIdBaseTableModel

- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate timeLineType:(MBlogTimeLineType)type;

@end
