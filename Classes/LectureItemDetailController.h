//
//  LectureItemDetailController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 15..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LectureItemDetailController : UIViewController {
	NSInteger lectureNo;
	NSInteger itemNo;
	NSString *itemName;
	UIButton *quizButton;
	NSInteger etestNo;
}

@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, assign) NSInteger itemNo;
@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) IBOutlet UIButton *quizButton;

- (IBAction)quizButtonClick:(id)sender;

@end
