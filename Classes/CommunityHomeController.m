//
//  CommunityHomeController.m
//  mClass
//
//  Created by 김규완 on 11. 1. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  커뮤니티 홈

#import "CommunityHomeController.h"
#import "ArticleController.h"
#import "LectureIndexController.h"
#import "MessageController.h"
#import "SmartLMSAppDelegate.h"
#import "MainViewController.h"
#import "Constants.h"

@implementation CommunityHomeController

@synthesize table;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
	//타이틀
	self.navigationItem.title = @"커뮤니티";
    self.table.backgroundColor = [UIColor clearColor];
    //테이블데이타 리로드
	[self.table reloadData];
    
    //네비게이션 바 버튼 설정
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *naviBg = [UIImage imageNamed:@"navigation_back"];
        [self.navigationController.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
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
	[table release];
    [super dealloc];
}

#pragma mark - Custom Method

- (void)goIndex {
    NSLog(@"goIndex");
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"Cell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		cell.textLabel.text = @"전체공지";
	} else if (row == 1) {
		cell.textLabel.text = @"전체Q&A";
	} 
    else if (row == 2) {
		cell.textLabel.text = @"쪽지함";
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		ArticleController *notice = [[ArticleController alloc] initWithNibName:@"ArticleController" bundle:nil];
        notice.boardTitle = @"전체공지";
        notice.siteID = @"DEFAULT";
        notice.menuID = kAnnounceBoardID;
        
		[self.navigationController pushViewController:notice animated:YES];
		[notice release];
	} else if (row == 1) {
        /*
		LectureIndexController *lecture = [[LectureIndexController alloc] initWithNibName:@"LectureIndexController" bundle:nil];
		[lecture setIndexType:@"qna"];
		[self.navigationController pushViewController:lecture animated:YES];
		[lecture release];
        */
        ArticleController *notice = [[ArticleController alloc] initWithNibName:@"ArticleController" bundle:nil];
        notice.boardTitle = @"전체Q&A";
        notice.siteID = @"DEFAULT";
        notice.menuID = kQnABoardID;
        
		[self.navigationController pushViewController:notice animated:YES];
		[notice release];
		
	} 
    else if (row == 2) {
        MessageController *message = [[MessageController alloc] initWithNibName:@"MessageController" bundle:nil];
        message.page = 1;
        [self.navigationController pushViewController:message animated:YES];
        [message release];
    }
	
}

@end
