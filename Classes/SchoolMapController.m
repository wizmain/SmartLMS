//
//  SchoolMapController.m
//  mClass
//
//  Created by 김규완 on 11. 1. 6..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SchoolMapController.h"
#import "CustomAnnotationMarker.h"
#import "AlertUtils.h"
#import "mClassAppDelegate.h"
#import "MainViewController.h"

@implementation SchoolMapController

@synthesize mapView, mapType;
@synthesize geoCoder, locationManager, recentLocation, spinner, geoLabel;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"스쿨맵";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" 
																			  style:UIBarButtonItemStyleBordered
																			 target:self 
																			 action:@selector(goHome)];
	
	//spinner 설정
	self.spinner = [[UIActivityIndicatorView alloc]
					initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[self.spinner setCenter:CGPointMake(320.0f/2.0, 480.0f/2.0)];
	[self.view addSubview:spinner];
	
	[self.spinner startAnimating];
	
	//locationManager설정
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];//초기화
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//정확도 설정
	self.locationManager.distanceFilter = 2000.0f;//2000m이상 변경되면 noti
	
	//[self.locationManager startUpdatingLocation];//현재 위치 가져오기 시작 
	
	//mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
	[mapView setShowsUserLocation:YES];
	mapView.mapType = MKMapTypeStandard;//, MKMapTypeSatellite, MKMapTypeHybrid
	mapView.delegate = self;
	mapView.zoomEnabled = YES;
	mapView.scrollEnabled = YES;
	
	/*Region and Zoom */
	MKCoordinateRegion region;
	MKCoordinateSpan span;//보여줄 지도의 넓이 설정 한마디로 zoom
	span.latitudeDelta = 0.002;//숫자가 적을 수록 zoom in
	span.longitudeDelta = 0.002;
	
	CLLocationCoordinate2D location = mapView.userLocation.coordinate;
	location.latitude = 37.403601;
	location.longitude = 126.929635;
	
	CLLocationCoordinate2D location2 = mapView.userLocation.coordinate;
	location2.latitude = 37.402393;
	location2.longitude = 126.930381;
	
	region.span = span;
	region.center = location;
	
	[mapView setRegion:region animated:YES];
	[mapView regionThatFits:region];
	
	/*Reverse Geocoder Stuff*/
	geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:location];
	geoCoder.delegate = self;
	[geoCoder start];
	
	//maker 설정
	
	CustomAnnotationMarker *marker1 = [[CustomAnnotationMarker alloc] init];
	CLLocationCoordinate2D coordinate1;
    coordinate1.latitude = 37.403601;
    coordinate1.longitude = 126.929635;
	[marker1 setCoordinate:coordinate1];
	[marker1 setBuildingName:@"건물1"];
	CustomAnnotationMarker *marker2 = [[CustomAnnotationMarker alloc] init];
	CLLocationCoordinate2D coordinate2;
    coordinate2.latitude = 37.402393;
    coordinate2.longitude = 126.930381;
	[marker2 setCoordinate:coordinate2];
	[marker2 setBuildingName:@"건물2"];
	//지도에 마커넣기
	[mapView addAnnotation:marker1];
	[mapView addAnnotation:marker2];
	
	[marker1 release];
	[marker2 release];
	
	
	
	float heightPos = self.view.bounds.size.height;
	/*
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, heightPos - 150.0f, 320.0, 50.0)];
	
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	UIBarButtonItem *flexibleBarItem = [[UIBarButtonItem alloc] 
										initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
										target:nil 
										action:nil];
	UIBarButtonItem *hereButton = [[UIBarButtonItem alloc] 
								   initWithTitle:@"현위치" 
								   style:UIBarButtonSystemItemBookmarks 
								   target:self 
								   action:@selector(setHere:)];
	toolbar.items = [NSArray arrayWithObjects:flexibleBarItem, hereButton, nil];
	
	[self.view addSubview:toolbar];
	
	[flexibleBarItem release];
	[hereButton release];
	[toolbar release];
	*/
	
	
	geoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, heightPos - 150.0f, 160.0, 40.0)];
	geoLabel.backgroundColor = [UIColor clearColor];
	geoLabel.highlighted = YES;
	geoLabel.highlightedTextColor = [UIColor whiteColor];
	geoLabel.shadowColor = [UIColor blackColor];
	geoLabel.textColor = [UIColor whiteColor];
	geoLabel.textAlignment = UITextAlignmentLeft;
	geoLabel.numberOfLines = 2;
	[self.view addSubview:geoLabel];
	
	[self.spinner stopAnimating];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[self.locationManager stopUpdatingLocation];
	self.locationManager = nil;
	self.geoCoder = nil;
	self.mapView =  nil;
	self.recentLocation = nil;
	self.spinner = nil;
}


- (void)dealloc {
	[mapView release];
	[geoCoder release];
	[locationManager release];
	[recentLocation release];
	[spinner release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Methods
- (IBAction)changeMapType:(id)sender {
	
	NSLog(@"changeMapType index = %d", mapType.selectedSegmentIndex);
	
	if (mapType.selectedSegmentIndex == 0) {
		mapView.mapType = MKMapTypeStandard;
		[self.locationManager stopUpdatingLocation];
	} else if (mapType.selectedSegmentIndex == 1) {
		mapView.mapType = MKMapTypeSatellite;
		[self.locationManager stopUpdatingLocation];
	} else if (mapType.selectedSegmentIndex == 2) {
		mapView.mapType = MKMapTypeHybrid;
		[self.locationManager stopUpdatingLocation];
	} else if (mapType.selectedSegmentIndex == 3) {
		[self.locationManager startUpdatingLocation];
	}
}

- (void)setHere:(id)sender {
	[self.locationManager startUpdatingLocation];
}

- (void)goHome {
	[[[mClassAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

#pragma mark -
#pragma mark Geocoder delegate
//reverse geoCoder 실패시
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	NSLog(@"Reverse Geocoder Errored");
}
//reverse geoCoder  성공 
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	NSLog(@"Reverse Geocoder completed");
	
	if (geoLabel != nil) {
		NSString *geoString = @"";
		if (placemark.locality != nil) {
			geoString = [[geoString stringByAppendingString:placemark.locality] stringByAppendingString:@" "];
		}
		
		if (placemark.subLocality != nil) {
			geoString = [[geoString stringByAppendingString:placemark.subLocality] stringByAppendingString:@"\n"];
		}
		
		if (placemark.thoroughfare != nil) {
			geoString = [geoString stringByAppendingString:placemark.thoroughfare];
		}
		
		if ([geoString length] < 1 && placemark.country != nil) {
			geoString = placemark.country;
		}
		geoLabel.text = geoString;
	}
	//mPlacemark = placemark;
	//[mapView addAnnotation:placemark];
}


#pragma mark -
#pragma mark annotation delegate
//annotation 표시
- (MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id <MKAnnotation>) annotation {
	//MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentLocation"];
	//annView.animatesDrop = YES;
	//return annView;
	
	if (annotation == self.mapView.userLocation) {
		[mView.userLocation setTitle:@"현재위치"];
		return nil;
	}
	
	//CustomAnnotationMarker *mk = (CustomAnnotationMarker *)annotation;
	MKPinAnnotationView *dropPin = nil;
	static NSString *reusePinID = @"customPin";
	dropPin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusePinID];
	
	if (dropPin == nil) {
		dropPin = [[[MKPinAnnotationView alloc]
					initWithAnnotation:annotation reuseIdentifier:reusePinID] autorelease];
	}
	
	dropPin.animatesDrop = YES;
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	dropPin.userInteractionEnabled = YES;
	dropPin.canShowCallout = YES;
	dropPin.rightCalloutAccessoryView = infoButton;
	
	dropPin.pinColor = MKPinAnnotationColorGreen;
	dropPin.leftCalloutAccessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green.png"]] autorelease];
	
	return dropPin;
}

//annotation 더보기 
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	CustomAnnotationMarker *mk = (CustomAnnotationMarker *)view.annotation;
	
	AlertWithMessage([mk.title stringByAppendingString:@"\n"]);
	
}

#pragma mark -
#pragma mark LocatoinManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation *)oldLocation {
	NSString *info = [NSString stringWithFormat:@"didUpdateToLocation: Latitude = %f, longitude = %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
	NSLog(@"%@", info);
	
	MKCoordinateRegion region;
	region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
	MKCoordinateRegion adjustedRegion = [mapView regionThatFits:region];
	[mapView setRegion:adjustedRegion animated:YES];
	
	self.recentLocation = newLocation;
	
	[self.locationManager stopUpdatingLocation];

}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"locationManager error !!!");
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"위치기반 지점찾기" message:@"현재위치를 검색할수 없습니다.\n설정 > 일반 > 위치서비스 가 활성화 되어있는지 확인해주세요.\n\n위치정보를 가져올수 없어도 하단의 아이콘을 통하여 현재 지도의\n영업점/ATM 위치는 검색하실수\n있습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
	[alert show];
	[alert release];
}


@end
