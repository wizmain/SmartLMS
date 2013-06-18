//
//  LectureItemDetailController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 15..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LectureItemDetailController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "Constants.h"
#import "MainViewController.h"

@implementation LectureItemDetailController

@synthesize lectureNo;
@synthesize itemNo;
@synthesize itemName;
@synthesize quizButton;

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
	
	self.navigationItem.title = itemName;
    
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
	//itemName = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)quizButtonClick:(id)sender {
	
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)goIndex {
    NSLog(@"goIndex");
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

- (void)requestETestInfo {
	NSString *url = [kServerUrl stringByAppendingString:kLectureItemETestUrl];
	NSString *queryString = [NSString stringWithFormat:@"/%@/%@",lectureNo, itemNo];
	url = [url stringByAppendingString:queryString];
	NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didETestReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (void)didReceiveItemETest:(NSString *)result {
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	etestNo = (NSInteger)[jsonData objectForKey:@"etestNo"];
	
	[jsonParser release];
	
	
		
}


@end
