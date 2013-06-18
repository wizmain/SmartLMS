//
//  LectureHomeController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LectureHomeController.h"
#import "SettingProperties.h"
#import "Utils.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "LectureItemController.h"
#import "CustomLectureCell.h"
#import "LectureDetailController.h"
#import "MainViewController.h"

@implementation LectureHomeController

@synthesize lectureTable, lectureList, setting, year, term, indicator;

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
    
    /*
    UIBarButtonItem *reloadButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(bindLectureList)] autorelease];
    */
    
    UIButton *reload = [UIButton buttonWithType:UIButtonTypeCustom];
    [reload setBackgroundImage:[UIImage imageNamed:@"nav_reload"] forState:UIControlStateNormal];
    [reload addTarget:self action:@selector(bindLectureList) forControlEvents:UIControlEventTouchUpInside];
    reload.frame = CGRectMake(0, 0, 34, 30); 
    UIBarButtonItem *reloadButton = [[[UIBarButtonItem alloc] initWithCustomView:reload] autorelease];
    
    self.navigationItem.rightBarButtonItem = reloadButton;
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
	
	self.navigationItem.title = @"내강의실";
	
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *naviBg = [UIImage imageNamed:@"navigation_back"];
        [self.navigationController.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    }
	
    
    //[self bindLectureList];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	//NSLog(@"navigation willShowViewControll");
	//[viewController viewWillAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"viewWillAppear");
	[self bindLectureList];
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
	self.lectureTable =nil;
	self.setting = nil;
	self.lectureList = nil;
    self.indicator = nil;
}


- (void)dealloc {
    
    [indicator release];
	[setting release];
	[lectureTable release];
	[lectureList release];
    [super dealloc];
}

# pragma mark -
# pragma mark Custom Method
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)goIndex {
    NSLog(@"goIndex");
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

- (void)setDefaultYearTerm{
    /*
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
    */
    
    year = @"2010";
    term = @"20";
}

- (void)bindLectureList {
	NSLog(@"bindLectureList");
    
    [indicator startAnimating];
    [self.view bringSubviewToFront:indicator];
    
	self.setting = [Utils settingProperties];
		
	if (self.setting == nil) {
		[self setDefaultYearTerm];
	} else {
		year = [self.setting termYear];
		term = [self.setting termCode];
        if(year == nil || term == nil){
            [self setDefaultYearTerm];
        }
	}
	
	NSString *url = [[kServerUrl stringByAppendingString:kMyLectureUrl] stringByAppendingString:@"/"];
	url = [url stringByAppendingFormat:@"%@/%@",year, term];
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"request url = %@", url);
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
    
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"data = %@", resultData);

    [self didReceiveFinished:resultData];
    /* async 방식
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET"];
	*/
	
}



#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	//NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
    NSInteger lectureCount = 0;
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	self.lectureList = (NSArray *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		NSLog(@"실패");
		//AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"성공");
		NSLog(@"lectureList count %d", [self.lectureList count]);
        lectureCount = [self.lectureList count];
        
        
		for (int i=0; i<self.lectureList.count; i++) {
			//NSLog(@"%d = %@",i, [lectureList objectAtIndex:i]);
			NSDictionary *lecture = (NSDictionary *)[self.lectureList objectAtIndex:i];
			NSLog(@"LectureName = %@", [lecture objectForKey:@"lectureKorNm"]);
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
    
	[self.lectureTable reloadData];
    
    [self.indicator stopAnimating];
    
    if (lectureCount == 0) {
        AlertWithMessage(@"강좌가 존재하지 않습니다. 설정메뉴에서 원하는 년도와 학기를 설정해 주세요");
    }

	//[[NSNotificationCenter defaultCenter] postNotificationName:@"didTableReloaded" object:self userInfo:nil];
	
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.lectureList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    
    NSUInteger row = [indexPath row];
    
    static NSString *normalCellIdentifier = @"CustomLectureCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    CustomLectureCell *cell = (CustomLectureCell *) [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    
    if(cell == nil){
        cell = [CustomLectureCell cellWithNib];
        
        UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	NSLog(@"row = %d", row);
    
    
    
    if (self.lectureList != nil) {
		
		if(lectureList.count > 0){
            
			NSDictionary *lecture = [self.lectureList objectAtIndex:row];
			NSString *label = [[lecture objectForKey:@"lectureKorNm"] stringByAppendingFormat:@" (%@)",[lecture objectForKey:@"classNo"]];
			//cell.textLabel.text = label;
            //cell.textLabel.textColor = [UIColor whiteColor];
            cell.lectureTitle.text = label;
            cell.lectureDetail.text = [lecture objectForKey:@"mainTeacherName"];
            UIImage *image = [UIImage imageNamed:@"lecture_blank"];
            //image = [image imageScaledToSize:CGSizeMake(88, 50)];
            //[cell.lectureTitleImage setImage:[image imageScaledToSize:CGSizeMake(88, 50)]];
            [cell.lectureTitleImage setImage:image];
		}
	}
    

	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
    NSLog(@"row = %d", row);
	
	NSDictionary *lecture = [self.lectureList objectAtIndex:row];
    
	NSInteger lectureNo = [[NSString stringWithFormat:@"%@",[lecture objectForKey:@"lectureNo"]] intValue];
    
    LectureDetailController *lectureDetail = [[LectureDetailController alloc] initWithNibName:@"LectureDetailController" bundle:nil];
    lectureDetail.lectureNo = lectureNo;
    
    [self.navigationController pushViewController:lectureDetail animated:YES];
    
    
    //[lectureDetail release];
    //lectureDetail = nil;
}

- (oneway void)release {
    [super release];
}

@end
