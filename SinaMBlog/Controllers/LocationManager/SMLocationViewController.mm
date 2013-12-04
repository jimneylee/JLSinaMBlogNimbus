//
//  LocationViewController.m
//  SinaMBLog
//
//  Created by jimney on 13-3-20.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "SMLocationViewController.h"

@interface SMLocationViewController()
@property(nonatomic, strong) MKMapView* mapView;
@property(nonatomic, strong) BMKMapView* bMapView;
@property(nonatomic, strong) BMKSearch* bmkSearch;
@end

@implementation SMLocationViewController

- (id)initWithDelegate:(id)delegate
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }
    return self;
}

- (void)setRightBarButtonItemWithActivityIndicator
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
}

- (void)setRightBarButtonItemWithDeleteButton
{
    UIImage* image = [UIImage nimbusImageNamed:@"navigationbar_button_delete_background.png"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    UIButton* deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 68.f, 30.f)];
    [deleteBtn setBackgroundImage:image forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除位置" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    [deleteBtn addTarget:self action:@selector(deleteStreetPlace)
        forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bMapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.bMapView.scrollEnabled = YES;
    self.bMapView.delegate = self;
    self.bMapView.zoomLevel = 15;
    [self.view addSubview:self.bMapView];
    self.bMapView.showsUserLocation = YES;
        
    [self setRightBarButtonItemWithActivityIndicator];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView {    
    if (!_bmkSearch) {
        _bmkSearch = [[BMKSearch alloc] init];
        _bmkSearch.delegate = self;
    }
    
    [_bmkSearch reverseGeocode:mapView.userLocation.coordinate];
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation {
    if (userLocation.location.horizontalAccuracy < 100.f) {
        self.bMapView.showsUserLocation = NO;
    }
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        [self locationUpdated:result.geoPt streetPlace:result.strAddr];
	} else {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"定位出现错误!"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	static NSString *AnnotationViewID = @"annotationViewID";
	
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
	
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
	annotationView.canShowCallout = TRUE;
    [annotationView setSelected:YES animated:YES];
    return annotationView;
}

#pragma mark Private
- (void)deleteStreetPlace
{
    if ([self.delegate respondsToSelector:@selector(deleteStreetPlace)]) {
        [self.delegate deleteStreetPlace];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark LocationDelegate
- (void)locationUpdated:(CLLocationCoordinate2D)coordinate streetPlace:(NSString*)streetPlace
{
    BMKCoordinateRegion _region =
    BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.01, 0.01));
    [self.bMapView setRegion:_region animated:YES];
    
    
    NSArray* array = [NSArray arrayWithArray:self.bMapView.annotations];
    [self.bMapView removeAnnotations:array];
    
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = coordinate;
    item.title = streetPlace;
    [self.bMapView addAnnotation:item];
    
    [self setRightBarButtonItemWithDeleteButton];
    
    [self.delegate locationUpdatedWithLatitude:coordinate.latitude
                                     longitude:coordinate.longitude
                                   streetPlace:streetPlace];
}

@end
