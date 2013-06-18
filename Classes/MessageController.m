//
//  MessageController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 30..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//  메세지 보기

#import "MessageController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "Constants.h"
#import "AlertUtils.h"
#import "MessageReadController.h"
#import "MessageSearchUser.h"
#import "TransparentToolbar.h"

@implementation MessageController

@synthesize table, messageList, page, selectedRow, editButtonItem, cancelButtonItem;

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
	
	self.page = 1;
    //타이틀 설정
	self.navigationItem.title = @"쪽지함";
	self.navigationItem.hidesBackButton = YES;
    
    
	TransparentToolbar *toolbar = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 108, 45)];
	
	//UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
	//																	  target:self 
	//																	  action:@selector(editClick:)];
	//edit.style = UIBarButtonItemStyleBordered;
    
    //수정버튼 설정
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setBackgroundImage:[UIImage imageNamed:@"nav_edit"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    editButton.frame = CGRectMake(0, 0, 50, 30);
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
	//UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
	//																		 target:self 
	//																		 action:@selector(writeMessageClick:)];
	//compose.style = UIBarButtonItemStyleBordered;
    //수정버튼 설정
    UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [composeButton setBackgroundImage:[UIImage imageNamed:@"nav_write"] forState:UIControlStateNormal];
    [composeButton addTarget:self action:@selector(writeMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    composeButton.frame = CGRectMake(0, 0, 34, 30);
    
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithCustomView:composeButton];
	
	[toolbar setItems:[[[NSArray alloc] initWithObjects:edit, compose, nil] autorelease]];
	editButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
	self.navigationItem.rightBarButtonItem = editButtonItem;
    
    //뒤로버튼 설정
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
   
    /*
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)] autorelease];
    
    self.navigationItem.leftBarButtonItem = backButton;
	*/
	[edit release];
	[compose release];
	[toolbar release];
	//[self bindMessage];
    
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"viewWillAppear");
	[self bindMessage];
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
    self.table = nil;
    self.messageList = nil;
    self.editButtonItem = nil;
    self.cancelButtonItem = nil;
}


- (void)dealloc {
	[table release];
	[messageList release];
	[editButtonItem release];
	[cancelButtonItem release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method

- (void)writeMessageClick:(id)sender {
	
	MessageSearchUser *searchUserController = [[MessageSearchUser alloc] initWithNibName:@"MessageSearchUser" bundle:nil];
	UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:searchUserController];
	
		
	[self presentModalViewController:naviCon animated:YES];
	
	[searchUserController release];
	[naviCon release];
	
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editClick:(id)sender {
	if (self.cancelButtonItem == nil) {
		cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																				 target:self 
																				 action:@selector(editDoneClick:)];
		
	}
	
	self.navigationItem.rightBarButtonItem = cancelButtonItem;
	[self.table setEditing:YES animated:YES];
}

- (void)editDoneClick:(id)sender {
	self.navigationItem.rightBarButtonItem = editButtonItem;
	[self.table setEditing:NO animated:YES];
}

- (void)refreshTable {
	[table reloadData];
}

- (void)bindMessage {
	NSString *url = [kServerUrl stringByAppendingString:kMessageListUrl];
	NSString *query = [NSString stringWithFormat:@"/%d", self.page];
	url = [url stringByAppendingString:query];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didMessageReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

#pragma mark -
#pragma mark HTTPRequest delegate

- (void)didMessageReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	self.messageList = [(NSMutableArray *)[jsonData objectForKey:@"data"] retain];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"성공");
		
		[self refreshTable];
	}
}

- (void)didMessageDeleteReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if ([[resultStr objectForKey:@"result"] isEqualToString:@"fail"]) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
		[self refreshTable];
	} else {
		
		NSLog(@"성공");
		[self.messageList removeObjectAtIndex:selectedRow ];
		[self refreshTable];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"쪽지목록";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = UIColorFromRGB(kValueTextColor);
        
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.messageList != nil) {
		
		if(messageList.count > 0){
			NSDictionary *message = [self.messageList objectAtIndex:row];
			long long time = [[NSString stringWithFormat:@"%@",[message objectForKey:@"sendDate"]] longLongValue];
			time = time / 1000;
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd"];
			//NSString *label = [[message objectForKey:@"msgTitle"] stringByAppendingFormat:@" (%@)",[dateFormat stringFromDate:date]];
			//cell.textLabel.text = label;
			cell.textLabel.text = [message objectForKey:@"msgTitle"];
			cell.detailTextLabel.text = [dateFormat stringFromDate:date];
			
		}
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	NSDictionary *message = [[self.messageList objectAtIndex:row] retain];
	
	MessageReadController *messageReadController = [[MessageReadController alloc] initWithNibName:@"MessageReadController" bundle:[NSBundle mainBundle]];
	messageReadController.messageNo = [[NSString stringWithFormat:@"%@",[message objectForKey:@"msgNo"]] intValue];
	messageReadController.messageTitle = [message objectForKey:@"msgTitle"];
	messageReadController.receiveUserID = [message objectForKey:@"receiveUserID"];
	messageReadController.sendUserID = [message objectForKey:@"sendUserID"];
	messageReadController.receiveUserName = [message objectForKey:@"receiveUserName"];
    messageReadController.sendUserName = [message objectForKey:@"sendUserName"];
	NSLog(@"sendUserID = %@ receiveUserID=%@", [message objectForKey:@"sendUserID"], [message objectForKey:@"receiveUserID"]);
	/*
	[self.navigationController pushViewController:messageReadController animated:YES];
	;
	[messageReadController release];
	 */
	
	/*
	UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
	field.font = TTSTYLEVAR(font);
    field.backgroundColor = TTSTYLEVAR(backgroundColor);
	
	UIBarButtonItem *fieldItem = [[UIBarButtonItem alloc] initWithCustomView:field];
	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"전송" style:UIBarButtonItemStyleBordered target:messageReadController action:@selector(sendClick:)];
	NSArray *toolbar = [[NSArray alloc] initWithObjects:fieldItem, sendButton, nil];
	messageReadController.toolbarItems = toolbar;
	 */
	 
	UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:messageReadController];
	//naviCon.toolbarHidden = NO;
	
	[self presentModalViewController:naviCon animated:YES];
	
	[message release];
	[messageReadController release];
	[naviCon release];
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	NSDictionary *message = [[self.messageList objectAtIndex:row] retain];
	
	//[self.messageList removeObjectAtIndex:row];
	selectedRow = row;
	
	NSString *url = [kServerUrl stringByAppendingString:kMessageDeleteUrl];
	NSString *query = [NSString stringWithFormat:@"/%@", [message objectForKey:@"msgNo"]];
	url = [url stringByAppendingString:query];
	
	[message release];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didMessageDeleteReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

@end
