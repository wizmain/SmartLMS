//
//  SchoolMapController.h
//  mClass
//
//  Created by 김규완 on 11. 1. 6..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SchoolMapController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MKReverseGeocoderDelegate> {
	IBOutlet MKMapView *mapView;
	MKReverseGeocoder *geoCoder;
	CLLocationManager *locationManager;
	CLLocation *recentLocation;
	UILabel *geoLabel;
	MKPlacemark *mPlacemark;
	IBOutlet UISegmentedControl *mapType;
	UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UISegmentedControl *mapType;
@property (nonatomic, retain) MKReverseGeocoder *geoCoder;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *recentLocation;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UILabel *geoLabel;

- (IBAction)changeMapType:(id)sender;
- (void)goHome;

@end
