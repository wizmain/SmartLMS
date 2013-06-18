//
//  QuizEditController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuizEditController : UIViewController <UITextFieldDelegate> {
    NSInteger etestNo;
    NSInteger lectureNo;
    NSInteger itemNo;
    NSDictionary *etest;
    UITextField *quizTitle;
    UITextField *startDate;
    UITextField *closeDate;
    UIButton *saveButton;
    UIActionSheet *actionSheet;
    UIDatePicker *startDatePicker;
    UIDatePicker *closeDatePicker;
    NSString *etestState;
    UISwitch *etestSwitch;
    UILabel *etestStateLabel;
}

@property (nonatomic, assign) NSInteger etestNo;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, assign) NSInteger itemNo;
@property (nonatomic, retain) NSDictionary *etest;
@property (nonatomic, retain) IBOutlet UITextField *quizTitle;
@property (nonatomic, retain) IBOutlet UITextField *startDate;
@property (nonatomic, retain) IBOutlet UITextField *closeDate;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIDatePicker *startDatePicker;
@property (nonatomic, retain) UIDatePicker *closeDatePicker;
@property (nonatomic, retain) NSString *etestState;
@property (nonatomic, retain) IBOutlet UISwitch *etestSwitch;
@property (nonatomic, retain) IBOutlet UILabel *etestStateLabel;

- (void)bindETestInfo;
- (IBAction)saveETestInfo;
- (void)showDatePicker:(id)sender;
- (void)hideDatePicker:(id)sender;
- (IBAction)toggleSwitch:(id)sender;

@end
