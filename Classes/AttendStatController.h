//
//  AttendStatController.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 23..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendStatController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    UITableView *table;
    NSArray *tableData;
    NSInteger lectureNo;
    NSInteger studentCount;
    NSString *lectureTitle;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet NSArray *tableData;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, assign) NSInteger studentCount;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)requestAttendStat;

@end
