//
//  TimeTableView2.h
//  SmartLMS
//
//  Created by 김규완 on 11. 7. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableEditView.h"


@interface TimeTableView2 : UIViewController<UINavigationControllerDelegate> {
    UITableView *table;
    UITableViewCell *tableCell;
    NSArray *timeTableData;
    NSInteger dayOfWeek;
    UISegmentedControl *weekdaySegment;
    TimeTableEditView *editView;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UITableViewCell *tableCell;
@property (nonatomic, retain) IBOutlet UISegmentedControl *weekdaySegment;

@property (nonatomic, assign) NSInteger dayOfWeek;
@property (nonatomic, retain) NSArray *timeTableData;


- (NSString *)applicationDocumentsDirectory;
- (void)bindTimeTable;
- (void)changeWeekday:(id)sender;

@end
