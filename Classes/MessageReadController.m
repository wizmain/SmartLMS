//
//  MessageReadController.m
//  mClass
//
//  Created by 김규완 on 10. 12. 30..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//  메세지 대화

#import "MessageReadController.h"
#import "HTTPRequest.h"
#import "SmartLMSAppDelegate.h"
#import "JSON.h"
#import "Constants.h"
#import "AlertUtils.h"
#import "MessageTableDelegate.h"
#import "Utils.h"
#import "LoginProperties.h"

@implementation MessageReadController

@synthesize messageNo, messageTitle, messageList, receiveUserID, sendUserID, receiveUserName;
@synthesize table, toolbar, selectedArray, isEditMode, selectedImage, deselectedImage;
@synthesize addMessageField, sendButton, editButton, deleteAllButton;
@synthesize sendUserName;

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
    
    self.table.backgroundColor = [UIColor clearColor];
	
	self.isEditMode = NO;
	self.selectedImage = [UIImage imageNamed:@"check.png"];
	self.deselectedImage = [UIImage imageNamed:@"unchecked.png"];
	
    //창 타이틀 설정
    userID = [[SmartLMSAppDelegate sharedAppDelegate] authUserID];
    NSString *title = @"쪽지대화";
    
    //if([Utils isNullString:sendUserID]){
    //    sendUserID = userID;
    //}
    
    if( ![Utils isNullString:receiveUserID] && ![Utils isNullString:sendUserID]){
        NSLog(@"not null");
        if ([receiveUserID isEqualToString:userID]) {
            NSLog(@"receiveUserID");
            if (sendUserName != nil) {
                NSLog(@"receiveUserName not null");
                title = [NSString stringWithFormat:@"%@님과의 대화", sendUserName];
            }
        } else if([sendUserID isEqualToString:userID]){
            NSLog(@"sendUserID");
            if(receiveUserName != nil){
                NSLog(@"receiveUserName not nil");
                title = [NSString stringWithFormat:@"%@님과의 대화", receiveUserName];
            }
        }
        
        [self bindMessage];
        
    } else {
        AlertWithMessageAndDelegate(@"보낸사람과 받는사람이 설정 되지 않았습니다", self);
    }
    
    self.navigationItem.title = title;
    
    
    NSLog(@"sendUserID = %@ receiveUserID = %@", sendUserID, receiveUserID);
	
	editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
															   target:self 
															   action:@selector(editTable:)];
	deleteAllButton = [[UIBarButtonItem alloc] initWithTitle:@"지우기" 
													   style:UIBarButtonItemStyleBordered 
													  target:self 
													  action:@selector(deleteAllMessage:)];
	
	self.navigationItem.leftBarButtonItem = editButton;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											  target:self 
											  action:@selector(cancelMessage:)];
	
	
	//LoginProperties *prop = [Utils loginProperties];
	//self.sendUserID = [prop userID];
	
	
	//table.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
	//table.backgroundColor = RGB(121, 121, 121);
	
	
	addMessageField = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, 250, 32)];
	addMessageField.delegate = self;
    addMessageField.layer.cornerRadius = 10;
    addMessageField.clipsToBounds = YES;
    
	UIBarButtonItem *textField = [[UIBarButtonItem alloc] initWithCustomView:addMessageField];
	
	sendButton = [[UIBarButtonItem alloc] initWithTitle:@"전송" style:UIBarButtonItemStyleBordered 
												  target:self 
												  action:@selector(sendMessage:)];
	
	toolbar.items = [[NSArray alloc] initWithObjects:textField, sendButton, nil];
	
	
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
    self.toolbar = nil;
    self.sendUserID = nil;
    self.receiveUserID = nil;
    self.messageTitle = nil;
    self.messageList = nil;
    self.sendButton = nil;
    self.deleteAllButton =nil;
    self.editButton = nil;
    self.addMessageField = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMessageFieldDidChange:) 
	//											 name:@"textViewDidChange" object:addMessageField];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

- (void)dealloc {
	[table release];
	[toolbar release];
	[sendUserID release];
	[receiveUserID release];
	[messageTitle release];
	[messageList release];
	[sendButton release];
	[deleteAllButton release];
	[editButton release];
	//[messageTableDelegate release];
	[addMessageField release];
    [super dealloc];
}

#pragma mark -
#pragma mark textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"textFieldShouldReturn");
	/*
	[textField resignFirstResponder];
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
	toolbar.frame = CGRectMake(0, 372, 320, 44);
	table.frame = CGRectMake(0, 0, 320, 372);	
	[UIView commitAnimations];
	*/
	return YES;
}


-(void) keyboardWillHide:(NSNotification *)note{
    // get keyboard size and location
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
	
	// get the height since this is the main value that we need.
	NSInteger kbSizeH = keyboardBounds.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
	
	// get a rect for the textView frame
	//CGRect tableFrame = table.frame;
	//tableFrame.origin.y += kbSizeH;
	table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, table.frame.size.height+kbSizeH);
	//table.frame = tableFrame;
	CGRect toolbarFrame = toolbar.frame;
	toolbarFrame.origin.y += kbSizeH;
	// set views with new info
	toolbar.frame = toolbarFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notif {
	
	// get keyboard size and loctaion
	CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
	
	// get the height since this is the main value that we need.
	NSInteger kbSizeH = keyboardBounds.size.height;
	
	NSLog(@"keyboardWillShow");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
	
	CGRect toolbarFrame = toolbar.frame;
	toolbarFrame.origin.y -= kbSizeH;
	toolbar.frame = toolbarFrame;
	
	//먼저 늘어난 사이즈만큼 위로 올리고 스크롤을 위해 다시 사이즈 조정
	CGRect changeFrame = table.frame;
	changeFrame.size.height -=kbSizeH;
	NSValue *chageFrameValue = [NSValue valueWithCGRect:changeFrame];
	
	CGRect tableFrame = table.frame;
	//float originY = tableFrame.origin.y;
	tableFrame.origin.y -= kbSizeH;
	table.frame = tableFrame;
	
	[UIView commitAnimations];
	
	//table.frame = CGRectMake(table.frame.origin.x, originY, table.frame.size.width, table.frame.size.height-kbSizeH);
	[self performSelector:@selector(adjustTableSize:) withObject:chageFrameValue afterDelay:0.3];
	
	//[self adjustTableScroll];
}

- (void)adjustTableSize:(NSValue *)frameValue {
	table.frame = [frameValue CGRectValue];
	[self adjustTableScroll];
}

- (void)adjustTableScroll {
	if([self.messageList count] > 0)
	{
		NSUInteger index = [self.messageList count] - 1;
		[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
}

#pragma mark -
#pragma mark HPGrowingTextView delegate
	
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
	
	
	float diff = (growingTextView.frame.size.height - height);
	
	NSLog(@"growingTextView height=%f diff=%f", height, diff);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
	
	CGRect toolbarFrame = toolbar.frame;
	toolbarFrame.origin.y += diff;
	toolbarFrame.size.height -= diff;
	toolbar.frame = toolbarFrame;
	
	//먼저 늘어난 사이즈만큼 위로 올리고 스크롤을 위해 다시 사이즈 조정
	CGRect changeFrame = table.frame;
	changeFrame.size.height +=diff;
	NSValue *chageFrameValue = [NSValue valueWithCGRect:changeFrame];
	
	CGRect tableFrame = table.frame;
	//float originY = tableFrame.origin.y;
	tableFrame.origin.y += diff;
	table.frame = tableFrame;
	
	//table.frame = CGRectMake(table.frame.origin.x, originY, table.frame.size.width, table.frame.size.height+diff);
	[self performSelector:@selector(adjustTableSize:) withObject:chageFrameValue afterDelay:0.3];
	
	//toolbar.frame = CGRectMake(0, 156, 320, 44);
	//table.frame = CGRectMake(0, 0, 320, 156);	
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Custom Method
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteMessage:(NSString *)msgType msgNo:(NSString *)msgNo {
    
    NSString *url = [kServerUrl stringByAppendingString:kMessageDeleteUrl];
	//NSString *query = [NSString stringWithFormat:@"/%d", self.messageNo];
	NSString *query = [NSString stringWithFormat:@"/%@/%@", msgType, msgNo];
	url = [url stringByAppendingString:query];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didMessageDelete2ReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:msgNo];
}

- (void)bindMessage {
	NSString *url = [kServerUrl stringByAppendingString:kMessageConversation];
	//NSString *query = [NSString stringWithFormat:@"/%d", self.messageNo];
	NSString *query = [NSString stringWithFormat:@"?sendUserID=%@&receiveUserID=%@", sendUserID, receiveUserID];
	url = [url stringByAppendingString:query];
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSLog(@"url = %@", url);
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didMessageReceiveFinished:)];
	[httpRequest requestUrl:url bodyObject:nil httpMethod:@"GET" withTag:nil];
    
}

- (void)refreshTable {
	
	[self.table reloadData];
	NSInteger index = [self.messageList count];
	NSLog(@"refreshTable index = %d", index);
	if(index > 0) {
		[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

- (void)sendMessage:(id)sender {
	if(![addMessageField.text isEqualToString:@""])
	{
		NSString *msgContent = addMessageField.text;
        NSString *receiver = nil;
        NSString *senderName = nil;
		
		NSString *url = [kServerUrl stringByAppendingString:kMessageSendUrl];
		//NSString *query = [NSString stringWithFormat:@"/%d", self.messageNo];
		//NSString *query = [NSString stringWithFormat:@"?sendUserID=%@&receiveUserID=%@", sendUserID, receiveUserID];
		//url = [url stringByAppendingString:query];
		
		HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
		NSLog(@"url = %@", url);
        
        if ([sendUserID isEqualToString:userID]) {
            receiver = receiveUserID;
            senderName = receiveUserName;
        } else {
            receiver = sendUserID;
            senderName = sendUserName;
        }
		
		//POST로 전송할 데이터 설정
		NSString *msgTitle = [NSString stringWithFormat:@"%@님이 보낸 쪽지",senderName];
		NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:receiver, @"receivers", msgTitle, @"title", msgContent, @"content", nil];
		
		//통신완료 후 호출할 델리게이트 셀렉터 설정
		[httpRequest setDelegate:self selector:@selector(didSendMessageFinished:)];
		[httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST" withTag:nil];
		
	}
}

- (void)editTable:(id)sender {
	[self toggleEditMode];
}
//쪽지 대화 취소
- (void)cancelMessage:(id)sender {
	if (isEditMode) {
		[self toggleEditMode];
	} else {
		[self dismissModalViewControllerAnimated:YES];
	}
}
											 

- (void)deleteAllMessage:(id)sender {
	
    //NSMutableString *deleteNos = [NSMutableString stringWithString:@""];
	//삭제 처리
    for (int i=0; i<self.selectedArray.count; i++) {
        
        NSDictionary *msg = [self.selectedArray objectAtIndex:i];
        if([[msg valueForKey:@"selected"] isEqualToString:@"T"]){
            NSLog(@"selected msgNo = %@", [msg valueForKey:@"msgNo"]);
            NSNumber *msgNo = [msg objectForKey:@"msgNo"];
            [self deleteMessage:[msg valueForKey:@"msgType"] msgNo:[msgNo stringValue]];
        }
        
        
        //NSNumber *delete = (NSNumber *)[self.selectedArray objectAtIndex:i];
        
        //if (i==0) {
        //    [deleteNos appendString:[delete stringValue]];
        //} else {
        //    [deleteNos appendFormat:@",%@", [delete stringValue]];
        //}
    }
    
}

//삭제모드시 선택된 데이타 배열
- (void)initSelectedArray {
    
    NSLog(@"initSelectedArray");
    
	if (self.messageList != nil) {
		NSLog(@"messageList Not null");
		NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.messageList.count];
		for (int i=0; i<self.messageList.count; i++) {
            NSDictionary *msgInfo = [self.messageList objectAtIndex:i];
            NSDictionary *deleteMsg = [NSDictionary dictionaryWithObjectsAndKeys:[msgInfo valueForKey:@"msgNo"], @"msgNo", @"F", @"selected", [msgInfo valueForKey:@"msgType"], @"msgType", nil];
			[array addObject:deleteMsg];
		}
		self.selectedArray = array;
        NSLog(@"selectedArray count = %d", self.selectedArray.count);
		[array release];
	}
}

- (void)toggleEditMode {
	self.isEditMode = !isEditMode;
	
	if (isEditMode) {
        [self initSelectedArray];
		self.navigationItem.leftBarButtonItem = self.deleteAllButton;
	} else {
        self.selectedArray = nil;
		self.navigationItem.leftBarButtonItem = self.editButton;
	}
    
    [table reloadData];

}

#pragma mark -
#pragma mark HTTPRequest delegate

- (void)didMessageReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSMutableArray *message = [(NSMutableArray *)[jsonData objectForKey:@"data"] retain];
	NSDictionary *resultStr = (NSDictionary *)[jsonData objectForKey:@"result"];
	
	if (resultStr) {
		NSLog(@"실패");
		AlertWithMessage([jsonData objectForKey:@"message"]);
	} else {
		
		NSLog(@"성공");
		
		if (message){
			self.messageList = message;
			//[messageTableDelegate setMessageList:message];
			
			[self refreshTable];
		}
		
	}
}

- (void)didSendMessageFinished:(NSString *)result {
	
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSDictionary *resultObj = (NSDictionary *)[jsonData objectForKey:@"data"];
    
	
	if (resultObj) {
		if ([[resultObj valueForKey:@"result"] isEqualToString:@"success"]) {
            NSString *receiver = nil;
            NSString *sender = nil;
            if ([sendUserID isEqualToString:userID]) {
                receiver = receiveUserID;
                sender = sendUserID;
            } else {
                receiver = sendUserID;
                sender = receiveUserID;
            }
            
			NSString *msgContent = addMessageField.text;
			NSDate *today = [[NSDate alloc] init];
            long long longValue = [today timeIntervalSince1970] * 1000;
            
			NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
			[message setObject:msgContent forKey:@"msgContent"];
			[message setObject:receiver forKey:@"receiveUserID"];
			[message setObject:sender forKey:@"sendUserID"];
			[message setObject:[NSString stringWithFormat:@"%lld", longValue]  forKey:@"sendDate"];
            [message setObject:[resultObj valueForKey:@"param1"] forKey:@"msgNo"];
            [message setObject:@"SEND" forKey:@"msgType"];
			
			NSLog(@"addMessageObject sendUserID:%@ receiveUserID:%@, timelongValue=%@", sendUserID, receiveUserID, [NSString stringWithFormat:@"%lld", longValue]);
			
			[messageList addObject:message];
			//[messageList addObject:field.text];
			//[messageTableDelegate setMessageList:messageList];
			//[selectedArray addObject:[NSNumber numberWithBool:NO]];
			[self refreshTable];
            [message release];
			
			addMessageField.text = @"";
		}
	}
	
}

-(void)didMessageDelete2ReceiveFinished:(NSString *)result {
    NSLog(@"receiveData : %@", result);
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    //NSDictionary받을때-------------------------------
    //NSString *tag = [result objectForKey:@"tag"];
    //NSLog(@"tag = %@", tag);
    
    //NSString *resultString = [result objectForKey:@"result"];
    
	// JSON형식 문자열로 Dictionary생성
	
	
	//NSDictionary *jsonData = [jsonParser objectWithString:resultString];
	//NSDictionary *resultObj = (NSDictionary *)[jsonData objectForKey:@"result"];
    
	
    //NSString받을때
    NSDictionary *jsonData = [jsonParser objectWithString:result];
    NSDictionary *resultData = [jsonData objectForKey:@"resultData"];
    NSDictionary *resultTemp = (NSDictionary *)[resultData objectForKey:@"result"];
    NSDictionary *resultObj = (NSDictionary *)[resultTemp objectForKey:@"result"];
    
    NSString *tag = [resultData valueForKey:@"tag"];
    
    
	if (resultObj) {
        if ([[resultObj valueForKey:@"result"] isEqualToString:@"success"]) {
            
            for(int i=0;i<self.messageList.count;i++){
                
                NSDictionary *msg = [self.messageList objectAtIndex:i];
                NSNumber *tmpTag = [msg valueForKey:@"msgNo"];
                
                if ([tag isEqualToString:[tmpTag stringValue]] ) {
                    
                    NSLog(@"tag = msgNo %@ = %@", tag, [msg valueForKey:@"msgNo"]);
                    [self.messageList removeObjectAtIndex:i];
                    
                    for (int k=0; k<self.selectedArray.count; k++) {
                        NSNumber *delTag = [[self.selectedArray objectAtIndex:k] valueForKey:@"msgNo"];
                        if ([tag isEqualToString:[delTag stringValue]]) {
                            [self.selectedArray removeObjectAtIndex:k];
                        }
                    }
                    break;
                }
            }
            [self refreshTable];
        } else {
            AlertWithMessage([resultObj valueForKey:@"message"]);
        }
    }
    
    //[self toggleEditMode];
    
    //[self bindMessage];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;		
	
	static NSString *CellIdentifier = @"MessageCell";
	
	UIImageView *balloonView;
	UILabel *label;
	NSInteger row = [indexPath row];
	float w = 0.0;
    
    UILabel *detailLabel;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;		
		
		balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
		balloonView.tag = 1;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.tag = 2;
		label.numberOfLines = 0;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.font = [UIFont systemFontOfSize:14.0];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.tag = 3;
        detailLabel.numberOfLines = 1;
        detailLabel.lineBreakMode = UILineBreakModeClip;
        detailLabel.font = [UIFont systemFontOfSize:12.0];
        detailLabel.textColor = UIColorFromRGB(0x515050);
		
		UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
		message.tag = 0;
		[message addSubview:balloonView];
		[message addSubview:label];
        
        [message addSubview:detailLabel];

		[cell.contentView addSubview:message];
		
		[balloonView release];
		[label release];
		[message release];
        
        [detailLabel release];
		
		
		//수정모드시 나타날 선택이미지 
		UIImageView *imageView = [[UIImageView alloc] initWithImage:deselectedImage];
		//imageView.frame = CGRectMake(5.0, 10.0, 23.0, 23.0);
		[cell.contentView addSubview:imageView];
		imageView.hidden = !isEditMode;
		imageView.tag = kCellImageViewTag;
		[imageView release];
	}
	else
	{
		balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
		label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
        detailLabel = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:3];
	}
	
	NSDictionary *message = [messageList objectAtIndex:indexPath.row];
	NSString *text = (NSString *)[message objectForKey:@"msgContent"];
	NSString *sendID = (NSString *)[message objectForKey:@"sendUserID"];
    //NSString *receiverID = (NSString *)[message objectForKey:@"receiveUserID"];
    //NSString *messageText = [NSString stringWithFormat:@"%@ \n[%@]", text, sendID];
    long long sendDateNumber = [[NSString stringWithFormat:@"%@",[message objectForKey:@"sendDate"]] longLongValue];
    NSString *sendDateString = [Utils convertDateString:[NSNumber numberWithLongLong:sendDateNumber] formatString:@"MM월dd일 hh:mm"];
    

	//NSString *receiveUserID = (NSString *)[message objectForKey:@"receiveUserID"];
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
	
	CGSize sendUserSize = [sendDateString sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    NSInteger messageWidth = 0;
    if(size.width > sendUserSize.width){
        messageWidth += size.width;
    } else {
        messageWidth += sendUserSize.width;
    }
	
	if( [sendID isEqualToString:self.receiveUserID])
	{
        //balloonView.frame = CGRectMake(320.0f - (size.width + 28.0f), 2.0f, size.width + 28.0f, size.height + 15.0f);
        //balloonView.frame = CGRectMake(320.0f - (size.width + 28.0f), 2.0f, size.width + 28.0f, size.height + 35.0f);
        balloonView.frame = CGRectMake(320.0f - (messageWidth + 28.0f), 2.0f, messageWidth + 28, size.height + 35.0f);
		balloonView.image = [[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
		label.frame = CGRectMake(307.0f - (messageWidth + 5.0f), 8.0f, messageWidth + 5.0f, size.height);
        detailLabel.frame = CGRectMake(307.0f - (messageWidth + 5.0f), label.frame.size.height+10, label.frame.size.width, 15);
		
	}
	else
	{
		//balloonView.frame = CGRectMake(0.0, 2.0, size.width + 28, size.height + 15);
        //balloonView.frame = CGRectMake(0.0, 2.0, size.width + 28, size.height + 35);
        balloonView.frame = CGRectMake(0.0, 2.0, messageWidth + 28, size.height + 35);
		balloonView.image = [[UIImage imageNamed:@"grey.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
		label.frame = CGRectMake(16, 8, messageWidth + 5, size.height);
        detailLabel.frame = CGRectMake(16, size.height + 10, messageWidth + 5, 15);
	}
	
	label.text = text;
	detailLabel.text = [NSString stringWithFormat:@"[%@]", sendDateString];
	
	[UIView beginAnimations:@"cell shift" context:nil];
	
	//UIView *msgView = (UIView *)[cell.contentView viewWithTag:0];
	//msgView.frame = (isEditMode) ? kLabelIndentedRect : kLabelRect;
	//msgView.opaque = NO;
	
	NSDictionary *selected = [self.selectedArray objectAtIndex:row];
    
	//수정모드시 나타날 이미지 바인드
	UIImageView *iconImage = (UIImageView *)[cell.contentView viewWithTag:kCellImageViewTag];
	//cell의 높이에 맞춰 위치 조정
	float x = (cell.frame.size.height / 2) - (deselectedImage.size.height / 2);
	iconImage.frame = CGRectMake(5.0, x, 23.0, 23.0);
	iconImage.image = ([[selected objectForKey:@"selected"] isEqualToString:@"T"]) ? selectedImage : deselectedImage;
	iconImage.hidden = !isEditMode;
    
	[UIView commitAnimations];
    
	if (isEditMode) {
		tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		
		w = deselectedImage.size.width;
		CGRect balloonViewFrame = balloonView.frame;
		if (balloonViewFrame.origin.x == 0.0) {
			balloonViewFrame.origin.x += w;
			balloonView.frame = balloonViewFrame;
			label.frame = CGRectMake(16+w, 8, size.width + 5, size.height);
            detailLabel.frame = CGRectMake(16+w, size.height+10, messageWidth + 5, 15);
		}
		
	}
	
	
	
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *message = (NSDictionary *)[messageList objectAtIndex:indexPath.row];
	NSString *body = (NSString *)[message valueForKey:@"msgContent"];
	CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 15;
    return size.height + 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	//NSDictionary *message = [self.messageList objectAtIndex:row];
	
	if (isEditMode) {
		
		//BOOL selected = [[self.selectedArray objectAtIndex:row] boolValue];
		
        if (self.selectedArray) {
            
            NSMutableDictionary *msgInfo = [self.selectedArray objectAtIndex:row];
            if([[msgInfo valueForKey:@"selected"] isEqualToString:@"T"]){
                NSDictionary *selected = [NSDictionary dictionaryWithObjectsAndKeys:[msgInfo valueForKey:@"msgNo"], @"msgNo", @"F", @"selected", [msgInfo valueForKey:@"msgType"], @"msgType", nil];
                
                [self.selectedArray replaceObjectAtIndex:row withObject:selected];
            } else {
                NSDictionary *selected = [NSDictionary dictionaryWithObjectsAndKeys:[msgInfo valueForKey:@"msgNo"], @"msgNo", @"T", @"selected", [msgInfo valueForKey:@"msgType"], @"msgType", nil];
                
                [self.selectedArray replaceObjectAtIndex:row withObject:selected];
            }

        }
		[self.table reloadData];
		
		
	}
	
}

#pragma mark -
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// use "buttonIndex" to decide your action
	//
	NSLog(@"button Index %d", buttonIndex);
	
	if (buttonIndex == 0) {
		//취소
        [self.modalViewController dismissModalViewControllerAnimated:YES];
    } else {
		//확인
        [self.modalViewController dismissModalViewControllerAnimated:YES];
	}
    
}


@end
