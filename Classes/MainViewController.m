    //
//  MainViewController.m
//  mClass
//
//  Created by 김규완 on 11. 1. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "IndexViewController.h"
#import "MyLectureController.h"
#import "MoviePlayerController.h"
#import "ArticleController.h"
#import "CommunityHomeController.h"
#import "SettingsController.h"
#import "TimeTableController.h"
#import "MyInfoController.h"
#import "MyClassController.h"
#import "LectureHomeController.h"
#import "TimeTableView2.h"
#import "ApplyQuiz.h"
#import "SmartLMSAppDelegate.h"

@implementation MainViewController

@synthesize loginController, indexController, tabController, moviePlayer, naviController, movieNaviController;
@synthesize applyQuizController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    NSLog(@"MainViewController viewDidLoad");
	
	[super viewDidLoad];
    
    isMoviePlay = NO;
    
    //인덱스 컨트롤러 설정되어 있지 않으면 설정 및 추가 
	if (self.indexController.view.superview == nil) {
		if (self.indexController == nil) {
				IndexViewController *indexView = [[IndexViewController alloc] 
								  initWithNibName:@"IndexController"
								  bundle:nil];
				self.indexController = indexView;

			//CGRect newFrame = self.window.frame;
			//self.indexController.view.frame = [[[mClassAppDelegate sharedAppDelegate] window] frame];
            //CGRect rect = [[UIScreen mainScreen] bounds];
            //self.indexController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+40, rect.size.width, rect.size.height);
            //self.indexController.view.frame = CGRectMake(0, 0, 320, 460);
			[indexView release];
		}
	}
	
	[self.view addSubview:self.indexController.view];
	
	
    //탭 컨트롤러 등록
	if (self.tabController.view.superview == nil) {
		NSLog(@"tabController load");
		if (tabController == nil) {
			
            
			UITabBarController *tab = [[UITabBarController alloc] init];
			tab.customizableViewControllers = nil;
			/*
			NoticeController *notice = [[NoticeController alloc] initWithNibName:@"NoticeController" bundle:nil];
			notice.view.frame = CGRectMake(0, 0, 320, 460);
			UINavigationController *tab1Navi = [[UINavigationController alloc] initWithRootViewController:notice];
			tab1Navi.tabBarItem.image = [UIImage imageNamed:@"077-Government"];
			tab1Navi.tabBarItem.title = @"공지사항";
			tab1Navi.view.frame = CGRectMake(0, -20, 320, 460);
			[notice release];
			*/
			
			UINavigationController *tab2Navi = nil;
            
            //강사,학생인지 따라 다르게
            Boolean isStudent = [[SmartLMSAppDelegate sharedAppDelegate] isStudent];
            NSString *tab3Title = @"수업운영";
            
            if(isStudent){
                tab3Title = @"수업참여";
            } else {
            
            }
            
            //나의강의실
            MyClassController *myclass = [[MyClassController alloc] initWithNibName:@"MyClassController" bundle:nil];
            tab2Navi = [[UINavigationController alloc] initWithRootViewController:myclass];
            //tab2Navi.view.frame = CGRectMake(0, 20, 320, 460);
            [myclass release];

			tab2Navi.tabBarItem.image = [UIImage imageNamed:@"027-AddressBook"];
            tab2Navi.tabBarItem.title = @"나의강의실";
            
			//강좌수강
			LectureHomeController *mylecture = [[LectureHomeController alloc] initWithNibName:@"LectureHomeController" bundle:nil];
			UINavigationController *tab3Navi = [[UINavigationController alloc] initWithRootViewController:mylecture];
			tab3Navi.delegate = mylecture;
			tab3Navi.tabBarItem.image = [UIImage imageNamed:@"112-Monitor"];
			tab3Navi.tabBarItem.title = tab3Title;
			//tab3Navi.view.frame = CGRectMake(0, -20, 320, 460);
            
			[mylecture release];
			
			/*
			//TimeTableController *timeTable = [[TimeTableController alloc] initWithNibName:@"TimeTableController" bundle:nil];
            TimeTableView2 *timeTable = [[TimeTableView2 alloc] initWithNibName:@"TimeTableView2" bundle:nil];
            
			UINavigationController *tab4Navi = [[UINavigationController alloc] initWithRootViewController:timeTable];
			tab4Navi.tabBarItem.image = [UIImage imageNamed:@"020-Appointment"];
			tab4Navi.tabBarItem.title = @"시간표";
			//tab4Navi.view.frame = CGRectMake(0, -20, 320, 460);
            
            //timeTable.tabBarItem.image = [UIImage imageNamed:@"020-Appointment"];
            //timeTable.tabBarItem.title = @"강의시간표";
            //timeTable.view.frame = CGRectMake(0, -20, 320, 460);
			*/
            
            //커뮤니티
			CommunityHomeController *community = [[CommunityHomeController alloc] initWithNibName:@"CommunityHomeController" bundle:nil];
			UINavigationController *tab5Navi = [[UINavigationController alloc] initWithRootViewController:community];
			tab5Navi.tabBarItem.image = [UIImage imageNamed:@"039-IM"];
			tab5Navi.tabBarItem.title = @"커뮤니티";
            tab5Navi.delegate = self;
            
			//tab5Navi.view.frame = CGRectMake(0, -20, 320, 460);
			
            //설정
			SettingsController *setting = [[SettingsController alloc] initWithNibName:@"SettingsController" bundle:nil];
			UINavigationController *tab6Navi = [[UINavigationController alloc] initWithRootViewController:setting];
			tab6Navi.tabBarItem.image = [UIImage imageNamed:@"072-Settings"];
			tab6Navi.tabBarItem.title = @"환경설정";
			//tab6Navi.view.frame = CGRectMake(0, -20, 320, 460);
			
			tab.viewControllers = [NSArray arrayWithObjects:tab2Navi, tab3Navi, tab5Navi, tab6Navi, nil];
			//[tab1Navi release];
			[tab2Navi release];
			[tab3Navi release];
			//[tab4Navi release];
			[tab5Navi release];
			[tab6Navi release];
            //[timeTable release];
			self.tabController = tab;
            
            
            
            
			//CGRect newFrame =  [[[SmartLMSAppDelegate sharedAppDelegate] window] frame];
			//self.tabController.view.frame = newFrame;
            self.tabController.view.frame = CGRectMake(0, 0, 320, 460);
            
			self.tabController.delegate = self;
			[tab release];
		}
	}
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    NSLog(@"shouldAutorotateToInterface");
    //return YES;
    
    /*
    if(movieNaviController){
        NSLog(@"naviController YES");
        return [movieNaviController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
        
    }
    */
    
    
    /*
    if(isMoviePlay){
        //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
        //return (interfaceOrientation == UIInterfaceOrientationPortrait);
        return YES;
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
        //return YES;
    }
    */
    return NO;
}

/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willRotateToInterfaceOrientation");
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
	if (self.loginController.view.superview == nil) {
		self.loginController = nil;
	}
	if (self.indexController.view.superview == nil) {
		self.indexController = nil;
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.indexController viewWillAppear:animated];
    [self.tabController viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.loginController = nil;
    self.indexController = nil;
    self.tabController = nil;
    self.moviePlayer = nil;
    self.naviController = nil;
    self.movieNaviController = nil;
    self.applyQuizController = nil;
}


- (void)dealloc {
	[loginController release];
	[indexController release];
	[tabController release];
    [naviController release];
    [moviePlayer release];
    [movieNaviController release];
    [applyQuizController release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	//[viewController viewWillAppear:NO];
}


#pragma mark -
#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //[viewController viewWillAppear:animated];
}

#pragma mark -
#pragma mark Custom Method

//홈으로 변경
- (void)switchIndexView {
    
    isMoviePlay = NO;
	
	UIViewAnimationTransition trans = UIViewAnimationTransitionFlipFromRight;
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:1.00];
	[UIView setAnimationTransition: trans forView: [self view] cache: YES];
	
	if (self.indexController.view.superview == nil) {
		if (self.indexController == nil) {
			IndexViewController *indexView = [[IndexViewController alloc] 
											  initWithNibName:@"IndexController"
											  bundle:nil];
			self.indexController = indexView;
			//CGRect newFrame = [[[mClassAppDelegate sharedAppDelegate] window] frame];
			//self.indexController.view.frame = self.view.frame;
			[indexView release];
		}
		
		if (self.loginController.view.superview != nil) {
			[self.loginController.view removeFromSuperview];
		}
		if (self.tabController.view.superview != nil) {
			[self.tabController.view removeFromSuperview];
		}
		if (self.naviController.view.superview != nil) {
			[self.naviController.view removeFromSuperview];
		}
		
	}
	
	[self.view addSubview:self.indexController.view];
	
	[UIView commitAnimations];

}

//로그인 화면으로 변경
- (void)switchLoginView {

    isMoviePlay = NO;
    
	if (self.loginController.view.superview == nil) {
		if (self.loginController == nil) {
			LoginViewController *loginView = [[LoginViewController alloc] 
											  initWithNibName:@"LoginViewController"
											  bundle:nil];
			self.loginController = loginView;
			//CGRect newFrame =  [[[mClassAppDelegate sharedAppDelegate] window] frame];
			//self.loginController.view.frame = newFrame;
			[loginView release];
			
		}
	}
	
	
	
	[self.view addSubview:self.loginController.view];
	
}

- (void)switchTabView:(NSInteger)tabIndex {
	
	NSLog(@"switchTabView %d", tabIndex);
    
    isMoviePlay = NO;
	
    /*
	UIViewAnimationTransition trans = UIViewAnimationTransitionFlipFromRight;
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:1.00];
	[UIView setAnimationTransition: trans forView: [self view] cache: YES];
	*/
    
	if (self.loginController.view.superview != nil) {
		[self.loginController.view removeFromSuperview];
	}
	if (self.indexController.view.superview != nil) {
		[self.indexController.view removeFromSuperview];
	}
	if (self.naviController.view.superview != nil) {
		[self.naviController.view removeFromSuperview];
	}
	
    if(![[SmartLMSAppDelegate sharedAppDelegate] isStudent])
        [[[self.tabController viewControllers] objectAtIndex:1] setTitle:@"수업참여"];
	
	 
	[self.view addSubview:self.tabController.view];
	self.tabController.selectedIndex = tabIndex;
    [self.tabController viewWillAppear:NO];
	
	//[UIView commitAnimations];
	
}
//동영상화면으로 변경 
- (void)switchMoviePlayer:(NSInteger)lectureNo itemNo:(NSInteger)itemNo subjID:(NSString *)subjID weekSeq:(NSInteger)weekSeq orderSeq:(NSInteger)orderSeq {
	/*
	UIViewAnimationTransition trans = UIViewAnimationTransitionFlipFromRight;
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationTransition: trans forView: [self view] cache: YES];
	*/
    //[UIView commitAnimations];
    
    isMoviePlay = YES;
    
	moviePlayer = [[MoviePlayerController alloc] initWithNibName:@"MoviePlayerController" 
																			bundle:[NSBundle mainBundle]];
	moviePlayer.lectureNo = lectureNo;
	moviePlayer.itemNo = itemNo;
    moviePlayer.subjID = subjID;
    moviePlayer.weekSeq = weekSeq;
    moviePlayer.orderSeq = orderSeq;
    //moviePlayer.view.frame = CGRectMake(0, -20, 320, 480);
    moviePlayer.view.autoresizesSubviews = YES;
    moviePlayer.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
	
	/*
	if (self.loginController.view.superview != nil) {
		[self.loginController.view removeFromSuperview];
	}
	if (self.indexController.view.superview != nil) {
		[self.indexController.view removeFromSuperview];
	}
	if (self.tabController.view.superview != nil) {
		[self.tabController.view removeFromSuperview];
	}
    if (self.naviController.view.superview != nil) {
		[self.naviController.view removeFromSuperview];
	}
    */
    
    //movieNaviController = [[UINavigationController alloc] initWithRootViewController:moviePlayer];
    //[movieNaviController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
	//[self.view addSubview:movieNaviController.view];
    //[moviePlayer shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    [self presentModalViewController:moviePlayer animated:YES];
    //[self.view addSubview:moviePlayer.view];
	//[moviePlayer release];
    //[self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

//퀴즈 응시 화면으로 이동
- (void)switchApplyQuizView:(NSInteger)lectureNo itemNo:(NSInteger)itemNo etestNo:(NSInteger)etestNo {

        
    NSLog(@"switchApplyQuiz %d", etestNo);
    
        
    /*
     UIViewAnimationTransition trans = UIViewAnimationTransitionFlipFromRight;
     [UIView beginAnimations: nil context: nil];
     [UIView setAnimationDuration:1.00];
     [UIView setAnimationTransition: trans forView: [self view] cache: YES];
     */
    
    ApplyQuiz *apply = [[ApplyQuiz alloc] initWithNibName:@"ApplyQuiz" bundle:nil];
	
	apply.lectureNo = lectureNo;
	apply.itemNo = itemNo;
	apply.etestNo = etestNo;
    
    UINavigationController *applyNavi = [[UINavigationController alloc] initWithRootViewController:apply];
    applyNavi.toolbarHidden = NO;
    applyNavi.view.frame = CGRectMake(0, 0, 320, 460);
    self.applyQuizController = applyNavi;
    
    //[self presentModalViewController:applyNavi animated:YES];
    [self.view addSubview:self.applyQuizController.view];
    
    
    //[UIView commitAnimations];
        
    
}

@end
