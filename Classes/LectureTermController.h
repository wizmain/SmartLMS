//
//  LectureTermController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  학기설정

#import <UIKit/UIKit.h>
@class SettingProperties;

@interface LectureTermController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
	NSMutableArray *termList;
	SettingProperties *setting;
    UIImage *uncheckedImage;
    UIImage *checkedImage;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *termList;
@property (nonatomic, retain) SettingProperties *setting;
@property (nonatomic, retain) UIImage *uncheckedImage;
@property (nonatomic, retain) UIImage *checkedImage;

-(void)saveProperties:(id)sender;
-(void)reloadProperties:(id)sender;

@end
