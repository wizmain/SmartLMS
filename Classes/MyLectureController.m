//
//  MyLectureController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyLectureController.h"
#import "YearPickerDelegate.h"
#import "TermPickerDelegate.h"
#import "JSON.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "AlertUtils.h"
#import "NSString+Util.h"
#import "LectureItemController.h"
#import "LoginViewController.h"

@implementation MyLectureController


@synthesize lectureTable;
@synthesize yearButton;
@synthesize termButton;
@synthesize searchButton;
@synthesize viewDidMove, keyboardIsVisible;
@synthesize lectureList;

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

- (IBAction)searchButtonClicked:(id)sender {
	[self bindLectureList];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
	
	self.navigationItem.title = @"수업방";
	
	//년도, 학기 Picker Delegater 생성
	yearPickerDelegate = [[YearPickerDelegate alloc] init];
	termPickerDelegate = [[TermPickerDelegate alloc] init];
	
	//PickerView생성
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	yearPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	yearPickerView.showsSelectionIndicator = YES;
	yearPickerView.delegate = yearPickerDelegate;
	yearPickerView.dataSource = yearPickerDelegate;
	[yearPickerView selectRow:[yearPickerDelegate selectedYearIndex] inComponent:0 animated:YES];
	termPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	termPickerView.showsSelectionIndicator = YES;
	termPickerView.delegate = termPickerDelegate;
	termPickerView.dataSource = termPickerDelegate;
	[termPickerView selectRow:[termPickerDelegate selectedTermIndex] inComponent:0 animated:YES];
	
	if([[SmartLMSAppDelegate sharedAppDelegate] isAuthenticated] == NO) {
		LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
		UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
		loginView.navigationItem.title = @"로그인";
		
		[self presentModalViewController:navi animated:YES];
		//[self.parentViewController switchLoginView];
	} else {
		NSLog(@"logined");
		[self bindLectureList];
	}
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLectureTable) name:@"didTableReloaded" object:nil];
	
	/*
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 28)] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:15];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.8];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.text = @"강좌목록";
	lectureTable.tableHeaderView = label;
	 */
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
	self.lectureTable = nil;
	actionSheet = nil;
	activeTextField = nil;
	self.yearButton = nil;
	self.termButton = nil;
	yearPickerDelegate = nil;
	termPickerDelegate = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification
											   object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification object:nil];
	[super viewWillDisappear:animated];
}

- (void)dealloc {
	[lectureTable release];
	[actionSheet release];
	[activeTextField release];
	[yearButton release];
	[termButton release];
	[yearPickerDelegate release];
    [super dealloc];
}

#pragma mark -
#pragma mark custom method
- (void)reloadLectureTable {
	[self.lectureTable reloadData];
}

- (void)bindLectureList {
    
    NSLog(@"bindLectureList");
    
	//접속할 주소 설정
	NSString *year = [[yearPickerDelegate pData] objectAtIndex:[yearPickerView selectedRowInComponent:0]];
	NSString *term = [[termPickerDelegate pData] objectAtIndex:[termPickerView selectedRowInComponent:0]];
	NSString *termCode;
	
	if (year == nil || term == nil) {
		AlertWithMessage(@"년도와 학기를 선택해 주세요");
		return;
	}
	if ([year isEmpty] || [term isEmpty]) {
		AlertWithMessage(@"년도와 학기를 선택해 주세요");
		return;
	}
	
	if ([term isEqualToString:@"1학기"]) {
		termCode = kTerm10;
	} else if ([term isEqualToString:@"여름계절학기"]) {
		termCode = kTerm11;
	} else if ([term isEqualToString:@"2학기"]) {
		termCode = kTerm20;
	} else if ([term isEqualToString:@"겨울계절학기"]) {
		termCode = kTerm21;
	}
	
	//NSString *url = [[[mClassAppDelegate sharedAppDelegate] serverUrl] stringByAppendingString:[[mClassAppDelegate sharedAppDelegate] loginUrl]];
	NSString *url = [[kServerUrl stringByAppendingString:kMyLectureUrl] stringByAppendingString:@"/"];
	url = [[[url stringByAppendingString:year] stringByAppendingString:@"/"] stringByAppendingString:termCode];
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"request url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
	
	
}

#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	//NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	/*
	NSArray *data = (NSArray *)[jsonData valueForKey:@"data"];
	//NSLog(@"data count = %@", [data count]);
	NSDictionary *tmp;
	if (data) {
		for (int k=0; k<data.count; k++) {
			NSDictionary *tmp = (NSDictionary *)[data objectAtIndex:k];
			NSLog(@"data = %@",[tmp valueForKey:@"lectureKorNm"]);
		}
	}
	*/
	self.lectureList = (NSArray *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"lectureList count %d", [lectureList count]);
		for (int i=0; i<self.lectureList.count; i++) {
			//NSLog(@"%d = %@",i, [lectureList objectAtIndex:i]);
			NSDictionary *lecture = (NSDictionary *)[lectureList objectAtIndex:i];
			NSLog(@"LectureName = %@", [lecture valueForKey:@"lectureKorNm"]);
		}
	}

	/*
	 NSString *key;
	 for (key in jsonData){
	 NSLog(@"Key: %@, Value: %@", key, [jsonData valueForKey:key]);
	 }
	 for (key in userSession){
	 NSLog(@"Key: %@, Value: %@", key, [userSession valueForKey:key]);
	 }
	 */
	
	[jsonParser release];
	
	//lectureTable reload
	[self reloadLectureTable];
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"didTableReloaded" object:self userInfo:nil];

}

/*
- (void)keyboardWillShow:(NSNotification *)notification {
    if (keyboardIsVisible)
        return;
	
	NSDictionary *info = [notification userInfo];
	NSValue *aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	NSTimeInterval animationDuration = 0.300000011920929;
	CGRect frame = self.view.frame;
	frame.origin.y -= keyboardSize.height-35;
	frame.size.height += keyboardSize.height-35;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	self.view.frame = frame;
	[UIView commitAnimations];
	
	viewDidMove = YES;
    keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    if (viewDidMove) {
        NSDictionary *info = [aNotification userInfo];
        NSValue *aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
		
        NSTimeInterval animationDuration = 0.300000011920929;
        CGRect frame = self.view.frame;
        frame.origin.y += keyboardSize.height-35;
        frame.size.height -= keyboardSize.height-35;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
		
        viewDidMove = NO;
    }
	
    keyboardIsVisible = NO;
}
*/


#pragma mark -
#pragma mark Picker Method

- (IBAction)showYearPicker:(id)sender {
	NSLog(@"showYearPicker");
	actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	//CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	//UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	//pickerView.showsSelectionIndicator = YES;
	
	//pickerView.delegate = yearPickerDelegate;
	//pickerView.dataSource = yearPickerDelegate;
	//[pickerView selectRow:[yearPickerDelegate selectedYearIndex] inComponent:0 animated:YES];
	//yearField.text = [[yearPickerDelegate pData] objectAtIndex:[pickerView selectedRowInComponent:0]];
	//[actionSheet addSubview:pickerView];
	
	[actionSheet addSubview:yearPickerView];
	
	UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
	closeButton.momentary = YES; 
	closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
	closeButton.tintColor = [UIColor blackColor];
	[closeButton addTarget:self action:@selector(hideYearPicker:) forControlEvents:UIControlEventValueChanged];
	[actionSheet addSubview:closeButton];
	
	[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
	
	//[pickerView release];
	[closeButton release];
	
}

- (IBAction)hideYearPicker:(id)sender {
	NSLog(@"hide Year Picker");

	[yearButton setTitle:[[yearPickerDelegate pData] objectAtIndex:[yearPickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
	
	[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	//[self.tableView reloadData];
	//self.bindLectureList;
}

- (IBAction)showTermPicker:(id)sender {
	
	actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	//CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	//UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	//pickerView.showsSelectionIndicator = YES;
	//pickerView.delegate = termPickerDelegate;
	//pickerView.dataSource = termPickerDelegate;
	//[pickerView selectRow:[self selectedTermIndex] inComponent:0 animated:YES];
	
	//[actionSheet addSubview:pickerView];
	[actionSheet addSubview:termPickerView];
	
	UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
	closeButton.momentary = YES; 
	closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
	closeButton.tintColor = [UIColor blackColor];
	[closeButton addTarget:self action:@selector(hideTermPicker:) forControlEvents:UIControlEventValueChanged];
	[actionSheet addSubview:closeButton];
	
	[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
	
	//[pickerView release];
	[closeButton release];
}

- (IBAction)hideTermPicker:(id)sender {
	
	[termButton setTitle:[[termPickerDelegate pData] objectAtIndex:[termPickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
	[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	//[self.tableView reloadData];
	//self.bindLectureList;
	
}	 
	 



#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.lectureList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"강좌 목록";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	
	//UIImageView *icon = [[UIImageView alloc] initWithImage:img];
	if (cell == nil) {
		UIImage *img = [UIImage imageNamed:@"169-PencilBlack"];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		[cell.imageView setImage:img];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSUInteger row = [indexPath row];
    NSLog(@"row = %d", row);
	if (self.lectureList != nil) {
		
		if(self.lectureList.count > 0){
			NSDictionary *lecture = [self.lectureList objectAtIndex:row];
			NSString *label = [[lecture objectForKey:@"lectureKorNm"] stringByAppendingFormat:@" (%@)",[lecture objectForKey:@"classNo"]];
			cell.textLabel.text = label;
		}
	}

	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	NSDictionary *lecture = [self.lectureList objectAtIndex:row];
	NSInteger lectureNo = [[NSString stringWithFormat:@"%@",[lecture objectForKey:@"lectureNo"]] intValue];
	NSString *lectureTitle = [lecture objectForKey:@"lectureKorNm"];
	
	LectureItemController *lectureItemController = [[LectureItemController alloc] initWithNibName:@"LectureItemController" bundle:[NSBundle mainBundle]];
	lectureItemController.lectureNo = lectureNo;
	lectureItemController.lectureTitle = lectureTitle;
	[self.navigationController pushViewController:lectureItemController animated:YES];
	[lectureItemController release];
	lectureItemController = nil;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 18.0;
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0, 0, 320, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
	label.textAlignment = UITextAlignmentCenter;
    label.text = @"강좌목록";
	
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
	view.backgroundColor = RGB(101, 169, 239);
    [view autorelease];
    [view addSubview:label];
	
    return view;
}


#pragma mark -
#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeTextField = nil;
}





@end
