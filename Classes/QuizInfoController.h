//
//  QuizInfoController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuizInfoController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSInteger etestNo;
    UITableView *table;
    NSDictionary *etest;
    NSInteger lectureNo;
    NSInteger itemNo;
}

@property(nonatomic, assign) NSInteger etestNo;
@property(nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSDictionary *etest;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, assign) NSInteger itemNo;
- (void)bindETestInfo;
@end
