//
//  ReportProgressCell.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 24..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "ReportProgressCell.h"

@implementation ReportProgressCell

@synthesize titleLabel, percentLabel, progress;

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
    [titleLabel release];
    [percentLabel release];
    [progress release];
    [super dealloc];
}

+ (ReportProgressCell *)createCellFromNib {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ReportProgressCell" owner:self options:nil];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ReportProgressCell *customCell = nil;
    NSObject* nibItem = nil;
    
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ReportProgressCell class]]) {
            customCell = (ReportProgressCell *)nibItem;
            break;
        }
    }
    return customCell;
}

@end
