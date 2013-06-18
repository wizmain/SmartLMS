//
//  LectureTermController.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LectureTermController.h"
#import "Utils.h"
#import "SettingProperties.h"

@implementation LectureTermController

@synthesize table, termList, setting, checkedImage, uncheckedImage;

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
	
	self.navigationItem.title = @"현재학기설정";
    
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	
    /*
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
											  target:self 
											  action:@selector(reloadProperties:)];
	*/
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setBackgroundImage:[UIImage imageNamed:@"nav_reload"] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(reloadProperties:) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.frame = CGRectMake(0, 0, 35, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:reloadButton] autorelease];
    
    
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[dateFormatter setLocale:locale];
	[locale release];
	
	[dateFormatter setDateFormat:@"yyyy"];
	NSString *year = [dateFormatter stringFromDate:today];
	int lastYear = [year intValue] - 1;
	[dateFormatter setDateFormat:@"MM"];
	int month = [[dateFormatter stringFromDate:today] intValue];
	//[dateFormatter setDateFormat:@"dd"];
	//int day = [[dateFormatter stringFromDate:today] intValue];
	
	[dateFormatter release];
	
	NSMutableDictionary *term = [[NSMutableDictionary alloc] init];
	[term setObject:[NSString stringWithFormat:@"%d", lastYear] forKey:@"year"];
	[term setObject:@"20" forKey:@"term"];
	[term setObject:[NSString stringWithFormat:@"%d년 2학기",lastYear] forKey:@"title"];
	
	NSMutableDictionary *term0 = [[NSMutableDictionary alloc] init];
	[term0 setObject:[NSString stringWithFormat:@"%d", lastYear] forKey:@"year"];
	[term0 setObject:@"21" forKey:@"term"];
	[term0 setObject:[NSString stringWithFormat:@"%d년 겨울계절학기",lastYear] forKey:@"title"];
	
	NSMutableDictionary *term1 = [[NSMutableDictionary alloc] init];
	[term1 setObject:year forKey:@"year"];
	[term1 setObject:@"10" forKey:@"term"];
	[term1 setObject:[NSString stringWithFormat:@"%@년 1학기",year] forKey:@"title"];
	
	NSMutableDictionary *term2 = [[NSMutableDictionary alloc] init];
	[term2 setObject:year forKey:@"year"];
	[term2 setObject:@"11" forKey:@"term"];
	[term2 setObject:[NSString stringWithFormat:@"%@년 여름계절학기",year] forKey:@"title"];
	
	NSMutableDictionary *term3 = [[NSMutableDictionary alloc] init];
	[term3 setObject:year forKey:@"year"];
	[term3 setObject:@"20" forKey:@"term"];
	[term3 setObject:[NSString stringWithFormat:@"%@년 2학기",year] forKey:@"title"];
	
	NSMutableDictionary *term4 = [[NSMutableDictionary alloc] init];
	[term4 setObject:year forKey:@"year"];
	[term4 setObject:@"21" forKey:@"term"];
	[term4 setObject:[NSString stringWithFormat:@"%@년 겨울계절학기",year] forKey:@"title"];
	
	termList = [[NSMutableArray alloc] initWithObjects:term, term0, term1, term2, term3, term4, nil];
	
	self.setting = [Utils settingProperties];
    if(self.setting == nil){
        SettingProperties *set = [[SettingProperties alloc] init];
        [set setTermYear:year];
        if (month < 8) {
            [set setTermCode:@"20"];
        } else {
            [set setTermCode:@"10"];
        }
        
        [Utils saveSettingProperties:set];
        
        [self reloadProperties:nil];
    }
	
	NSLog(@"viewDid");
	/*
	[term release];
	[term0 release];
	[term1 release];
	[term2 release];
	[term3 release];
	[term4 release];
	*/
    
    uncheckedImage = [UIImage imageNamed:@"unchecked"];
    checkedImage = [UIImage imageNamed:@"check"];

}



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
	self.table =nil;
	self.termList = nil;
	self.setting = nil;
}


- (void)dealloc {
	[table release];
	[termList release];
	[setting release];
    [checkedImage release];
    [uncheckedImage release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveProperties:(id)sender {
	SettingProperties *set = [[SettingProperties alloc] init];
	[set setTermYear:[self.setting termYear]];
	[set setTermCode:[self.setting termCode]];
	[Utils saveSettingProperties:set];
}

- (void)reloadProperties:(id)sender {
	self.setting = [Utils settingProperties];
	[self.table reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.termList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"현재학기설정";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	
	//UIImageView *icon = [[UIImageView alloc] initWithImage:img];
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
        [cell.imageView setImage:uncheckedImage];
		cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.termList != nil) {
		
		if(self.termList.count > 0){
			
			NSDictionary *term = [self.termList objectAtIndex:row];
			cell.textLabel.text = [term objectForKey:@"title"];
            cell.textLabel.textColor = [UIColor blackColor];
			
			if (self.setting != nil) {
				
				if ([[term objectForKey:@"year"] isEqualToString:[self.setting termYear]] && 
					[[term objectForKey:@"term"] isEqualToString:[self.setting termCode]]) {
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    [cell.imageView setImage:checkedImage];
				} else {
					cell.accessoryType = UITableViewCellAccessoryNone;
                    [cell.imageView setImage:uncheckedImage];
				}
			}
		}
	}
	
	
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];

	NSDictionary *termInfo = [self.termList objectAtIndex:row];

	[self.setting setTermYear:[termInfo objectForKey:@"year"]];
	[self.setting setTermCode:[termInfo objectForKey:@"term"]];
	
	[self saveProperties:nil];
	
	[self.table reloadData];
}

@end
