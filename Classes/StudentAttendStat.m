//
//  StduentAttendStat.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "StudentAttendStat.h"
#import "StudentAttendStatCell.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "MainViewController.h"

@implementation StudentAttendStat

@synthesize table, tableData, lectureNo, itemNo, lectureTitle;

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
    
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor grayColor];
    
    UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_middle"]];
    self.view.backgroundColor = backImg;
    [backImg release];
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    self.navigationItem.title = lectureTitle;//@"수강생출석현황";
    
    [self requestStduentAttendStat];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.tableData = nil;
    self.lectureTitle = nil;
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

- (void)requestStduentAttendStat {
    
    NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kStudentAttendStat];
	url = [url stringByAppendingFormat:@"/%d/%d",self.lectureNo, self.itemNo];
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
	
	self.tableData = (NSArray *)[jsonData objectForKey:@"data"];
	//NSDictionary *resultObj = (NSDictionary *)[jsonData objectForKey:@"result"];
    
    
    
    [table reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"진행상태";
    
    StudentAttendStatCell *cell = (StudentAttendStatCell *)[tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
        
        cell = [StudentAttendStatCell createCellFromNib];
        
		cell.accessoryType = UITableViewCellAccessoryNone;
		//cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.backgroundColor = [UIColor clearColor];
	}
    
	
	NSUInteger row = [indexPath row];
    
    NSDictionary *t = [self.tableData objectAtIndex:row];
    
    //int seq = [[t valueForKey:@"weekSeq"] intValue];
    int studyTime = [[t valueForKey:@"studyTime"] intValue];
    int recmdStudtyMinute = [[t valueForKey:@"recmdStudyMinute"] intValue];
    int maxStudyMinute = 18;
    NSString *applyQuizTF;
    
    if([t valueForKey:@"attendQuiz"] != Nil){
        applyQuizTF = @"F";
    } else {
        applyQuizTF = [t valueForKey:@"attendQuiz"];
    }
    
    //cell.seqLabel.text = [NSString stringWithFormat:@"%d", row + 1];
    cell.studentNameLabel.textColor = UIColorFromRGB(kValueTextColor);
    
    if([t objectForKey:@"studentNm"] == Nil){
        cell.studentNameLabel.text = @"홍길동";
    } else {
        cell.studentNameLabel.text = [t objectForKey:@"studentNm"];
    }
    
    float rate = 0;
    
    if (recmdStudtyMinute > 0) {
        maxStudyMinute = recmdStudtyMinute;
    }
    
    if(studyTime > 0){
        rate = (float)studyTime/maxStudyMinute;
    }
    
    cell.attendProgress.progress = rate;
    if([applyQuizTF isEqualToString:@"T"]){
        cell.applyQuizLabel.text = @"응시";
    } else {
        cell.applyQuizLabel.text = @"비응시";
    }
    
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//NSUInteger row = [indexPath row];
    //NSLog(@"row = %d", row);
    
    
    /*
     NSDictionary *article = [self.articleList objectAtIndex:row];
     NSInteger contentsID = [[NSString stringWithFormat:@"%@",[article objectForKey:@"contentsID"]] intValue];
     NSLog(@"contentsID = %d", contentsID);
     ArticleReadController *articleReadController = [[ArticleReadController alloc] initWithNibName:@"ArticleReadController" bundle:[NSBundle mainBundle]];
     articleReadController.siteID = self.siteID;
     articleReadController.menuID = self.menuID;
     articleReadController.contentsID = contentsID;
     [self.navigationController pushViewController:articleReadController animated:YES];
     [articleReadController release];
     articleReadController = nil;
     */
}

@end
