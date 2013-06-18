//
//  MyInfoController.h
//  mClass
//
//  Created by 김규완 on 11. 2. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTTPRequest;

@interface MyInfoController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
	NSArray *lectureList;
    UILabel *nameLabel;
    UILabel *majorLabel;
    UILabel *hakbunLabel;
    UILabel *gradeLabel;
    UIActivityIndicatorView *indicator;
    NSString *year;
    NSString *term;
    UIImageView *profileImage;
    UILabel *lectureListLabel;
    NSString *termName;
    HTTPRequest *httpRequest;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *lectureList;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *majorLabel;
@property (nonatomic, retain) IBOutlet UILabel *hakbunLabel;
@property (nonatomic, retain) IBOutlet UILabel *gradeLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UILabel *lectureListLabel;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *term;
@property (nonatomic, retain) NSString *termName;

- (void)bindMyInfo;
- (void)bindMyLecture;
- (void)setDefaultYearTerm;
- (void)didMyInfoReceiveFinished:(NSString *)result;
- (void)didMyLectureReceiveFinished:(NSString *)result;
@end
