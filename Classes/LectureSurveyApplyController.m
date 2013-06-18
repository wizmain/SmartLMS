//
//  LectureSurveyApplyController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LectureSurveyApplyController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "AlertUtils.h"
#import "Constants.h"

@implementation LectureSurveyApplyController

@synthesize quizNumberLabel;
@synthesize quizTitle;
@synthesize quizExample;
@synthesize surveyList;
@synthesize exampleList;
@synthesize answerList;
@synthesize tableExampleList;
@synthesize surveyNo;
@synthesize itemNo;
@synthesize quizCnt;
@synthesize exampleCnt;
@synthesize quizNo;
@synthesize applyNo;
@synthesize currentQNo;
@synthesize spinner, subjectiveAnswerText, subjectAnswerButton;

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
    [quizNumberLabel release];
	[quizTitle release];
	[quizExample release];
	[surveyList release];
	[answerList release];
	[exampleList release];
	[tableExampleList release];
    [backImg release];
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
    
    self.navigationItem.title = @"강의만족도조사";
    
    backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_middle"]];
    self.view.backgroundColor = backImg;
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"제출하기" style:UIBarButtonItemStyleBordered target:self action:@selector(submitButtonClick:)];
	UIBarButtonItem *setAnswerButton = [[UIBarButtonItem alloc] initWithTitle:@"정답설정" style:UIBarButtonItemStyleBordered target:self action:@selector(setAnswerButtonClick:)];
	UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"이전문제" style:UIBarButtonItemStyleBordered target:self action:@selector(prevQuizButtonClick:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"다음문제" style:UIBarButtonItemStyleBordered target:self action:@selector(nextQuizButtonClick:)];
	//NSArray *toolbar = [[NSArray alloc] initWithObjects:submitButton, flexible, setAnswerButton, nil];
    NSArray *toolbar = [[NSArray alloc] initWithObjects:prevButton, flexible, nextButton, nil];
	
	//self.navigationItem.leftBarButtonItem = 
	self.navigationItem.rightBarButtonItem = submitButton;
	self.toolbarItems = toolbar;

    self.answerList = [NSMutableArray array];
    
    [self applySurvey];
    
    [submitButton release];
    [setAnswerButton release];
    [prevButton release];
    [nextButton release];
    [flexible release];
    [toolbar release];
}

- (void)viewDidUnload   
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    /*
     [quizNumberLabel release];
     [quizTitle release];
     [quizExample release];
     [surveyList release];
     [answerList release];
     [exampleList release];
     [tableExampleList release];
     [backImg release];
    */
    self.quizNumberLabel = nil;
	self.quizTitle = nil;
	self.quizExample = nil;
    self.surveyList = nil;
    self.answerList = nil;
    self.exampleList = nil;
    self.tableExampleList = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Custom Method
-(IBAction)submitButtonClick:(id)sender {
    /*
	NSString *url = [kServerUrl stringByAppendingString:kLectureSurveyUrl];
	NSString *queryString = [NSString stringWithFormat:@"/%d/%d",surveyNo];
	url = [url stringByAppendingString:queryString];
	NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didSubmitReceiveFinished:)];
	
	NSLog(@"submitButtonClick url = %@", url);
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET"];
    */
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)setAnswerButtonClick:(id)sender {
    
    [spinner startAnimating];
	
	if (self.surveyList) {
		NSDictionary *quiz = (NSDictionary *)[self.surveyList objectAtIndex:currentQNo-1];
		NSString *qType = [quiz objectForKey:@"type"];
		NSLog(@"setAnswerButtonClick qType = %@", qType);
		NSInteger answerObjective = 0;//객관식 정답
		NSString *answerSubjective = @"";//주관식 정답
		NSString *url;// = [kServerUrl stringByAppendingString:kETestObjectiveAnswerUrl];
		NSDictionary *bodyObject;
		
		if (self.answerList) {
			for (int i=0; i<[self.answerList count]; i++) {
				NSDictionary *a = (NSDictionary *)[self.answerList objectAtIndex:i];
				
				int answerQNo = [[NSString stringWithFormat:@"%@",[a objectForKey:@"qno"]] intValue];
				if ( answerQNo == self.currentQNo ) {
					//주관식이면
					if ([qType isEqualToString:@"주관식"] || [qType isEqualToString:@"1"]) {
						answerSubjective = [a objectForKey:@"answerSubjective"];
						url = [kServerUrl stringByAppendingString:kLectureSurveyAnswerSubjectiveUrl];
						//POST로 전송할 데이터 설정
						bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSString stringWithFormat:@"%d",-1], @"lectureNo"
									  , [NSString stringWithFormat:@"%d",surveyNo], @"surveyNo"
									  , [NSString stringWithFormat:@"%d",currentQNo], @"qNo"
									  , answerSubjective, @"subjectiveAnswer"
                                      , nil];
						
                        
					} else {
						answerObjective = [[NSString stringWithFormat:@"%@",[a objectForKey:@"answerObjective"]] intValue];
						url = [kServerUrl stringByAppendingString:kLectureSurveyAnswerObjectiveUrl];
						//POST로 전송할 데이터 설정
						bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSString stringWithFormat:@"%d",-1], @"lectureNo"
									  , [NSString stringWithFormat:@"%d",surveyNo], @"surveyNo"
									  , [NSString stringWithFormat:@"%d",currentQNo], @"qNo"
									  , [NSString stringWithFormat:@"%d",answerObjective], @"objectiveAnswer"
                                      , nil];
					}
				}
			}
		}
		
		if (answerObjective == 0 && [answerSubjective isEqualToString:@""]) {
			AlertWithMessage(@"정답을 설정해 주세요");
		} else {
			
			HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
            
            /*================== async방식
			[httpRequest setDelegate:self selector:@selector(didSetAnswerReceiveFinished:)];
			NSLog(@"setAnswerButtonClick url = %@", url);
            
            
			//페이지 호출
			[httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST"];
            =======================*/
            
            
            NSError *error = nil;
            NSHTTPURLResponse *response = nil;
            NSData *responseData = [httpRequest requestUrlSync:url bodyObject:bodyObject httpMethod:@"POST" error:error response:response];
            
            NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"data = %@", resultData);
            
            [self didSetAnswerReceiveFinished:resultData];
            
		}
		
	}
	
	[spinner stopAnimating];
	
}

- (IBAction)prevQuizButtonClick:(id)sender {
	if (currentQNo == 1) {
		AlertWithMessage(@"이전 문제가 없습니다");
	} else {
		currentQNo--;
		[self bindSurvey];
	}
    
}

- (IBAction)nextQuizButtonClick:(id)sender {
	if (self.surveyList != nil) {
		
		if (currentQNo == [self.surveyList count]) {
			AlertWithMessage(@"다음 문제가 없습니다");
		} else {
			self.currentQNo++;
			[self bindSurvey];
		}
	}
}

//문제 바인드
- (void)bindSurvey {
	
	NSLog(@"bindSurvey");
	
	if (self.surveyList) {
		
		if ([self.surveyList count] > 0) {
			//해당 문제의 퀴즈 정보가져오기
			NSDictionary *q = [self.surveyList objectAtIndex:self.currentQNo-1];
			int qno = [[NSString stringWithFormat:@"%@",[q objectForKey:@"surveyQNo"]] intValue];//(int)[q objectForKey:@"qno"];
			
			quizNumberLabel.text = [NSString stringWithFormat:@"%d.번", qno];
			quizTitle.text = [q objectForKey:@"question"];
            NSString *type = [q valueForKey:@"type"];
            if ([type isEqualToString:@"객관식"]) {
                
                [self.view bringSubviewToFront:quizExample];
                subjectiveAnswerText.hidden = YES;
                quizExample.hidden = NO;
                //퀴즈의 예제 목록 바인드
                self.tableExampleList = (NSArray *)[q objectForKey:@"exampleList"];
                
                //예제 테이블 리로드
                [quizExample reloadData];
                
                
            } else {
                [self.view bringSubviewToFront:subjectiveAnswerText];
                quizExample.hidden = YES;
                subjectiveAnswerText.hidden = NO;
            }
            
            
			//기존 설정된 값 설정 미리 선택되어 있게 처리
            if (self.answerList) {
                for (int i=0; i<[self.answerList count]; i++) {
                    NSDictionary *a = (NSDictionary *)[self.answerList objectAtIndex:i];
                    NSLog(@"answer = %@ currentQNo = %d", (NSInteger)[a objectForKey:@"answerObjective"], self.currentQNo);
                    
                    int answerExNo = [[NSString stringWithFormat:@"%@",[a objectForKey:@"qno"]] intValue];
                    if ( answerExNo == self.currentQNo) {	
                        
                        //NSLog(@"빙고 answerExample = %@",(int)[a valueForKey:@"answerObjective"]);
                        if ([type isEqualToString:@"객관식"]) {
                            int row = [[NSString stringWithFormat:@"%@",[a objectForKey:@"answerObjective"]] intValue];
                            [quizExample selectRowAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0] animated:NO scrollPosition:0];
                        } else {
                            subjectiveAnswerText.text = [a objectForKey:@"answerSubjective"];
                        }
                    }
                }
            }
		}
	}
}



- (void)applySurvey {
	
	NSString *url = [kServerUrl stringByAppendingString:kLectureSurvyeApplyUrl];
	NSString *queryString = [NSString stringWithFormat:@"?lectureNo=-1&surveyNo=%d", surveyNo];
	url = [url stringByAppendingString:queryString];
	NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(applySurveyReceiveResult:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}


#pragma mark -
#pragma mark HttpRequest Delegate

- (void)didSubmitReceiveFinished:(NSString *)result {
	NSLog(@"didSetAnswerReceiveFinished receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSDictionary *jsonResult = [jsonData objectForKey:@"result"];
	NSString *resultStr = [jsonResult objectForKey:@"result"];
	if ([resultStr isEqualToString:@"success"]) {
		AlertWithMessage(@"제출 되었습니다");
		[self dismissModalViewControllerAnimated:YES];
	} else {
		//AlertWithMessage(@"제출하지 못했습니다.");
		AlertWithMessage([jsonResult objectForKey:@"message"]);
	}
}

- (void)didSetAnswerReceiveFinished:(NSString *)result {
	NSLog(@"didSetAnswerReceiveFinished receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSDictionary *jsonResult = [jsonData objectForKey:@"result"];
	NSString *resultStr = [jsonResult objectForKey:@"result"];
	if ([resultStr isEqualToString:@"success"]) {
		//AlertWithMessage(@"설정되었습니다");
	} else {
		AlertWithMessage(@"설정 하지 못했습니다.");
	}
    
}

- (void)applySurveyReceiveResult:(NSString *)result {
	NSLog(@"applySurvey receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
    
	self.surveyList = [jsonData valueForKey:@"data"];
	NSDictionary *jsonResult = (NSDictionary *)[jsonData objectForKey:@"result"];
	
    //실패
	if (jsonResult) {
        NSString *message = [jsonResult valueForKey:@"message"];
        AlertWithMessage(message);
		[self dismissModalViewControllerAnimated:YES];
		        
	} else {
			
        currentQNo = 1;
        [self bindSurvey];
    }
    
	[jsonParser release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableExampleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"보기";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:normalCellIdentifier] autorelease];
        
	}
	
	UIImage *uncheck = [UIImage imageNamed:@"unchecked.png"];
	cell.imageView.image = uncheck;
	UIImage *checked = [UIImage imageNamed:@"checked.png"];
	cell.imageView.highlightedImage = checked;
	
	NSUInteger row = [indexPath row];
	
	if (self.tableExampleList) {
		
		if([self.tableExampleList count] > 0){
			NSDictionary *ex = [self.tableExampleList objectAtIndex:row];
			NSString *label = [ [NSString stringWithFormat:@"%@",[ex objectForKey:@"exampleNo"]] stringByAppendingFormat:@"번 %@",[ex objectForKey:@"example"]];
			cell.textLabel.text = label;
			//cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
		}
	}
	
	
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.tableExampleList) {
		//NSInteger row = [indexPath row];
		//NSLog(@"didSelectRowAtIndexPath row = %d", row);
		//NSLog(@"didSelectRowAtIndexPath exampleList count = %i", self.tableExampleList.count);
		NSDictionary *ex = (NSDictionary *)[self.tableExampleList objectAtIndex:[indexPath row]];
		BOOL answerExsit = NO;
		
		if (self.answerList) {
            
			for (int i=0; i<[self.answerList count]; i++) {
				NSMutableDictionary *answer = [self.answerList objectAtIndex:i];
				NSInteger answerQno = [[NSString stringWithFormat:@"%@",[answer objectForKey:@"qno"]] intValue];
				NSInteger exQno = [[NSString stringWithFormat:@"%@",[ex objectForKey:@"qno"]] intValue];
				if (answerQno == exQno) {
					NSLog(@"빙고");
					[answer setObject:[ex objectForKey:@"exampleNo"] forKey:@"answerObjective"];
					answerExsit = YES;
				}
			}
		} else {
			self.answerList = [NSMutableArray array];
		}
        
        NSLog(@"answer Not exist");
        //NSArray *keys = [[NSArray alloc] initWithObjects:@"qno",@"answerObjective",@"answerSubjective", nil];
        //NSArray *values = [[NSArray alloc] initWithObjects:[ex objectForKey:@"qno"], [ex objectForKey:@"qexampleNo"], @"", nil];
        NSMutableDictionary *answer = [[NSMutableDictionary alloc] init];
        [answer setObject:[ex objectForKey:@"surveyQNo"] forKey:@"qno"];
        [answer setObject:[ex objectForKey:@"exampleNo"] forKey:@"answerObjective"];
        [answer setObject:@"" forKey:@"answerSubjective"];
        //NSDictionary *answer = [NSDictionary initWithObjects:values forKeys:keys];
        NSLog(@"answer qno = %@ answerObjective = %@", [answer objectForKey:@"qno"], [answer objectForKey:@"answerObjective"]);
        [self.answerList addObject:answer];
        NSLog(@"set Answer answer count = %d", self.answerList.count);
        
        //서버에 저장
        [self setAnswerButtonClick:nil];
        
        //[keys release];
		if (answerExsit == NO) {
			//[values release];
			
			[answer release];
		} else {
			NSLog(@"answer Exist");
		}
        
	}
	
	/*
     NSUInteger row = [indexPath row];
     NSDictionary *lecture = [self.lectureList objectAtIndex:row];
     NSInteger lectureNo = (NSInteger)[lecture objectForKey:@"lectureNo"];
     NSString *lectureTitle = [lecture objectForKey:@"lectureKorNm"];
     
     LectureItemController *lectureItemController = [[LectureItemController alloc] initWithNibName:@"LectureItemController" bundle:[NSBundle mainBundle]];
     lectureItemController.lectureNo = lectureNo;
     lectureItemController.lectureTitle = lectureTitle;
     [self.navigationController pushViewController:lectureItemController animated:YES];
     [lectureItemController release];
     lectureItemController = nil;
     */
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0, 0, 320, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
	label.textAlignment = UITextAlignmentCenter;
    label.text = @"보기";
	
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
	view.backgroundColor = RGB(101, 169, 239);
    [view autorelease];
    [view addSubview:label];
	
    return view;
}


@end
