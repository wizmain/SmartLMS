//
//  WizGridEvent.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
NSInteger GridEvent_sortByStartTime(id ev1, id ev2, void *keyForSorting);

@interface GridEvent : NSObject {
	NSString *_title;
	NSDate *_start;
	NSDate *_end;
	NSDate *_displayDate;
	BOOL _allDay;
	NSInteger _weekday;
	NSInteger _period;
	
	UIColor *backgroundColor;
	UIColor *textColor;
	
	NSDictionary *userInfo;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSDate *start;
@property (nonatomic,copy) NSDate *end;
@property (nonatomic,copy) NSDate *displayDate;
@property (readwrite,assign) BOOL allDay;
@property (nonatomic,retain) UIColor *backgroundColor;
@property (nonatomic,retain) UIColor *textColor;
@property (nonatomic,retain) NSDictionary *userInfo;
@property (nonatomic,assign) NSInteger weekday;
@property (nonatomic,assign) NSInteger period;

- (unsigned int)durationInMinutes;
- (unsigned int)minutesSinceMidnight;

@end
