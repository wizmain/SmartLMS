//
//  LectureSurveyController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LectureSurveyController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Constants.h"
#import "LectureSurveyApplyController.h"
#import "MainViewController.h"

@implementation LectureSurveyController

@synthesize table, dataList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [table release];
    [dataList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    table.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.title = @"강의만족도";
    
    self.navigationItem.hidesBackButton = YES;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    
    [self bindDataList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.dataList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Custom Method


- (void)goIndex {
    NSLog(@"goIndex");
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bindDataList {
    
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kLectureSurveyUrl];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (void)reloadReportTable{
	[self.table reloadData];
}


#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	self.dataList = (NSArray *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
        
	}
	
	[jsonParser release];
	
    [table reloadData];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"강의만족도";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	
	if (cell == nil) {
		UIImage *img = [UIImage imageNamed:@"166-Drawing"];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		[cell.imageView setImage:img];
        cell.textLabel.textColor = UIColorFromRGB(kValueTextColor);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.dataList != nil) {
		
		if(self.dataList.count > 0){
			NSDictionary *item = [self.dataList objectAtIndex:row];
			cell.textLabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"title"]];
			
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"yyyy-MM-dd"];

            long long submitStartTime = [[NSString stringWithFormat:@"%@",[item objectForKey:@"startDate"]] longLongValue];
            
            submitStartTime = submitStartTime / 1000;
            NSDate *submitStartDate = [NSDate dateWithTimeIntervalSince1970:submitStartTime];
            
            long long submitCloseTime = [[NSString stringWithFormat:@"%@",[item objectForKey:@"closeDate"]] longLongValue];
            
            submitCloseTime = submitCloseTime / 1000;
            NSDate *submitCloseDate = [NSDate dateWithTimeIntervalSince1970:submitCloseTime];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ~ %@", [dateFormat stringFromDate:submitStartDate], [dateFormat stringFromDate:submitCloseDate]];
            
			
		}
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
	NSDictionary *item = [self.dataList objectAtIndex:row];
    
    LectureSurveyApplyController *apply = [[LectureSurveyApplyController alloc] initWithNibName:@"LectureSurveyApplyController" bundle:nil];
	
	apply.surveyNo = [[NSString stringWithFormat:@"%@",[item valueForKey:@"surveyNo"]] intValue];
	
	UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:apply];
	naviCon.toolbarHidden = NO;
	
		
	[self presentModalViewController:naviCon animated:NO];
	
	
	//[[mClassAppDelegate sharedAppDelegate] switchView:applyQuiz.view];
	//[[mClassAppDelegate sharedAppDelegate] switchView:nil];
	
	[apply release];
	[naviCon release];
	
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	//NSUInteger row = [indexPath row];
	
	//NSDictionary *item = [self.dataList objectAtIndex:row];
	
}


@end
