//
//  HaksaInfoController.m
//  mClass
//
//  Created by 김규완 on 11. 2. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HaksaInfoController.h"
#import "mClassAppDelegate.h"
#import "MainViewController.h"

@implementation HaksaInfoController

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
	
	self.navigationItem.title = @"학사안내";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" 
																			  style:UIBarButtonItemStyleBordered
																			 target:self 
																			 action:@selector(goHome)];
	
	[self.table reloadData];
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
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (void)goHome {
	[[[mClassAppDelegate sharedAppDelegate] mainViewController] switchIndexView];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"학사안내";
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
		cell.textLabel.text = @"학사일정";
	} else if (row == 1) {
		cell.textLabel.text = @"수강신청";
	} else if (row == 2) {
		cell.textLabel.text = @"휴/복학/편입";
	} else if (row == 3) {
		cell.textLabel.text = @"증명발급";
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		//NoticeController *notice = [[NoticeController alloc] initWithNibName:@"NoticeController" bundle:nil];
		//[self.navigationController pushViewController:notice animated:YES];
		//[notice release];
	} else if (row == 1) {
		//MessageController *message = [[MessageController alloc] initWithNibName:@"MessageController" bundle:nil];
		//[self.navigationController pushViewController:message animated:YES];
		//[message release];
	}
	
}




@end
