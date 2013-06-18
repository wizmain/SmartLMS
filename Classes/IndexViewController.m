    //
//  IndexViewController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//  인덱스 홈

#import "IndexViewController.h"
#import "LoginViewController.h"
#import "SchoolHomeController.h"
#import "SmartLMSAppDelegate.h"
#import "MainViewController.h"
#import "LoginProperties.h"
#import "HTTPRequest.h"
#import "Utils.h"
#import "Constants.h"
#import "SubIndexWebController.h"
#import "AlertUtils.h"

@implementation IndexViewController

@synthesize logoImage, button1, button2, button3, button4, button5, button6;
@synthesize mainView, pageTitle, versionLabel;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
    
	mainView = [[SmartLMSAppDelegate sharedAppDelegate] mainViewController];
    
    //버전 및 학생여부 설정
    versionLabel.text = [[SmartLMSAppDelegate sharedAppDelegate] version];
    
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"indexViewController viewWillAppear");
    
    if([[SmartLMSAppDelegate sharedAppDelegate] isStudent]){
    
        [button2 setTitle:@"수업참여" forState:UIControlStateNormal];
        [button2 setTitle:@"수업참여" forState:UIControlStateHighlighted];
        [button2 setTitle:@"수업참여" forState:UIControlStateDisabled];
        [button2 setTitle:@"수업참여" forState:UIControlStateSelected];
    } else {
    
        //button2.titleLabel.text = @"수업운영";
        [button2 setTitle:@"수업운영" forState:UIControlStateNormal];
        [button2 setTitle:@"수업운영" forState:UIControlStateHighlighted];
        [button2 setTitle:@"수업운영" forState:UIControlStateDisabled];
        [button2 setTitle:@"수업운영" forState:UIControlStateSelected];
    }
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
	[logoImage release];
	[button1 release];
	[button2 release];
	[button3 release];
	[button4 release];
	[button5 release];
    [button6 release];
    [versionLabel release];
	[super dealloc];
}

#pragma mark -
#pragma mark Custom Method

- (IBAction)button1Click:(id)sender {
	[self.mainView switchTabView:0];
}


- (IBAction)button2Click:(id)sender {
    [self.mainView switchTabView:1];
}


- (IBAction)button3Click:(id)sender {
    //[self.mainView switchTabView:2];
    
    //AlertWithMessage(@"비정규강좌는 로그인이 필요합니다");
    
    SubIndexWebController *subWebView = [[SubIndexWebController alloc] initWithNibName:@"SubIndexWebController" bundle:nil];
    
    //subWebView.urlString = @"http://cyber.daelim.ac.kr:8083/lcms_mobile/login.php";
    subWebView.urlString = @"http://cyber.daelim.ac.kr:8080/go8083.jsp";
    subWebView.pageTitle = @"비정규강좌";
    UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:subWebView];
    [self presentModalViewController:naviCon animated:YES];
    //[naviController pushViewController:subWebView animated:YES];
    
    [subWebView release];
    [naviCon release];
}


- (IBAction)button4Click:(id)sender {
	[self.mainView switchTabView:2];
}

- (IBAction)button5Click:(id)sender {
	[self.mainView switchTabView:3];
}

- (IBAction)button6Click:(id)sender {
    /*
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
    [httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET"];
    
    [[SmartLMSAppDelegate sharedAppDelegate] switchLoginView];
    */
    
    SubIndexWebController *subWebView = [[SubIndexWebController alloc] initWithNibName:@"SubIndexWebController" bundle:nil];
    
    subWebView.urlString = @"http://cyber.daelim.ac.kr:8080/menual.jsp";
    subWebView.pageTitle = @"도움말";
    UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:subWebView];
    [self presentModalViewController:naviCon animated:YES];
    //[naviController pushViewController:subWebView animated:YES];
    
    [subWebView release];
    [naviCon release];
    
    
}




@end
