//
//  TimeTableEditView.h
//  SmartLMS
//
//  Created by 김규완 on 11. 7. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTable.h"

@interface TimeTableEditView : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    NSInteger dayOfWeek;
    NSInteger period;
    NSInteger backColor;
    Boolean isUpdate;
    
    UITextField *titleField;
    UITextField *professorField;
    UITextField *classRoomField;
    UIView *colorView;
    UISegmentedControl *periodControl;
    UISegmentedControl *dayOfWeekControl;
    TimeTable *timeTable;
    
    UIButton *colorButton1, *colorButton2, *colorButton3, *colorButton4, *colorButton5;

}

@property (nonatomic, assign) NSInteger dayOfWeek;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, assign) Boolean isUpdate;
@property (nonatomic, retain) TimeTable *timeTable;

@property (nonatomic, retain) IBOutlet UITextField *titleField;
@property (nonatomic, retain) IBOutlet UITextField *professorField;
@property (nonatomic, retain) IBOutlet UITextField *classRoomField;
@property (nonatomic, retain) IBOutlet UIView *colorView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *periodControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *dayOfWeekControl;

- (void)colorButtonClick:(id)sender;
- (void)setColorButtonSelected:(NSInteger) button;
- (IBAction)backgroundTap:(id)sender;
@end
