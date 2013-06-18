//
//  LectureSurveyController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LectureSurveyController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *table;
    NSArray *dataList;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *dataList;

- (void)bindDataList;

@end
