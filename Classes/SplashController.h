//
//  SplashController.h
//  mClass
//
//  Created by 김규완 on 11. 1. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplashController : UIViewController {
	UIView *splashView;
	UIImage *splashImage;
}

@property (nonatomic, retain) IBOutlet UIView *splashView;
@property (nonatomic, retain) IBOutlet UIImage *splashImage;


- (void)hideSplash;
- (void)showSplash;

@end
