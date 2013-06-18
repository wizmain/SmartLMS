//
//  TimeTableEditView.m
//  SmartLMS
//
//  Created by 김규완 on 11. 7. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeTableEditView.h"
#import "Utils.h"
#import "Constants.h"
#import "SmartLMSAppDelegate.h"
#import "TimeTableDBManager.h"

#define kUITextViewCellRowHeight	323.0
#define kUITabBarHeight				50


@implementation TimeTableEditView

@synthesize dayOfWeek, period, isUpdate, timeTable;
@synthesize titleField, professorField, classRoomField, colorView, periodControl, dayOfWeekControl;

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
    [titleField release];
    [professorField release];
    [classRoomField release];
    [colorView release];
    [periodControl release];
    [dayOfWeekControl release];
    [colorButton1 release];
    [colorButton2 release];
    [colorButton3 release];
    [colorButton4 release];
    [colorButton5 release];
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
    
    self.navigationItem.title = @"시간표수정";
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTimeTable)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignTextField:) name:UITextViewTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:@"TimeTableEditHideKeyboard" object:nil];

    titleField.delegate = self;
    professorField.delegate = self;
    classRoomField.delegate = self;
    
    //시간표 바탕 색상 선택 버튼 바인드
    colorButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    colorButton1.backgroundColor = UIColorFromRGB(kTimeTableColor1);//RGB(250,157,168);
    colorButton1.frame = CGRectMake(5, 0, 50, 50);
    colorButton1.alpha = 0.4;
    colorButton1.tag = 1;
    [colorButton1 addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    colorButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    colorButton2.backgroundColor = UIColorFromRGB(kTimeTableColor2);// RGB(210,252,149);
    colorButton2.frame = CGRectMake(65, 0, 50, 50);
    colorButton2.alpha = 0.4;
    colorButton2.tag = 2;
    [colorButton2 addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    colorButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    colorButton3.backgroundColor = UIColorFromRGB(kTimeTableColor3);// RGB(158,250,219);
    colorButton3.frame = CGRectMake(125, 0, 50, 50);
    colorButton3.alpha = 0.4;
    colorButton3.tag = 3;
    [colorButton3 addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    colorButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    colorButton4.backgroundColor = UIColorFromRGB(kTimeTableColor4);// RGB(240,157,250);
    colorButton4.frame = CGRectMake(185, 0, 50, 50);
    colorButton4.alpha = 0.4;
    colorButton4.tag = 4;
    [colorButton4 addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    colorButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    colorButton5.backgroundColor = UIColorFromRGB(kTimeTableColor5);// RGB(247,210,156);
    colorButton5.frame = CGRectMake(245, 0, 50, 50);
    colorButton5.alpha = 0.4;
    colorButton5.tag = 5;
    [colorButton5 addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [colorView addSubview:colorButton1];
    [colorView addSubview:colorButton2];
    [colorView addSubview:colorButton3];
    [colorView addSubview:colorButton4];
    [colorView addSubview:colorButton5];
    
    isUpdate = NO;
    
    //수정이면 바인드
    if (dayOfWeek > 0 && period > 0) {
        
        NSLog(@"viewDidLoad dayOfWeek = %d period = %d", dayOfWeek, period);
        
        timeTable = [[TimeTableDBManager timeTable:dayOfWeek period:period] retain];
        
        if (timeTable){
            
            NSLog(@"Name : %@ period : %@", [timeTable valueForKey:@"title"], [timeTable valueForKey:@"period"]);
            titleField.text = [timeTable valueForKey:@"title"];
            period = [[NSString stringWithFormat:@"%@", [timeTable valueForKey:@"period"]] intValue];
            periodControl.selectedSegmentIndex = period - 1;
            if([timeTable valueForKey:@"color"] != nil){
                backColor = [[NSString stringWithFormat:@"%@", [timeTable valueForKey:@"color"]] intValue];
                [self setColorButtonSelected:backColor];
            }
            professorField.text = [timeTable valueForKey:@"professor"];
            classRoomField.text = [timeTable valueForKey:@"classRoom"];
            dayOfWeek = [[NSString stringWithFormat:@"%@", [timeTable valueForKey:@"dayOfWeek"]] intValue];
            dayOfWeekControl.selectedSegmentIndex = dayOfWeek - dayOfWeekSegmentAdjust;
            isUpdate = YES;
        } else {
            
            dayOfWeekControl.selectedSegmentIndex = dayOfWeek - dayOfWeekSegmentAdjust;
            periodControl.selectedSegmentIndex = period - 1;

        }
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    titleField = nil;
    professorField = nil;
    classRoomField = nil;
    colorView = nil;
    periodControl = nil;
    dayOfWeekControl = nil;
    timeTable = nil;
    
    colorButton1 = nil;
    colorButton2 = nil;
    colorButton3 = nil;
    colorButton4 = nil;
    colorButton5 = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma makr Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    /*
    if (theTextField == titleField || theTextField == classRoomField){
        //[titleField resignFirstResponder];
        [professorField becomeFirstResponder];//다음으로 포커스 이동
    } else if (theTextField == professorField){
        [classRoomField becomeFirstResponder];
    } else {
        [classRoomField resignFirstResponder];
    }
    */
    [theTextField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"keyboardWillShow");
	NSDictionary *keyboardInfo = (NSDictionary *)[notification userInfo];
	//self.isShowingKeyboard = YES;
	
	CGRect keyboardEndFrame;
	CGFloat keyboardHeight;
	
	[[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrame];
	
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || 
		[[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
		keyboardHeight = keyboardEndFrame.size.height;
	} else {
		keyboardHeight = keyboardEndFrame.size.width;
	}
	
	CGFloat animationDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	UIViewAnimationCurve curve = [[keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationCurve:curve]; 
	[UIView setAnimationDuration:animationDuration]; 
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	CGRect frame = self.view.frame;
    NSLog(@"frame height = %f", frame.size.height);
	frame.size.height -= keyboardHeight;
	frame.size.height += kUITabBarHeight;
    NSLog(@"keyboardHeight = %f", keyboardHeight);
	self.view.frame = frame;
	NSLog(@"frame height = %f", frame.size.height);
    
	[UIView commitAnimations];
	
	//[self.view bringSubviewToFront:resignTextFieldButton];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	NSDictionary *keyboardInfo = (NSDictionary *)[notification userInfo];
	//self.isShowingKeyboard = NO;
	

    CGRect keyboardEndFrame;
    CGFloat keyboardHeight;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrame];
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || 
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        keyboardHeight = keyboardEndFrame.size.height;
    } else {
        keyboardHeight = keyboardEndFrame.size.width;
    }
    
    CGFloat animationDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationCurve:curve]; 
    [UIView setAnimationDuration:animationDuration]; 
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect frame = self.view.frame;
    frame.size.height += keyboardHeight;
    frame.size.height -= kUITabBarHeight;
    self.view.frame = frame;
    
    [UIView commitAnimations];
	
	
}

#pragma mark -
#pragma mark custom method

- (void)colorButtonClick:(id)sender{

    UIButton *button = (UIButton *)sender;

    backColor = button.tag;
    
    [self setColorButtonSelected:button.tag];
    
}

- (void)setColorButtonSelected:(NSInteger) button {
    if (button == 1) {
        colorButton1.alpha = 1;
        colorButton2.alpha = 0.4;
        colorButton3.alpha = 0.4;
        colorButton4.alpha = 0.4;
        colorButton5.alpha = 0.4;
    } else if(button == 2) {
        colorButton1.alpha = 0.4;
        colorButton2.alpha = 1;
        colorButton3.alpha = 0.4;
        colorButton4.alpha = 0.4;
        colorButton5.alpha = 0.4;
    } else if(button == 3) {
        colorButton1.alpha = 0.4;
        colorButton2.alpha = 0.4;
        colorButton3.alpha = 1;
        colorButton4.alpha = 0.4;
        colorButton5.alpha = 0.4;
    } else if(button == 4) {
        colorButton1.alpha = 0.4;
        colorButton2.alpha = 0.4;
        colorButton3.alpha = 0.4;
        colorButton4.alpha = 1;
        colorButton5.alpha = 0.4;
    } else if(button == 5) {
        colorButton1.alpha = 0.4;
        colorButton2.alpha = 0.4;
        colorButton3.alpha = 0.4;
        colorButton4.alpha = 0.4;
        colorButton5.alpha = 1;
    } 
}

- (void)saveTimeTable {
    
    
    //TimeTable *timeTable = [[[TimeTable alloc] init] autorelease];
    self.timeTable.title = titleField.text;
    self.timeTable.period = [NSNumber numberWithInt:periodControl.selectedSegmentIndex+1];
    self.timeTable.dayOfWeek = [NSNumber numberWithInt:dayOfWeekControl.selectedSegmentIndex+dayOfWeekSegmentAdjust];
    self.timeTable.classRoom = classRoomField.text;
    self.timeTable.professor = professorField.text;
    self.timeTable.color = [NSNumber numberWithInt:backColor];
    
    NSLog(@"saveTimeTable dayOfWeek = %d period = %d", [self.timeTable.dayOfWeek intValue], [self.timeTable.period intValue]);
    
    if(isUpdate){
        NSLog(@"update");
        [TimeTableDBManager updateTimeTable:timeTable];
        NSLog(@"update complete");
    } else {
        NSLog(@"insert");
        [TimeTableDBManager insertTimeTable:timeTable];
        NSLog(@"insert complete");
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)backgroundTap:(id)sender {
    [titleField resignFirstResponder];
    [classRoomField resignFirstResponder];
    [professorField resignFirstResponder];
}


@end
