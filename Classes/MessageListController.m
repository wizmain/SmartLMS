//
//  MessageListController.m
//  mClass
//
//  Created by 김규완 on 11. 2. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageListController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "Constants.h"
#import "AlertUtils.h"
#import "MessageReadController.h"
#import "MessageSearchUser.h"
#import "TransparentToolbar.h"

@implementation MessageListController

@synthesize messageList, page;
@synthesize isEditMode, selectedImage, deselectedImage, selectedArray, editButtonItem, deleteButtonItem, trashButton;
//@synthesize toolbar;

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
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
	
	self.page = 1;
	self.navigationItem.title = @"메세지함";
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_middle.png"]];
	
	self.isEditMode = NO;
	self.selectedImage = [UIImage imageNamed:@"selected.png"];
	self.deselectedImage = [UIImage imageNamed:@"unselected.png"];
	
	//----------------------------------------------------------------------------------------------------------------
	// navigationbar의 오른쪽 버튼 바인드
	
	UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																		  target:self 
																		  action:@selector(editClick:)];
	edit.style = UIBarButtonItemStyleBordered;
	
	UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																			 target:self 
																			 action:@selector(writeMessageClick:)];
	compose.style = UIBarButtonItemStyleBordered;
	
	TransparentToolbar *editButtons = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
	[editButtons setItems:[[[NSArray alloc] initWithObjects:edit, compose, nil] autorelease]];
	editButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButtons];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[edit release];
	[compose release];
	[editButtons release];
	//----------------------------------------------------------------------------------------------------------------
	
		
	
	
	//서버에서 쪽지 목록 가져오기
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
    self.selectedArray = nil;
    self.selectedImage = nil;
    self.deselectedImage = nil;
    self.deleteButtonItem = nil;
    self.editButtonItem = nil;
    self.messageList =nil;
    self.trashButton = nil;
}


- (void)dealloc {
	[selectedArray release];
	[selectedImage release];
	[deselectedImage release];
	[deleteButtonItem release];
	[editButtonItem release];
	[messageList release];
	[trashButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (void)makeDeleteItem {
	//----------------------------------------------------------------------------------------------------------------
	// 에디트 모드시 하단 툴바에 나타나는 버튼 바인드
	UIImage *trashBackImg = [UIImage imageNamed:@"redbutton"];
	UIImage *trashImage = [UIImage imageNamed:@"062-WhiteTrash"];
	//[trashImage setAlpha:78.0f];
	
	trashButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[trashButton addTarget:self 
					action:@selector(deleteMessage:) 
		  forControlEvents:UIControlEventTouchUpInside];
	trashButton.frame = CGRectMake(0.0f, 0.0f, 95.0f, 29.0f);
	trashButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	trashButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[trashButton setTitle:@"삭    제" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected ];
	[trashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected ];
	[trashButton.titleLabel setFont:[UIFont fontWithName:@"AppleGothic" size:15.0f]];
	[trashButton.titleLabel setAlpha:78.0f];
	[trashButton setBackgroundImage:[trashBackImg stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
	trashButton.adjustsImageWhenDisabled = YES;
	trashButton.adjustsImageWhenHighlighted = YES;
	[trashButton setBackgroundColor:[UIColor clearColor]];
	[trashButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];//trashImage.size.width
	[trashButton setImage:trashImage forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected ];
	[trashButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];//trashButton.titleLabel.bounds.size.width
	deleteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:trashButton];
	
	
	/*
	 //툴바 만들기
	 //self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 45)];
	 toolbar = [[UIToolbar alloc] init];
	 [toolbar setBarStyle:UIBarStyleBlackOpaque];//UIBarStyleDefault, UIBarStyleBlackOpaque, UIBarStyleBlackTranslucent, 
	 //[toolbar setBackgroundColor:RGB(200, 200, 200)];
	 [toolbar setOpaque:NO];
	 [toolbar setTranslucent:NO];
	 [toolbar sizeToFit];
	 // 툴바의 높이를 계산한다. 
	 CGFloat toolbarHeight = [toolbar frame].size.height;
	 // 뷰의 영역를 얻는다. 
	 CGRect viewBounds = self.view.bounds;
	 // 뷰의 영역에서 높이를 얻는다.
	 CGFloat viewHeight = CGRectGetHeight(viewBounds);
	 // 뷰의 영역에서 폭를 얻는다.
	 CGFloat viewWidth = CGRectGetWidth(viewBounds);
	 // 툴바의 영역을 만듣다.
	 CGRect rectArea = CGRectMake(0, viewHeight - toolbarHeight - 100, viewWidth, toolbarHeight);
	 // 툴바의 영역를 설정한다. 
	 [toolbar setFrame:rectArea];
	 
	 UIBarButtonItem *trashButtonItem = [[UIBarButtonItem alloc] initWithCustomView:trashButton];
	 [toolbar setItems:[[[NSArray alloc] initWithObjects:trashButtonItem, nil] autorelease]];
	 self.toolbar.hidden = NO;
	 [self.view addSubview:toolbar];
	 */
	[trashImage release];
	[trashBackImg release];
}	

//삭제모드시 선택된 데이타 배열
- (void)initSelectedArray {
	if (self.messageList != nil) {
		
		NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.messageList.count];
		for (int i=0; i<self.messageList.count; i++) {
			[array addObject:[NSNumber numberWithBool:NO]];
		}
		self.selectedArray = array;
		[array release];
	}
}

- (void)writeMessageClick:(id)sender {
	
	MessageSearchUser *searchUserController = [[MessageSearchUser alloc] initWithNibName:@"MessageSearchUser" bundle:nil];
	UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:searchUserController];
	
	
	[self presentModalViewController:naviCon animated:YES];
	
	[searchUserController release];
	[naviCon release];
	
}

- (void)editClick:(id)sender {
	self.isEditMode = !isEditMode;
	//self.toolbar.hidden = !isEditMode;
	[self toggleRightButton];
	[self.tableView reloadData];
}

//navigationbar의 오른쪽 메뉴 버튼 토글
- (void)toggleRightButton {
	//수정모드이면
	if (isEditMode) {
		//삭제버튼 바인드
		if ( self.deleteButtonItem == nil) {
			[self makeDeleteItem];
		}
		self.navigationItem.rightBarButtonItem = self.deleteButtonItem;
		
	} else {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}
}

- (void)refreshTable {
	[self.tableView reloadData];
}

//서버에서 쪽지 데이타 가져오기
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
 
- (void)deleteMessage:(id)sender {
	
	for (int i=0; i<selectedArray.count; i++) {
		NSNumber *selected = [selectedArray objectAtIndex:i];
		if ([selected boolValue] == YES) {
			//삭제
		}
	}
	
	self.isEditMode = !isEditMode;
	//self.toolbar.hidden = !isEditMode;
	[self toggleRightButton];
	[self.tableView reloadData];
	
}

#pragma mark -
#pragma mark HTTPRequest delegate

- (void)didMessageReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	self.messageList = [(NSArray *)[jsonData objectForKey:@"data"] retain];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"성공");
		[self initSelectedArray];
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		
		UILabel *label = [[UILabel alloc] initWithFrame:kLabelRect];
		label.tag = kCellLabelTag;
		[cell.contentView addSubview:label];
		[label release];
		
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:deselectedImage];
		imageView.frame = CGRectMake(5.0, 10.0, 23.0, 23.0);
		[cell.contentView addSubview:imageView];
		imageView.hidden = !isEditMode;
		imageView.tag = kCellImageViewTag;
		[imageView release];
		
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
			NSString *labelString = [[message objectForKey:@"msgTitle"] stringByAppendingFormat:@" (%@)",[dateFormat stringFromDate:date]];
			//cell.textLabel.text = labelString;
			
						
			[UIView beginAnimations:@"cell shift" context:nil];
			
			UILabel *label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
			label.text = labelString;
			label.frame = (isEditMode) ? kLabelIndentedRect : kLabelRect;
			label.opaque = NO;
			
			UIImageView *iconImage = (UIImageView *)[cell.contentView viewWithTag:kCellImageViewTag];
			NSNumber *selected = [selectedArray objectAtIndex:row];
			iconImage.image = ([selected boolValue]) ? selectedImage : deselectedImage;
			iconImage.hidden = !isEditMode;
			[UIView commitAnimations];
			
		}
	}
	
	
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	NSDictionary *message = [self.messageList objectAtIndex:row];
	
	if (isEditMode) {
		BOOL selected = [[selectedArray objectAtIndex:row] boolValue];
		[selectedArray replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:!selected]];
		[self.tableView reloadData];
	} else {
		MessageReadController *messageReadController = [[MessageReadController alloc] initWithNibName:@"MessageReadController" bundle:[NSBundle mainBundle]];
		messageReadController.messageNo = [[NSString stringWithFormat:@"%@",[message objectForKey:@"msgNo"]] intValue];
		messageReadController.messageTitle = [message objectForKey:@"msgTitle"];
		messageReadController.receiveUserID = [message objectForKey:@"sendUserID"];
		messageReadController.sendUserID = [message objectForKey:@"receiveUserID"];
		messageReadController.receiveUserName = [message objectForKey:@"receiveUserName"];
		
		UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:messageReadController];
		//naviCon.toolbarHidden = NO;
		
		[self presentModalViewController:naviCon animated:YES];
		
		[message release];
		[messageReadController release];
		[naviCon release];
	}
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

@end
