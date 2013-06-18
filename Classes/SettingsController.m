//
//  Settings.m
//  mClass
//
//  Created by 김규완 on 11. 1. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  설정 컨트롤러

#import "SettingsController.h"
#import "LoginSettingController.h"
#import "LectureTermController.h"
#import "LoginProperties.h"
#import "Utils.h"
#import "SmartLMSAppDelegate.h"
#import "MainViewController.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "CustomNavigationBar.h"

@implementation SettingsController

@synthesize table;

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
	//타이틀 설정
	self.navigationItem.title = @"설정";
    self.table.backgroundColor = [UIColor clearColor];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *image = [UIImage imageNamed:@"navigation_back"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    
    //UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(goIndex)];
    //self.navigationItem.rightBarButtonItem = homeButton;
    //[homeButton release];
    
    //홈버튼 설정
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    
    
    
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
    [super dealloc];
}

- (void)goIndex {
    NSLog(@"goIndex");
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

- (void)logout:(id)sender {
    
    AlertWithMessageAndDelegate(@"로그아웃 후에 프로그램이 종료됩니다", self);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"설정";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		cell.textLabel.text = @"로그인설정";
	} else if (row == 1) {
		cell.textLabel.text = @"학기설정";
	} else if (row == 2 ) {
        
        cell.textLabel.text = @"로그아웃";
    }
	/*
	if (self.messageList != nil) {
		
		if(messageList.count > 0){
			NSDictionary *message = [self.messageList objectAtIndex:row];
			long long time = [[NSString stringWithFormat:@"%@",[message objectForKey:@"sendDate"]] longLongValue];
			time = time / 1000;
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd"];
			NSString *label = [[message objectForKey:@"msgTitle"] stringByAppendingFormat:@" (%@)",[dateFormat stringFromDate:date]];
			cell.textLabel.text = label;
		}
	}
	*/
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		LoginSettingController *loginSetting = [[LoginSettingController alloc] initWithNibName:@"LoginSettingController" bundle:nil];
		[self.navigationController pushViewController:loginSetting animated:YES];
		[loginSetting release];
	} else if (row == 1) {
		LectureTermController *term = [[LectureTermController alloc] initWithNibName:@"LectureTermController" bundle:nil];
		[self.navigationController pushViewController:term animated:YES];
		[term release];
	} else if (row == 2) {
        //AlertWithMessageAndDelegate(@"로그아웃 후에 프로그램이 종료됩니다", self);
        
        
    }
	
}

#pragma mark -
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// use "buttonIndex" to decide your action
	//
	NSLog(@"button Index %d", buttonIndex);
	
	if (buttonIndex == 0) {//cancel
        
        
		
	} else {//ok
		
        LoginProperties *loginProperties = [[LoginProperties alloc] init];
        [loginProperties setAutoLogin:@"NO"];
        [loginProperties setSaveUserID:nil];
        [loginProperties setPassword:nil];
        [Utils saveLoginProperties:loginProperties];
        
        NSString *url = [kServerUrl stringByAppendingString:kLogoutUrl];
        HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
        NSLog(@"url = %@", url);
        //통신완료 후 호출할 델리게이트 셀렉터 설정
        [httpRequest setDelegate:nil selector:nil];
        [httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
        
        
        exit(0);
        
        
        //[[SmartLMSAppDelegate sharedAppDelegate] setIsAuthenticated:NO];
        //[[SmartLMSAppDelegate sharedAppDelegate] setAuthGroup:@""];
        //[[SmartLMSAppDelegate sharedAppDelegate] initMainView];
        //[[SmartLMSAppDelegate sharedAppDelegate] switchLoginView];
	}
    
}

@end
