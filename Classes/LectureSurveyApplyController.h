//
//  LectureSurveyApplyController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LectureSurveyApplyController : UIViewController {
    UILabel *quizNumberLabel;
	UITextView *quizTitle;
	UITableView *quizExample;
	NSArray *surveyList;
	NSArray *exampleList;
	NSMutableArray *answerList;
	NSInteger surveyNo;
	NSInteger itemNo;
	NSInteger quizCnt;
	NSInteger exampleCnt;
	NSInteger quizNo;
	NSInteger applyNo;
	NSInteger currentQNo;
	NSArray *tableExampleList;
    UIActivityIndicatorView *spinner;
    UITextView *subjectiveAnswerText;
    UIButton *subjectAnswerButton;
    UIColor *backImg;
}

@property (nonatomic, retain) IBOutlet UILabel *quizNumberLabel;
@property (nonatomic, retain) IBOutlet UITextView *quizTitle;
@property (nonatomic, retain) IBOutlet UITableView *quizExample;
@property (nonatomic, retain) NSArray *surveyList;
@property (nonatomic, retain) NSArray *exampleList;
@property (nonatomic, retain) NSMutableArray *answerList;
@property (nonatomic, retain) NSArray *tableExampleList;
@property (nonatomic, assign) NSInteger surveyNo;
@property (nonatomic, assign) NSInteger itemNo;
@property (nonatomic, assign) NSInteger quizCnt;
@property (nonatomic, assign) NSInteger exampleCnt;
@property (nonatomic, assign) NSInteger quizNo;
@property (nonatomic, assign) NSInteger applyNo;
@property (nonatomic, assign) NSInteger currentQNo;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UITextView *subjectiveAnswerText;
@property (nonatomic, retain) IBOutlet UIButton *subjectAnswerButton;

- (IBAction)submitButtonClick:(id)sender;
- (IBAction)setAnswerButtonClick:(id)sender;
- (IBAction)prevQuizButtonClick:(id)sender;
- (IBAction)nextQuizButtonClick:(id)sender;
- (void)didSetAnswerReceiveFinished:(NSString *)result;
- (void)applySurvey;
- (void)bindSurvey;

@end
