//
//  LectureItemController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 13..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LectureItemController.h"
#import "Constants.h"
#import "JSON.h"
#import "HTTPRequest.h"
#import "AlertUtils.h"
#import "SmartLMSAppDelegate.h"
#import "LectureItemDetailController.h"
#import "LoginViewController.h"
#import "MainViewController.h"

#define MAINLABEL_TAG	1
#define SECONDLABEL_TAG	2
#define PHOTO_TAG		3

@implementation LectureItemController

@synthesize lectureNo;
@synthesize lectureItemTable;
@synthesize lectureItemList;
@synthesize lectureTitle;
@synthesize subjID;

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
	//네비게이션 타이틀 설정
	self.navigationItem.title = lectureTitle;
    
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
	
    NSLog(@"subjID=%@", self.subjID);
    
	[self bindLectureItem];
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
	self.lectureItemTable = nil;
    self.lectureItemList = nil;
    self.lectureTitle = nil;
    
    [[[SmartLMSAppDelegate sharedAppDelegate] httpRequest] cancel];
}


- (void)dealloc {
	[lectureItemList release];
	[lectureItemTable release];
	[moviePlayer release];
    [lectureTitle release];
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

- (void)bindLectureItem {
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kLectureItemListUrl];
	url = [url stringByAppendingFormat:@"/%d",self.lectureNo];
	NSLog(@"url = %@", url);

	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
    
    
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
    
    /*
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [self didReceiveFinished:resultData];
    */
}

- (void)reloadLectureItemTable{
	[self.lectureItemTable reloadData];
}


#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	//NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
    
    
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	self.lectureItemList = (NSArray *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
		for (int i=0; i<self.lectureItemList.count; i++) {
			//NSDictionary *item = (NSDictionary *)[lectureItemList objectAtIndex:i];
			//NSLog(@"ItemName = %@", [item objectForKey:@"itemNm"]);
		}
	}
	
	[jsonParser release];
	
	[self reloadLectureItemTable];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.lectureItemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"강좌 차시 목록";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	
	if (cell == nil) {
		UIImage *img = [UIImage imageNamed:@"115-FilmBlack"];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		[cell.imageView setImage:img];
        cell.textLabel.textColor = UIColorFromRGB(0x0b6ad4);
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.lectureItemList != nil) {
		
		if(self.lectureItemList.count > 0){
			NSDictionary *item = [self.lectureItemList objectAtIndex:row];
			//NSString *weekSeq = [NSString stringWithFormat:@"%@",[item objectForKey:@"weekSeq"]];
			//NSString *label = [weekSeq stringByAppendingFormat:@"주차 %@강 %@",[item objectForKey:@"orderSequence"],[item objectForKey:@"itemNm"]];
			//cell.textLabel.text = [weekSeq stringByAppendingFormat:@"주차 %@강",[item objectForKey:@"orderSequence"]];
			//cell.detailTextLabel.text = [item objectForKey:@"itemNm"];
            cell.textLabel.text = [item objectForKey:@"itemNm"];
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd"];
            
            long long attendStartTime = [[NSString stringWithFormat:@"%@",[item objectForKey:@"attendStartDt"]] longLongValue];
			
			attendStartTime = attendStartTime / 1000;
			NSDate *attendStartDate = [NSDate dateWithTimeIntervalSince1970:attendStartTime];
			
            NSString *attendStartDateString = [dateFormat stringFromDate:attendStartDate];
            
            long long attendCloseTime = [[NSString stringWithFormat:@"%@",[item objectForKey:@"attendCloseDt"]] longLongValue];
			
			attendCloseTime = attendCloseTime / 1000;
			NSDate *attendCloseDate = [NSDate dateWithTimeIntervalSince1970:attendCloseTime];
			
            NSString *attendCloseDateString = [dateFormat stringFromDate:attendCloseDate];
            
			cell.detailTextLabel.text = [attendStartDateString stringByAppendingFormat:@" ~ %@", attendCloseDateString];
            
			//NSString *imageUrl = [kServerUrl stringByAppendingString:@"/images/mobile/icon1.png"];
			//NSLog(@"image url = %@",imageUrl);
			//cell.imageView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
		}
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];

	NSDictionary *item = [self.lectureItemList objectAtIndex:row];
	//NSInteger itemNumber = [[NSString stringWithFormat:@"%@",[item objectForKey:@"itemNo"]] intValue];
    selectedItemNo = [[NSString stringWithFormat:@"%@",[item objectForKey:@"itemNo"]] intValue];
    NSInteger weekSeq = [[item objectForKey:@"weekSeq"] intValue];
    NSInteger orderSeq = [[item objectForKey:@"orderSequence"] intValue];
    
    if([[SmartLMSAppDelegate sharedAppDelegate] isCellNetwork]){
        //AlertWithMessageAndDelegate(@"3G 상태에서는 동영상 스트리밍이 제한됩니다. 3G video streaming will be limited in state", self);
        AlertWithMessage(@"3G 상태에서는 동영상 스트리밍이 제한됩니다. 3G video streaming will be limited in state");
    } else {
        [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchMoviePlayer:lectureNo itemNo:selectedItemNo subjID:self.subjID weekSeq:weekSeq orderSeq:orderSeq];
        //[[SmartLMSAppDelegate sharedAppDelegate] switchMoviePlayer:lectureNo itemNo:selectedItemNo];
        
    }
	
	NSLog(@"lectureItemController didSelectedRow");
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	
	NSDictionary *item = [self.lectureItemList objectAtIndex:row];
	NSInteger itemNo = [[NSString stringWithFormat:@"%@",[item objectForKey:@"itemNo"]] intValue];
	
	LectureItemDetailController *itemDetail = [[LectureItemDetailController alloc] initWithNibName:@"LectureItemDetailController" bundle:[NSBundle mainBundle]];
	itemDetail.lectureNo = lectureNo;
	itemDetail.itemNo = itemNo;
	itemDetail.itemName = [item objectForKey:@"itemNm"];
	[self.navigationController pushViewController:itemDetail animated:YES];
	[itemDetail release];
	itemDetail = nil;
}

#pragma mark -
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// use "buttonIndex" to decide your action
	//
	NSLog(@"button Index %d", buttonIndex);
	
	if (buttonIndex == 0) {
		//취소
		
        
    } else {
		//동영상 실행
        [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchMoviePlayer:lectureNo itemNo:selectedItemNo subjID:self.subjID weekSeq:0 orderSeq:0];
        
	}
    
}

@end
