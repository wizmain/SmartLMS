//
//  Settings.h
//  mClass
//
//  Created by 김규완 on 11. 1. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
- (void)goIndex;
- (IBAction)logout:(id)sender;

@end
