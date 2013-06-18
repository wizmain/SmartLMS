//
//  TimeTableController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeTableController.h"
#import "GridEvent.h"

@interface TimeTableController(PrivateMethods)
@property (readonly) GridEvent *event;
@end


@implementation TimeTableController

@synthesize timeTableView;

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
	NSLog(@"timetable viewdidload");
    [super viewDidLoad];
	
	CGRect frame = self.view.frame;
	timeTableView = [[TimeTableView alloc] initWithFrame:frame];
	timeTableView.delegate = self;
	timeTableView.dataSource = self;
	[self.view addSubview:timeTableView];
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
	[timeTableView release];
    [super dealloc];
}


#pragma mark -
#pragma mark Custom Method

#pragma mark -
#pragma mark TimeTableView Delegate


#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

- (NSArray *)timeTableView:(TimeTableView *)timeTableView eventsForWeekday:(NSInteger)weekday {
	NSArray *arr;
	if (weekday == 1) {
		arr = [NSArray arrayWithObjects:self.event, self.event, nil];
		((GridEvent *)[arr objectAtIndex:0]).title = @"공업수학";
		((GridEvent *)[arr objectAtIndex:0]).period = 2;
		((GridEvent *)[arr objectAtIndex:0]).backgroundColor = [UIColor brownColor];
		((GridEvent *)[arr objectAtIndex:1]).title = @"일반물리학";
		((GridEvent *)[arr objectAtIndex:1]).backgroundColor = [UIColor yellowColor];
		((GridEvent *)[arr objectAtIndex:1]).period = 5;
	} else if (weekday == 2) {
		arr = [NSArray arrayWithObjects:self.event, self.event, nil];
		((GridEvent *)[arr objectAtIndex:0]).title = @"공업수학";
		((GridEvent *)[arr objectAtIndex:0]).backgroundColor = [UIColor brownColor];
		((GridEvent *)[arr objectAtIndex:0]).period = 3;
		((GridEvent *)[arr objectAtIndex:1]).title = @"일반물리학";
		((GridEvent *)[arr objectAtIndex:1]).backgroundColor = [UIColor yellowColor];
		((GridEvent *)[arr objectAtIndex:1]).period = 7;
	} else {
		arr = nil;
	}
	
	return arr;

}

- (void)timeTableView:(TimeTableView *)timeTableView eventTapped:(GridEvent *)event {
	//NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
	//NSString *eventInfo = [NSString stringWithFormat:@"Hour %i. Userinfo: %@", [components hour], [event.userInfo objectForKey:@"test"]];
	/*
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:event.title
													 message:eventInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
    */
}


- (GridEvent *)event {
	static int counter;
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	
	[dict setObject:[NSString stringWithFormat:@"number %i", counter++] forKey:@"test"];
	
	GridEvent *event = [[GridEvent alloc] init];
	event.backgroundColor = [UIColor purpleColor];
	event.textColor = [UIColor whiteColor];
	event.allDay = NO;
	event.userInfo = dict;
	return [event autorelease];
}

@end
