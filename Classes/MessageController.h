//
//  MessageController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 30..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//  쪽지목록

#import <UIKit/UIKit.h>


@interface MessageController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *table;
	NSMutableArray *messageList;
	NSInteger page;
	NSInteger selectedRow;
	UIBarButtonItem *editButtonItem;
	UIBarButtonItem *cancelButtonItem;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *messageList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, retain) UIBarButtonItem *editButtonItem;
@property (nonatomic, retain) UIBarButtonItem *cancelButtonItem;

- (void)writeMessageClick:(id)sender;
- (void)editClick:(id)sender;
- (void)editDoneClick:(id)sender;
- (void)bindMessage;
	
@end
