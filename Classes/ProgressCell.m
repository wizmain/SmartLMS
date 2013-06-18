//
//  ProgressCell.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 23..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "ProgressCell.h"

@implementation ProgressCell

@synthesize seqLabel, statLabel, progress;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    [seqLabel release];
    [statLabel release];
    [progress release];
    [super dealloc];
}

+ (ProgressCell *)createCellFromNib {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ProgressCell" owner:self options:nil];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ProgressCell *customCell = nil;
    NSObject* nibItem = nil;
    
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ProgressCell class]]) {
            customCell = (ProgressCell *)nibItem;
            break;
        }
    }
    return customCell;
}

@end
