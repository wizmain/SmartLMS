//
//  MessageListController.h
//  mClass
//
//  Created by 김규완 on 11. 2. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransparentToolbar;

#define kCellImageViewTag		1000
#define kCellLabelTag			1001
#define kLabelIndentedRect	CGRectMake(40.0, 12.0, 275.0, 20.0)
#define kLabelRect			CGRectMake(15.0, 12.0, 275.0, 20.0)

@interface MessageListController : UITableViewController {
	
	NSArray *messageList;
	NSInteger page;
	BOOL isEditMode;
	
	UIImage *selectedImage;			//선택표시 이미지
	UIImage *deselectedImage;		//선택안됨 이미지
	//UIToolbar *toolbar;
	NSMutableArray *selectedArray;	//선택된
	UIBarButtonItem *editButtonItem;
	UIBarButtonItem *deleteButtonItem;
	UIButton *trashButton;
}

@property (nonatomic, retain) NSArray *messageList;
@property (nonatomic, assign) NSInteger page;

//@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *deselectedImage;
@property (nonatomic, assign) BOOL isEditMode;
@property (nonatomic, retain) NSMutableArray *selectedArray;
@property (nonatomic, retain) UIBarButtonItem *editButtonItem;
@property (nonatomic, retain) UIBarButtonItem *deleteButtonItem;
@property (nonatomic, retain) UIButton *trashButton;

- (void)writeMessageClick:(id)sender;
- (void)editClick:(id)sender;
- (void)bindMessage;
- (void)deleteMessage:(id)sender;
- (void)initSelectedArray;
- (void)toggleRightButton;
- (void)makeDeleteItem;
@end
