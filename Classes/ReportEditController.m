//
//  ReportEditController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReportEditController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Constants.h"
#import "Utils.h"
#import "UITextViewCell.h"
#import "UITextFieldCell.h"

#define kUITextViewCellRowHeight	323.0
#define kUITabBarHeight				50

@implementation ReportEditController

@synthesize titleText, startDateText, closeDateText, contentText, saveButton, reportNo;
@synthesize isShowingKeyboard, table, report, selectedSection, resignTextFieldButton, contentEditDoneButton;
@synthesize actionSheet, startDatePicker, closeDatePicker, lectureNo, itemNo, lectureTitle;

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
    [titleText release];
    [startDateText release];
    [closeDateText release];
    [contentText release];
    [saveButton release];
    [startDatePicker release];
    [closeDatePicker release];
    [actionSheet release];
    [contentEditDoneButton release];
    [resignTextFieldButton release];
    [report release];
    [table release];
    [lectureTitle release];
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
    self.navigationItem.title = lectureTitle;
    isShowingKeyboard = NO;
    
    self.navigationItem.hidesBackButton = YES;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    
    //과제정보 바인드
    [self bindReportInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignTextField:) name:UITextViewTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:@"EditArticleShouldHideKeyboard" object:nil];

    
    contentEditDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(reportContentEditDone:)];
    /*
    saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveReport:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    */
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    [save setBackgroundImage:[UIImage imageNamed:@"nav_save"] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveReport:) forControlEvents:UIControlEventTouchUpInside];
    save.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:save] autorelease];
    
    
    
    //날짜 설정용 datePicker설정
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    startDatePicker.datePickerMode = UIDatePickerModeDate;
    startDatePicker.date = [[NSDate alloc] init];
    [startDatePicker addTarget:self action:@selector(startDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    closeDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    closeDatePicker.datePickerMode = UIDatePickerModeDate;
    closeDatePicker.date = [[NSDate alloc] init];
    [closeDatePicker addTarget:self action:@selector(closeDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *actionSheetToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    actionSheetToolbar.barStyle = UIBarStyleBlackOpaque;
    [actionSheetToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:spacer];
    [spacer release];
    
    /*
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
    [barItems addObject:cancel];
    [cancel release];
    */
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideDatePicker:)];
    [barItems addObject:done];
    [done release];
    
    [actionSheetToolbar setItems:barItems];
    [barItems release];
    
    [actionSheet addSubview:actionSheetToolbar];
    [actionSheet addSubview:startDatePicker];
    [actionSheet addSubview:closeDatePicker];
    
    [actionSheetToolbar release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    /*
     
     [titleText release];
     [startDateText release];
     [closeDateText release];
     [contentText release];
     [saveButton release];
     [startDatePicker release];
     [closeDatePicker release];
     [actionSheet release];
     [contentEditDoneButton release];
     [resignTextFieldButton release];
     [report release];
     [table release];
     [lectureTitle release];

    */
    self.titleText = nil;
    self.startDateText = nil;
    self.closeDateText = nil;
    self.contentText = nil;
    self.saveButton = nil;
    self.startDatePicker = nil;
    self.closeDatePicker = nil;
    self.contentEditDoneButton = nil;
    self.resignTextFieldButton = nil;
    self.report =nil;
    self.table = nil;
    self.lectureTitle =nil;
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

- (void)bindReportInfo {
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kReportInfoUrl];
	url = [url stringByAppendingFormat:@"/%d",self.reportNo];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (void)saveReport:(id)sender {
    
    NSString *url = [kServerUrl stringByAppendingString:kReportSaveUrl];
	NSString *action;
	
	if ( reportNo > 0) {
		action = @"update";
	} else {
		action = @"insert";
	}
	
	//url = [url stringByAppendingString:query];
	
	//POST로 전송할 데이터 설정
	NSDictionary *bodyObject =  [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSString stringWithFormat:@"%d", reportNo], @"reportNo", 
								 [NSString stringWithFormat:@"%d", lectureNo], @"lectureNo",
								 [NSString stringWithFormat:@"%d", itemNo], @"itemNo",
								 action,@"action",
								 titleText.text, @"reportName",
								 contentText.text, @"reportContent",
                                 startDateText.text, @"startDate",
                                 closeDateText.text, @"closeDate", nil];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReportSaveFinished:)];
	[httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST" withTag:nil];
}

#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	self.report = (NSDictionary *)[jsonData objectForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
        
		titleText.text = [report valueForKey:@"reportNm"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        long long submitStartTime = [[NSString stringWithFormat:@"%@",[report objectForKey:@"submitStartDt"]] longLongValue];
        
        submitStartTime = submitStartTime / 1000;
        NSDate *submitStartDate = [NSDate dateWithTimeIntervalSince1970:submitStartTime];
        
        NSString *submitStartDateString = [dateFormat stringFromDate:submitStartDate];
        
        long long submitCloseTime = [[NSString stringWithFormat:@"%@",[report objectForKey:@"submitCloseDt"]] longLongValue];
        
        submitCloseTime = submitCloseTime / 1000;
        NSDate *submitCloseDate = [NSDate dateWithTimeIntervalSince1970:submitCloseTime];
        
        NSString *submitCloseDateString = [dateFormat stringFromDate:submitCloseDate];
        
        startDateText.text = submitStartDateString;
        closeDateText.text = submitCloseDateString;
        
        contentText.text = [report objectForKey:@"reportContent"];
        [dateFormat release];
	}
	
	[jsonParser release];
	
}
- (void)didReportSaveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
        if ([[resultStr objectForKey:@"result"] isEqualToString:@"success"]) {
            //AlertWithMessage([jsonData objectForKey:@"message"]);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            AlertWithMessage([jsonData objectForKey:@"message"]);
        }

	} else {
        
    }
	
	[jsonParser release];
	
}


- (IBAction)resignTextField:(id)sender {
	NSLog(@"resignTextField");
	[titleText resignFirstResponder];
	UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	for(UIView *subview in cell.contentView.subviews) {
		if([subview isKindOfClass:[UITextView class]]) {
			[subview becomeFirstResponder];
			break;
		}
	}
	[self.view sendSubviewToBack:resignTextFieldButton];
}

- (void)hideKeyboard:(NSNotification *)notification {
	
	UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	for(UIView *subview in cell.contentView.subviews) {
		if([subview isKindOfClass:[UITextView class]]) {
			contentText = [(UITextView *)subview retain];
			break;
		}
	}
	
	if(contentText != nil) {
		[contentText resignFirstResponder];
	}
	[titleText resignFirstResponder];
	
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *keyboardInfo = (NSDictionary *)[notification userInfo];
	self.isShowingKeyboard = YES;
	
	CGRect keyboardEndFrame;
	CGFloat keyboardHeight;
	
	[[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrame];
	
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || 
		[[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
		keyboardHeight = keyboardEndFrame.size.height;
	} else {
		keyboardHeight = keyboardEndFrame.size.width;
	}
	
	CGFloat animationDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	UIViewAnimationCurve curve = [[keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationCurve:curve]; 
	[UIView setAnimationDuration:animationDuration]; 
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	CGRect frame = self.view.frame;
	frame.size.height -= keyboardHeight;
	frame.size.height += kUITabBarHeight;
	self.view.frame = frame;
	
	[UIView commitAnimations];
	
	[self.view bringSubviewToFront:resignTextFieldButton];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	NSDictionary *keyboardInfo = (NSDictionary *)[notification userInfo];
	self.isShowingKeyboard = NO;
	
	if((contentText != nil)) {
		CGRect keyboardEndFrame;
		CGFloat keyboardHeight;
		
		[[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrame];
		
		if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || 
			[[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
			keyboardHeight = keyboardEndFrame.size.height;
		} else {
			keyboardHeight = keyboardEndFrame.size.width;
		}
		
		CGFloat animationDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
		UIViewAnimationCurve curve = [[keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
		
		[UIView beginAnimations:nil context:nil]; 
		[UIView setAnimationCurve:curve]; 
		[UIView setAnimationDuration:animationDuration]; 
        [UIView setAnimationBeginsFromCurrentState:YES];
		
        CGRect frame = self.view.frame;
        frame.size.height += keyboardHeight;
		frame.size.height -= kUITabBarHeight;
        self.view.frame = frame;
		
		[UIView commitAnimations];
	}	
}

- (void)reportContentEditDone:(id)sender{
    [contentText resignFirstResponder];
}

- (void)showDatePicker:(id)sender {
    
    UITextField *textField = (UITextField *)sender;
    
    if(textField.tag == 2){
        //[self.view bringSubviewToFront:resignTextFieldButton];
        [actionSheet bringSubviewToFront:startDatePicker];
    }
    else{
        [actionSheet bringSubviewToFront:closeDatePicker];
    }
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    //[actionSheet showFromTabBar:super.view.tabBarController];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 500)];

}

- (void)hideDatePicker:(id)sender {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)startDateChanged:(id)sender {
    NSLog(@"startDateChanged");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"date = %@",[formatter stringFromDate:[startDatePicker date]]);

    startDateText.text = [formatter stringFromDate:[startDatePicker date]];

    [formatter release];
}

- (void)closeDateChanged:(id)sender {
    NSLog(@"closeDateChanged");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"date = %@",[formatter stringFromDate:[closeDatePicker date]]);
    
    closeDateText.text = [formatter stringFromDate:[closeDatePicker date]];

    [formatter release];
}

#pragma mark -
#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
    //[table reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"textFieldDidBeginEditing");
    selectedSection = textField.tag;
    NSLog(@"selectedSection = %d", selectedSection);
    
    if (textField.tag == 2 || textField.tag == 3) {
        [textField resignFirstResponder];
        NSString *dateString = textField.text;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormater dateFromString:dateString];
        
        if(textField.tag == 2) {
            startDatePicker.date = dateFromString;
        } else if(textField.tag == 3) {
            closeDatePicker.date = dateFromString;
        }
        [dateFormater release];
        
        [self showDatePicker:textField];
    }
    
	
	
	[self.view bringSubviewToFront:resignTextFieldButton];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	selectedSection = 0;
	[textField resignFirstResponder];
    if ([textField.text isEqualToString:@"#%#"]) {
        [NSException raise:@"Test exception" format:@"Nothing bad, actually"];
    }
	
	//[table reloadData];
}

#pragma mark -
#pragma mark UITextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
	NSLog(@"textViewDidBeginEditing");
	selectedSection = 4;
	
    UITableViewCell *cell = (UITableViewCell*) [[textView superview] superview];
    [table scrollToRowAtIndexPath:[table indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	NSLog(@"scrollToRowAtIndexPath:%@", [table indexPathForCell:cell]);

    self.navigationItem.rightBarButtonItem = contentEditDoneButton;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	NSLog(@"textViewDidEndEditing");
	
	selectedSection = 0;
	
	UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	for(UIView *subview in cell.contentView.subviews) {
		if([subview isKindOfClass:[UITextView class]]) {
			contentText = [(UITextView *)subview retain];
			break;
		}
	}
	
	[self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	[textView resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem = saveButton;

	//[table reloadData];
}
/*
 - (void)textViewDidChange:(UITextView *)textView {
 //[self refreshPage];
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;//몇개의 섹션으로 이루어져 있다
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int result = 0;
	
	switch (section) {
		case 0://title섹션일때 테이블 row 수
			result = 1;
			break;
		case 1://내용 섹션일 때 테이블 row 수
			result = 2;
			break;
        case 2:
            result = 1;
		default:
			break;
	}
	
	return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int result = 45;
	
	switch (indexPath.section) {
		case 0:
			result = 45;
			break;
        case 1:
            result = 45;
            break;
		case 2:
			result = kUITextViewCellRowHeight;
			break;
		default:
			break;
	}
	
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//타이틀
	UITextFieldCell *textCell = (UITextFieldCell *) [tableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
	if (textCell == nil) {
        textCell = [UITextFieldCell createNewTextCellFromNib];
    }
	
	//내용
	UITextViewCell *contentCell = (UITextViewCell *) [tableView dequeueReusableCellWithIdentifier:kCellTextView_ID];
	if (contentCell == nil) {
        contentCell = [UITextViewCell createNewTextCellFromNib];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"과제명";
					textCell.textField.placeholder = @"과제명";
					textCell.textField.tag = 1;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
					
					if(self.report)
						textCell.textField.text = [self.report objectForKey:@"reportNm"];
					
					titleText = [textCell.textField retain];
                    
					
					cell = textCell;
					break;
                    /*
                     case 1:
                     cell.textLabel.font = [UIFont systemFontOfSize:16.0];
                     cell.textLabel.textColor = [UIColor grayColor];
                     cell.textLabel.text = @"Status";
                     
                     cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
                     if(self.page.status != nil)
                     cell.detailTextLabel.text = [statuses objectForKey:self.page.status];
                     cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
                     break;
                     */
				default:
					break;
			}
			
			break;
        case 1:
        {
            switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"제출시작일";
					textCell.textField.placeholder = @"제출시작일";
					textCell.textField.tag = 2;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
                    //textCell.textField.enabled = NO;
					
					if(self.report){
                        long long submitStartTime = [[NSString stringWithFormat:@"%@",[report objectForKey:@"submitStartDt"]] longLongValue];
                        
                        submitStartTime = submitStartTime / 1000;
                        NSDate *submitStartDate = [NSDate dateWithTimeIntervalSince1970:submitStartTime];

						textCell.textField.text = [dateFormat stringFromDate:submitStartDate];
                    }
					startDateText = [textCell.textField retain];
					
					cell = textCell;
					break;
                case 1:
                    textCell.titleLabel.text = @"제출마감일";
					textCell.textField.placeholder = @"제출마감일";
					textCell.textField.tag = 3;
					textCell.textField.delegate = self;
					textCell.textField.returnKeyType = UIReturnKeyDone;
                    //textCell.textField.enabled = NO;
                    
					
					if(self.report){
						
                        long long submitCloseTime = [[NSString stringWithFormat:@"%@",[report objectForKey:@"submitCloseDt"]] longLongValue];
                        
                        submitCloseTime = submitCloseTime / 1000;
                        NSDate *submitCloseDate = [NSDate dateWithTimeIntervalSince1970:submitCloseTime];
                        
                        textCell.textField.text = [dateFormat stringFromDate:submitCloseDate];
                    }
					
					closeDateText = [textCell.textField retain];
					
					cell = textCell;
                    /*
                    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
                    cell.textLabel.textColor = [UIColor grayColor];
                    cell.textLabel.text = @"Status";
                     
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
                    if(self.page.status != nil)
                        cell.detailTextLabel.text = [statuses objectForKey:self.page.status];
                    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
                    */
                    break;
                    
				default:
					break;
			}
			
			break;

            
        }
		case 2:
        {
			UIColor *backgroundColor = [UIColor whiteColor];
			
			// Uncomment the following line for debugging UITextView position
			// backgroundColor = [UIColor blueColor];
			
			contentCell.textView.backgroundColor = backgroundColor;
			contentCell.textView.tag = 4;
			contentCell.textView.delegate = self;
			//contentCell.textView.returnKeyType = UIReturnKeyDone;
            contentCell.textView.font = [UIFont fontWithName:@"Helvetica" size:14.0];
			
			if(self.report)
				contentCell.textView.text = [self.report objectForKey:@"reportContent"];
			cell = contentCell;
            
			contentText = [contentCell.textView retain];
			break;
        }
            
		default:
			break;
	}
    
    return cell;
}



@end
