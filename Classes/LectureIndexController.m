//
//  LectureIndexController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LectureIndexController.h"
#import "HTTPRequest.h"
#import "Constants.h"
#import "JSON.h"
#import "Utils.h"
#import "AlertUtils.h"
#import "SmartLMSAppDelegate.h"

@implementation LectureIndexController

@synthesize table, lectureList, indexType;

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
	
	self.navigationItem.title = @"내강의실";
	
	NSString *url = [[kServerUrl stringByAppendingString:kMyLectureUrl] stringByAppendingString:@"/"];
	url = [[[url stringByAppendingString:@"2010"] stringByAppendingString:@"/"] stringByAppendingString:@"20"];
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"request url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
	
	
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
    self.lectureList = nil;
}


- (void)dealloc {
	[table release];
	[lectureList release];
    [super dealloc];
}


#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
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
	
	//lectureTable reload
	[table reloadData];
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"didTableReloaded" object:self userInfo:nil];
	
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
	
	if (self.lectureList != nil) {
		
		if(lectureList.count > 0){
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
	
	if ([self.indexType isEqualToString:@"qna"]) {
		
	}
	
	/*
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
	*/
}

@end
