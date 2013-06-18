//
//  MyClassControllerj.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyClassController.h"
#import "MyInfoController.h"
#import "LectureSurveyController.h"
#import "SmartLMSAppDelegate.h"
#import "MainViewController.h"

@implementation MyClassController

@synthesize table;

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
    [super viewDidLoad];
    
    backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_middle"]];
    self.view.backgroundColor = backImg;
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *naviBg = [UIImage imageNamed:@"navigation_back"];
        [self.navigationController.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    }
    
    table.backgroundColor = [UIColor clearColor];
    
	self.navigationItem.title = @"나의강의실";
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"nav_home"] forState:UIControlStateNormal];
    [indexButton addTarget:self action:@selector(goIndex) forControlEvents:UIControlEventTouchUpInside];
    indexButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indexButton] autorelease];
    
    
	[self.table reloadData];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willAnimateRotateToInterfaceOrientation");
    self.view.backgroundColor = backImg;
}
                           
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willRotateToInterfaceOrientation");
    self.view.backgroundColor = backImg;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
    backImg = nil;
}


- (void)dealloc {
	[table release];
    [backImg release];
    [super dealloc];
}

#pragma mark - Custom Method

- (void)goIndex {
    
    [[[SmartLMSAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"Cell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		cell.textLabel.text = @"나의정보";
	} else if (row == 1) {
		cell.textLabel.text = @"강의만족도조사";
	} else if (row == 2) {
        
    }
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		MyInfoController *myinfo = [[MyInfoController alloc] initWithNibName:@"MyInfoController" bundle:nil];
		[self.navigationController pushViewController:myinfo animated:YES];
		[myinfo release];
	} else if (row == 1) {
        
		LectureSurveyController *survey = [[LectureSurveyController alloc] initWithNibName:@"LectureSurveyController" bundle:nil];
        
        [self.navigationController pushViewController:survey animated:YES];
        [survey release];
	} else if ( row == 2) {
        
    }
	/*
	 NSDictionary *lecture = [self.lectureList objectAtIndex:row];
	 NSInteger lectureNo = [[NSString stringWithFormat:@"%@",[lecture objectForKey:@"lectureNo"]] intValue];
	 NSString *lectureTitle = [lecture objectForKey:@"lectureKorNm"];
	 
	 LectureItemController *lectureItemController = [[LectureItemController alloc] initWithNibName:@"LectureItemController" bundle:[NSBundle mainBundle]];
	 lectureItemController.lectureNo = lectureNo;
	 lectureItemController.lectureTitle = lectureTitle;
	 [self.navigationController pushViewController:lectureItemController animated:YES];
	 [lectureItemController release];
	 lectureItemController = nil;
	 */
}


@end
