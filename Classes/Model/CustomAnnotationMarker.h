//
//  CustomAnnotationMarker.h
//  mClass
//
//  Created by 김규완 on 11. 1. 6..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotationMarker : NSObject <MKAnnotation> {

	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	NSString *buildingName;
	NSString *telephone;
	NSString *address;
	
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *buildingName;
@property (nonatomic, retain) NSString *telephone;
@property (nonatomic, retain) NSString *address;


@end
