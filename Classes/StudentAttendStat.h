//
//  StduentAttendStat.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentAttendStat : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *table;
    NSArray *tableData;
    NSInteger lectureNo;
    NSInteger itemNo;
    NSString *lectureTitle;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet NSArray *tableData;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, assign) NSInteger itemNo;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)requestStduentAttendStat;
    
@end
