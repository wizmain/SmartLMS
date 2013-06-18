    //
//  HomeViewController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SchoolHomeController.h"
#import "IntroduceController.h"
#import "SchoolMapController.h"
#import "mClassAppDelegate.h"
#import "MainViewController.h"
#import "HaksaInfoController.h"
#import "ScheduleController.h"

@implementation SchoolHomeController

@synthesize introButton, majorButton, infoButton, admissionButton, scheduleButton;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"학교소개";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" 
																			  style:UIBarButtonItemStyleBordered 
																			 target:self 
																			action:@selector(goHome)];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}


- (void)dealloc {
	[introButton release];
	[majorButton release];
	[infoButton release];
	[admissionButton release];
	[scheduleButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method

- (IBAction)introButtonClick:(id)sender {
	
	NSLog(@"introButtonClick");
	
	IntroduceController *intro = [[IntroduceController alloc] initWithNibName:@"IntroduceController" 
																	   bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:intro animated:YES];
	
	[intro release];
}


- (IBAction)majorButtonClick:(id)sender {
	
}


- (IBAction)infoButtonClick:(id)sender {
	HaksaInfoController *haksa = [[HaksaInfoController alloc] initWithNibName:@"HaksaInfoController" bundle:nil];
	[self.navigationController pushViewController:haksa animated:YES];
	[haksa release];
}


- (IBAction)admissionButtonClick:(id)sender {
	
}

- (IBAction)schoolmapClick:(id)sender {
	SchoolMapController *map = [[SchoolMapController alloc] initWithNibName:@"SchoolMapController" bundle:nil];
	[self.navigationController pushViewController:map animated:YES];
	[map release];
}

- (IBAction)scheduleButtonClick:(id)sender {
	ScheduleController *schedule = [[ScheduleController alloc] initWithNibName:@"ScheduleController" bundle:nil];
	[self.navigationController pushViewController:schedule animated:YES];
	[schedule release];
}
	

- (void)goHome {
	[[[mClassAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

@end
