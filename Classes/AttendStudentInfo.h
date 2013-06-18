//
//  AttendStudentInfo.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 11..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendStudentInfo : UIViewController {

    NSString *userID;
    NSString *userName;
    NSInteger lectureNo;
    NSDictionary *attendInfo;
    UILabel *studentNameLabel;
    UILabel *majorLabel;
    UILabel *hakbunLabel;
    UIProgressView *attendProgress;
    UIProgressView *reportProgress;
    UIProgressView *etestProgress;
    NSString *lectureTitle;
    UILabel *attendPercentLabel;
    UILabel *etestPercentLabel;
    UILabel *reportPercentLabel;
}

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) NSDictionary *attendInfo;
@property (nonatomic, retain) IBOutlet UILabel *studentNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *majorLabel;
@property (nonatomic, retain) IBOutlet UILabel *hakbunLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *attendProgress;
@property (nonatomic, retain) IBOutlet UIProgressView *reportProgress;
@property (nonatomic, retain) IBOutlet UIProgressView *etestProgress;
@property (nonatomic, retain) IBOutlet UILabel *attendPercentLabel;
@property (nonatomic, retain) IBOutlet UILabel *etestPercentLabel;
@property (nonatomic, retain) IBOutlet UILabel *reportPercentLabel;
@property (nonatomic, retain) NSString *lectureTitle;

- (void)bindAttendInfo;

@end
