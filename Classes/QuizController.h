//
//  QuizController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuizController : UIViewController {
    NSInteger lectureNo;
    UITableView *table;
    NSArray *dataList;
}

@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *dataList;


- (void)bindDataList;

@end
