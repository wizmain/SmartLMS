//
//  HomeViewController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SchoolHomeController : UIViewController {
	UIButton *introButton;
	UIButton *majorButton;
	UIButton *infoButton;
	UIButton *admissionButton;
	UIButton *scheduleButton;
}

@property (nonatomic, retain) IBOutlet UIButton *introButton;
@property (nonatomic, retain) IBOutlet UIButton *majorButton;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *admissionButton;
@property (nonatomic, retain) IBOutlet UIButton *scheduleButton;

- (IBAction)introButtonClick:(id)sender;
- (IBAction)majorButtonClick:(id)sender;
- (IBAction)infoButtonClick:(id)sender;
- (IBAction)admissionButtonClick:(id)sender;
- (IBAction)schoolmapClick:(id)sender;
- (IBAction)scheduleButtonClick:(id)sender;
- (void)goHome;
@end
