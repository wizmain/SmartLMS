//
//  AttendStudentInfo.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 11..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "AttendStudentInfo.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "MessageReadController.h"
#import "MainViewController.h"

@implementation AttendStudentInfo

@synthesize userID, lectureNo, attendInfo, userName, lectureTitle;
@synthesize studentNameLabel, majorLabel, hakbunLabel, attendProgress, reportProgress, etestProgress;
@synthesize attendPercentLabel, etestPercentLabel, reportPercentLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = lectureTitle;
    
    UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_middle"]];
    self.view.backgroundColor = backImg;
    [backImg release];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    /*
    UIButton *msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgButton setBackgroundImage:[UIImage imageNamed:@"msg_button"] forState:UIControlStateNormal];
    [msgButton addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    msgButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:msgButton] autorelease];
    */
    
    [self bindAttendInfo];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    self.studentNameLabel = nil;
    self.majorLabel = nil;
    self.hakbunLabel = nil;
    self.attendProgress = nil;
    self.reportProgress = nil;
    self.etestProgress = nil;
    self.lectureTitle = nil;
}

- (void)dealloc {
    [studentNameLabel release];
    [majorLabel release];
    [hakbunLabel release];
    [attendProgress release];
    [reportProgress release];
    [etestProgress release];
    [lectureTitle release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom Method

- (void)bindAttendInfo {
    NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kUserAttendInfo];
	url = [url stringByAppendingFormat:@"/%d/%@",self.lectureNo, userID];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)goIndex {
    NSLog(@"goIndex");
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

- (void)sendMsg {
    MessageReadController *messageReadController = [[MessageReadController alloc] 
                                                    initWithNibName:@"MessageReadController" 
                                                    bundle:[NSBundle mainBundle]];
    messageReadController.receiveUserID = userID;
    messageReadController.receiveUserName = userName;
    
    UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:messageReadController];
    [self presentModalViewController:naviCon animated:YES];
    
    [messageReadController release];
    [naviCon release];
}


#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	self.attendInfo = (NSDictionary *)[jsonData objectForKey:@"data"];
	NSDictionary *resultObj = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultObj) {
        NSString *resultStr = [resultObj valueForKey:@"result"];
        if(resultStr){
            if([resultStr isEqualToString:@"fail"]){
                NSLog(@"message = %@", [resultObj objectForKey:@"message"]);
                //NSString *message = [resultObj objectForKey:@"message"];
                //if(message != nil)
                //    AlertWithMessage(message);
            }
        }
        
        return;
        
	} else {
        
        NSDictionary *userInfo = [self.attendInfo objectForKey:@"userInfo"];
        
        self.studentNameLabel.text = (NSString *)[userInfo valueForKey:@"userKName"];
        self.userName = studentNameLabel.text;
        //majorLabel.text = (NSString *)[userInfo valueForKey:@""];
        self.hakbunLabel.text = (NSString *)[userInfo valueForKey:@"userID"];
        
        int attendCount = [[attendInfo valueForKey:@"attendCount"] intValue];
        int etestCount = [[attendInfo valueForKey:@"etestCount"] intValue];
        int userApplyCount = [[attendInfo valueForKey:@"userApplyCount"] intValue];
        int reportCount = [[attendInfo valueForKey:@"reportCount"] intValue];
        int submitReportCount = [[attendInfo valueForKey:@"submitReportCount"] intValue];
        int lectureItemCount = [[attendInfo valueForKey:@"lectureItemCount"] intValue];
        
        float attendPercent = 0;
        float reportPercent = 0;
        float etestPercent = 0;
        
        if(lectureItemCount > 0 && attendCount > 0){
            attendPercent = (float)attendCount / lectureItemCount;
            self.attendPercentLabel.text = [NSString stringWithFormat:@"%d %%", (int)(attendPercent*100)];
        }
        NSLog(@"attendCount = %d lectureItemCount = %d", attendCount, lectureItemCount);
        
        if(etestCount > 0 && userApplyCount > 0){
            etestPercent = (float)userApplyCount / etestCount;
            self.etestPercentLabel.text = [NSString stringWithFormat:@"%d %%", (int)(etestPercent*100)];
        }
        NSLog(@"userApplyCount = %d, etestCount = %d", userApplyCount, etestCount);
        
        if(reportCount > 0 && submitReportCount > 0){
            reportPercent = (float)submitReportCount / reportCount;
            self.reportPercentLabel.text = [NSString stringWithFormat:@"%d %%", (int)(reportPercent*100)];
        }
        NSLog(@"reportCount = %d submitReportCount = %d", reportCount, submitReportCount);
        
        NSLog(@"attendPercent = %f reportPercent = %f etestPercent = %f", attendPercent, reportPercent, etestPercent);
        
        [self.attendProgress setProgress:attendPercent];
        [self.reportProgress setProgress:reportPercent];
        [self.etestProgress setProgress:etestPercent];
        

	}
	
	[jsonParser release];
	
}

@end
