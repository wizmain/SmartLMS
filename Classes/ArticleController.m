//
//  NoticeController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ArticleController.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "ArticleReadController.h"
#import "ArticleEditController.h"
#import "SmartLMSAppDelegate.h"
#import "TransparentToolbar.h"
#import "Utils.h"

@implementation ArticleController

@synthesize noticeTable;
@synthesize page;
@synthesize siteID;
@synthesize menuID;
@synthesize articleList;
@synthesize lectureNo;
@synthesize boardTitle, isStudent;

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
	NSLog(@"viewDidLoad");
	[super viewDidLoad];
	
    if(self.boardTitle == nil) {
        self.navigationItem.title = @"게시판";
    } else {
        self.navigationItem.title = boardTitle;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    isStudent = [[SmartLMSAppDelegate sharedAppDelegate] isStudent];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    

	//UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    
    //NSInteger toolbarWidth = 90;
    
    //if(isStudent){
    //    toolbarWidth = 45;
    //}
    
	
	UIBarButtonItem *flexibleLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    /*
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																			 target:self 
									 										 action:@selector(refreshClick:)];
	refresh.style = UIBarButtonItemStyleBordered;
    */
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"nav_reload"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventTouchUpInside];
    refreshButton.frame = CGRectMake(0, 0, 34, 30);
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    
    
    /*
	UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																			 target:self 
																			 action:@selector(writeArticleClick:)];
    
	compose.style = UIBarButtonItemStyleBordered;
    */
    
    NSLog(@"siteID = %@, menuID = %@, lectureNo = %d", siteID, menuID, lectureNo);
    if(![Utils isNullString:siteID]){
        if([siteID isEqualToString:@"LMS"]){
            NSLog(@"siteID = LMS");
            //공지사항이면
            NSString *annmenu = [NSString stringWithFormat:@"LMS-%d-1", lectureNo];
            
            if ([annmenu isEqualToString:menuID]) {
                NSLog(@"lms announce ");
                if(isStudent){//학생
                    NSLog(@"siteID = 학생");
                    TransparentToolbar *toolbar = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
                    [toolbar setItems:[[NSArray alloc] initWithObjects:flexibleLeft, refresh, nil]];
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
                    [toolbar release];
                } else {
                    //교수
                    NSLog(@"siteID = 교수");
                    TransparentToolbar *toolbar = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 45)];
                    UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [composeButton setBackgroundImage:[UIImage imageNamed:@"nav_write"] forState:UIControlStateNormal];
                    [composeButton addTarget:self action:@selector(writeArticleClick:) forControlEvents:UIControlEventTouchUpInside];
                    composeButton.frame = CGRectMake(0, 0, 34, 30);
                    UIBarButtonItem *compose = [[[UIBarButtonItem alloc] initWithCustomView:composeButton] autorelease];
                    
                    [toolbar setItems:[[NSArray alloc] initWithObjects:flexibleLeft, refresh, compose, nil]];
                    //[toolbar setBarStyle:UIBarStyleBlackOpaque];
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
                    [toolbar release];
                }
            } else {
                NSLog(@"LMS  qna");
                //공지사항 아니면 버튼 나오게
                TransparentToolbar *toolbar = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 45)];
                UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [composeButton setBackgroundImage:[UIImage imageNamed:@"nav_write"] forState:UIControlStateNormal];
                [composeButton addTarget:self action:@selector(writeArticleClick:) forControlEvents:UIControlEventTouchUpInside];
                composeButton.frame = CGRectMake(0, 0, 34, 30);
                UIBarButtonItem *compose = [[[UIBarButtonItem alloc] initWithCustomView:composeButton] autorelease];
                
                [toolbar setItems:[[NSArray alloc] initWithObjects:flexibleLeft, refresh, compose, nil]];
                //[toolbar setBarStyle:UIBarStyleBlackOpaque];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
                [toolbar release];
            }
            
        } else {
            NSLog(@"siteID = DEFAULT");
            //공지사항이면
            if([menuID isEqualToString:kAnnounceBoardID]){
                //관리자이면
                if([[[SmartLMSAppDelegate sharedAppDelegate] authUserID] isEqualToString:@"admin"]){
                    TransparentToolbar *toolbar = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 45)];
                    UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [composeButton setBackgroundImage:[UIImage imageNamed:@"nav_write"] forState:UIControlStateNormal];
                    [composeButton addTarget:self action:@selector(writeArticleClick:) forControlEvents:UIControlEventTouchUpInside];
                    composeButton.frame = CGRectMake(0, 0, 34, 30);
                    UIBarButtonItem *compose = [[[UIBarButtonItem alloc] initWithCustomView:composeButton] autorelease];
                    
                    [toolbar setItems:[[NSArray alloc] initWithObjects:flexibleLeft, refresh, compose, nil]];
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
                    [toolbar release];
                } else {
                    TransparentToolbar *toolbar = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
                    [toolbar setItems:[[NSArray alloc] initWithObjects:flexibleLeft, refresh, nil]];
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
                    [toolbar release];
                }
            } else {
                TransparentToolbar *toolbar = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 45)];
                UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [composeButton setBackgroundImage:[UIImage imageNamed:@"nav_write"] forState:UIControlStateNormal];
                [composeButton addTarget:self action:@selector(writeArticleClick:) forControlEvents:UIControlEventTouchUpInside];
                composeButton.frame = CGRectMake(0, 0, 34, 30);
                UIBarButtonItem *compose = [[[UIBarButtonItem alloc] initWithCustomView:composeButton] autorelease];
                
                [toolbar setItems:[[NSArray alloc] initWithObjects:flexibleLeft, refresh, compose, nil]];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
                [toolbar release];
            }
        }
        
    }
	
	
	
	[flexibleLeft release];
	[refresh release];
	
	
    
    if(page < 1)
        page = 1;
    
}


- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"viewWillAppear");
	
	[super viewWillAppear:animated];
    
    if(self.siteID != nil && self.menuID != nil && page > 0) {
        [self bindNotice];
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
    
    [[[SmartLMSAppDelegate sharedAppDelegate] httpRequest] cancel];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.noticeTable = nil;
    spinner = nil;
    self.articleList = nil;
    self.boardTitle = nil;
    self.siteID = nil;
    self.menuID = nil;
}


- (void)dealloc {
	[noticeTable release];
    [articleList release];
    [boardTitle release];
    [siteID release];
    [menuID release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bindNotice {
    
	NSString *url = [[kServerUrl stringByAppendingString:kArticleListUrl] stringByAppendingString:@"/"];
	NSString *query = [NSString stringWithFormat:@"%@/%@/%d", siteID, menuID, page];
	url = [url stringByAppendingString:query];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"bindNotice url = %@", url);
	
    
    //로그인 인디케이터 시작
	//spinner = [[ProgressIndicator alloc] initWithLabel:@"처리중입니다"];
	//[spinner show];
    
    
    //통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didNoticeReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
    
    /*
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [self didNoticeReceiveFinished:resultData];
	*/
}

- (void)reloadNoticeTable {
	[self.noticeTable reloadData];
}

- (void)refreshClick:(id)sender {
	[self bindNotice];
}

#pragma mark -
#pragma mark HTTPRequest delegate
- (void)didNoticeReceiveFinished:(NSString *)result {
	//NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	self.articleList = (NSArray *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"성공");
		NSLog(@"articleList count %d", [self.articleList count]);
		for (int i=0; i<self.articleList.count; i++) {
			//NSLog(@"%d = %@",i, [lectureList objectAtIndex:i]);
			//NSDictionary *article = (NSDictionary *)[self.articleList objectAtIndex:i];
			//NSLog(@"articleTitle = %@", [article objectForKey:@"title"]);
		}
		
		[self reloadNoticeTable];
	}
    
    //[spinner dismissWithClickedButtonIndex:0 animated:YES];
	
}

- (void)writeArticleClick:(id)sender {
	ArticleEditController *articleEdit = [[ArticleEditController alloc] initWithNibName:@"ArticleEditController" bundle:[NSBundle mainBundle]];
	articleEdit.siteID = siteID;
	articleEdit.menuID = menuID;
	[self.navigationController pushViewController:articleEdit animated:YES];
	[articleEdit release];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.articleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"공지사항";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		UIImage *img = [UIImage imageNamed:@"252-Exclamation"];
		cell.imageView.image = img;
        cell.textLabel.textColor = UIColorFromRGB(kValueTextColor);
    
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.articleList != nil) {
		
		if(articleList.count > 0){
			NSDictionary *article = [self.articleList objectAtIndex:row];
			NSLog(@"createTime = %@", [article objectForKey:@"createTime"]);
            if(article) {
                if([article objectForKey:@"createTime"] != (id)[NSNull null]) {
                    long long time = [[NSString stringWithFormat:@"%@",[article objectForKey:@"createTime"]] longLongValue];
                    time = time / 1000;
                    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                    //NSLog(@"date = %@",[dateFormat stringFromDate:date]);
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    
                    
                }
                //NSString *label = [[article objectForKey:@"title"] stringByAppendingFormat:@" (%@)",[dateFormat stringFromDate:date]];
                if(article){

                    
                    if([article objectForKey:@"title"] != (id)[NSNull null]){
                        cell.textLabel.text = [article objectForKey:@"title"];
                    } else {

                    }
                }
            }
		}
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	NSDictionary *article = [self.articleList objectAtIndex:row];
	NSInteger contentsID = [[NSString stringWithFormat:@"%@",[article objectForKey:@"contentsID"]] intValue];
	NSLog(@"contentsID = %d", contentsID);
	ArticleReadController *articleReadController = [[ArticleReadController alloc] initWithNibName:@"ArticleReadController" bundle:[NSBundle mainBundle]];
	articleReadController.siteID = self.siteID;
	articleReadController.menuID = self.menuID;
	articleReadController.contentsID = contentsID;
    articleReadController.boardTitle = boardTitle;
    
	//[self.navigationController pushViewController:articleReadController animated:YES];
    UINavigationController *navi = [[[UINavigationController alloc] initWithRootViewController:articleReadController] autorelease];
    [self presentModalViewController:navi animated:YES];
    
	[articleReadController release];
	articleReadController = nil;
	
}
@end
