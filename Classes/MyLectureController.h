//
//  MyLectureController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kYearComponent	0
#define kTermComponent	1
@class YearPickerDelegate;
@class TermPickerDelegate;

@interface MyLectureController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *lectureTable;
	UIActionSheet *actionSheet;
	UITextField *activeTextField;
	UIButton *yearButton;
	UIButton *termButton;
	UIButton *searchButton;
	YearPickerDelegate *yearPickerDelegate;
	TermPickerDelegate *termPickerDelegate;
	UIPickerView *yearPickerView;
	UIPickerView *termPickerView;
	BOOL viewDidMove, keyboardIsVisible;
	NSArray *lectureList;
}

@property (nonatomic, retain) IBOutlet UITableView *lectureTable;
@property (nonatomic, retain) IBOutlet UIButton *yearButton;
@property (nonatomic, retain) IBOutlet UIButton *termButton;
@property (nonatomic, assign) BOOL viewDidMove, keyboardIsVisible;
@property (nonatomic, retain) NSArray *lectureList;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

- (IBAction)showYearPicker:(id)sender;
- (IBAction)hideYearPicker:(id)sender;
- (IBAction)showTermPicker:(id)sender;
- (IBAction)hideTermPicker:(id)sender;
- (void)bindLectureList;
- (IBAction)searchButtonClicked:(id)sender;
- (void)reloadLectureTable;
//- (void)keyboardWillShow:(NSNotification *)notification;
//- (void)keyboardWillHide:(NSNotification *)notification;
@end
