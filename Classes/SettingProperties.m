//
//  SettingProperties.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingProperties.h"


@implementation SettingProperties

@synthesize termYear, termCode;


#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aEncoder{
	[aEncoder encodeObject:termYear forKey:kTermYearKey];
	[aEncoder encodeObject:termCode forKey:kTermCodeKey];
	
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super init]) {
		self.termYear = [aDecoder decodeObjectForKey:kTermYearKey];
		self.termCode = [aDecoder decodeObjectForKey:kTermCodeKey];

	}
	return self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
	SettingProperties *copy = [[[self class] allocWithZone:zone] init];
	copy.termYear = [[self.termYear copyWithZone:zone] autorelease];
	copy.termCode = [self.termCode copyWithZone:zone];

	return copy;
}

@end
