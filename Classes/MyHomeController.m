//
//  MyHomeController.m
//  mClass
//
//  Created by 김규완 on 11. 2. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyHomeController.h"
#import "MyLectureController.h"
#import "MyInfoController.h"

@implementation MyHomeController

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
	
	self.navigationItem.title = @"내강의실";
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
	[table release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"강의실";
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
		cell.textLabel.text = @"수강신청조회";
	} else if (row == 1) {
		cell.textLabel.text = @"성적조회";
	} else if (row == 2) {
		cell.textLabel.text = @"내강의실";
	} else if (row == 3) {
		cell.textLabel.text = @"내정보";
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];

	if (row == 0) {
		
	} else if (row == 1) {
		
	} else if (row == 2) {
		MyLectureController *mylecture = [[MyLectureController alloc] initWithNibName:@"MyLectureController" bundle:nil];
		[self.navigationController pushViewController:mylecture animated:YES];
		[mylecture release];
	} else if (row == 3) {
		MyInfoController *myinfo = [[MyInfoController alloc] initWithNibName:@"MyInfoController" bundle:nil];
		[self.navigationController pushViewController:myinfo animated:YES];
		[myinfo release];
	}
	 
}



@end
