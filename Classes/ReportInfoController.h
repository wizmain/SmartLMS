//
//  ReportInfoController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReportInfoController : UIViewController<UITableViewDelegate, UITableViewDelegate> {
    UITableView *table;
    NSInteger reportNo;
    NSDictionary *report;
    NSString *lectureTitle;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, assign) NSInteger reportNo;
@property (nonatomic, retain) NSDictionary *report;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)bindReportInfo;

@end
