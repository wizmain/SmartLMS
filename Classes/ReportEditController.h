//
//  ReportEditController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReportEditController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>{
    UITableView *table;
    UITextField *titleText;
    UITextField *startDateText;
    UITextField *closeDateText;
    UITextView *contentText;
    NSInteger reportNo;
    NSInteger lectureNo;
    NSInteger itemNo;
    BOOL isShowingKeyboard;
    NSDictionary *report;
    NSInteger selectedSection;
    IBOutlet UIButton *resignTextFieldButton;
    UIBarButtonItem *saveButton;
    UIBarButtonItem *contentEditDoneButton;
    UIActionSheet *actionSheet;
    UIDatePicker *startDatePicker;
    UIDatePicker *closeDatePicker;
    NSString *lectureTitle;
}

@property (nonatomic, retain) IBOutlet UITextField *titleText;
@property (nonatomic, retain) IBOutlet UITextField *startDateText;
@property (nonatomic, retain) IBOutlet UITextField *closeDateText;
@property (nonatomic, retain) IBOutlet UITextView *contentText;
@property (nonatomic, assign) NSInteger reportNo;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, assign) NSInteger itemNo;
@property (nonatomic, assign) BOOL isShowingKeyboard;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSDictionary *report;
@property (nonatomic, assign) NSInteger selectedSection;
@property (nonatomic, retain) UIButton *resignTextFieldButton;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) UIBarButtonItem *contentEditDoneButton;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIDatePicker *startDatePicker;
@property (nonatomic, retain) UIDatePicker *closeDatePicker;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)saveReport:(id)sender;
- (void)bindReportInfo;
- (IBAction)resignTextField:(id)sender;
- (void)hideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)reportContentEditDone:(id)sender;
- (void)showDatePicker:(id)sender;
- (void)hideDatePicker:(id)sender;
@end
