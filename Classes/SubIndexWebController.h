//
//  SubIndexWebController.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 9. 16..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubIndexWebController : UIViewController {
    UIWebView *webView;
    NSString *urlString;
    NSString *isCyberLink;
    NSString *pageTitle;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *isCyberLink;
@property (nonatomic, retain) NSString *pageTitle;

@end
