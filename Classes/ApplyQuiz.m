//
//  ApplyQuiz.m
//  mClass
//
//  Created by 김규완 on 10. 12. 20..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplyQuiz.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "AlertUtils.h"
#import "JSON.h"
#import "MainViewController.h"
#import "SmartLMSAppDelegate.h"

@implementation ApplyQuiz

@synthesize quizNumberLabel;
@synthesize quizTitle;
@synthesize quizExample;
@synthesize pageControl;
@synthesize submitButton;
@synthesize setAnswerButton;
@synthesize quizList;
@synthesize exampleList;
@synthesize answerList;
@synthesize tableExampleList;
@synthesize etestNo;
@synthesize lectureNo;
@synthesize itemNo;
@synthesize quizCnt;
@synthesize exampleCnt;
@synthesize quizNo;
@synthesize applyNo;
@synthesize currentQNo;

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
	
	self.navigationController.toolbarHidden = NO;
    
    self.navigationItem.title = @"퀴즈응시";
    
    UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_middle"]];
    self.view.backgroundColor = backImg;
    [backImg release];
    
    quizExample.backgroundColor = [UIColor clearColor];
    
    
    UIBarButtonItem *submitButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"제출하기" style:UIBarButtonItemStyleBordered target:self action:@selector(submitButtonClick:)];
	UIBarButtonItem *answerButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"정답설정" style:UIBarButtonItemStyleBordered target:self action:@selector(setAnswerButtonClick:)];
	UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	NSArray *toolbar = [[NSArray alloc] initWithObjects:submitButtonItem, flexible, answerButtonItem, nil];
	
	
    UIButton *prevQuizButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevQuizButton setBackgroundImage:[UIImage imageNamed:@"prev_quiz"] forState:UIControlStateNormal];
    [prevQuizButton addTarget:self action:@selector(prevQuizButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    prevQuizButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:prevQuizButton];
    
    UIButton *nextQuizButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextQuizButton setBackgroundImage:[UIImage imageNamed:@"next_quiz"] forState:UIControlStateNormal];
    [nextQuizButton addTarget:self action:@selector(nextQuizButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nextQuizButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextQuizButton];
    
    /*
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"이전문제" style:UIBarButtonItemStylePlain target:self action:@selector(prevQuizButtonClick:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"다음문제" style:UIBarButtonItemStylePlain target:self action:@selector(nextQuizButtonClick:)];
    
    //self.navigationController.toolbarItems = toolbar;
    */
    
    self.toolbarItems = toolbar;
    
    self.quizCnt = 0;
    
	[self applyQuiz];
    
    //AlertWithMessage(@"정답을 체크하신 후에 정답설정을 반드시 하셔야 합니다");

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
      
	self.quizNumberLabel = nil;
	self.quizTitle = nil;
	self.quizExample = nil;
	self.pageControl = nil;
	self.submitButton = nil;
	self.setAnswerButton = nil;
    self.quizList = nil;
    self.exampleList = nil;
    self.answerList = nil;
    self.tableExampleList = nil;

}


- (void)dealloc {
	[quizNumberLabel release];
	[quizTitle release];
	[quizExample release];
	[pageControl release];
	[submitButton release];
	[setAnswerButton release];
	[quizList release];
	[answerList release];
	[exampleList release];
	[tableExampleList release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method



-(IBAction)submitButtonClick:(id)sender {
	NSString *url = [kServerUrl stringByAppendingString:kETestSubmitUrl];
	NSString *queryString = [NSString stringWithFormat:@"/%d/%d",etestNo, applyNo];
	url = [url stringByAppendingString:queryString];
	NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didSubmitReceiveFinished:)];
	
	NSLog(@"submitButtonClick url = %@", url);
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (IBAction)setAnswerButtonClick:(id)sender {
	
	if (quizList) {
		NSDictionary *quiz = (NSDictionary *)[self.quizList objectAtIndex:currentQNo-1];
		NSString *qType = [quiz objectForKey:@"qtype"];
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
						url = [kServerUrl stringByAppendingString:kETestSubjectiveAnswerUrl];
						//POST로 전송할 데이터 설정
						bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSString stringWithFormat:@"%d",lectureNo], @"LecNo"
									  , [NSString stringWithFormat:@"%d",etestNo], @"ETestNo"
									  , [NSString stringWithFormat:@"%d",applyNo], @"applyNo"
									  , [NSString stringWithFormat:@"%d",currentQNo], @"qNo"
									  , answerSubjective, @"answer", nil];
						

					} else {
						answerObjective = [[NSString stringWithFormat:@"%@",[a objectForKey:@"answerObjective"]] intValue];
						url = [kServerUrl stringByAppendingString:kETestObjectiveAnswerUrl];
						//POST로 전송할 데이터 설정
						bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSString stringWithFormat:@"%d",lectureNo], @"LecNo"
									  , [NSString stringWithFormat:@"%d",etestNo], @"ETestNo"
									  , [NSString stringWithFormat:@"%d",applyNo], @"applyNo"
									  , [NSString stringWithFormat:@"%d",currentQNo], @"qNo"
									  , [NSString stringWithFormat:@"%d",answerObjective], @"exampleNo", nil];
					}
				}
			}
		}
		
		if (answerObjective == 0 && [answerSubjective isEqualToString:@""]) {
			AlertWithMessage(@"정답을 설정해 주세요");
		} else {
			
			HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
			[httpRequest setDelegate:self selector:@selector(didSetAnswerReceiveFinished:)];
			NSLog(@"setAnswerButtonClick url = %@", url);
			//페이지 호출
			[httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST" withTag:nil];
		}
		
	}
	
	
	
}

- (IBAction)prevQuizButtonClick:(id)sender {
	if (self.currentQNo == 1) {
		AlertWithMessage(@"이전 문제가 없습니다");
	} else {
		self.currentQNo--;
		[self bindQuiz];
	}

}

- (IBAction)nextQuizButtonClick:(id)sender {
	if (quizList != nil) {
		
		if (self.currentQNo == [self.quizList count]) {
			AlertWithMessage(@"다음 문제가 없습니다");
		} else {
			self.currentQNo++;
			[self bindQuiz];
		}
	}
}

//문제 바인드
- (void)bindQuiz {
	
	NSLog(@"bindQuiz");
	
	if (self.quizList) {
        
        //self.navigationItem.title = [NSString stringWithFormat:@"[총%d문제] %d번", self.quizCnt, self.currentQNo];
		
		if ([self.quizList count] > 0) {
			//해당 문제의 퀴즈 정보가져오기
            //NSDictionary *q = [self.quizList objectAtIndex:self.currentQNo-1];
            NSDictionary *q = nil;
            for(int k=0;k<[self.quizList count];k++){
                NSDictionary *tmp = [self.quizList objectAtIndex:k];
                if( [[NSString stringWithFormat:@"%@",[tmp objectForKey:@"qno"]] intValue] == self.currentQNo){
                    q = tmp;
                }
            }
            
			int qno = [[NSString stringWithFormat:@"%@",[q objectForKey:@"qno"]] intValue];//(int)[q objectForKey:@"qno"];
			
			quizNumberLabel.text = [NSString stringWithFormat:@"[총%d문제] %d.번", self.quizCnt, qno];
			quizTitle.text = [q objectForKey:@"qtitle"];
			//퀴즈의 예제 목록 초기화
			self.tableExampleList = [NSMutableArray array];
			//예제 바인드
			for (int i=0; i< [self.exampleList count]; i++) {
				NSDictionary *ex = [self.exampleList objectAtIndex:i];
				int exQNo = [[NSString stringWithFormat:@"%@",[ex objectForKey:@"qno"]] intValue];
				//(int)[ex objectForKey:@"qno"]
				//모든 예제의 목록에서 해당 문제의 예제만 골라 설정
				if ( exQNo == qno) {
					//NSLog(@"ex = %@",[ex objectForKey:@"qexample"]);
					[self.tableExampleList addObject:ex];
				}
			}
			//예제 테이블 리로드
			[quizExample reloadData];
			
			//기존 설정된 값 설정 미리 선택되어 있게 처리
			if (self.answerList) {
				for (int i=0; i<[self.answerList count]; i++) {
					NSDictionary *a = (NSDictionary *)[self.answerList objectAtIndex:i];
					NSLog(@"answer = %@ currentQNo = %d", (NSInteger)[a objectForKey:@"answerObjective"], self.currentQNo);
					
					int answerExNo = [[NSString stringWithFormat:@"%@",[a objectForKey:@"qno"]] intValue];
					if ( answerExNo == self.currentQNo) {	
						
						NSLog(@"빙고 answerExample = %@",(int)[a valueForKey:@"answerObjective"]);
						int row = [[NSString stringWithFormat:@"%@",[a objectForKey:@"answerObjective"]] intValue];
						[quizExample selectRowAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0] animated:NO scrollPosition:0];
					}
				}
			} else {
                NSLog(@"answerList nil");
            }
			
		}
	}
}


- (void)requestQuizData {
	NSString *url = [kServerUrl stringByAppendingString:kLectureItemETestUrl];
	NSString *queryString = [NSString stringWithFormat:@"/%d/%d",lectureNo, itemNo];
	url = [url stringByAppendingString:queryString];
	NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(didETestReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (void)applyQuiz {
	
	NSString *url = [kServerUrl stringByAppendingString:kApplyQuizUrl];
	NSString *queryString = [NSString stringWithFormat:@"?LecNo=%d&ETestNo=%d",lectureNo, etestNo];
	url = [url stringByAppendingString:queryString];
	NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	[httpRequest setDelegate:self selector:@selector(applyQuizReceiveResult:)];
	
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
		[[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchTabView:1];
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
		AlertWithMessage(@"설정되었습니다");
	} else {
		AlertWithMessage(@"설정 하지 못했습니다.");
	}

}

- (void)applyQuizReceiveResult:(NSString *)result {
	NSLog(@"applyQuiz receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];

	NSDictionary *etestInfo = [jsonData valueForKey:@"result"];
	//NSString *resultStr = [jsonData objectForKey:@"result"];
	NSLog(@"applyQuiz 성공");
	
	if (etestInfo) {
		if ([etestInfo valueForKey:@"result"]) {
			//실패
			NSLog(@"퀴즈 실패");
			AlertWithMessage([etestInfo valueForKey:@"message"]);
			[self dismissModalViewControllerAnimated:YES];
			[[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchTabView:1];
		} else {
			
			self.quizList = (NSArray *)[etestInfo valueForKey:@"questionList"];
			self.exampleList = (NSArray *)[etestInfo valueForKey:@"exampleList"];
			self.answerList = (NSMutableArray *)[etestInfo valueForKey:@"answerList"];
			self.applyNo = [[NSString stringWithFormat:@"%@", [etestInfo objectForKey:@"applyNo"]] intValue];
			NSLog(@"applyNo = %d", applyNo);
			NSLog(@"quizList = %d",quizList.count);
			NSLog(@"exampleList = %d",exampleList.count);
			NSLog(@"answerList = %d",answerList.count);
			
			if ([self.answerList count] == 0) {
				self.answerList = [NSMutableArray array];
			}
            
            
			            
            if (quizList != nil) {
            
                if ([quizList count] > 0) {
                    
                    self.quizCnt = [quizList count];
                    
                    for (int i=0;i<[quizList count];i++){
                        //NSDictionary *q = [quizList objectAtIndex:i];
                        //NSLog(@"applyQuiz quizNo = %@", [q valueForKey:@"qno"]);
                    }
                    
                } 
            }
            
            currentQNo = 1;
            
			[self bindQuiz];

			 
		}

	} else {
		AlertWithMessage(@"퀴즈 데이타가 존재하지 않습니다.");
		[self dismissModalViewControllerAnimated:YES];
		[[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchTabView:1];
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
	
    static NSString *normalCellIdentifier = @"ETestExample";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:normalCellIdentifier] autorelease];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        
	}
	
	UIImage *uncheck = [UIImage imageNamed:@"unchecked.png"];
	cell.imageView.image = uncheck;
	UIImage *checked = [UIImage imageNamed:@"check.png"];
	cell.imageView.highlightedImage = checked;
	
	NSUInteger row = [indexPath row];
	
	if (self.tableExampleList) {
		
		if([self.tableExampleList count] > 0){
			NSDictionary *ex = [self.tableExampleList objectAtIndex:row];
			//NSString *label = [ [NSString stringWithFormat:@"%@",[ex objectForKey:@"qexampleNo"]] stringByAppendingFormat:@".%@",[ex objectForKey:@"qexample"]];
            NSString *label = [ex valueForKey:@"qexample"];

			cell.textLabel.text = label;
			//cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            
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
        
        //선택된보기정보
		NSDictionary *ex = (NSDictionary *)[self.tableExampleList objectAtIndex:[indexPath row]];
		BOOL answerExist = NO;
		
		if (self.answerList) {
            //답안작성 목록에서 해당 보기의 정답설정한 내용이 있는지 확인
			for (int i=0; i<[self.answerList count]; i++) {
                
				NSMutableDictionary *tmpAnswer = [self.answerList objectAtIndex:i];
                //보기가 포함된 문항의 번호와 답안목록의 번호같은거 찾음
				NSInteger answerQno = [[NSString stringWithFormat:@"%@",[tmpAnswer objectForKey:@"qno"]] intValue];
				NSInteger exQno = [[NSString stringWithFormat:@"%@",[ex objectForKey:@"qno"]] intValue];
				if (answerQno == exQno) {
					NSLog(@"빙고");
					[tmpAnswer setObject:[ex objectForKey:@"qexampleNo"] forKey:@"answerObjective"];
					answerExist = YES;
				}
			}
		} else {
            
            NSLog(@"answer not exsit");
            
            //답안설정된 내용 없으면 초기화
			self.answerList = [NSMutableArray array];   
		}

        if (answerExist == NO) {
            //[values release];
            
            //NSArray *keys = [[NSArray alloc] initWithObjects:@"qno",@"answerObjective",@"answerSubjective", nil];
            //NSArray *values = [[NSArray alloc] initWithObjects:[ex objectForKey:@"qno"], [ex objectForKey:@"qexampleNo"], @"", nil];
            NSMutableDictionary *answer = [[NSMutableDictionary alloc] init];
            [answer setObject:[ex objectForKey:@"qno"] forKey:@"qno"];
            [answer setObject:[ex objectForKey:@"qexampleNo"] forKey:@"answerObjective"];
            [answer setObject:@"" forKey:@"answerSubjective"];
            //NSDictionary *answer = [NSDictionary initWithObjects:values forKeys:keys];
            NSLog(@"answer qno = %@ answerObjective = %@", [answer objectForKey:@"qno"], [answer objectForKey:@"answerObjective"]);
            [self.answerList addObject:answer];
            NSLog(@"set Answer answer count = %d", self.answerList.count);
            [answer release];
            //[keys release];

            
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    float height = 20;
    
    if (self.tableExampleList) {
		
		if([self.tableExampleList count] > 0){
			NSDictionary *ex = [self.tableExampleList objectAtIndex:row];
			NSString *cellText = [ex valueForKey:@"qexample"];
            
            UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
            
            height = labelSize.height + 20;
		}
	}
    
    return height;
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
    label.text = [NSString stringWithFormat:@"보기 총%d개", self.tableExampleList.count];
	
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
	view.backgroundColor = RGB(101, 169, 239);
    [view autorelease];
    [view addSubview:label];
	
    return view;
}


@end
