//
//  QuizStatController.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 24..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizStatController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *table;
    NSArray *tableData;
    NSInteger studentCount;
    NSInteger lectureNo;
    NSString *lectureTitle;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet NSArray *tableData;
@property (nonatomic, assign) NSInteger studentCount;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)requestETestStat;

@end
