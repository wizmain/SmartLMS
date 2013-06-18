//
//  TermPickerDelegate.h
//  mClass
//
//  Created by 김규완 on 10. 12. 9..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TermPickerDelegate : NSObject <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSArray *pData;
}

@property (nonatomic, retain) NSArray *pData;

- (int)selectedTermIndex;
@end
