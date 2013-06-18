//
//  TimeTableView2.m
//  SmartLMS
//
//  Created by 김규완 on 11. 7. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeTableView2.h"
#import "TimeTableCell.h"
#import "TimeTable.h"
#import "Constants.h"
#import "SmartLMSAppDelegate.h"
#import "TimeTableDBManager.h"

@implementation TimeTableView2

@synthesize table, tableCell, dayOfWeek, timeTableData, weekdaySegment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [timeTableData release];
    [weekdaySegment release];
    [editView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"강의시간표";
    table.separatorColor = [UIColor grayColor];
    table.backgroundColor = [UIColor clearColor];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:today];
    self.dayOfWeek = [weekdayComponents weekday];
    NSLog(@"dayOfWeek = %d",dayOfWeek);
    
    weekdaySegment.selectedSegmentIndex = dayOfWeek - dayOfWeekSegmentAdjust;
    //weekdaySegment.segmentedControlStyle = UI
    [weekdaySegment addTarget:self action:@selector(changeWeekday:) forControlEvents:UIControlEventValueChanged];
    
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationController.delegate = self;
    [self bindTimeTable];
    
    NSLog(@"viewDidLoad");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    [self bindTimeTable];
}

#pragma mark -
#pragma makr Custom Method 

- (void)setTableEdit:(id)sender {
    [self.table setEditing:!self.table.editing animated:YES];
}

- (void)bindTimeTable {
    
    NSLog(@"bindTimeTable");
    /*
    NSError *error = nil;
    
    NSManagedObjectContext *context = [[SmartLMSAppDelegate sharedAppDelegate] managedObjectContext];
    
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeTable" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *predicateString = [NSString stringWithFormat:@"dayOfWeek = %d",dayOfWeek];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    timeTableData = [[context executeFetchRequest:fetchRequest error:&error] retain];
    for(NSManagedObject *info in timeTableData) {
        NSLog(@"rowId : %@ Name : %@ dayOfWeek : %@,  period : %@", [info valueForKey:@"rowId"], [info valueForKey:@"title"], [info valueForKey:@"dayOfWeek"], [info valueForKey:@"period"]);
        
    }
    [fetchRequest release];
    */
    
    timeTableData = [[TimeTableDBManager weekdayData:dayOfWeek] retain];
    
    [table reloadData];
    
}

- (void)changeWeekday:(id)sender {
    dayOfWeek = weekdaySegment.selectedSegmentIndex + dayOfWeekSegmentAdjust;
    [self bindTimeTable];
}


#pragma mark -
#pragma mark Application's Documents directory

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"시간표";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    TimeTableCell *cell = (TimeTableCell *)[tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
        /*
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimeTableCell" owner:self options:nil];
        for(id currentObject in nib){
            if([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (TimeTableCell *)currentObject;
                break;
            }
        }
        */
        cell = [TimeTableCell createCellFromNib];
        
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.backgroundColor = [UIColor clearColor];
	}
    
	
	NSUInteger row = [indexPath row];
    
    cell.periodLabel.text = [NSString stringWithFormat:@"%d", row + 1];
    cell.subjectLabel.text = @"";
    cell.infoLabel.text = @"";
    
    if(self.timeTableData != nil){
        for(NSManagedObject *t in self.timeTableData){
            if((row+1) == [[NSString stringWithFormat:@"%@", [t valueForKey:@"period"]] intValue]){
                cell.subjectLabel.text = [t valueForKey:@"title"];
                cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@", [t valueForKey:@"classRoom"], [t valueForKey:@"professor"]];
                //UIColor *backColor = [UIColor clearColor];
                int color = [[NSString stringWithFormat:@"%@", [t valueForKey:@"color"]] intValue];
                if(color == 1) {
                    //backColor = UIColorFromRGBWithAlpha(0xfa9da8, 0.4);
                    cell.contentView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor1, 0.4);
                    cell.accessoryView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor1, 0.4);
                    cell.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor1, 0.4);
                } else if(color == 2) {
                    //backColor = UIColorFromRGBWithAlpha(0xd2fc95, 0.4);
                    cell.contentView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor2, 0.4);
                    cell.accessoryView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor2, 0.4);
                    cell.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor2, 0.4);
                } else if(color == 3) {
                    //backColor = UIColorFromRGBWithAlpha(0x9efadb, 0.4);
                    cell.contentView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor3, 0.4);
                    cell.accessoryView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor3, 0.4);
                    cell.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor3, 0.4);
                } else if(color == 4) {
                    //backColor = UIColorFromRGBWithAlpha(0xf09dfa, 0.4);
                    cell.contentView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor4, 0.4);
                    cell.accessoryView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor4, 0.4);
                    cell.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor4, 0.4);
                } else if(color == 5){
                    //backColor = UIColorFromRGBWithAlpha(0xf7d29c, 0.4);
                    cell.contentView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor5, 0.4);
                    cell.accessoryView.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor5, 0.4);
                    cell.backgroundColor = UIColorFromRGBWithAlpha(kTimeTableColor5, 0.4);
                }
                
                /*
                for (UIView *view in cell.contentView.subviews){
                    view.backgroundColor = backColor;
                }
                */
                
            }
        }
    }
    
	/*
	if (self.articleList != nil) {
		
		if(articleList.count > 0){
			NSDictionary *article = [self.articleList objectAtIndex:row];
			NSLog(@"createTime = %@", [article objectForKey:@"createTime"]);
			long long time = [[NSString stringWithFormat:@"%@",[article objectForKey:@"createTime"]] longLongValue];
			time = time / 1000;
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd"];
			NSLog(@"date = %@",[dateFormat stringFromDate:date]);
			//NSString *label = [[article objectForKey:@"title"] stringByAppendingFormat:@" (%@)",[dateFormat stringFromDate:date]];
			cell.textLabel.text = [article objectForKey:@"title"];
			cell.detailTextLabel.text = [dateFormat stringFromDate:date];
		}
	}
	*/
    //cell.textLabel.text = @"공업수학";
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    NSLog(@"row = %d", row);
    
    editView = [[TimeTableEditView alloc] initWithNibName:@"TimeTableEditView" bundle:nil];
    editView.dayOfWeek = weekdaySegment.selectedSegmentIndex + dayOfWeekSegmentAdjust;
    editView.period = row + 1;
    
    [self.navigationController pushViewController:editView animated:YES];
    //[edit release];
    
    /*
	NSDictionary *article = [self.articleList objectAtIndex:row];
	NSInteger contentsID = [[NSString stringWithFormat:@"%@",[article objectForKey:@"contentsID"]] intValue];
	NSLog(@"contentsID = %d", contentsID);
	ArticleReadController *articleReadController = [[ArticleReadController alloc] initWithNibName:@"ArticleReadController" bundle:[NSBundle mainBundle]];
	articleReadController.siteID = self.siteID;
	articleReadController.menuID = self.menuID;
	articleReadController.contentsID = contentsID;
	[self.navigationController pushViewController:articleReadController animated:YES];
	[articleReadController release];
	articleReadController = nil;
	*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row];
    
    if(self.timeTableData != nil){
        for(NSManagedObject *t in self.timeTableData){
            if( (row+1) == [[NSString stringWithFormat:@"%@", [t valueForKey:@"period"]] intValue]){

                [TimeTableDBManager deleteTimeTable:(TimeTable *)t];
                
            }
        }
    }
    
    [self bindTimeTable];
    
}

#pragma -
#pragma UINavigationController delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self bindTimeTable];
}



@end
