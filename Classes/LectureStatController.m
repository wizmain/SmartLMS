//
//  LectureStatController.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 17..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "LectureStatController.h"
#import "HTTPRequest.h"
#import "JSON.h"
#import "SmartLMSAppDelegate.h"
#import "Constants.h"
#import "AttendStudentController.h"
#import "AttendStatController.h"
#import "QuizStatController.h"
#import "ReportStatController.h"
#import "MainViewController.h"

@implementation LectureStatController

@synthesize table, lectureNo, attendInfo, lectureTitle;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = lectureTitle;
    
    UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_middle"]];
    self.view.backgroundColor = backImg;
    [backImg release];
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    table.backgroundColor = [UIColor clearColor];
    
    [self bindLectureStat];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.lectureTitle = nil;
    self.attendInfo = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [table release];
    [lectureTitle release];
    [attendInfo release];
    [super dealloc];
}

#pragma mark - Private Method
- (void)bindLectureStat {
    NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kLectureStat];
	url = [url stringByAppendingFormat:@"/%d",self.lectureNo];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (void)didReceiveFinished:(NSString *)result {
    NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	self.attendInfo = (NSDictionary *)[jsonData objectForKey:@"data"];
	//NSDictionary *resultObj = (NSDictionary *)[jsonData objectForKey:@"result"];
    
    
    [self.table reloadData];
    
}


- (void)goIndex {
    NSLog(@"goIndex");
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {//수강생수
        return 1;
    } else if(section == 1) {//강의시청율
        return 1;
    } else if(section == 2) {//퀴즈응시율
        return 1;
    } else if (section == 3) {//과제제출
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if(section == 0) {
        return @"수강생";
    } else if(section == 1) {
        return @"강의시청율";
    } else if(section == 2) {
        return @"퀴즈응시율";
    } else if (section == 3) {
        return @"과제제출";
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
        label.text = @"수강생";
    } else if(section == 1) {
        label.text = @"강의시청율";
    } else if(section == 2) {
        label.text = @"퀴즈응시율";
    } else if (section == 3) {
        label.text = @"과제제출";
    }
    
    label.textColor = UIColorFromRGB(kValueTextColor);
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
	
    static NSString *normalCellIdentifier = @"LectureStatCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    
    if(cell == nil){
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:normalCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    //수강생수
    int attendRequestCount = [[self.attendInfo valueForKey:@"attendRequestCount"] intValue];
    
	if ([indexPath section] == 0) { 
		//cell.textLabel.text = @"수강생";
        cell.textLabel.text = [NSString stringWithFormat:@"수강생 : %d명", attendRequestCount];//수강생수
        
    } else if([indexPath section] == 1) {
        
        
        int itemCount = [[self.attendInfo valueForKey:@"lectureItemCount"] intValue];//차시수
        int attendCount = [[self.attendInfo valueForKey:@"attendCount"] intValue];//수강수
        int totalAttendPercent = 0;
        if (attendCount > 0 && itemCount > 0 && attendRequestCount > 0) {
            totalAttendPercent = (int)(((float)attendCount / (itemCount * attendRequestCount)) * 100);
            
        }
        NSLog(@"attendCount = %d itemCount = %d attendRequestCount = %d", attendCount, itemCount, attendRequestCount);
        
        //금주
        int weekAttendCount = [[self.attendInfo valueForKey:@"weekAttendCount"] intValue];
        int weekAttendPercent = 0;
        if(weekAttendCount > 0){
            weekAttendPercent = (int)((float)weekAttendCount / attendRequestCount)*100;
        }
        NSLog(@"weekAttendCount = %d", weekAttendCount);
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [NSString stringWithFormat:@"강의시청율 : %d%% 금주 : %d%%", totalAttendPercent, weekAttendPercent];
        
	} else if([indexPath section] == 2){
        int userApplyCount = [[self.attendInfo valueForKey:@"userApplyCount"] intValue];//시험응시인원
        int etestCount = [[self.attendInfo valueForKey:@"etestCount"] intValue];
        int applyPercent = 0;
        if(userApplyCount > 0 && attendRequestCount > 0){
            applyPercent = (int)(((float)userApplyCount / (etestCount * attendRequestCount)) * 100);
        }
        NSLog(@"userApplyCount = %d attendRequestCount = %d", userApplyCount, attendRequestCount);
        
        int weekETestApplyCount = [[self.attendInfo valueForKey:@"weekETestApplyCount"] intValue];
        int weekETestApplyPercent = 0;
        if(weekETestApplyCount > 0){
            weekETestApplyPercent = (int)((float)weekETestApplyCount / attendRequestCount)*100;
        }
        NSLog(@"weekETestApplyCount = %d", weekETestApplyCount);
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.textLabel.text = @"퀴즈응시율";
        cell.textLabel.text = [NSString stringWithFormat:@"퀴즈응시율 : %d%% 금주 : %d%%", applyPercent, weekETestApplyPercent];
    } else if([indexPath section] == 3) {
        
        int reportCount = [[self.attendInfo valueForKey:@"reportCount"] intValue];//과제갯수
        int submitReportCount = [[self.attendInfo valueForKey:@"submitReportCount"] intValue];//과제제출수
        int reportPercent = 0;
        if(submitReportCount > 0 && reportCount > 0){
            reportPercent = (int)(((float)submitReportCount / (reportCount * attendRequestCount) ) * 100);
        }
        
		//cell.textLabel.text = @"과제제출";
        cell.textLabel.text = [NSString stringWithFormat:@"과제제출 : %d%%", reportPercent];
	}
    
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	int section = [indexPath section];
    int studentCount = [[attendInfo valueForKey:@"attendRequestCount"] intValue];
    
	if(section == 0){
        AttendStudentController *attendStudent = [[AttendStudentController alloc] initWithNibName:@"AttendStudentController" bundle:nil];
        attendStudent.lectureNo = lectureNo;
        attendStudent.showAttendInfoFlag = @"T";
        attendStudent.lectureTitle = lectureTitle;
        [self.navigationController pushViewController:attendStudent animated:YES];
        [attendStudent release];
        /*
        ReportEditController *reportEdit = [[ReportEditController alloc] initWithNibName:@"ReportEditController" bundle:nil];
        reportEdit.reportNo = reportNo;
        reportEdit.lectureNo = [[NSString stringWithFormat:@"%@", [self.report objectForKey:@"lectureNo"]] intValue];
        reportEdit.itemNo = [[NSString stringWithFormat:@"%@", [self.report objectForKey:@"itemNo"]] intValue];
        NSLog(@"lectureNo = %d itemNo = %d", reportEdit.lectureNo, reportEdit.itemNo);
        [self.navigationController pushViewController:reportEdit animated:YES];
        [reportEdit release];
        reportEdit = nil;
        */
    } else if(section == 1) {
        AttendStatController *attendStat = [[AttendStatController alloc] initWithNibName:@"AttendStatController" bundle:nil];
        attendStat.lectureNo = lectureNo;
        attendStat.studentCount = studentCount;
        attendStat.lectureTitle = lectureTitle;
        [self.navigationController pushViewController:attendStat animated:YES];
        [attendStat release];
    } else if(section == 2) {
        QuizStatController *quizStatController = [[QuizStatController alloc] initWithNibName:@"QuizStatController" bundle:nil];
        quizStatController.lectureNo = lectureNo;
        quizStatController.studentCount = studentCount;
        quizStatController.lectureTitle = lectureTitle;
        [self.navigationController pushViewController:quizStatController animated:YES];
        [quizStatController release];
    } else if(section == 3) {
        ReportStatController *reportStatController = [[ReportStatController alloc] initWithNibName:@"ReportStatController" bundle:nil];
        reportStatController.lectureNo = lectureNo;
        reportStatController.studentCount = studentCount;
        reportStatController.lectureTitle = lectureTitle;
        [self.navigationController pushViewController:reportStatController animated:YES];
        [reportStatController release];
    }
}



@end
