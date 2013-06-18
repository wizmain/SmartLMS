//
//  ArticleEditController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 28..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextFieldCell.h"
#import "UITextViewCell.h"

@interface ArticleEditController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	
	NSInteger contentsID;
	NSString *siteID;
	NSString *menuID;
	UITableView *table;
	NSDictionary *article;
	NSNumber *selectedSection;
	IBOutlet UITextView *contentTextView;
	IBOutlet UITextField *titleTextField;
	IBOutlet UIButton *resignTextFieldButton;
	BOOL isShowingKeyboard;
    NSString *boardTitle;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, assign) NSNumber *selectedSection;
@property (nonatomic, retain) IBOutlet UITextView *contentTextView;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UIButton *resignTextFieldButton;
@property (nonatomic, assign) NSInteger contentsID;
@property (nonatomic, retain) NSString *siteID;
@property (nonatomic, retain) NSString *menuID;
@property (nonatomic, retain) NSDictionary *article;
@property (nonatomic, assign) BOOL isShowingKeyboard;
@property (nonatomic, retain) NSString *boardTitle;

- (void)refreshTable;
- (void)requestArticle;
- (IBAction)resignTextField:(id)sender;
- (void)hideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)goBack:(id)sender;

@end
