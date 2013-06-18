//
//  LoginSettingController.h
//  mClass
//
//  Created by 김규완 on 11. 1. 24..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginProperties;

@interface LoginSettingController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
	UITextField *userID;
	UITextField *password;
	UISwitch *autoLogin;
	LoginProperties *loginProperties;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) UITextField *userID;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UISwitch *autoLogin;
@property (nonatomic, retain) LoginProperties *loginProperties;

- (void)saveSettingClick:(id)sender;

@end
