//
//  ReportInfoController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReportInfoController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Constants.h"
#import "ReportEditController.h"
#import "MainViewController.h"
#import "Utils.h"

@implementation ReportInfoController

@synthesize table, reportNo, report, lectureTitle;

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
    [report release];
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
    table.backgroundColor = [UIColor clearColor];
    //CGRect headerViewFrame = table.tableHeaderView.frame;
    //headerViewFrame.size.height = 30;
    //table.tableHeaderView.frame = headerViewFrame;
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
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self bindReportInfo];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.report = nil;
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

- (void)bindReportInfo {
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kReportInfoUrl];
	url = [url stringByAppendingFormat:@"/%d",self.reportNo];
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
	
	self.report = (NSDictionary *)[jsonData objectForKey:@"data"];
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
    
    if(section == 0) {//과제명
        return 1;
    } else if(section == 1) {//제출기한
        return 1;
    } else if(section == 2) {//
        return 1;
    } else if (section == 3) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 42;
    
    if([indexPath section] == 0) {//과제명
        return 42;
    } else if([indexPath section] == 1) {//제출기한
        return 42;
    } else if([indexPath section] == 2) {//
        return 42;
    } else if ([indexPath section] == 3) {
        return 85;
    } else {
        return 42;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if(section == 0) {
        return @"과제명";
    } else if(section == 1) {
        return @"제출기한";
    } else if(section == 2) {
        return @"제출현황";
    } else if (section == 3) {
        return @"과제내용";
    } else if (section == 4) {
        return @"연장감점여부";
    } else {
        return @"";
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
    label.textColor = UIColorFromRGB(kValueTextColor);
    if(section == 0) {
        label.text = @"과제명";
    } else if(section == 1) {
        label.text = @"제출기한";
    } else if(section == 2) {
        label.text = @"제출현황";
    } else if (section == 3) {
        label.text = @"과제내용";
    } else if (section == 4) {
        label.text =  @"연장감점여부";
    }

    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    //if (section == 0)
    //    [headerView setBackgroundColor:[UIColor redColor]];
    //else 
    //    [headerView setBackgroundColor:[UIColor clearColor]];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"CustomLectureCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    
    if(cell == nil){
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    self.navigationItem.title = [self.report objectForKey:@"reportNm"];
    
	if ([indexPath section] == 0) { 
		cell.textLabel.text = [self.report objectForKey:@"reportNm"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if([indexPath section] == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        long long submitStartTime = [[NSString stringWithFormat:@"%@",[self.report objectForKey:@"submitStartDt"]] longLongValue];
        
        submitStartTime = submitStartTime / 1000;
        NSDate *submitStartDate = [NSDate dateWithTimeIntervalSince1970:submitStartTime];
        
        NSString *submitStartDateString = [dateFormat stringFromDate:submitStartDate];
        
        long long submitCloseTime = [[NSString stringWithFormat:@"%@",[self.report objectForKey:@"submitCloseDt"]] longLongValue];
        
        submitCloseTime = submitCloseTime / 1000;
        NSDate *submitCloseDate = [NSDate dateWithTimeIntervalSince1970:submitCloseTime];
        
        NSString *submitCloseDateString = [dateFormat stringFromDate:submitCloseDate];
        
        cell.textLabel.text = [submitStartDateString stringByAppendingFormat:@" ~ %@", submitCloseDateString];
        
        [dateFormat release];
        
	} else if([indexPath section] == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        BOOL isStudent = [[SmartLMSAppDelegate sharedAppDelegate] isStudent];
        if(isStudent){
            if([self.report objectForKey:@"reportSubmitFg"] != [NSNull null]){
                cell.textLabel.text = @"미제출";
            } else {
                NSString *submitFg = (NSString *)[self.report objectForKey:@"reportSubmitFg"];
                cell.textLabel.text = @"미제출";
                if(![Utils isNullString:submitFg]){
                    if([submitFg isEqualToString:@"T"]){
                        cell.textLabel.text = @"제출";
                    }
                }
            }
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"제출인원 : %@ 총학생수 : %@", [self.report objectForKey:@"reportUserCount"], [self.report objectForKey:@"reportUserTotalCount"]];
        }
        
    } else if([indexPath section] == 3) { 
        
		//cell.textLabel.text = [self.report objectForKey:@"reportContent"];
        
        UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(20, 5, 280, 80)];
        [webview loadHTMLString:[self.report valueForKey:@"reportContent"] baseURL:nil];
        [cell addSubview:webview];
        [webview release];
        
	} else {
        
        if ([indexPath row] == 0) { 
			cell.textLabel.text = @"연장감점여부";
		} else if ([indexPath row] == 1) {
			cell.textLabel.text = @"첨부파일";
		}
    }
    
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
	//if([indexPath section] == 0){
    BOOL isStudent = [[SmartLMSAppDelegate sharedAppDelegate] isStudent];
    if(!isStudent){
        ReportEditController *reportEdit = [[ReportEditController alloc] initWithNibName:@"ReportEditController" bundle:nil];
        reportEdit.reportNo = reportNo;
        reportEdit.lectureNo = [[NSString stringWithFormat:@"%@", [self.report objectForKey:@"lectureNo"]] intValue];
        reportEdit.itemNo = [[NSString stringWithFormat:@"%@", [self.report objectForKey:@"itemNo"]] intValue];
        NSLog(@"lectureNo = %d itemNo = %d", reportEdit.lectureNo, reportEdit.itemNo);
        [self.navigationController pushViewController:reportEdit animated:YES];
        [reportEdit release];
        reportEdit = nil;
        
    }
}

@end
