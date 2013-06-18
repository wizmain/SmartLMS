//
//  RecordController.h
//  SmartLMS
//
//  Created by 김규완 on 11. 4. 26..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecordController : UIViewController {
    NSInteger lectureNo;
    UIWebView *webview;
    NSString *lectureTitle;
}

@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) NSString *lectureTitle;

@end
