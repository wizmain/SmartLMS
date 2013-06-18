//
//  TimeTableDBManager.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 7. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeTable.h"

@interface TimeTableDBManager : NSObject

+ (TimeTable *)timeTable:(NSInteger) dayOfWeek period:(NSInteger) period;
+ (NSArray *)weekdayData:(NSInteger)dayOfWeek;
+ (Boolean)updateTimeTable:(TimeTable *)timeTable;
+ (Boolean)deleteTimeTable:(TimeTable *)timeTable;
+ (Boolean)insertTimeTable:(TimeTable *)timeTable;

@end
