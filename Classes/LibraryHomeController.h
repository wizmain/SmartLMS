//
//  LibraryHomeController.h
//  mClass
//
//  Created by 김규완 on 11. 1. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LibraryHomeController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
}

@property (nonatomic, retain) IBOutlet UITableView *table;

@end
