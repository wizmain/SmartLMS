//
//  LectureStatController.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 17..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LectureStatController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *table;
    NSDictionary *attendInfo;
    NSInteger lectureNo;
    NSString *lectureTitle;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSDictionary *attendInfo;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)bindLectureStat;

@end
