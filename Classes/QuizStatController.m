//
//  QuizStatController.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 24..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "QuizStatController.h"
#import "ProgressCell.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "MainViewController.h"

@implementation QuizStatController

@synthesize table, tableData, studentCount, lectureNo, lectureTitle;

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
    self.table.backgroundColor = [UIColor clearColor];
    self.table.separatorColor = [UIColor grayColor];
    
    UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_middle"]];
    self.view.backgroundColor = backImg;
    [backImg release];
    
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    self.navigationItem.title = lectureTitle;//@"퀴즈통계";
    
    [self requestETestStat];
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

- (void)requestETestStat {
    
    NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kLectureETestStat];
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
	
	self.tableData = (NSArray *)[jsonData objectForKey:@"data"];
	//NSDictionary *resultObj = (NSDictionary *)[jsonData objectForKey:@"result"];
    
    
    
    [self.table reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"진행상태";
    
    ProgressCell *cell = (ProgressCell *)[tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
        
        cell = [ProgressCell createCellFromNib];
        
		cell.accessoryType = UITableViewCellAccessoryNone;
		//cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.backgroundColor = [UIColor clearColor];
	}
    
	
	NSUInteger row = [indexPath row];
    
    NSDictionary *t = [self.tableData objectAtIndex:row];
    int attendUserCount = [[t valueForKey:@"applyUserCnt"] intValue];
    int seq = [[t valueForKey:@"weekSeq"] intValue];
    
    //cell.seqLabel.text = [NSString stringWithFormat:@"%d", row + 1];
    cell.seqLabel.text = [NSString stringWithFormat:@"%d주차", seq];
    
    int percent = 0;
    float rate = 0;
    
    if(attendUserCount > 0 && studentCount > 0){
        rate = (float)attendUserCount / studentCount;
        NSLog(@"division rate = %.2f", rate);
    }
    
    cell.progress.progress = rate;
    percent = (int)(rate * 100);
    
    NSLog(@"attendUserCount = %d studentCount = %d percent = %d rate = %f",attendUserCount, studentCount, percent, rate);
    cell.statLabel.text = [[[NSNumber numberWithInt:percent] stringValue] stringByAppendingString:@"%"];
    
    
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
