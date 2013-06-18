//
//  MessageTableDelegate.h
//  mClass
//
//  Created by 김규완 on 10. 12. 31..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageTableDelegate : NSObject <UITableViewDelegate, UITableViewDataSource> {
	NSArray *messageList;
	BOOL isEditMode;
}

@property (nonatomic, retain) NSArray *messageList;
@property (nonatomic, assign) BOOL isEditMode;

@end
