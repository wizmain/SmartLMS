//
//  QuizEditController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizEditController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Constants.h"

#define kHourPicker 0
#define kMinPicker  1
#define kStartDateFieldTag  1
#define kCloseDateFieldTag  2
#define kStartHourFieldTag  5
#define kStartMinFieldTag   6
#define kCloseHourFieldTag  7
#define kCloseMinFieldTag   8
#define kStartTimePickerTag 3
#define kCloseTimePickerTag 4

@implementation QuizEditController

@synthesize etestNo, etest, lectureNo, itemNo;
@synthesize quizTitle, startDate, closeDate, saveButton;
@synthesize actionSheet, startDatePicker, closeDatePicker, etestState, etestSwitch, etestStateLabel;

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
    [quizTitle release];
    [startDate release];
    [closeDate release];
    [saveButton release];
    [actionSheet release];
    [startDatePicker release];
    [closeDatePicker release];
    [etestStateLabel release];
    [etestSwitch release];
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
    
    [self bindETestInfo];
    
    self.navigationItem.title = @"퀴즈수정";
    
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
    
    
    quizTitle.delegate = self;
    quizTitle.returnKeyType = UIReturnKeyDone;
    startDate.delegate = self;
    closeDate.delegate = self;
        
    //날짜 설정용 datePicker설정
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    startDatePicker.date = [[NSDate alloc] init];
    [startDatePicker addTarget:self action:@selector(startDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    closeDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    closeDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
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

- (void)bindETestInfo {
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kETestInfoUrl];
	url = [url stringByAppendingFormat:@"/%d",self.etestNo];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (IBAction)saveETestInfo {
    
    NSString *url = [kServerUrl stringByAppendingString:kETestSaveUrl];
	NSString *action;
	
	if ( etestNo > 0) {
		action = @"update";
	} else {
		action = @"insert";
	}
	
	//url = [url stringByAppendingString:query];
    //NSDateFormatter *fommater = [NSDateFormatter
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *submitStartDate = [dateFormat dateFromString:startDate.text];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *startYMD = [dateFormat stringFromDate:submitStartDate];
    [dateFormat setDateFormat:@"HH"];
    NSString *startH = [dateFormat stringFromDate:submitStartDate];
    [dateFormat setDateFormat:@"mm"];
    NSString *startM = [dateFormat stringFromDate:submitStartDate];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *submitCloseDate = [dateFormat dateFromString:closeDate.text];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *closeYMD = [dateFormat stringFromDate:submitCloseDate];
    [dateFormat setDateFormat:@"HH"];
    NSString *closeH = [dateFormat stringFromDate:submitCloseDate];
    [dateFormat setDateFormat:@"mm"];
    NSString *closeM = [dateFormat stringFromDate:submitCloseDate];
    
    [dateFormat release];
    
    NSLog(@"startDate %@, closeDate %@ closeYMD %@ submitCloseDate %@", startDate.text, closeDate.text, closeYMD, submitCloseDate);
    
	//POST로 전송할 데이터 설정
	NSDictionary *bodyObject =  [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSString stringWithFormat:@"%d", etestNo], @"etestNo", 
								 [NSString stringWithFormat:@"%d", lectureNo], @"lectureNo",
								 [NSString stringWithFormat:@"%d", itemNo], @"itemNo",
								 action,@"action",
								 quizTitle.text, @"etestName",
								 self.etestState, @"etestState",
                                 startYMD, @"startDate",
                                 startH, @"startHour",
                                 startM, @"startMin",
                                 closeYMD, @"closeDate", 
                                 closeH, @"closeHour", 
                                 closeM, @"closeMin", nil];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didQuizSaveFinished:)];
	[httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST" withTag:nil];
    
}


- (void)didQuizSaveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
        if ([[resultStr objectForKey:@"result"] isEqualToString:@"success"]) {
            AlertWithMessage([jsonData objectForKey:@"message"]);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            AlertWithMessage([jsonData objectForKey:@"message"]);
        }
        
	} else {
        
    }
	
	[jsonParser release];
	
}


- (void)showDatePicker:(id)sender {
    
    UITextField *textField = (UITextField *)sender;
    
    if(textField.tag == kStartDateFieldTag){
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
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSLog(@"date = %@",[formatter stringFromDate:[startDatePicker date]]);
    
    startDate.text = [formatter stringFromDate:[startDatePicker date]];
    [formatter release];
}

- (void)closeDateChanged:(id)sender {
    NSLog(@"closeDateChanged");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSLog(@"date = %@",[formatter stringFromDate:[closeDatePicker date]]);
    
    closeDate.text = [formatter stringFromDate:[closeDatePicker date]];
    [formatter release];
}

#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
    
	//NSLog(@"receiveData : %@", [result objectForKey:@"result"]);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
    
	NSDictionary *jsonData = [jsonParser objectWithString:result];
    
	self.etest = (NSDictionary *)[jsonData objectForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
		quizTitle.text = [self.etest valueForKey:@"etestNm"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
        
        long long submitStartTime = [[NSString stringWithFormat:@"%@",[self.etest objectForKey:@"etestStartDt"]] longLongValue];
        
        submitStartTime = submitStartTime / 1000;
        NSDate *submitStartDate = [NSDate dateWithTimeIntervalSince1970:submitStartTime];
        
        NSString *submitStartDateString = [dateFormat stringFromDate:submitStartDate];
        
        long long submitCloseTime = [[NSString stringWithFormat:@"%@",[self.etest objectForKey:@"etestCloseDt"]] longLongValue];
        
        submitCloseTime = submitCloseTime / 1000;
        NSDate *submitCloseDate = [NSDate dateWithTimeIntervalSince1970:submitCloseTime];
        
        NSString *submitCloseDateString = [dateFormat stringFromDate:submitCloseDate];
        
        startDate.text = submitStartDateString;
        closeDate.text = submitCloseDateString;
        
        self.etestState = [self.etest valueForKey:@"etestFg"];
        
        if([self.etestState isEqualToString:@"T"]){
            etestSwitch.on = YES;
        } else {
            etestSwitch.on = NO;
        }
        
	}
	
	[jsonParser release];
	
}

- (IBAction)toggleSwitch:(id)sender {
    
    
    
    if([self.etestState isEqualToString:@"T"]){
        self.etestState = @"F";
        etestSwitch.on = NO;
        etestStateLabel.text = @"중지";
    } else {
        self.etestState = @"T";
        etestSwitch.on = YES;
        etestStateLabel.text = @"정상";
    }
    
    NSLog(@"toggleSwitch %@", self.etestState);
}


#pragma mark -
#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn");
	[textField resignFirstResponder];
	return YES;
    //[table reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"textFieldDidBeginEditing tag = %d", textField.tag);
    
    if (textField.tag == kStartDateFieldTag) {
        [textField resignFirstResponder];
        NSString *dateString = startDate.text;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormater dateFromString:dateString];
        
        startDatePicker.date = dateFromString;
        
        [dateFormater release];
        
        [self showDatePicker:textField];
    } else if (textField.tag == kCloseDateFieldTag) {
        [textField resignFirstResponder];
        NSString *dateString = closeDate.text;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormater dateFromString:dateString];
        
        closeDatePicker.date = dateFromString;
        
        [dateFormater release];
        
        [self showDatePicker:textField];
    } 

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	
	//[table reloadData];
}

@end
