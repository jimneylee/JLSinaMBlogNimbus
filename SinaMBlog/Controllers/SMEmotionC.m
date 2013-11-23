//
//  SMEmotionC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-5.
//  Copyright (c) 2013年 SuperMaxDev. All rights reserved.
//

#import "SMEmotionC.h"
#import "SMEmotionEntity.h"

#define MARGIN 25
#define ROW_COUNT 4
#define COLUMN_COUNT 7
#define SPACE 10
#define FACE_WIDTH 30
#define PAGE_CONTROL_HEIGHT 20

@implementation SMEmotionC

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _emotionArray = [SMGlobalConfig emotionsArray];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView
{
	[super loadView];
	self.view.backgroundColor = [UIColor clearColor];
    
//	_scrollView = [[TTScrollView alloc] initWithFrame:self.view.bounds];
//    _scrollView.backgroundColor = [UIColor clearColor];
//	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	_scrollView.zoomEnabled = NO;
//	_scrollView.pageSpacing = 20.f;
//	_scrollView.delegate = self;
//	_scrollView.dataSource = self;
//	[self.view addSubview:_scrollView];
//	
//	_pageControll = [[TTPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - PAGE_CONTROL_HEIGHT,
//																	self.view.bounds.size.width, PAGE_CONTROL_HEIGHT)];
//	[_pageControll addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
//	_pageControll.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//	[self.view addSubview:_pageControll];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TTScrollViewDataSource

//////////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSInteger)numberOfPagesInScrollView:(TTScrollView*)scrollView
//{
//	int numInPage = ROW_COUNT * COLUMN_COUNT;
//	int pageNum = ceil((float)_emotionArray.count / numInPage);
//	[_pageControll setNumberOfPages:pageNum];
//	return pageNum;
//}
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
//- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex
//{
//	int row = ROW_COUNT;
//	int column = COLUMN_COUNT;
//	
//	TTView* pageView = (TTView*)[scrollView dequeueReusablePage];
//	if (pageView == nil) {
//		pageView = [[[TTView alloc] initWithFrame:CGRectMake(0, 0, column * (FACE_WIDTH + SPACE),
//                                                             row * (FACE_WIDTH + SPACE))] autorelease];
//		pageView.backgroundColor = [UIColor clearColor];
//		
//		UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceTaped:)];
//		[pageView addGestureRecognizer:[gest autorelease]];
//	}
//	for (int i = 0; i < row; i++) {
//		for (int j = 0; j < column; j++) {
//			TTImageView* imgView = (TTImageView*)[pageView viewWithTag:9 + i*column +j];
//			if (row*column*pageIndex + i*column + j < _emotionArray.count) {
//				SMEmotionEntity* entity = [_emotionArray objectAtIndex:row*column*pageIndex + i*column + j];
//				if (imgView == nil) {
//					imgView = [[TTImageView alloc] initWithFrame:CGRectMake(j*(FACE_WIDTH + SPACE) + MARGIN,
//                                                                            i*(FACE_WIDTH + SPACE) + MARGIN,
//                                                                            FACE_WIDTH, FACE_WIDTH)];
//					imgView.tag = 9 + i*column +j;
//					imgView.backgroundColor = [UIColor clearColor];
//					[pageView addSubview:[imgView autorelease]];
//				}
//				[imgView unsetImage];
//				imgView.urlPath = entity.urlPath;
//			}
//			else {
//				[imgView removeFromSuperview];
//			}
//		}
//	}
//	
//	return pageView;
//}
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
//- (CGSize)scrollView:(TTScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex
//{
//	return CGSizeZero;
//}
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)scrollView:(TTScrollView*)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex
//{
//	[_pageControll setCurrentPage:pageIndex];
//}
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)pageChanged:(id)sender
//{
//	TTPageControl* ctrl = sender;
//	[_scrollView setCenterPageIndex:ctrl.currentPage];
//}
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
////todo:考虑touch move down来模拟选择
//- (void)faceTaped:(UIGestureRecognizer*)gest
//{
//	CGPoint point = [gest locationInView:_scrollView];
//    //	NSLog(@"lo: %f, %f", point.x, point.y);
//	int row = ROW_COUNT;//floor(_scrollView.bounds.size.height / FACE_WIDTH);
//	int column = COLUMN_COUNT;//floor(_scrollView.bounds.size.width / FACE_WIDTH);
//	
//	int currentRow = floor((point.y - MARGIN) / (FACE_WIDTH+SPACE));
//	int currentcolumn = floor((point.x - MARGIN) / (FACE_WIDTH + SPACE));
//#ifdef DEBUG
//    NSLog(@"row = %d, column = %d", currentRow, currentcolumn);
//#endif
//	int index = row*column*_scrollView.centerPageIndex + column* currentRow + currentcolumn;
//	if (index < _emotionArray.count) {
//		if ([self.emotionDelegate respondsToSelector:@selector(emotionSelectedWithCode:)]) {
//			[self.emotionDelegate emotionSelectedWithCode:[(SMEmotionEntity*)[_emotionArray objectAtIndex:index] code]];
//		}
//	}
//}

@end
