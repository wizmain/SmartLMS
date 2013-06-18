//
//  LectureDetailController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 13..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LectureDetailController : UIViewController {
    NSInteger lectureNo;
    NSString *subjID;
    UILabel *lectureTitle;
    UILabel *lectureGrade;
    UILabel *lectureTeacher;
    UIButton *attendButton;
    UIButton *reportButton;
    UIButton *quizButton;
    UIButton *recordButton;
    UIButton *boardButton;
    UIButton *studentButton;
    UIActivityIndicatorView *indicator;
    NSString *lectureTitleString;
    UILabel *lectureStatPercent;
    UIProgressView *attendProgressView;
}

@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) NSString *subjID;
@property (nonatomic, retain) IBOutlet UILabel *lectureTitle;
@property (nonatomic, retain) IBOutlet UILabel *lectureGrade;
@property (nonatomic, retain) IBOutlet UILabel *lectureTeacher;
@property (nonatomic, retain) IBOutlet UIButton *attendButton;
@property (nonatomic, retain) IBOutlet UIButton *reportButton;
@property (nonatomic, retain) IBOutlet UIButton *quizButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *boardButton;
@property (nonatomic, retain) IBOutlet UIButton *studentButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UILabel *lectureStatPercent;
@property (nonatomic, retain) IBOutlet UIProgressView *attendProgressView;
@property (nonatomic, retain) NSString *lectureTitleString;

- (void)bindLectureInfo;
- (IBAction)attendButtonClick:(id)sender;
- (IBAction)reportButtonClick:(id)sender;
- (IBAction)quizButtonClick:(id)sender;
- (IBAction)recordButtonClick:(id)sender;
- (IBAction)boardButtonClick:(id)sender;
- (IBAction)studentButtonClick:(id)sender;
- (IBAction)studentStatButtonClick:(id)sender;
- (IBAction)lectureStatButtonClick:(id)sender;
- (void)requestLectureStatPercent;
- (void)didLectureInfoReceiveFinished:(NSString *)result;
- (void)didLectureStatReceiveFinished:(NSString *)result;
- (void)didStudentAttendInfoReceiveFinished:(NSString *)result;
- (void)requestStudentAttendInfo;
@end
