//
//  QuizInfoController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizInfoController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Constants.h"
#import "QuizEditController.h"
#import "ApplyQuiz.h"
#import "MainViewController.h"

@implementation QuizInfoController

@synthesize etestNo, table, etest, lectureNo, itemNo;

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
    [etest release];
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
    self.navigationItem.title = @"퀴즈상세";
    
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
    
    table.backgroundColor = [UIColor clearColor];
    
    [self bindETestInfo];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.etest = nil;
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

- (void)bindETestInfo {
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kETestInfoUrl];
	url = [url stringByAppendingFormat:@"/%d",self.etestNo];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}


#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	self.etest = (NSDictionary *)[jsonData objectForKey:@"data"];
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
    
    if(section == 0) {//이름
        return 1;
    } else if(section == 1) {//기간
        return 1;
    } else if(section == 2) {//상태
        return 1;
    } else if (section == 3) {//응시버튼
        return 1;
    } else {
        return 1;
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
        return 65;
    } else if([indexPath section] == 2) {//
        return 42;
    } else if ([indexPath section] == 3) {
        return 42;
    } else {
        return 42;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        return @"퀴즈명";
    } else if(section == 1) {
        return @"시험기한";
    } else if(section == 2) {
        return @"시험상태";
    } else if (section == 3) {
        return @"응시";
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
    
    if(section == 0) {
        label.text = @"퀴즈명";
        
    } else if(section == 1) {
        label.text = @"시험기간";
        
    } else if(section == 2) {
        label.text = @"시험상태";
        
    } else if (section == 3) {
        //label.text = @"응시";
        
    } else if (section == 4) {
        //label.text =  @"";
    }
    
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
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
    
    self.navigationItem.title = [self.etest objectForKey:@"etestNm"];
    
	if ([indexPath section] == 0) { 
		cell.textLabel.text = [self.etest objectForKey:@"etestNm"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if([indexPath section] == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh시 mm분"];
        
        long long submitStartTime = [[NSString stringWithFormat:@"%@",[self.etest objectForKey:@"etestStartDt"]] longLongValue];
        
        submitStartTime = submitStartTime / 1000;
        NSDate *submitStartDate = [NSDate dateWithTimeIntervalSince1970:submitStartTime];
        
        NSString *submitStartDateString = [dateFormat stringFromDate:submitStartDate];
        
        long long submitCloseTime = [[NSString stringWithFormat:@"%@",[self.etest objectForKey:@"etestCloseDt"]] longLongValue];
        
        submitCloseTime = submitCloseTime / 1000;
        NSDate *submitCloseDate = [NSDate dateWithTimeIntervalSince1970:submitCloseTime];
        
        NSString *submitCloseDateString = [dateFormat stringFromDate:submitCloseDate];
        
        cell.textLabel.text = [submitStartDateString stringByAppendingFormat:@" 부터\n%@ 까지", submitCloseDateString];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        
        [dateFormat release];
        
	} else if([indexPath section] == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.etest objectForKey:@"questionState"]];
        
    } else if([indexPath section] == 3) {   
        
		cell.textLabel.text = @"응시하기";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
	} else {
        
    }
    
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if([indexPath section] == 0){
        QuizEditController *quizEdit = [[QuizEditController alloc] initWithNibName:@"QuizEditController" bundle:nil];
        quizEdit.etestNo = etestNo;
        quizEdit.lectureNo = lectureNo;
        quizEdit.itemNo = itemNo;
        
        [self.navigationController pushViewController:quizEdit animated:YES];
        [quizEdit release];
        quizEdit = nil;
        
    } else if ([indexPath section] == 3){
        ApplyQuiz *apply = [[ApplyQuiz alloc] initWithNibName:@"ApplyQuiz" bundle:nil];
        [apply setTitle:@"퀴즈응시"];
        apply.lectureNo = [[NSString stringWithFormat:@"%@", [self.etest valueForKey:@"lectureNo"]] intValue];
        apply.itemNo = [[NSString stringWithFormat:@"%@", [self.etest valueForKey:@"itemNo"]] intValue];
        apply.etestNo = etestNo;
        
        UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:apply];
        naviCon.toolbarHidden = NO;
        
        UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"제출하기" style:UIBarButtonItemStyleBordered target:apply action:@selector(submitButtonClick:)];
        UIBarButtonItem *setAnswerButton = [[UIBarButtonItem alloc] initWithTitle:@"정답설정" style:UIBarButtonItemStyleBordered target:apply action:@selector(setAnswerButtonClick:)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *toolbar = [[NSArray alloc] initWithObjects:submitButton, flexible, setAnswerButton, nil];
        
        
        apply.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"이전문제" style:UIBarButtonItemStylePlain target:apply action:@selector(prevQuizButtonClick:)];
        apply.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"다음문제" style:UIBarButtonItemStylePlain target:apply action:@selector(nextQuizButtonClick:)];
        apply.toolbarItems = toolbar;
        
        [self presentModalViewController:naviCon animated:NO];
        
        
        //[[mClassAppDelegate sharedAppDelegate] switchView:applyQuiz.view];
        //[[mClassAppDelegate sharedAppDelegate] switchView:nil];
        
        //[apply release];
        //[naviCon release];

    }
}


@end
