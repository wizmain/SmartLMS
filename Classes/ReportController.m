//
//  ReportController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 8..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReportController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Constants.h"
#import "ReportInfoController.h"
#import "MainViewController.h"

@implementation ReportController

@synthesize lectureNo, table, reportList, isStudent, lectureTitle;

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
    [reportList release];
    [lectureTitle release];
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
    
    self.navigationItem.title = lectureTitle;
    
    self.navigationItem.hidesBackButton = YES;
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
    
    isStudent = [[SmartLMSAppDelegate sharedAppDelegate] isStudent];
    
    [self bindReportList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.reportList = nil;
    self.lectureTitle = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Custom Method

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)goIndex {
    NSLog(@"goIndex");
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

- (void)bindReportList {
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kReportListUrl];
	url = [url stringByAppendingFormat:@"/%d",self.lectureNo];
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
	
	self.reportList = (NSArray *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
		for (int i=0; i<self.reportList.count; i++) {
			//NSDictionary *item = (NSDictionary *)[self.reportList objectAtIndex:i];
			//NSLog(@"ItemName = %@", [item objectForKey:@"reportNm"]);
		}
	}
	
	[jsonParser release];
	
    [self.table reloadData];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.reportList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"과제목록";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	
	if (cell == nil) {
		UIImage *img = [UIImage imageNamed:@"220-Documents"];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		[cell.imageView setImage:img];
        cell.textLabel.textColor = UIColorFromRGB(kValueTextColor);
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.reportList != nil) {
		
		if(self.reportList.count > 0){
            
			NSDictionary *item = [self.reportList objectAtIndex:row];
			cell.textLabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"reportNm"]];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd"];
            
            long long submitStartTime = [[NSString stringWithFormat:@"%@",[item objectForKey:@"submitStartDt"]] longLongValue];
			
			submitStartTime = submitStartTime / 1000;
			NSDate *submitStartDate = [NSDate dateWithTimeIntervalSince1970:submitStartTime];
			
            NSString *submitStartDateString = [dateFormat stringFromDate:submitStartDate];
            
            long long submitCloseTime = [[NSString stringWithFormat:@"%@",[item objectForKey:@"submitCloseDt"]] longLongValue];
			
			submitCloseTime = submitCloseTime / 1000;
			NSDate *submitCloseDate = [NSDate dateWithTimeIntervalSince1970:submitCloseTime];
			
            NSString *submitCloseDateString = [dateFormat stringFromDate:submitCloseDate];
            
			cell.detailTextLabel.text = [submitStartDateString stringByAppendingFormat:@" ~ %@", submitCloseDateString];
			//NSString *imageUrl = [kServerUrl stringByAppendingString:@"/images/mobile/icon1.png"];
			//NSLog(@"image url = %@",imageUrl);
			//cell.imageView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
		}
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger row = [indexPath row];
    
    NSDictionary *item = [self.reportList objectAtIndex:row];
    
    ReportInfoController *reportInfo = [[ReportInfoController alloc] initWithNibName:@"ReportInfoController" bundle:nil];
    reportInfo.reportNo = [[NSString stringWithFormat:@"%@", [item objectForKey:@"reportNo"]] intValue];
    reportInfo.lectureTitle = lectureTitle;
    [self.navigationController pushViewController:reportInfo animated:YES];
    
    [reportInfo release];
    reportInfo = nil;
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	//NSUInteger row = [indexPath row];
	
	//NSDictionary *item = [self.reportList objectAtIndex:row];
	
}


@end
