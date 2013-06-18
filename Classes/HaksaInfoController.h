//
//  HaksaInfoController.h
//  mClass
//
//  Created by 김규완 on 11. 2. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HaksaInfoController : UIViewController<UITableViewDelegate, UITableViewDataSource>  {
	UITableView *table;
}

@property (nonatomic, retain) IBOutlet UITableView *table;

- (void)goHome;

@end
