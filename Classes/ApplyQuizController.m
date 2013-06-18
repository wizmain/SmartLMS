//
//  ApplyQuizController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplyQuizController.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "AlertUtils.h"
#import "mClassAppDelegate.h"

@implementation ApplyQuizController

/*
@synthesize quizNumberLabel;
@synthesize quizTitle;
@synthesize quizExample;
@synthesize pageControl;
@synthesize submitButton;
@synthesize setAnswerButton;
@synthesize quizList;
@synthesize etestNo;
@synthesize lectureNo;
@synthesize itemNo;
@synthesize quizCnt;
@synthesize exampleCnt;
@synthesize quizNo;
@synthesize applyNo;
*/

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}
/*
#pragma mark -
#pragma mark Custom Method
-(IBAction)submitButtonClick:(id)sender {
	
}

- (IBAction)setAnswerButtonClick:(id)sender {
	
}

- (void)requestETestInfo {
	NSString *url = [kServerUrl stringByAppendingString:kLectureItemETestUrl];
	NSString *queryString = [NSString stringWithFormat:@"/%@/%@",lectureNo, itemNo];
	url = [url stringByAppendingString:queryString];
	NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[mClassAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didETestReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET"];
}

- (void)requestQuiz {
	
	NSString *url = [kServerUrl stringByAppendingString:kApplyQuizUrl];
	NSString *queryString = [NSString stringWithFormat:@"?LecNo=%@&ItemNo=%@&logType=I&StudyTime=5",lectureNo, itemNo];
	url = [url stringByAppendingString:queryString];
	NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[mClassAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didQuizReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET"];
}

#pragma mark -
#pragma mark HttpRequest Delegate

- (void)didETestReceiveFinished:(NSString *)result {
	
}

- (void)didQuizReceiveFinished:(NSString *)result {
	
}
*/
@end
