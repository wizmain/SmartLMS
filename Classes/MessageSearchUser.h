//
//  MessageSearchUser.h
//  mClass
//
//  Created by 김규완 on 11. 1. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageSearchUser : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource> {
	UISearchBar *searchBar;
	NSMutableArray *userList;
	NSMutableArray *copiedUserList;
	BOOL searching;
	BOOL isSelectRow;
	UITableView *table;
	UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *userList;
@property (nonatomic, retain) NSMutableArray *copiedUserList;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, assign) BOOL isSelectRow;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;


- (void)searchUser;
- (void)closeWindow:(id)sender;

@end
