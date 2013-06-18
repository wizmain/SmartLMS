//
//  SubIndexViewController.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 9. 16..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "SubIndexViewController.h"
#import "SubIndexWebController.h"
#import "SmartLMSAppDelegate.h"

@implementation SubIndexViewController

@synthesize menu01Button, menu02Button, menu03Button, menu04Button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    menu01Button = nil;
    menu02Button = nil;
    menu03Button = nil;
    menu04Button = nil;
}

- (void)dealloc
{
    [menu01Button release];
    [menu02Button release];
    [menu03Button release];
    [menu04Button release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom Method
- (IBAction)menu01ButtonClick:(id)sender {
    SubIndexWebController *subWebView = [[SubIndexWebController alloc] initWithNibName:@"SubIndexWebController" bundle:nil];
    
    subWebView.urlString = @"http://www.daelim.ac.kr/DaelimH/Index.jsp";
    UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:subWebView];
    [self presentModalViewController:naviCon animated:YES];
    //[naviController pushViewController:subWebView animated:YES];
    
    [subWebView release];
    [naviCon release];
}

- (IBAction)menu02ButtonClick:(id)sender {
    SubIndexWebController *subWebView = [[SubIndexWebController alloc] initWithNibName:@"SubIndexWebController" bundle:nil];
    
    subWebView.urlString = @"http://newipsi.daelim.ac.kr/web/entrance/home";
    UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:subWebView];
    [self presentModalViewController:naviCon animated:YES];
    //[naviController pushViewController:subWebView animated:YES];
    
    [subWebView release];
    [naviCon release];
}

- (IBAction)menu03ButtonClick:(id)sender {
    
}

- (IBAction)menu04ButtonClick:(id)sender {
    [[SmartLMSAppDelegate sharedAppDelegate] switchMainView];
}

@end
