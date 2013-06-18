//
//  LectureDetailController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 13..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//  강좌홈

#import "LectureDetailController.h"
#import "HTTPRequest.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Utils.h"
#import "Constants.h"
#import "SmartLMSAppDelegate.h"
#import "LectureItemController.h"
#import "ReportController.h"
#import "QuizController.h"
#import "AttendStudentController.h"
#import "LectureBoardController.h"
#import "RecordController.h"
#import "LectureStatController.h"
#import "ArticleController.h"
#import "AttendStudentInfo.h"
#import "MainViewController.h"

#define kLectureInfoTag         @"lectureInfo"
#define kStudentAttendInfoTag   @"studentAttendInfo"
#define kLectureStatTag         @"lectureStat"

@implementation LectureDetailController

@synthesize lectureNo, lectureTitle, lectureGrade, lectureTeacher, indicator;
@synthesize attendButton, recordButton, reportButton, boardButton, quizButton, studentButton;
@synthesize lectureTitleString, lectureStatPercent, attendProgressView;
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
	//타이틀 설정
	self.navigationItem.title = @"강좌홈";
    
    
    
    //상단버튼설정
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
    
    //강좌정보 바인드
    [self bindLectureInfo];
    
    //버튼 설정
    //학생이면 수강생목록 강사이면 강좌통계 
    studentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    studentButton.frame = CGRectMake(228, 273, 72, 68);
    //[studentButton setImage:[UIImage imageNamed:@"06"] forState:UIControlStateNormal];
    [studentButton setBackgroundImage:[UIImage imageNamed:@"07"] forState:UIControlStateNormal];
    [studentButton setTitle:@"수업참여현황" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
    [studentButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    [studentButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [studentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [[studentButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [[studentButton titleLabel] setTextColor:[UIColor blackColor]];
    [studentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reportButton.frame = CGRectMake(124, 172, 72, 68);
    [reportButton setBackgroundImage:[UIImage imageNamed:@"02"] forState:UIControlStateNormal];
    [reportButton setTitle:@"과제방" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
    [reportButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    [reportButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [reportButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [[reportButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [[reportButton titleLabel] setTextColor:[UIColor blackColor]];
    [reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //228, 172
    quizButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quizButton.frame = CGRectMake(228, 172, 72, 68);
    [quizButton setBackgroundImage:[UIImage imageNamed:@"05"] forState:UIControlStateNormal];
    [quizButton setTitle:@"수업공지" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
    [quizButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    [quizButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [quizButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [[quizButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [[quizButton titleLabel] setTextColor:[UIColor blackColor]];
    [quizButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quizButton addTarget:self action:@selector(quizButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //124 273
    boardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    boardButton.frame = CGRectMake(124, 273, 72, 68);
    [boardButton setBackgroundImage:[UIImage imageNamed:@"05"] forState:UIControlStateNormal];
    [boardButton setTitle:@"수업Q&A" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
    [boardButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    [boardButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [boardButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [[boardButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [[boardButton titleLabel] setTextColor:[UIColor blackColor]];
    [boardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [boardButton addTarget:self action:@selector(boardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //쿠키에서 현재 로그인한 권한을 읽어온다
    BOOL isStudent = [[SmartLMSAppDelegate sharedAppDelegate] isStudent];
    
    if (isStudent){
        
        //학생이면 학생정보 바인드
        NSLog(@"학생");
        [self requestStudentAttendInfo];
        
        [studentButton addTarget:self action:@selector(goStudentInfo) forControlEvents:UIControlEventTouchUpInside];
    } else {
        NSLog(@"교수 입니다 ");
        //교수정보 바인드
        [self requestLectureStatPercent];
        
        reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        reportButton.frame = CGRectMake(124, 172, 72, 68);
        [reportButton setBackgroundImage:[UIImage imageNamed:@"06"] forState:UIControlStateNormal];
        [reportButton setTitle:@"수강생명단" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
        [reportButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
        [reportButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [reportButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [[reportButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [[reportButton titleLabel] setTextColor:[UIColor blackColor]];
        [reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [reportButton addTarget:self action:@selector(goStudent) forControlEvents:UIControlEventTouchUpInside];
        
        //228, 172
        quizButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        quizButton.frame = CGRectMake(228, 172, 72, 68);
        [quizButton setBackgroundImage:[UIImage imageNamed:@"05"] forState:UIControlStateNormal];
        [quizButton setTitle:@"수업게시판" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
        [quizButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
        [quizButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [quizButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [[quizButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [[quizButton titleLabel] setTextColor:[UIColor blackColor]];
        [quizButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [quizButton addTarget:self action:@selector(goLectureBoard) forControlEvents:UIControlEventTouchUpInside];

        boardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        boardButton.frame = CGRectMake(124, 273, 72, 68);
        [boardButton setBackgroundImage:[UIImage imageNamed:@"02"] forState:UIControlStateNormal];
        [boardButton setTitle:@"과제방" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
        [boardButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
        [boardButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [boardButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [[boardButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [[boardButton titleLabel] setTextColor:[UIColor blackColor]];
        [boardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [boardButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        
        [studentButton addTarget:self action:@selector(goLectureStat) forControlEvents:UIControlEventTouchUpInside];
        [studentButton setBackgroundImage:[UIImage imageNamed:@"07"] forState:UIControlStateNormal];
        [studentButton setTitle:@"통계관리" forState:UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected];
        [[studentButton titleLabel] setTextColor:[UIColor blackColor]];
    }
    
    //버튼 바인드
    [self.view addSubview:reportButton];
    [self.view addSubview:quizButton];
    [self.view addSubview:boardButton];
    [self.view addSubview:studentButton];
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
    self.lectureTitle = nil;
    self.lectureGrade = nil;
    self.lectureTeacher = nil;
    self.attendButton = nil;
    self.reportButton = nil;
    self.quizButton = nil;
    self.recordButton = nil;
    self.boardButton = nil;
    self.studentButton = nil;
    self.subjID = nil;
    self.indicator = nil;
    self.lectureStatPercent = nil;
    
    [[[SmartLMSAppDelegate sharedAppDelegate] httpRequest] cancel];
}


- (void)dealloc {
    [lectureTitle release];
    [lectureGrade release];
    [lectureTeacher release];
    [attendButton release];
    [reportButton release];
    [quizButton release];
    [recordButton release];
    [boardButton release];
    [studentButton release];
    [indicator release];
    [lectureStatPercent release];
    [subjID release];
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

- (void)goStudent {
    NSLog(@"goStudent Click");
    AttendStudentController *student = [[AttendStudentController alloc] initWithNibName:@"AttendStudentController" bundle:nil];
    student.lectureNo = lectureNo;
    student.showAttendInfoFlag = @"F";
    student.lectureTitle = self.lectureTitleString;
    [self.navigationController pushViewController:student animated:YES];
    [student release];
    student = nil;
}

- (void)goLectureStat {
    NSLog(@"goLectureStat Click");
    LectureStatController *lectureStat = [[LectureStatController alloc] initWithNibName:@"LectureStatController" bundle:nil];
    lectureStat.lectureNo = lectureNo;
    lectureStat.lectureTitle = self.lectureTitleString;
    [self.navigationController pushViewController:lectureStat animated:YES];
    [lectureStat release];
    
}

- (void)goStudentInfo {
    
    
    AttendStudentInfo *i = [[AttendStudentInfo alloc] initWithNibName:@"AttendStudentInfo" bundle:nil];
    i.userID = [[SmartLMSAppDelegate sharedAppDelegate] authUserID];
    i.lectureNo = lectureNo;
    i.lectureTitle = self.lectureTitleString;
    [self.navigationController pushViewController:i animated:YES];
    
    [i release];
}


- (void)goLectureBoard {
    LectureBoardController *board = [[LectureBoardController alloc] initWithNibName:@"LectureBoardController" bundle:nil];
    board.lectureNo = lectureNo;
    board.lectureTitle = self.lectureTitleString;
    [self.navigationController pushViewController:board animated:YES];
    
    [board release];
}


- (void)bindLectureInfo {
    
    [indicator startAnimating];
    [self.view bringSubviewToFront:indicator];
    
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kLectureInfoUrl];
	url = [url stringByAppendingFormat:@"/%d",self.lectureNo];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
    
    
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:kLectureInfoTag];
    
    
    /*
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
    
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"data = %@", resultData);
    
    [self didReceiveFinished:resultData];
    */
    
}

//교수자가 로그인 했을때 전체 수강 진행율
- (void)requestLectureStatPercent {
    
    //[indicator startAnimating];
    //[self.view bringSubviewToFront:indicator];
    
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kLectureStatUrl];
	url = [url stringByAppendingFormat:@"/%d",self.lectureNo];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
    
    
    //통신완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
     //페이지 호출
    [httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:kLectureStatTag];
    
    /*
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
    
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"data = %@", resultData);
    
    [self didLectureStatReceiveFinished:resultData];
    */
}

//학생 로그인 했을때 학생의 수강 진행율
- (void)requestStudentAttendInfo {
    
    //[indicator startAnimating];
    //[self.view bringSubviewToFront:indicator];
    
    NSString *userID = [[SmartLMSAppDelegate sharedAppDelegate] authUserID];
    
	NSString *url = [kServerUrl stringByAppendingFormat:@"%@",kUserAttendInfo];
	url = [url stringByAppendingFormat:@"/%d/%@", self.lectureNo, userID];
	NSLog(@"url = %@", url);
    
	//request생성
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
    
    
    //통신완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
    //페이지 호출
    [httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:kStudentAttendInfoTag];
     
    /*
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:nil httpMethod:@"GET" error:error response:response];
    
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"data = %@", resultData);
    
    [self didStudentAttendInfoReceiveFinished:resultData];
    */
}


#pragma mark -
#pragma mark Connection Result Delegate

- (void)didReceiveFinished:(NSString *)result {
    NSLog(@"result = %@", result);
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *jsonObj = [jsonParser objectWithString:result];
    NSDictionary *resultData = [jsonObj objectForKey:@"resultData"];
    
    
    NSString *tag = [resultData valueForKey:@"tag"];
    NSDictionary *resultObj = [resultData objectForKey:@"result"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *resultString = [jsonWriter stringWithObject:resultObj];
    NSLog(@"tag = %@, resultString = %@", tag, resultString);
    
    //NSDictionary받을때
    //NSLog(@"receiveDic :%@", result);
    //NSString *tag = [result objectForKey:@"tag"];
    //NSString *resultString = [result objectForKey:@"result"];
    
    
    if ([tag isEqualToString:kLectureInfoTag]) {
        
        [self didLectureInfoReceiveFinished:resultString];
    } else if([tag isEqualToString:kLectureStatTag]) {
        [self didLectureStatReceiveFinished:resultString];
    } else if ([tag isEqualToString:kStudentAttendInfoTag]) {
        [self didStudentAttendInfoReceiveFinished:resultString];
    }

}


- (void)didLectureInfoReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	NSDictionary *lecture = (NSDictionary *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
		//self.navigationItem.title = [lecture objectForKey:@"lectureKorNm"];
        self.lectureTitleString = [NSString stringWithFormat:@"%@ (%@)",[lecture objectForKey:@"lectureKorNm"], [lecture objectForKey:@"classNo"]];
        self.lectureTitle.text = self.lectureTitleString;
        self.lectureGrade.text = [NSString stringWithFormat:@"%@ 학점", [lecture objectForKey:@"credit"]];
        self.lectureTeacher.text = [lecture objectForKey:@"mainTeacherName"];
        self.subjID = [lecture objectForKey:@"subjID"];
        NSLog(@"subjID = %@", self.subjID);
	}
	
	[jsonParser release];
    
    
	
}

- (void)didLectureStatReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	NSDictionary *lecture = (NSDictionary *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
    int totalAttendPercent = 0;
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
		int attendRequestCount = [[lecture objectForKey:@"attendRequestCount"] intValue];
        int itemCount= [[lecture objectForKey:@"lectureItemCount"] intValue];
        int attendCount = [[lecture objectForKey:@"attendCount"] intValue];
        float rate = 0.0;
        
        if(attendCount > 0 && itemCount > 0 && attendRequestCount > 0){
            rate = (float)attendCount / (itemCount * attendRequestCount);
            totalAttendPercent = (int)(rate*100);
        }
        
        NSLog(@"attendCount = %d itemCount = %d attendRequestCount = %d totalAttendPercent = %d"
              , attendCount, itemCount, attendRequestCount, totalAttendPercent);
        
        self.lectureStatPercent.text = [NSString stringWithFormat:@"%d %%", totalAttendPercent];
        self.attendProgressView.progress = rate;
	}
	
	[jsonParser release];
	
    [indicator stopAnimating];
}

- (void)didStudentAttendInfoReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	
	NSDictionary *data = (NSDictionary *)[jsonData valueForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		AlertWithMessage([jsonData objectForKey:@"message"]);
		return;
	} else {
		
        //NSDictionary *userInfo = [data objectForKey:@"userInfo"];
        
        int attendCount = [[data objectForKey:@"attendCount"] intValue];
        int itemCount = [[data objectForKey:@"lectureItemCount"] intValue];
        int attendPercent = 0;
        float rate = 0.0;
        
        if(attendCount > 0 && itemCount > 0){
            rate = (float)attendCount / itemCount;
            attendPercent = (int)(rate*100);
        }
        
        NSLog(@"attendCount = %d itemCount = %d attendPercent = %d"
              , attendCount, itemCount, attendPercent);
        
        self.lectureStatPercent.text = [NSString stringWithFormat:@"%d %%", attendPercent];
        self.attendProgressView.progress = rate;
	}
	
	[jsonParser release];
	
    [self.indicator stopAnimating];
}

- (IBAction)attendButtonClick:(id)sender {
    NSLog(@"attendButtonClick");
    
    LectureItemController *lectureItemController = [[LectureItemController alloc] initWithNibName:@"LectureItemController" bundle:[NSBundle mainBundle]];
	lectureItemController.lectureNo = lectureNo;
    lectureItemController.lectureTitle = self.lectureTitleString;
    lectureItemController.subjID = self.subjID;
    
	
	[self.navigationController pushViewController:lectureItemController animated:YES];
	[lectureItemController release];
	lectureItemController = nil;
}

- (IBAction)reportButtonClick:(id)sender {
    ReportController *report = [[ReportController alloc] initWithNibName:@"ReportController" bundle:nil];
    report.lectureNo = lectureNo;
    report.lectureTitle = self.lectureTitleString;
    [self.navigationController pushViewController:report animated:YES];
    [report release];
    report = nil;
}

- (IBAction)quizButtonClick:(id)sender {
    /*
    QuizController *quiz = [[QuizController alloc] initWithNibName:@"QuizController" bundle:nil];
    quiz.lectureNo = lectureNo;
    [self.navigationController pushViewController:quiz animated:YES];
    [quiz release];
    quiz = nil;
    */
    ArticleController *board = [[ArticleController alloc] initWithNibName:@"ArticleController" bundle:nil];
    board.boardTitle = [NSString stringWithFormat:@"%@ 공지사항", lectureTitleString];
    board.menuID = [NSString stringWithFormat:@"LMS-%d-1", lectureNo];
    board.siteID = @"LMS";
    board.lectureNo = lectureNo;
    [self.navigationController pushViewController:board animated:YES];
    [board release];
}

- (IBAction)recordButtonClick:(id)sender {
    RecordController *record = [[RecordController alloc] initWithNibName:@"RecordController" bundle:nil];
    record.lectureNo = lectureNo;
    record.lectureTitle = self.lectureTitleString;
    
    [self.navigationController pushViewController:record animated:YES];
    [record release];
}

- (IBAction)boardButtonClick:(id)sender {
    /*
    LectureBoardController *boardController = [[LectureBoardController alloc] initWithNibName:@"LectureBoardController" bundle:nil];
    boardController.lectureNo = lectureNo;
    [self.navigationController pushViewController:boardController animated:YES];
    [boardController release];
    */
    ArticleController *board = [[ArticleController alloc] initWithNibName:@"ArticleController" bundle:nil];
    board.boardTitle = [NSString stringWithFormat:@"%@ Q&A", self.lectureTitleString];
    board.menuID = [NSString stringWithFormat:@"LMS-%d-2", lectureNo];
    board.siteID = @"LMS";
    board.lectureNo = lectureNo;
    [self.navigationController pushViewController:board animated:YES];
    [board release];
}

- (IBAction)studentButtonClick:(id)sender {
    AttendStudentController *student = [[AttendStudentController alloc] initWithNibName:@"AttendStudentController" bundle:nil];
    student.lectureNo = lectureNo;
    student.showAttendInfoFlag = @"F";
    [self.navigationController pushViewController:student animated:YES];
    [student release];
    student = nil;
}

- (IBAction)studentStatButtonClick:(id)sender {
    LoginProperties *prop = [Utils loginProperties];
    
    AttendStudentInfo *i = [[AttendStudentInfo alloc] initWithNibName:@"AttendStudentInfo" bundle:nil];
    i.userID = [prop userID];
    i.lectureNo = lectureNo;
    i.lectureTitle = self.lectureTitleString;
    [self.navigationController pushViewController:i animated:YES];
    
    [i release];

}

- (IBAction)lectureStatButtonClick:(id)sender {
    AttendStudentController *student = [[AttendStudentController alloc] initWithNibName:@"AttendStudentController" bundle:nil];
    student.lectureNo = lectureNo;
    student.showAttendInfoFlag = @"F";
    student.lectureTitle = self.lectureTitleString;
    [self.navigationController pushViewController:student animated:YES];
    [student release];
    student = nil;
}

@end
