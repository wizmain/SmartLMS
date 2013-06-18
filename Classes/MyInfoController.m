//
//  MyInfoController.m
//  mClass
//
//  Created by 김규완 on 11. 2. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyInfoController.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "SmartLMSAppDelegate.h"
#import "SettingProperties.h"
#import "Utils.h"
#import "MainViewController.h"

#define kMyInfoTag      @"myinfo"
#define kMyLectureTag   @"mylecture"

@implementation MyInfoController

@synthesize table, lectureList, nameLabel, majorLabel, hakbunLabel, gradeLabel, indicator, year, term;
@synthesize profileImage, lectureListLabel, termName;

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
	
	self.navigationItem.title = @"내정보";
    
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
    
    
    year = nil;
    term = nil;
	
    [indicator startAnimating];
    
    httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
    
    [self bindMyInfo];
    [self bindMyLecture];
    
    [indicator stopAnimating];
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
    self.lectureList =nil;
    self.nameLabel =nil;
    self.hakbunLabel = nil;
    self.gradeLabel = nil;
    self.majorLabel = nil;
    self.indicator = nil;
    self.profileImage = nil;
}


- (void)dealloc {
	[table release];
	[lectureList release];
    [nameLabel release];
    [hakbunLabel release];
    [gradeLabel release];
    [majorLabel release];
    [indicator release];
    [profileImage release];
    [super dealloc];
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

- (void)bindMyInfo {

    NSString *url = [kServerUrl stringByAppendingString:kMyInfoUrl];
	
	NSLog(@"url = %@", url);
    
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:kMyInfoTag];
    
    
    /* sync방식
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [self didMyInfoReceiveFinished:resultData];
    */
}

- (void)setDefaultYearTerm{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [locale release];
    
    [dateFormatter setDateFormat:@"yyyy"];
    year = [dateFormatter stringFromDate:today];
    [dateFormatter setDateFormat:@"MM"];
    int month = [[dateFormatter stringFromDate:today] intValue];
    if (month > 0 && month < 3) {
        term = @"21";//겨울계절할기
    } else if (month > 2 && month < 8) {
        term = @"10";//1학기
    } else if (month > 7 && month < 9) {
        term = @"11";//여름학기
    } else if (month > 8 && month < 12) {
        term = @"20";
    } else {
        term = @"21";
    }
}

- (void)termName:(NSString *)termCode {
    
    if ([termCode isEqualToString:@"10"]){
        termName = @"1학기";
    } else if ([termCode isEqualToString:@"11"]){
        termName = @"여름계절학기";
    } else if ([termCode isEqualToString:@"20"]){
        termName = @"2학기";
    } else if ([termCode isEqualToString:@"21"]) {
        termName = @"겨울계절학기";
    }
}

- (void)bindMyLecture {
    

    SettingProperties *setting = [Utils settingProperties];
    
	if (setting == nil) {
        [self setDefaultYearTerm];
	} else {
		self.year = [setting termYear];
		self.term = [setting termCode];
        if(year == nil || term == nil){
            [self setDefaultYearTerm];
        }
	}
    
    [self termName:term];
    
    lectureListLabel.text = [NSString stringWithFormat:@"%@년 %@", self.year, self.termName];
	
	NSString *url = [[kServerUrl stringByAppendingString:kMyLectureUrl] stringByAppendingString:@"/"];
	url = [url stringByAppendingFormat:@"%@/%@",self.year, self.term];
	
	NSLog(@"url = %@", url);
    
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:kMyLectureTag];
    
    
    /*
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [self didMyLectureReceiveFinished:resultData];
    */
}

- (void)didReceiveFinished:(NSString *)result {
    //NSLog(@"receiveDic :%@", result);
    //NSString *tag = [result objectForKey:@"tag"];
    //NSString *resultString = [result objectForKey:@"result"];
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *jsonData = [jsonParser objectWithString:result];
    NSDictionary *resultData = [jsonData objectForKey:@"resultData"];
    NSString *tag = [resultData valueForKey:@"tag"];
    NSDictionary *resultObj = [resultData objectForKey:@"result"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *resultString = [jsonWriter stringWithObject:resultObj];
    if ([tag isEqualToString:kMyInfoTag]) {
        [self didMyInfoReceiveFinished:resultString];
    } else {
        [self didMyLectureReceiveFinished:resultString];
    }
}

- (void)didMyInfoReceiveFinished:(NSString *)result {
    NSLog(@"receiveDic :%@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSDictionary *userInfo = (NSDictionary *)[jsonData objectForKey:@"data"];
	
	if (userInfo) {
		if([userInfo objectForKey:@"result"]) {
            AlertWithMessage([jsonData objectForKey:@"message"]);
        } else {
            nameLabel.text = [userInfo objectForKey:@"userKName"];
            hakbunLabel.text = [userInfo objectForKey:@"userID"];
        }
	} else {
		AlertWithMessage(@"실패");
	}
}

- (void)didMyLectureReceiveFinished:(NSString *)result {
    NSLog(@"MyLecture receiveData : %@", result);
	
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
		
		NSLog(@"성공");
		NSLog(@"lectureList count %d", [lectureList count]);
		for (int i=0; i<lectureList.count; i++) {
			//NSLog(@"%d = %@",i, [lectureList objectAtIndex:i]);
			//NSDictionary *lecture = (NSDictionary *)[lectureList objectAtIndex:i];
			//NSLog(@"LectureName = %@", [lecture objectForKey:@"lectureKorNm"]);
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
	
	[table reloadData];

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.lectureList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"수강목록";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
        //cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.lectureList != nil) {
		
		if(self.lectureList.count > 0){
			
			NSDictionary *ann = [self.lectureList objectAtIndex:row];
			cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",[ann objectForKey:@"lectureKorNm"], [ann objectForKey:@"classNo"]];
			cell.textLabel.textColor = UIColorFromRGB(kValueTextColor);
			
			
		}
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
}


@end
