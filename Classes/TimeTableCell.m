//
//  TimeTableCell.m
//  SmartLMS
//
//  Created by 김규완 on 11. 7. 8..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeTableCell.h"


@implementation TimeTableCell

@synthesize periodLabel, subjectLabel, infoLabel;

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
    [periodLabel release];
    [subjectLabel release];
    [infoLabel release];
    [super dealloc];
}

+ (TimeTableCell *)createCellFromNib {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TimeTableCell" owner:self options:nil];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    TimeTableCell *customCell = nil;
    NSObject* nibItem = nil;
    
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[TimeTableCell class]]) {
            customCell = (TimeTableCell *)nibItem;
            break;
        }
    }
    return customCell;
}

@end
