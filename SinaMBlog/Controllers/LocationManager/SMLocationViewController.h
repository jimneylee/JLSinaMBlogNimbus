//
//  LocationViewController.h
//  MapKitTest
//
//  Created by jimney on 13-3-20.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BMapKit.h"

@protocol StreetPlaceLocationDelegate <NSObject>
- (void)deleteStreetPlace;
- (void)locationUpdatedWithLatitude:(double)latitude
                          longitude:(double)longitude
                        streetPlace:(NSString*)streetPlace;
@end

@interface SMLocationViewController : UIViewController<MKMapViewDelegate,
                                                     BMKSearchDelegate,
                                                     BMKMapViewDelegate,
                                                     BMKAnnotation>
- (id)initWithDelegate:(id)delegate;

@property(nonatomic, assign) id<StreetPlaceLocationDelegate> delegate;

@end
