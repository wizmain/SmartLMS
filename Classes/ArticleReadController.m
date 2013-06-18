//
//  ArticleReadController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 27..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ArticleReadController.h"
#import "HTTPRequest.h"
#import "JSON.h"
#import "Constants.h"
#import "AlertUtils.h"
#import "ArticleEditController.h"
#import "SmartLMSAppDelegate.h"

@implementation ArticleReadController

@synthesize siteID;
@synthesize menuID;
@synthesize contentsID;
@synthesize titleLabel;
@synthesize contents, boardTitle;

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
	
	self.navigationItem.title = boardTitle;
	
	
    self.navigationItem.hidesBackButton = YES;
    
    isStudent = [[SmartLMSAppDelegate sharedAppDelegate] isStudent];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                                                                           target:self 
                                                                                           action:@selector(writeArticleClick:)];
    */
    if(isStudent){
        
    } else {
        UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [composeButton setBackgroundImage:[UIImage imageNamed:@"nav_edit"] forState:UIControlStateNormal];
        [composeButton addTarget:self action:@selector(writeArticleClick:) forControlEvents:UIControlEventTouchUpInside];
        composeButton.frame = CGRectMake(0, 0, 50, 30);
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:composeButton] autorelease];
    }
    
	[self requestArticle];
	//contentsText.font = [UIFont systemFontOfSize:16];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[self requestArticle];
	[super viewWillAppear:animated];
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
	self.siteID = nil;
	self.menuID = nil;
	self.titleLabel = nil;
	self.contents = nil;

}


- (void)dealloc {
	[siteID release];
	[menuID release];
	[titleLabel release];
	[contents release];
	[toolbar release];
	[actionButton release];
    [boardTitle release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom method

- (void)goBack {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)requestArticle {
	NSString *url = [kServerUrl stringByAppendingString:kArticleReadUrl];
	NSString *query = [NSString stringWithFormat:@"/%d", self.contentsID];
	url = [url stringByAppendingString:query];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didArticleReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
}

- (void)writeArticleClick:(id)sender {
	ArticleEditController *articleEdit = [[ArticleEditController alloc] initWithNibName:@"ArticleEditController" bundle:[NSBundle mainBundle]];
	articleEdit.siteID = siteID;
	articleEdit.menuID = menuID;
	articleEdit.contentsID = contentsID;
    articleEdit.boardTitle = boardTitle;
	[self.navigationController pushViewController:articleEdit animated:YES];
	[articleEdit release];
}


#pragma mark -
#pragma mark HTTPRequest delegate

- (void)didArticleReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSDictionary *article = (NSDictionary *)[jsonData objectForKey:@"data"];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"성공");
		if(article){
			titleLabel.text = [article objectForKey:@"title"];
			//contentsText.text = [article objectForKey:@"descText"];
            
            
            [contents loadHTMLString:[article objectForKey:@"descHtml"] baseURL:nil];
            
            
		}
	}
	
}

@end
