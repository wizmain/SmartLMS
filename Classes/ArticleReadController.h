//
//  ArticleReadController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 27..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ArticleReadController : UIViewController {
	NSString *siteID;
	NSString *menuID;
	NSInteger contentsID;
	UILabel *titleLabel;
	//UITextView *contentsText;
    UIWebView *contents;
	UIToolbar *toolbar;
	UIBarButtonItem *actionButton;
    NSString *boardTitle;
    BOOL isStudent;
}

@property (nonatomic, retain) NSString *siteID;
@property (nonatomic, retain) NSString *menuID;
@property (nonatomic, assign) NSInteger contentsID;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
//@property (nonatomic, retain) IBOutlet UITextView *contentsText;
@property (nonatomic, retain) IBOutlet UIWebView *contents;
@property (nonatomic, retain) NSString *boardTitle;

- (void)requestArticle;

@end
