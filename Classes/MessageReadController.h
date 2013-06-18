//
//  MessageReadController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 30..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HPGrowingTextView.h"

#define kCellImageViewTag		1000
#define kCellLabelTag			1001
#define kLabelIndentedRect	CGRectMake(40.0, 12.0, 275.0, 20.0)
#define kLabelRect			CGRectMake(15.0, 12.0, 275.0, 20.0)

@class MessageTableDelegate;

@interface MessageReadController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, HPGrowingTextViewDelegate> {
	NSInteger messageNo;
	NSString *messageTitle;
	NSString *receiveUserID;
	NSString *receiveUserName;
    NSString *sendUserName;
	NSString *sendUserID;
    NSString *userID;
	NSMutableArray *messageList;
	IBOutlet UITableView *table;
	//MessageTableDelegate *messageTableDelegate;
	UIToolbar *toolbar;
	NSMutableArray *selectedArray;	//선택된
	BOOL isEditMode;
	UIImage *selectedImage;			//선택표시 이미지
	UIImage *deselectedImage;		//선택안됨 이미지
	HPGrowingTextView *addMessageField;
	UIBarButtonItem *sendButton;
	UIBarButtonItem *editButton;
	UIBarButtonItem *deleteAllButton;
	
}

@property (nonatomic, assign) NSInteger messageNo;
@property (nonatomic, retain) NSString *messageTitle;
@property (nonatomic, retain) NSString *receiveUserID;
@property (nonatomic, retain) NSString *sendUserID;
@property (nonatomic, retain) NSString *receiveUserName;
@property (nonatomic, retain) NSString *sendUserName;
@property (nonatomic, retain) NSMutableArray *messageList;
@property (nonatomic, retain) NSMutableArray *selectedArray;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) BOOL isEditMode;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *deselectedImage;
@property (nonatomic, retain) HPGrowingTextView *addMessageField;
@property (nonatomic, retain) UIBarButtonItem *sendButton;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) UIBarButtonItem *deleteAllButton;

- (void)refreshTable;
- (void)bindMessage;
- (void)editTable:(id)sender;
- (void)cancelMessage:(id)sender;
- (void)initSelectedArray;
- (void)adjustTableScroll;
- (void)adjustTableSize:(NSValue *)frameValue;
- (void)toggleEditMode;
- (IBAction)sendMessage:(id)sender;
- (void)deleteMessage:(NSString *)msgType msgNo:(NSString *)msgNo;

@end
