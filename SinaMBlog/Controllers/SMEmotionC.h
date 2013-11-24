//
//  SMEmotionC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-5.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

@protocol SMEmotionDelegate;
@interface SMEmotionC : UIViewController//<TTScrollViewDelegate, TTScrollViewDataSource>
{
//    TTScrollView* _scrollView;
//	TTPageControl* _pageControll;
    
	NSArray* _emotionArray;
}
@property (nonatomic, assign) id<SMEmotionDelegate> emotionDelegate;
@end

@protocol SMEmotionDelegate <NSObject>

@optional
- (void)emotionSelectedWithCode:(NSString*)code;

@end

