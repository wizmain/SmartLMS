//
//  LectureItemController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 13..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviePlayerController.h"

@interface LectureItemController : UIViewController {
	NSInteger lectureNo;
	NSString *lectureTitle;
	UITableView *lectureItemTable;
	NSArray *lectureItemList;
    MoviePlayerController *moviePlayer;
    NSInteger selectedItemNo;
    NSString *subjID;
}

@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) NSString *lectureTitle;
@property (nonatomic, retain) NSArray *lectureItemList;
@property (nonatomic, retain) IBOutlet UITableView *lectureItemTable;
@property (nonatomic, retain) NSString *subjID;

- (void)bindLectureItem;
- (void)reloadLectureItemTable;

@end
