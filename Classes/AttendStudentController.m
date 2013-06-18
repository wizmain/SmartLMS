//
//  AttendStudentController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttendStudentController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Constants.h"
#import "AttendStudentInfo.h"
#import "MainViewController.h"
#import "MessageReadController.h"

@implementation AttendStudentController

@synthesize table, lectureNo, dataList, studentSearchBar, tableData, inSearch, showAttendInfoFlag, lectureTitle;

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
    [tableData release];
    [lectureTitle release];
    [studentSearchBar release];
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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 수강생", lectureTitle];
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor grayColor];
    inSearch = NO;
    
    
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
    
    [self bindDataList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    self.tableData = nil;
    self.lectureTitle =nil;
    self.dataList = nil;
    self.studentSearchBar = nil;
    
    [[[SmartLMSAppDelegate sharedAppDelegate] httpRequest] cancel];
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

- (void)bindDataList {
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kAttendStudentListUrl];
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

- (void)searchStudent:(NSString *)searchText {
    
}


#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
    //원본데이타
	self.dataList = (NSArray *)[jsonData valueForKey:@"data"];
    //테이블과 연결될 데이타
    self.tableData = [[NSMutableArray alloc] initWithArray:dataList];

	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
        
	}
	
	[jsonParser release];
	
    [self.table reloadData];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
    int dataCount = [self.dataList count];
    if(dataCount > 0){
        return dataCount + 1;//more버튼위해서
    } else {
        return dataCount;
    }
    */
    if(self.tableData != nil)
        return [self.tableData count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"수강생";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	
	if (cell == nil) {
		UIImage *img = [UIImage imageNamed:@"103-Person"];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		[cell.imageView setImage:img];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.tableData != nil) {
		
		if(self.tableData.count > 0){

            NSDictionary *item = [self.dataList objectAtIndex:row];
            //cell.textLabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"userNm"]];
            if(item){
                cell.textLabel.text = [item objectForKey:@"userNm"];
                cell.textLabel.textColor = UIColorFromRGB(kValueTextColor);
                cell.detailTextLabel.text = [item objectForKey:@"userID"];
            }

		}
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
	NSDictionary *item = [self.tableData objectAtIndex:row];
    
    NSLog(@"didSelect");
    
    if(showAttendInfoFlag){
        NSLog(@"showAttendInfo");
        if([showAttendInfoFlag isEqualToString:@"T"]){
            AttendStudentInfo *i = [[AttendStudentInfo alloc] initWithNibName:@"AttendStudentInfo" bundle:nil];
            i.userID = [item valueForKey:@"userID"];
            i.lectureNo = lectureNo;
            
            [self.navigationController pushViewController:i animated:YES];
            
            [i release];
        } else {
            NSLog(@"Message send");
            MessageReadController *message = [[MessageReadController alloc] initWithNibName:@"MessageReadController" bundle:nil];
            message.receiveUserID = [[SmartLMSAppDelegate sharedAppDelegate] authUserID];
            message.sendUserID = [item valueForKey:@"userID"];
            message.receiveUserName = [item valueForKey:@"userNm"];
            //[self.navigationController pushViewController:message animated:YES];
            UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:message];
            [self presentModalViewController:naviCon animated:YES];
            
            [message release];
            [naviCon release];
            
        }
    } else {
        /*
        MessageReadController *message = [[MessageReadController alloc] initWithNibName:@"MessageReadController" bundle:nil];
        message.sendUserID = [[SmartLMSAppDelegate sharedAppDelegate] authUserID];
        message.receiveUserID = [item valueForKey:@"userID"];
        message.receiveUserName = [item valueForKey:@"userNm"];
        [self.navigationController pushViewController:message animated:YES];
        */
    }
    
	
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	//NSUInteger row = [indexPath row];
	
	//NSDictionary *item = [self.dataList objectAtIndex:row];
	
}

#pragma mark -
#pragma mark Search Bar Delegate Method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    inSearch = YES;
    NSString *searchText = [searchBar text];
    NSLog(@"searchText = %@", searchText);
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    for (UIView *possibleButton in searchBar.subviews)
    {
        if ([possibleButton isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)possibleButton;
            cancelButton.enabled = YES;
            break;
        }
    }
    
    self.tableData = [[NSMutableArray alloc] init];
    
    for(NSDictionary *a in self.dataList) {
        NSString *userID = [a valueForKey:@"userID"];
        if([userID rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound){
            [self.tableData addObject:a];

        }
    }
    
    [table reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search Cancel");
    inSearch = NO;
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    self.tableData = [[NSMutableArray alloc] initWithArray:self.dataList];
    [self.table reloadData];
}



@end
