//
//  NoticeController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressIndicator.h"

@interface ArticleController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *noticeTable;
	NSInteger page;
	NSString *siteID;
	NSString *menuID;
	NSArray *articleList;
    NSString *boardTitle;
    ProgressIndicator *spinner;
    BOOL isStudent;
    NSInteger lectureNo;

}

@property (nonatomic, retain) IBOutlet UITableView *noticeTable;
@property (nonatomic, retain) NSString *siteID;
@property (nonatomic, retain) NSString *menuID;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, retain) NSArray *articleList;
@property (nonatomic, retain) NSString *boardTitle;
@property (nonatomic, assign) BOOL isStudent;
@property (nonatomic, assign) NSInteger lectureNo;

- (void)bindNotice;
- (void)reloadNoticeTable;
- (void)writeArticleClick:(id)sender;
- (void)refreshClick:(id)sender;
- (void)didNoticeReceiveFinished:(NSString *)result;
@end
