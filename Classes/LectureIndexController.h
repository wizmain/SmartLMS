//
//  LectureIndexController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LectureIndexController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
	NSArray *lectureList;
	NSString *indexType;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *lectureList;
@property (nonatomic, retain) NSString *indexType;

@end
