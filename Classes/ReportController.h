//
//  ReportController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 8..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReportController : UIViewController {
    NSInteger lectureNo;
    UITableView *table;
    NSArray *reportList;
    BOOL isStudent;
    NSString *lectureTitle;
}

@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *reportList;
@property (nonatomic, assign) BOOL isStudent;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)bindReportList;
@end
