//
//  ApplyQuiz.h
//  mClass
//
//  Created by 김규완 on 10. 12. 20..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ApplyQuiz : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UILabel *quizNumberLabel;
	UITextView *quizTitle;
	UITableView *quizExample;
	UIPageControl *pageControl;
	UIBarButtonItem *submitButton;
	UIBarButtonItem *setAnswerButton;
	NSArray *quizList;
	NSArray *exampleList;
	NSMutableArray *answerList;
	NSInteger etestNo;
	NSInteger lectureNo;
	NSInteger itemNo;
	NSInteger quizCnt;
	NSInteger exampleCnt;
	NSInteger quizNo;
	NSInteger applyNo;
	NSInteger currentQNo;
	NSMutableArray *tableExampleList;
}

@property (nonatomic, retain) IBOutlet UILabel *quizNumberLabel;
@property (nonatomic, retain) IBOutlet UITextView *quizTitle;
@property (nonatomic, retain) IBOutlet UITableView *quizExample;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *setAnswerButton;
@property (nonatomic, retain) NSArray *quizList;
@property (nonatomic, retain) NSArray *exampleList;
@property (nonatomic, retain) NSMutableArray *answerList;
@property (nonatomic, retain) NSMutableArray *tableExampleList;
@property (nonatomic, assign) NSInteger etestNo;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, assign) NSInteger itemNo;
@property (nonatomic, assign) NSInteger quizCnt;
@property (nonatomic, assign) NSInteger exampleCnt;
@property (nonatomic, assign) NSInteger quizNo;
@property (nonatomic, assign) NSInteger applyNo;
@property (nonatomic, assign) NSInteger currentQNo;

- (IBAction)submitButtonClick:(id)sender;
- (IBAction)setAnswerButtonClick:(id)sender;
- (IBAction)prevQuizButtonClick:(id)sender;
- (IBAction)nextQuizButtonClick:(id)sender;
- (void)applyQuiz;
- (void)bindQuiz;

@end
