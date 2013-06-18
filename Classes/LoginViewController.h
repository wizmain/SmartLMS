//
//  mClassViewController.h
//  mClass
//
//  Created by 김규완 on 10. 11. 30..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressIndicator.h"
@class LoginProperties;

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
	UITextField *txtUserID;
	UITextField *txtPassword;
	UISwitch *swSaveID;
	UISwitch *swAutoLogin;
	UIButton *loginButton;
    UILabel *versionLabel;
	ProgressIndicator *spinner;
	LoginProperties *loginProperties;
}

@property (nonatomic, retain) IBOutlet UITextField *txtUserID;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet UISwitch *swSaveID;
@property (nonatomic, retain) IBOutlet UISwitch *swAutoLogin;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;
@property (nonatomic, retain) LoginProperties *loginProperties;

- (IBAction)loginButtonPressed:(id)sender;
- (void)loginProcess;
- (void)didReceiveFinished:(NSString *)result;
@end

