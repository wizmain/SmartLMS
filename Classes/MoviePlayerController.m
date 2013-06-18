    //
//  MoviePlayerController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 15..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MoviePlayerController.h"
#import "HTTPRequest.h"
#import "Constants.h"
#import "AlertUtils.h"
#import "JSON.h"
#import "ApplyQuiz.h"
#import "MainViewController.h"
#import "SmartLMSAppDelegate.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation MoviePlayerController

@synthesize attendTimer;
@synthesize lectureNo;
@synthesize itemNo;
@synthesize player;
@synthesize playerView;
@synthesize subjID, weekSeq, orderSeq;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.wantsFullScreenLayout = YES;
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//NSLog(@"moviePlayer viewDidLoad");
	self.navigationItem.title = @"강좌수강";
    
    NSString *strWeekSeq = [NSString stringWithFormat:@"%d", weekSeq];
    NSString *strOrderSeq = [NSString stringWithFormat:@"%d", orderSeq];
    
    if(weekSeq < 10) {
        strWeekSeq = [NSString stringWithFormat:@"0%d", weekSeq];
    }
    
    if(orderSeq < 10) {
        strOrderSeq = [NSString stringWithFormat:@"0%d", orderSeq];
    }
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_0006" ofType:@"MP4"];
    //NSString *path = @"http://123.140.193.181:1935/vod/mp4:extremists.m4v/playlist.m3u8";
    //NSString *path = @"http://123.140.193.181:1935/vod/mp4:index.mp4/playlist.m3u8";
    //NSString *path = @"http://123.140.193.181:1935/vod/mp4:index.mp4/playlist.m3u8";
	//NSURL *url = [NSURL fileURLWithPath:path];
    
    
    NSString *path = [NSString stringWithFormat:@"%@/live/%@/%@/%@/%@/mp4:index.mp4/playlist.m3u8", kVodServer, subjID, subjID, strWeekSeq, strOrderSeq];
    
    //NSString *path = [NSString stringWithFormat:@"%@/live/%@/%@/%@/%@/mp4:index.mp4/playlist.m3u8", kVodServer,subjID, subjID, strWeekSeq, strOrderSeq];
    
    
    NSURL *url = [NSURL URLWithString:path];
	NSLog(@"movie url = %@", url);
	playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [playerView.view setFrame:self.view.bounds];
    //playerView.view.frame = CGRectMake(0, 0, 480, 320);
    
	player = [playerView moviePlayer];
    //[playerView shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
	[player setControlStyle:MPMovieControlStyleFullscreen];
    //[player setFullscreen:YES];
    
	player.view.backgroundColor = [UIColor blackColor];
    
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    //CGAffineTransform transform = CGAffineTransformMakeRotation(90*M_PI/180);
    //[self.player.view setTransform:transform];
    //[self.player.view setBounds:CGRectMake(0, 0, 480, 320)];
    
	//[playerView.view setTransform:transform];
    //[playerView.view setBounds:CGRectMake(0, 0, 480, 320)];
    //[[self view] setBounds:CGRectMake(0, 0, 480, 320)];
    //[[self view] setCenter:CGPointMake(160, 230)];
    //[[self view] setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
    //[[player view] setFrame:CGRectMake(0, 0, 480, 320)];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(movieFinishedCallback:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:player];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(durationAvailableCallback:) 
												 name:MPMovieDurationAvailableNotification 
											   object:player];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(mediaTypesAvailableNoti:) 
												 name:MPMovieMediaTypesAvailableNotification 
											   object:player];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayerFullscreenNoti:) 
												 name:MPMoviePlayerDidEnterFullscreenNotification 
											   object:player];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayerExitFullscreenNoti:) 
												 name:MPMoviePlayerDidExitFullscreenNotification 
											   object:player];
	//동영상 플레이 상태 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayerPlaybackStateChange:) 
												 name:MPMoviePlayerPlaybackStateDidChangeNotification 
											   object:player];
	
	//버퍼링 상태등.. 변화
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayerLoadStateChange:) 
												 name:MPMoviePlayerLoadStateDidChangeNotification 
											   object:player];
	
	//무비 url 변경시
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayerNowPlayingMovieChange:) 
												 name:MPMoviePlayerNowPlayingMovieDidChangeNotification 
											   object:player];
	
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
	
	//[self presentMoviePlayerViewControllerAnimated:playerView];
	//[playerView release];
    
    //[self.navigationController.view addSubview:playerView.view];
    [self.view addSubview:playerView.view];
    
    //수강기록 시작
	[self attendLog];
    
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    NSLog(@"shouldAutorotateToInterface");
    //return YES;
    //return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    self.player = nil;
    self.playerView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    oldStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:oldStatusBarStyle animated:NO];
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willRotateToInterfaceOrientation");
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willAnimateRotateToInterfaceOrientation");
    
}


- (void)dealloc {
	[attendTimer release];
    [playerView release];
	[applyQuiz release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method

- (void)orientationChanged:(NSNotification *)notification
{
    // We must add a delay here, otherwise we'll swap in the new view
	// too quickly and we'll get an animation glitch
    [self performSelector:@selector(updateLandScapeView) withObject:nil afterDelay:0];
    NSLog(@"orientaionChanged");
    
    
}

- (void)updateLandScapeView
{
    /*
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    //[self shouldAutorotateToInterfaceOrientation:deviceOrientation];
    
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
	{
        //[self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        //[self.playerView shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        [self.playerView.view setBounds:CGRectMake(-230, 155, 480, 350)];
        self.playerView.view.transform = CGAffineTransformMakeRotation(3.14/2);
    }
	else if (deviceOrientation == UIDeviceOrientationPortrait)
	{
        //[self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
        //[self.playerView shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
        self.playerView.view.transform = CGAffineTransformMakeRotation(0.0);
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
    {
        //[self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        //[self.playerView shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        self.playerView.view.transform = CGAffineTransformMakeRotation(-3.14/2);
    }
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        //[self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
    */
    
}


- (void)startAttendTimer {
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 
													  target:self 
													selector:@selector(updateAttendTime:) 
													userInfo:nil 
													 repeats:YES];
	self.attendTimer = timer;
}

- (void)stopAttendTimer {
	[self.attendTimer invalidate];
	self.attendTimer = nil;
}


//수강 시간 기록 업데이트
- (void)updateAttendTime:(id)sender {
	
	NSString *url = [kServerUrl stringByAppendingString:kLectureAttendUrl];
	NSString *queryString = [NSString stringWithFormat:@"?LecNo=%d&ItemNo=%d&logType=I&StudyTime=5",lectureNo, itemNo];
	url = [url stringByAppendingString:queryString];
	//NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didUpdateAttendTimeReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
	
}

//강의 수강 로그 기록
- (void)attendLog {
	NSString *url = [kServerUrl stringByAppendingString:kAttendLogUrl];
	NSString *queryString = [NSString stringWithFormat:@"?LecNo=%d&ItemNo=%d&LogType=I",lectureNo, itemNo];
	url = [url stringByAppendingString:queryString];
	//NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didAttendLogReceiveFinished:)];
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

//퀴즈 정보 가져오기
- (void)requestItemETest {
	NSString *url = [kServerUrl stringByAppendingString:kLectureItemETestUrl];
	NSString *queryString = [NSString stringWithFormat:@"/%d/%d",lectureNo, itemNo];
	url = [url stringByAppendingString:queryString];
	//NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didReceiveItemETest:)];
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
	
}

- (void)goBack {
	//[self.navigationController popViewControllerAnimated:YES];
    //NSLog(@"goBack");
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark HTTPRequest Delegate

- (void)didUpdateAttendTimeReceiveFinished:(NSString *)result {
	//NSLog(@"didUpdateAttendTime receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	NSDictionary *jsonResult = (NSDictionary *)[jsonData objectForKey:@"result"];
	NSString *resultStr = [jsonResult objectForKey:@"result"];
	
	if ( [resultStr isEqualToString:@"fail"] ) {
		//NSLog(@"실패");
		AlertWithMessage([jsonResult objectForKey:@"message"]);
		isForceStoped = YES;
		//업데이트 타이머 중단
		[self stopAttendTimer];
		[self.player stop];
		[self goBack];
	} else {
		//NSLog(@"성공");
	}
	
	[jsonParser release];
	
}

- (void)didAttendLogReceiveFinished:(NSString *)result {
	//NSLog(@"didAttendLog receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	NSDictionary *jsonResult = (NSDictionary *)[jsonData objectForKey:@"result"];
	NSString *resultStr = [jsonResult objectForKey:@"result"];
	if ( [resultStr isEqualToString:@"fail"] ) {
		//NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
		isForceStoped = YES;
		[self stopAttendTimer];
		[self.player stop];
		[self goBack];
	} else {
		//NSLog(@"성공");
	}
	
	[jsonParser release];
	
}

- (void)didReceiveItemETest:(NSString *)result {
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	NSInteger etestNo = [[NSString stringWithFormat:@"%@",[jsonData objectForKey:@"etestNo"]] intValue];
    
    //NSLog(@"etestNo = %d", etestNo);
    
    [self dismissModalViewControllerAnimated:YES];
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchApplyQuizView:lectureNo itemNo:itemNo etestNo:etestNo];

	[jsonParser release];
	/*
	
	ApplyQuiz *apply = [[ApplyQuiz alloc] initWithNibName:@"ApplyQuiz" bundle:nil];
	[apply setTitle:@"퀴즈응시"];
	apply.lectureNo = lectureNo;
	apply.itemNo = itemNo;
	apply.etestNo = etestNo;
	
	
	applyQuiz = apply;
	UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:applyQuiz];
	naviCon.toolbarHidden = NO;
	
    
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"제출하기" style:UIBarButtonItemStyleBordered target:applyQuiz action:@selector(submitButtonClick:)];
	UIBarButtonItem *setAnswerButton = [[UIBarButtonItem alloc] initWithTitle:@"정답설정" style:UIBarButtonItemStyleBordered target:applyQuiz action:@selector(setAnswerButtonClick:)];
	UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	NSArray *toolbar = [[NSArray alloc] initWithObjects:submitButton, flexible, setAnswerButton, nil];
	
	
	applyQuiz.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"이전문제" style:UIBarButtonItemStylePlain target:applyQuiz action:@selector(prevQuizButtonClick:)];
	applyQuiz.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"다음문제" style:UIBarButtonItemStylePlain target:applyQuiz action:@selector(nextQuizButtonClick:)];
	applyQuiz.toolbarItems = toolbar;
    
	
	[self presentModalViewController:naviCon animated:NO];
	*/
	
	
	//[[mClassAppDelegate sharedAppDelegate] switchView:nil];
	
	//[apply release];
	//[naviCon release];
	
}

- (void)didReceiveMessage:(NSString *)message {
	//[myMessage setText:message];
}

#pragma mark -
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// use "buttonIndex" to decide your action
	//
	//NSLog(@"button Index %d", buttonIndex);
	
	if (buttonIndex == 0) {
		//cancel 뒤로 가기
		
        [self dismissModalViewControllerAnimated:YES];
		[[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchTabView:1];
        
        
        //[self removeFromParentViewController];
        //[[SmartLMSAppDelegate sharedAppDelegate] removeMoviePlayer];
        
	} else {
		//퀴즈로 이동
        
        
        
		[self requestItemETest];
        
	}

}

#pragma mark -
#pragma mark MoviePlayer Notification Method

- (void)movieFinishedCallback:(NSNotification *)aNotification {
	[self stopAttendTimer];
	//MPMoviePlayerController *player = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
	//NSLog(@"movieFinish");
	//[player autorelease];
    
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    //CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadian(0));
    //[self.player.view setTransform:transform];
    //[self.player.view setBounds:CGRectMake(0, 0, 320, 480)];
	    
	//시험 참여 여부 팝업
	if (isForceStoped) {
		//오류나 강제로 조건에 맞지 않아 플레이가 종료되었을때
		AlertWithMessageAndDelegate(@"퀴즈에 응시하시겠습니까?", self);
	} else {
		AlertWithMessageAndDelegate(@"퀴즈에 응시하시겠습니까?", self);
	}
    
}

- (void)durationAvailableCallback:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	
	//NSLog(@"durationAvailableCallback %f", player.duration);
	
	[self startAttendTimer];
}

- (void)mediaTypesAvailableNoti:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	//NSLog(@"mediaTypesAvailableNoti");
}

- (void)moviePlayerFullscreenNoti:(NSNotification *)aNotification {
	//NSLog(@"moviePlayerFullscreenNoti");
}

- (void)moviePlayerExitFullscreenNoti:(NSNotification *)aNotification {
	//NSLog(@"MPMoviePlayerDidExitFullscreenNotification");
}

- (void)moviePlayerPlaybackStateChange:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	if (player) {
		//NSLog(@"moviePlayerPlaybackStateChange %d", player.playbackState);
        
        if (player.playbackState == MPMoviePlaybackStatePlaying) {
            //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        }

	}
	
}

- (void)moviePlayerLoadStateChange:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	//NSLog(@"moviePlayerLoadStateChane");
    
    
}

- (void)moviePlayerNowPlayingMovieChange:(NSNotification *)aNotification {
	//MPMoviePlayerController *player = [aNotification object];
	//NSLog(@"now playing movie url = %@", player.contentURL);
}

@end
