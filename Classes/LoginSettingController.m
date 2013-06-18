//
//  LoginSettingController.m
//  mClass
//
//  Created by 김규완 on 11. 1. 24..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  로그인 설정

#import "LoginSettingController.h"
#import "LoginProperties.h"
#import "Utils.h"
#import "AlertUtils.h"

@implementation LoginSettingController

@synthesize table, userID, password, autoLogin, loginProperties;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table.backgroundColor = [UIColor clearColor];
    //제목설정
	self.navigationItem.title = @"로그인설정";
    
    self.navigationItem.hidesBackButton = YES;
    
    //뒤로 버튼 설정
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //저장버튼 설정
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"nav_save"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    //로그인설정
	self.loginProperties = [Utils loginProperties];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[table release];
	[userID release];
	[password release];
	[autoLogin release];
	[loginProperties release];
    [super dealloc];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *loginIDCellIdentifier = @"LoginIDCell";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loginIDCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:loginIDCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		if ([indexPath section] == 0) {
			if ([indexPath row]==0 ){
				UITextField *userIDField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
				userIDField.adjustsFontSizeToFitWidth = YES;
				userIDField.textColor = [UIColor blackColor];
				if ([indexPath section] == 0) { // Email & Password Section
					if ([indexPath row] == 0) {
						userIDField.placeholder = @"아이디";
						userIDField.keyboardType = UIKeyboardTypeEmailAddress;
						userIDField.returnKeyType = UIReturnKeyNext;
					}
					else {
						userIDField.placeholder = @"비밀번호";
						userIDField.keyboardType = UIKeyboardTypeDefault;
						userIDField.returnKeyType = UIReturnKeyDone;
						userIDField.secureTextEntry = YES;
					}
				}
				userIDField.backgroundColor = [UIColor whiteColor];
				userIDField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
				userIDField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
				userIDField.textAlignment = UITextAlignmentLeft;
				userIDField.tag = 0;
				//playerTextField.delegate = self;
				
				userIDField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
				[userIDField setEnabled: YES];
				if (self.loginProperties != nil) {
					if ([self.loginProperties userID] != nil) {
						userIDField.text = [self.loginProperties userID];
					}
				}
				self.userID = userIDField;
				[cell addSubview:self.userID];

				[userIDField release];
			} else if ([indexPath row]==1 ){
				UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
				passwordField.adjustsFontSizeToFitWidth = YES;
				passwordField.textColor = [UIColor blackColor];
				if ([indexPath section] == 0) { // Email & Password Section
					if ([indexPath row] == 0) {
						passwordField.placeholder = @"아이디";
						passwordField.keyboardType = UIKeyboardTypeEmailAddress;
						passwordField.returnKeyType = UIReturnKeyNext;
					}
					else {
						passwordField.placeholder = @"비밀번호";
						passwordField.keyboardType = UIKeyboardTypeDefault;
						passwordField.returnKeyType = UIReturnKeyDone;
						passwordField.secureTextEntry = YES;
					}
				}
				passwordField.backgroundColor = [UIColor whiteColor];
				passwordField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
				passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
				passwordField.textAlignment = UITextAlignmentLeft;
				passwordField.tag = 0;
				//playerTextField.delegate = self;
				
				passwordField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
				[passwordField setEnabled: YES];
				if (self.loginProperties != nil) {
					if ([self.loginProperties password] != nil) {
						passwordField.text = [self.loginProperties password];
					}
				}
				self.password = passwordField;
				[cell addSubview:self.password];
				[passwordField release];
				
			} else if ([indexPath row]==2) {
				UISwitch *autoLoginSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
				
				if (self.loginProperties != nil) {
					if ([self.loginProperties autoLogin] != nil) {
						if ([[self.loginProperties autoLogin] isEqualToString:@"YES"]) {
							[autoLoginSwitch setOn:YES];
						} else {
							[autoLoginSwitch setOn:NO];
						}
					}
				}
				
				self.autoLogin = autoLoginSwitch;
				
				[cell addSubview:self.autoLogin];
				
				[autoLoginSwitch release];
			}
		}
	}
	if ([indexPath section] == 0) { // Email & Password Section
		if ([indexPath row] == 0) { // Email
			cell.textLabel.text = @"아이디";
		}
		else if ([indexPath row] == 1) {
			cell.textLabel.text = @"비밀번호";
		} else if ([indexPath row] == 2) {
			cell.textLabel.text = @"자동로그인";
		} 
	}
	else { // Login button section
		cell.textLabel.text = @"Log in";
	}
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
}

#pragma mark -
#pragma mark Custom Method 

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveSettingClick:(id)sender {
	
	LoginProperties *loginProp = [[LoginProperties alloc] init];
	
	[loginProp setUserID:self.userID.text];
	[loginProp setPassword:self.password.text];
	
	if (self.autoLogin.on) {
        NSLog(@"autologin on");
		[loginProp setAutoLogin:@"YES"];
	} else {
		[loginProp setAutoLogin:@"NO"];
	}
	
	//로그인 설정 저장
	[Utils saveLoginProperties:loginProp];
	
	AlertWithMessage(@"저장 되었습니다");
}


@end
