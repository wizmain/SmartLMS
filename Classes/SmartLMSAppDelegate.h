//
//  SmartLMSAppDelegate.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class HTTPRequest;
@class ApplyQuiz;
@class SplashController;
@class IndexViewController;
@class MoviePlayerController;
@class MainViewController;
@class SubIndexViewController;

@interface SmartLMSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	SplashController *splashController;
    LoginViewController *loginViewController;
	MoviePlayerController *moviePlayer;
	MainViewController *mainViewController;
	IndexViewController *indexViewController;
    SubIndexViewController *subIndexViewController;
    UINavigationController *movieNaviController;
    UINavigationController *naviController;
	//사용할 Http커넥션 객체
	HTTPRequest *httpRequest;
	NSString *serverUrl;
	NSString *loginUrl;
	BOOL alertRunning;
	BOOL isAuthenticated;
    NSString *authGroup;//인증된 그룹 학생,교수,교직원,관리자..STUDENT, TEACHER, STAFF, ADMIN, ETC
    NSString *authUserID;
    NSString *version;
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) MoviePlayerController *moviePlayer;
@property (nonatomic, retain) HTTPRequest *httpRequest;
@property (nonatomic, retain) NSString *serverUrl;
@property (nonatomic, retain) NSString *loginUrl;
@property (nonatomic, getter = isAlertRunning) BOOL alertRunning;
@property (nonatomic, retain) SplashController *splashController;
@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) IndexViewController *indexViewController;
@property (nonatomic, retain) UINavigationController *movieNaviController;
@property (nonatomic, retain) SubIndexViewController *subIndexViewController;
@property (nonatomic, retain) UINavigationController *naviController;
@property (nonatomic, retain) NSString *authGroup;
@property (nonatomic, retain) NSString *authUserID;
@property (nonatomic, retain, readonly) NSString *version;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SmartLMSAppDelegate *)sharedAppDelegate;

- (void)switchMainView;
- (void)switchLoginView;
- (void)switchMoviePlayer:(NSInteger)lectureNo itemNo:(NSInteger)itemNo;
- (void)didReceiveFinished:(NSString *)result;
- (void)switchSubIndexView;
- (void)loginProcess;
- (BOOL)isStudent;
- (BOOL)isCellNetwork;
- (BOOL)isNetworkReachable;
- (void)initMainView;
- (void)removeMoviePlayer;

@end

