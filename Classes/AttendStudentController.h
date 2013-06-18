//
//  AttendStudentController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AttendStudentController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSInteger lectureNo;
    UITableView *table;
    NSArray *dataList;
    NSMutableArray *tableData;
    UISearchBar *studentSearchBar;
    BOOL inSearch;
    NSString *showAttendInfoFlag;
    NSString *lectureTitle;
}

@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UISearchBar *studentSearchBar;
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, assign) BOOL inSearch;
@property (nonatomic, retain) NSString *showAttendInfoFlag;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)bindDataList;
- (void)searchStudent:(NSString *)searchText;

@end
