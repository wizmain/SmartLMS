//
//  MainViewController.h
//  mClass
//
//  Created by 김규완 on 11. 1. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  총괄 컨트롤러

#import <UIKit/UIKit.h>

@class IndexViewController;
@class LoginViewController;
@class MoviePlayerController;

@interface MainViewController : UIViewController <UINavigationControllerDelegate, UITabBarControllerDelegate> {
	UITabBarController *tabController;
	IndexViewController *indexController;
	LoginViewController *loginController;
	MoviePlayerController *moviePlayer;
	UINavigationController *naviController;
    UINavigationController *movieNaviController;
    UINavigationController *applyQuizController;
    BOOL isMoviePlay;
}

@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) IndexViewController *indexController;
@property (nonatomic, retain) LoginViewController *loginController;
@property (nonatomic, retain) MoviePlayerController *moviePlayer;
@property (nonatomic, retain) UINavigationController *naviController;
@property (nonatomic, retain) UINavigationController *movieNaviController;
@property (nonatomic, retain) UINavigationController *applyQuizController;

- (void)switchLoginView;
- (void)switchIndexView;
- (void)switchTabView:(NSInteger)tabIndex;
- (void)switchApplyQuizView:(NSInteger)lectureNo itemNo:(NSInteger)itemNo etestNo:(NSInteger)etestNo;
- (void)switchMoviePlayer:(NSInteger)lectureNo itemNo:(NSInteger)itemNo subjID:(NSString *)subjID weekSeq:(NSInteger)weekSeq orderSeq:(NSInteger)orderSeq;

@end
