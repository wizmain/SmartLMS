//
//  MessageCell.m
//  mClass
//
//  Created by 김규완 on 10. 12. 30..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageCell.h"


@implementation MessageCell

@synthesize balloonView, label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	if( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
	
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
		balloonView.tag = 1;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.tag = 2;
		label.numberOfLines = 0;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.font = [UIFont systemFontOfSize:14.0];
		
		//UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
		//UIView *v = self.contentView;
		//v.tag = 0;
		//[v addSubview:balloonView];
		//[v addSubview:label];

	}
	
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	//[super setSelected:selected animated:animated];
}

- (void)dealloc {
	[balloonView release];
	[label release];
	[super dealloc];
}

@end
