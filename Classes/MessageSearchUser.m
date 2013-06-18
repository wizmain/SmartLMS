//
//  MessageSearchUser.m
//  mClass
//
//  Created by 김규완 on 11. 1. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageSearchUser.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "Constants.h"
#import "AlertUtils.h"
#import "MessageReadController.h"

@implementation MessageSearchUser

@synthesize searchBar, userList, copiedUserList, searching, isSelectRow;
@synthesize table, searchDisplayController;

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
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self 
											  action:@selector(closeWindow:)];
	self.navigationItem.title = @"회원검색";
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
    self.searchBar = nil;
    self.userList = nil;
    self.copiedUserList = nil;
    self.table = nil;
}


- (void)dealloc {
	[searchBar release];
	[userList release];
	[copiedUserList release];
    [table release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (void)searchUser {
	
	NSString *url = [kServerUrl stringByAppendingString:kSearchUserPostUrl];
	//NSString *query = [NSString stringWithFormat:@"/%@/1", searchBar.text];
	//url = [url stringByAppendingString:query];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	
	//POST로 전송할 데이터 설정
	NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:searchBar.text, @"searchText", @"1", @"page", nil];
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didSearchUserReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST" withTag:nil];
	
}



- (void)closeWindow:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark HTTPRequest delegate
- (void)didSearchUserReceiveFinished:(NSString *)result {
	NSLog(@"result = %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	self.userList = [(NSMutableArray *)[jsonData objectForKey:@"data"] retain];
	NSDictionary *resultObj = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultObj) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"성공");
		
		[self.searchDisplayController.searchResultsTableView reloadData];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"numberOfRowsInSection = %d", [self.userList count]);
	//return [self.userList count];
	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        // NSLog(@"count is %d", [self.filteredListContent count]);
        return [self.userList count];
    } else {
        return 0;
    } 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"회원정보";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.userList != nil) {
		
		if(self.userList.count > 0){
			
			if (tableView == self.searchDisplayController.searchResultsTableView) {
				
				NSDictionary *userInfo = [self.userList objectAtIndex:row];
				NSString *label = [[userInfo objectForKey:@"userKName"] stringByAppendingFormat:@" (%@)",[userInfo objectForKey:@"userID"]];
				
				cell.textLabel.text = label;
				
			} else {
				
			}
			
			
		}
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		NSDictionary *user = [userList objectAtIndex:[indexPath row]];
		
		MessageReadController *messageReadController = [[MessageReadController alloc] 
														initWithNibName:@"MessageReadController" 
														bundle:[NSBundle mainBundle]];
        
        
        NSLog(@"receiveUserID=%@, receiveUserName=%@", [user objectForKey:@"userID"],[user objectForKey:@"userKName"]);
        messageReadController.sendUserID = [user objectForKey:@"userID"];
		messageReadController.receiveUserID = [[SmartLMSAppDelegate sharedAppDelegate] authUserID];
		messageReadController.receiveUserName = [user objectForKey:@"userKName"];
		
		[self.navigationController pushViewController:messageReadController animated:YES];
		[user release];
		[messageReadController release];
		
    } else {
        
    }
	
}

#pragma mark -
#pragma mark SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	searching = YES;
	isSelectRow = NO;
	self.table.scrollEnabled = NO;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	[copiedUserList removeAllObjects];
	
	if ([searchText length] > 0) {
		searching = YES;
		isSelectRow = YES;
		self.table.scrollEnabled = YES;
		[self searchUser];
	} else {
		searching = NO;
		isSelectRow = NO;
		self.table.scrollEnabled = NO;
	}
	
	//[self.table reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	NSLog(@"searchBarSearchButtonClicked");
	[self searchUser];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	//searchDisplayController.searchBar.hidden = YES;
	[searchDisplayController setActive:NO animated:YES];
}

#pragma mark -
#pragma mark SearchDisplayDelegate
//검색창이 닫아지는 때에 호출
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
	[self searchBarCancelButtonClicked:controller.searchBar];
}
//검색창에 키워드 등록시 호출
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	return YES;
}



@end
