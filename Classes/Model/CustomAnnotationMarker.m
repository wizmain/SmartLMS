//
//  CustomAnnotationMarker.m
//  mClass
//
//  Created by 김규완 on 11. 1. 6..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomAnnotationMarker.h"


@implementation CustomAnnotationMarker

@synthesize buildingName, telephone, address, coordinate;

- (NSString *)title {
	return title;
}

- (NSString *)subtitle {
	return subtitle;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	coordinate = newCoordinate;
}

- (void)dealloc {
	[buildingName release];
	[telephone release];
	[address release];
	[super dealloc];
}

@end
