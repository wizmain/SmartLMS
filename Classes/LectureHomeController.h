//
//  LectureHomeController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingProperties;

@interface LectureHomeController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *lectureTable;
	NSArray *lectureList;
	SettingProperties *setting;
    NSString *year;
    NSString *term;
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) IBOutlet UITableView *lectureTable;
@property (nonatomic, retain) NSArray *lectureList;
@property (nonatomic, retain) SettingProperties *setting;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *term;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

- (void)bindLectureList;
- (void)setDefaultYearTerm;
- (void)didReceiveFinished:(NSString *)result;

@end
