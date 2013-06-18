//
//  MessageCell.h
//  mClass
//
//  Created by 김규완 on 10. 12. 30..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MessageCellIdentifier	@"MessageCellIdentifier"

@interface MessageCell : UITableViewCell {
	UIImageView *balloonView;
	UILabel *label;
}

@property (nonatomic, retain) UIImageView *balloonView;
@property (nonatomic, retain) UILabel *label;

@end
