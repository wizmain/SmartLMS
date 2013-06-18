//
//  CommunityHomeController.h
//  mClass
//
//  Created by 김규완 on 11. 1. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommunityHomeController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
}

@property (nonatomic, retain) IBOutlet UITableView *table;

@end
