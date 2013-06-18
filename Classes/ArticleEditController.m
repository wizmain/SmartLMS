//
//  ArticleEditController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 28..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ArticleEditController.h"
#import "HTTPRequest.h"
#import "JSON.h"
#import "Constants.h"
#import "AlertUtils.h"
#import "SmartLMSAppDelegate.h"

#define kUITextViewCellRowHeight	323.0
#define kUITabBarHeight				50

@implementation ArticleEditController

@synthesize table, selectedSection;
@synthesize siteID, menuID, contentsID, article;
@synthesize contentTextView, titleTextField, resignTextFieldButton;
@synthesize isShowingKeyboard, boardTitle;

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
	
	if (self.contentsID > 0) {
		self.navigationItem.title = boardTitle;//@"글수정";
		[self requestArticle];
	} else {
		self.navigationItem.title = boardTitle;//@"글작성";
	}

    /*
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																						   target:self 
																						   action:@selector(saveArticleClick:)];
    */
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"nav_save"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveArticleClick:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:saveButton] autorelease];
    
    /*
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																			 style:UIBarButtonSystemItemCancel 
																			target:self 
																			action:@selector(goBack:)];
	*/
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignTextField:) name:UITextViewTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:@"EditArticleShouldHideKeyboard" object:nil];
    
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
	self.table = nil;
	self.siteID = nil;
	self.menuID = nil;
	self.article = nil;
	self.contentTextView = nil;
	self.titleTextField = nil;
	self.resignTextFieldButton = nil;
}


- (void)dealloc {
	[table release];
	[siteID release];
	[menuID release];
	[article release];
	[contentTextView release];
	[titleTextField release];
	[resignTextFieldButton release];
	[selectedSection release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Methods
- (void)refreshTable {
	[self.table reloadData];
}

- (void)goBack:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EditArticleShouldHideKeyboard" object:nil];
	[self.navigationController popViewControllerAnimated:YES];
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

- (void)saveArticleClick:(id)sender {
	
	NSString *url = [kServerUrl stringByAppendingString:kArticleSaveUrl];
	NSString *action;
	
	if (self.contentsID > 0) {
		action = @"update";
	} else {
		action = @"insert";
	}
	
	//url = [url stringByAppendingString:query];
	
	//POST로 전송할 데이터 설정
	NSDictionary *bodyObject =  [NSDictionary dictionaryWithObjectsAndKeys:
								 siteID, @"siteID", 
								 menuID, @"menuID",
								 [NSString stringWithFormat:@"%d", contentsID], @"contentsID",
								 action,@"action",
								 titleTextField.text, @"title",
								 contentTextView.text, @"descText", nil];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didArticleSaveFinished:)];
	[httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST" withTag:nil];
}

- (IBAction)resignTextField:(id)sender {
	NSLog(@"resignTextField");
	[titleTextField resignFirstResponder];
	UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	for(UIView *subview in cell.contentView.subviews) {
		if([subview isKindOfClass:[UITextView class]]) {
			[subview becomeFirstResponder];
			break;
		}
	}
	[self.view sendSubviewToBack:resignTextFieldButton];
}

- (void)hideKeyboard:(NSNotification *)notification {
	UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	for(UIView *subview in cell.contentView.subviews) {
		if([subview isKindOfClass:[UITextView class]]) {
			contentTextView = [(UITextView *)subview retain];
			break;
		}
	}
	
	if(contentTextView != nil) {
		[contentTextView resignFirstResponder];
	}
	[titleTextField resignFirstResponder];
	
}

- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *keyboardInfo = (NSDictionary *)[notification userInfo];
	self.isShowingKeyboard = YES;
	
	CGRect keyboardEndFrame;
	CGFloat keyboardHeight;
	
	[[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrame];
	
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || 
		[[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
		keyboardHeight = keyboardEndFrame.size.height;
	} else {
		keyboardHeight = keyboardEndFrame.size.width;
	}
	
	CGFloat animationDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	UIViewAnimationCurve curve = [[keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationCurve:curve]; 
	[UIView setAnimationDuration:animationDuration]; 
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	CGRect frame = self.view.frame;
	frame.size.height -= keyboardHeight;
	frame.size.height += kUITabBarHeight;
	self.view.frame = frame;
	
	[UIView commitAnimations];
	
	[self.view bringSubviewToFront:resignTextFieldButton];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	NSDictionary *keyboardInfo = (NSDictionary *)[notification userInfo];
	self.isShowingKeyboard = NO;
	
	if((contentTextView != nil)) {
		CGRect keyboardEndFrame;
		CGFloat keyboardHeight;
		
		[[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrame];
		
		if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || 
			[[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
			keyboardHeight = keyboardEndFrame.size.height;
		} else {
			keyboardHeight = keyboardEndFrame.size.width;
		}
		
		CGFloat animationDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
		UIViewAnimationCurve curve = [[keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
		
		[UIView beginAnimations:nil context:nil]; 
		[UIView setAnimationCurve:curve]; 
		[UIView setAnimationDuration:animationDuration]; 
        [UIView setAnimationBeginsFromCurrentState:YES];
		
        CGRect frame = self.view.frame;
        frame.size.height += keyboardHeight;
		frame.size.height -= kUITabBarHeight;
        self.view.frame = frame;
		
		[UIView commitAnimations];
	}
	
}


#pragma mark -
#pragma mark HTTPRequest delegate

- (void)didArticleReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	self.article = [(NSDictionary *)[jsonData objectForKey:@"data"] retain];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"성공");
		if(article){
			//titleLabel.text = [article objectForKey:@"title"];
			//contentsText.text = [article objectForKey:@"descText"];
		}
		
		[self refreshTable];
	}
	
}

- (void)didArticleSaveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSDictionary *resultData = (NSDictionary *)[jsonData objectForKey:@"result"];
	NSString *resultStr = (NSString *)[resultData valueForKey:@"result"];
	
	if (resultStr) {
		
		if ([resultStr isEqualToString:@"fail"]) {
			NSLog(@"실패");
			AlertWithMessage([resultData objectForKey:@"message"]);
		} else {
			
			NSLog(@"성공");
			
			[self.navigationController popViewControllerAnimated:YES];
		}
	} else {
		NSLog(@"실패");
		AlertWithMessage([resultData objectForKey:@"message"]);
	}

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//2개의 섹션으로 이루어져 있다
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int result = 0;
	
	switch (section) {
		case 0://title섹션일때 테이블 row 수
			result = 1;
			break;
		case 1://내용 섹션일 때 테이블 row 수
			result = 1;
			break;
		default:
			break;
	}
	
	return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int result = 45;
	
	switch (indexPath.section) {
		case 0:
			result = 45;
			break;
		case 1:
			result = kUITextViewCellRowHeight;
			break;
		default:
			break;
	}
	
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//타이틀
	UITextFieldCell *textCell = (UITextFieldCell *) [tableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
	if (textCell == nil) {
        textCell = [UITextFieldCell createNewTextCellFromNib];
    }
	
	//내용
	UITextViewCell *contentCell = (UITextViewCell *) [tableView dequeueReusableCellWithIdentifier:kCellTextView_ID];
	if (contentCell == nil) {
        contentCell = [UITextViewCell createNewTextCellFromNib];
    }
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					textCell.titleLabel.text = @"제목";
					textCell.textField.placeholder = @"Page Title";
					textCell.textField.tag = 1;
					textCell.textField.delegate = self;
					//textCell.textField.returnKeyType = UIReturnKeyDone;
					
					if(article)
						textCell.textField.text = [article objectForKey:@"title"];
					
					titleTextField = [textCell.textField retain];
					
					cell = textCell;
					break;
				/*
				case 1:
					cell.textLabel.font = [UIFont systemFontOfSize:16.0];
					cell.textLabel.textColor = [UIColor grayColor];
					cell.textLabel.text = @"Status";
					
					cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
					if(self.page.status != nil)
						cell.detailTextLabel.text = [statuses objectForKey:self.page.status];
					cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
					break;
				*/
				default:
					break;
			}
			
			break;
		
		case 1:
        {
			UIColor *backgroundColor = [UIColor whiteColor];
			
			// Uncomment the following line for debugging UITextView position
			// backgroundColor = [UIColor blueColor];
			
			contentCell.textView.backgroundColor = backgroundColor;
			contentCell.textView.tag = 2;
			contentCell.textView.delegate = self;
			//contentCell.textView.returnKeyType = UIReturnKeyDone;
			
			if(article)
				contentCell.textView.text = [article objectForKey:@"descText"];
			cell = contentCell;
			contentTextView = [contentCell.textView retain];
			break;
        }
		
		default:
			break;
	}
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedSection = [NSNumber numberWithInt:indexPath.section];
	
	switch ([selectedSection intValue]) {
		case 0:
			switch (indexPath.row) {
				case 0:
					// Nothing
					break;
				//case 1:
				//	[self showStatusPicker:self];
				default:
					break;
			}
			[contentTextView resignFirstResponder];
			break;
		case 1:
			[titleTextField resignFirstResponder];
			[contentTextView becomeFirstResponder];
			break;
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -
#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//[textField resignFirstResponder];
	return YES;	
	[self refreshTable];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	selectedSection = [NSNumber numberWithInt:0];
	NSLog(@"textFieldDidBeginEditing");
	[self.view bringSubviewToFront:resignTextFieldButton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	selectedSection = nil;
	[textField resignFirstResponder];
    if ([textField.text isEqualToString:@"#%#"]) {
        [NSException raise:@"Test exception" format:@"Nothing bad, actually"];
    }
	
	[self refreshTable];
}

#pragma mark -
#pragma mark UITextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
	NSLog(@"textViewDidBeginEditing");
	selectedSection = [NSNumber numberWithInt:1];
	
    UITableViewCell *cell = (UITableViewCell*) [[textView superview] superview];
    [table scrollToRowAtIndexPath:[table indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	NSLog(@"scrollToRowAtIndexPath:%@", [table indexPathForCell:cell]);

}

- (void)textViewDidEndEditing:(UITextView *)textView {
	NSLog(@"textViewDidEndEditing");
	
	selectedSection = nil;
	
	UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	for(UIView *subview in cell.contentView.subviews) {
		if([subview isKindOfClass:[UITextView class]]) {
			contentTextView = [(UITextView *)subview retain];
			break;
		}
	}
	
	[self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	//if(textView.text != nil) {
	//	[self.page setContent:[NSString stringWithFormat:@"%@", textView.text]];
	//}
	
	[textView resignFirstResponder];
	//[self preserveUnsavedPage];
	//[self refreshPage];
	[self refreshTable];
}
/*
- (void)textViewDidChange:(UITextView *)textView {
	//[self refreshPage];
}
*/


@end
