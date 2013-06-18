//
//  SplashController.m
//  mClass
//
//  Created by 김규완 on 11. 1. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplashController.h"


@implementation SplashController

@synthesize splashImage, splashView;

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
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
}


- (void)dealloc {
	[splashView release];
	[splashImage release];
    [super dealloc];
}


#pragma mark -
#pragma mark Custom Method
- (void)showSplash {
	UIViewController *modal = [[UIViewController alloc] init];
	modal.view = splashView;
	[self presentModalViewController:modal animated:NO];
	[self performSelector:@selector(hideSplash) withObject:nil afterDelay:0.5];
}

- (void)hideSplash {
	[[self modalViewController] dismissModalViewControllerAnimated:YES];
}



@end
