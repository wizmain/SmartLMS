//
//  SmartLMSAppDelegate.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SmartLMSAppDelegate.h"
#import "LoginViewController.h"
#import "HTTPRequest.h"
#import "LoginProperties.h"
#import "Utils.h"
#import "JSON.h"
#import "Constants.h"
#import "SplashController.h"
#import "IndexViewController.h"
#import "MoviePlayerController.h"
#import "ApplyQuiz.h"
#import "MainViewController.h"
#import "AlertUtils.h"
#import "SubIndexViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@implementation SmartLMSAppDelegate

@synthesize window;
@synthesize loginViewController;
@synthesize httpRequest;
@synthesize serverUrl;
@synthesize loginUrl, authUserID;
@synthesize alertRunning, isAuthenticated, authGroup;
@synthesize splashController, moviePlayer;
@synthesize mainViewController, indexViewController, movieNaviController, subIndexViewController, naviController;
@synthesize version;

+ (SmartLMSAppDelegate *)sharedAppDelegate {
	return (SmartLMSAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)initMainView {
    self.mainViewController = nil;
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.mainViewController = main;
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.mainViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
    [main release];
}

- (void)switchMainView {
    NSLog(@"switchMainView");
	if (self.mainViewController == nil) {
		MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        
		self.mainViewController = main;
        CGRect rect = [[UIScreen mainScreen] bounds];
        self.mainViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        
        
		[main release];
        
	}
    
    if(![self isStudent])
        [[[[self.mainViewController tabController] viewControllers] objectAtIndex:1] setTitle:@"수업참여"];
    
    [self.window addSubview:self.mainViewController.view];
    //[self.window bringSubviewToFront:self.mainViewController.view];
	
}

- (void)switchLoginView {
    
	if (self.loginViewController == nil) {
		LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
		self.loginViewController = login;
		[login release];
        
		//self.loginViewController.view.frame = CGRectMake(0, 20, 320, 460);
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        self.loginViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
	}
	[self.window addSubview:self.loginViewController.view];
}


- (void)switchMoviePlayer:(NSInteger)lectureNo itemNo:(NSInteger)itemNo {
    
    moviePlayer = [[MoviePlayerController alloc] initWithNibName:@"MoviePlayerController" 
                                                              bundle:[NSBundle mainBundle]];
    
    moviePlayer.lectureNo = lectureNo;
    moviePlayer.itemNo = itemNo;
    //movieNaviController = [[UINavigationController alloc] initWithRootViewController:moviePlayer];
    
    //[movieNaviController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
    [self.window addSubview:moviePlayer.view];
    
}

- (void)switchSubIndexView {
	
    
    if(self.subIndexViewController == nil) {
        SubIndexViewController *subIndex = [[SubIndexViewController alloc] initWithNibName:@"SubIndexViewController" bundle:nil];
        self.subIndexViewController = subIndex;
        //self.subIndexViewController.view.frame = CGRectMake(0, 20, 320, 460);
        naviController = [[UINavigationController alloc] initWithRootViewController:self.subIndexViewController];
        [subIndex release];
    }
    
    
}

- (void)removeMoviePlayer {
    [self.moviePlayer release];
    //self.moviePlayer = nil;
}

- (BOOL)isStudent {
    
    if([Utils isNullString:self.authGroup]){
    
        return YES;
    } else {
    
        if ([self.authGroup isEqualToString:@"주간"] || [self.authGroup isEqualToString:@"야간"]) {
            return YES;
        } else {
            return NO;
        }
    }
}

-(BOOL) isNetworkReachable
{
	struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
	
	SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
	
    if(flag & kSCNetworkFlagsReachable){
        return YES;
    }else {
        return NO;
    }
}

-(BOOL)isCellNetwork{
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
	
    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
	
    if(flag & kSCNetworkReachabilityFlagsIsWWAN){
        return YES;
    }else {
        return NO;
    }
}

- (void)loginProcess {
    // 로그인 설정정보 확인
	LoginProperties *loginProperties = [Utils loginProperties];
	
	if (loginProperties == nil) {
		NSLog(@"loginProperties nil");
		[self switchLoginView];
		
	} else {
		
		//자동 로그인 셋팅이면
        NSLog(@"autologin %@", [loginProperties autoLogin]);
		if ([[loginProperties autoLogin] isEqualToString:@"YES"]) {
			NSLog(@"loginProperties autologin YES");
			//로그인 주소 설정
			//NSString *url = [serverUrl stringByAppendingString:loginUrl];
			NSString *url = [kServerUrl stringByAppendingString:kLoginUrl];
			NSLog(@"%@",url);
			
			//POST로 전송할 데이터 설정
			NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:[loginProperties userID],@"userid", [loginProperties password],@"passwd", nil];
			/*
             //통신완료 후 호출할 델리게이트 셀렉터 설정
             [httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
             
             //페이지 호출
             [httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST" connectionDelegate:self];
             */
            
            NSError *error = nil;
            NSHTTPURLResponse *response = nil;
            NSData *responseData = [httpRequest requestUrlSync:url bodyObject:bodyObject httpMethod:@"POST" error:error response:response];
            NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            [self didReceiveFinished:resultData];
			
            
		} else {
			NSLog(@"LoginProperties autologin NO");
			[self switchLoginView];
		}
	}
}

- (void)didReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	NSDictionary *results = [jsonParser objectWithString:result];
	
	NSString *key;
	for (key in results){
		NSLog(@"Key: %@, Value: %@", key, [results valueForKey:key]);
	}
	
	[jsonParser release];
    
    NSDictionary *userSession = [results objectForKey:@"userSession"];
	
	//[self switchTabView];
	NSString *resultStr = (NSString *)[userSession valueForKey:@"result"];
    NSLog(@"resultStr = %@", resultStr);
	if ( [resultStr isEqualToString:@"success"]) {
        
		isAuthenticated = YES;
        self.authGroup = [userSession valueForKey:@"userKind"];
        
        
	} else {
        [self switchLoginView];
    }
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//에러가 발생하였을 경우 호출되는 메소드
	NSLog(@"SmartLMSAppDelegate Error: %@", [error localizedDescription]);
	AlertWithError(error);
    [self switchLoginView];
}


#pragma mark -
#pragma mark Core Data Stack
/**
 * 
 */
- (NSManagedObjectContext *)managedObjectContext {
    if(managedObjectContext != nil){
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil){
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if(managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:[Utils dataFilePath:@"SmartLMS.sqlite"]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                             NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                             NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]){
        
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    if([Utils isNullString:version]){
        version = @"0.0.0";
    }
	
	if (self.mainViewController.view.superview == nil) {
		if (self.mainViewController == nil) {
			MainViewController *mainView = [[MainViewController alloc] 
											initWithNibName:@"MainViewController"
											bundle:nil];
			self.mainViewController = mainView;
			//CGRect newFrame = self.window.frame;
			self.mainViewController.view.frame = CGRectMake(0, 20, 320, 460);
			[mainView release];
		}
	}
    
    //추가적으로 페이지 하나더 추가 해달라 해서
    if(self.subIndexViewController.view.superview == nil) {
        if(self.subIndexViewController == nil) {
            SubIndexViewController *subIndex = [[SubIndexViewController alloc] initWithNibName:@"SubIndexViewController" bundle:nil];
            self.subIndexViewController = subIndex;
            self.subIndexViewController.view.frame = CGRectMake(0, 20, 320, 460);
            //naviController = [[UINavigationController alloc] initWithRootViewController:self.subIndexViewController];
            [subIndex release];
        }
    }
	
    //추가 페이지 여기서 결정하면 됨
	[window addSubview:mainViewController.view];
    
    [self loginProcess];
    
    //[window addSubview:self.subIndexViewController.view];

    
    // Override point for customization after application launch.
    httpRequest = [[HTTPRequest alloc] init];
	isAuthenticated = NO;
	
    // Add the view controller's view to the window and display.
    
	
	
	
    [window makeKeyAndVisible];
	[splashController showSplash];
    return YES;
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[loginViewController release];
	[httpRequest release];
	[serverUrl release];
	[loginUrl release];
    [window release];
	[splashController release];
	[mainViewController release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [movieNaviController release];
    [moviePlayer release];
    [naviController release];
    [subIndexViewController release];
    [window release];
    [super dealloc];
}


@end
