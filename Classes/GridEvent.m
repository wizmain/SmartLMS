//
//  WizGridEvent.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridEvent.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

static const unsigned int MINUTES_IN_HOUR                = 60;
static const unsigned int DAY_IN_MINUTES                 = 1440;
static const unsigned int MIN_EVENT_DURATION_IN_MINUTES  = 30;

NSInteger GridEvent_sortByStartTime(id ev1, id ev2, void *keyForSorting) {
	GridEvent *event1 = (GridEvent *)ev1;
	GridEvent *event2 = (GridEvent *)ev2;
	
	//int v1 = [event1 minutesSinceMidnight];
	//int v2 = [event2 minutesSinceMidnight];
	int v1 = [event1 period];
	int v2 = [event2 period];
	
	if (v1 < v2) {
		return NSOrderedAscending;
	} else if (v1 > v2) {
		return NSOrderedDescending;
	} else {
		/* Event start time is the same, compare by duration.
		 */
		int d1 = [event1 durationInMinutes];
		int d2 = [event2 durationInMinutes];
		
		if (d1 < d2) {
			/*
			 * Event with a shorter duration is after an event
			 * with a longer duration. Looks nicer when drawing the events.
			 */
			return NSOrderedDescending;
		} else if (d1 > d2) {
			return NSOrderedAscending;
		} else {
			/*
			 * The last resort: compare by title.
			 */
			return [event1.title compare:event2.title];
		}
	}
}




@implementation GridEvent

@synthesize title=_title;
@synthesize start=_start;
@synthesize end=_end;
@synthesize displayDate=_displayDate;
@synthesize allDay=_allDay;
@synthesize backgroundColor=_backgroundColor;
@synthesize textColor=_textColor;
@synthesize userInfo=_userInfo;
@synthesize weekday=_weekday;
@synthesize period=_period;

#define DATE_CMP(X, Y) ([X year] == [Y year] && [X month] == [Y month] && [X day] == [Y day])

- (unsigned int)minutesSinceMidnight {
	unsigned int fromMidnight = 0;
	
	NSDateComponents *displayComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:_displayDate];
	NSDateComponents *startComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:_start];
	
	if (DATE_CMP(startComponents, displayComponents)) {
		fromMidnight = [startComponents hour] * MINUTES_IN_HOUR + [startComponents minute];
	}
	
	/* The minimum duration for an event is 30 minutes because of the grid size.
	 * If the event starts, say, 23:59, adjust the start time to 23:30.
	 */
	int d = DAY_IN_MINUTES - MIN_EVENT_DURATION_IN_MINUTES;
	if (fromMidnight > d) {
		fromMidnight = d;
	}
	return fromMidnight;
}

- (unsigned int)durationInMinutes {
	unsigned int duration = 0;
	
	NSDateComponents *displayComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:_displayDate];
	NSDateComponents *startComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:_start];
	NSDateComponents *endComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:_end];
	
	if (DATE_CMP(endComponents, displayComponents)) {
		if (DATE_CMP(startComponents, displayComponents)) {
			duration = (int) (([_end timeIntervalSince1970] - [_start timeIntervalSince1970]) / (double) MINUTES_IN_HOUR);
		} else {
			duration = [endComponents hour] * MINUTES_IN_HOUR + [endComponents minute];
		}
		
		// The minimum duration is 30 minutes because of the grid size.
		if (duration < MIN_EVENT_DURATION_IN_MINUTES)
			duration = MIN_EVENT_DURATION_IN_MINUTES;
	} else {
		// No need to check the minimum duration here because minutesSinceMidnight adjusts the start time.
		duration = DAY_IN_MINUTES - [self minutesSinceMidnight];
	}
	return duration;
}

#undef DATE_CMP

- (void)dealloc {
	self.title = nil;
	self.start = nil;
	self.end = nil;
	self.displayDate = nil;
	self.backgroundColor = nil;
	self.textColor = nil;
	self.userInfo = nil;
	[super dealloc];
}

@end
