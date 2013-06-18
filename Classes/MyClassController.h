//
//  MyClassControllerj.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyClassController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
    UIColor *backImg;
}

@property (nonatomic, retain) IBOutlet UITableView *table;

@end
