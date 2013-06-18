//
//  TimeTableController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableView.h"
@class TimeTableView;

@interface TimeTableController : UIViewController<TimeTableViewDelegate, TimeTableViewDataSource> {
	TimeTableView *timeTableView;
}

@property (nonatomic, retain) IBOutlet TimeTableView *timeTableView;

@end
