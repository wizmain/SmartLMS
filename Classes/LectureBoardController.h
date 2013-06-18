//
//  LectureBoardController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LectureBoardController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *table;
    NSInteger lectureNo;
    NSString *lectureTitle;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) NSString *lectureTitle;

@end
