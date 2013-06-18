//
//  StudentAttendStatCell.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "StudentAttendStatCell.h"

@implementation StudentAttendStatCell

@synthesize studentNameLabel, attendProgress, attendTimeLabel, applyQuizLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    [studentNameLabel release];
    [attendProgress release];
    [attendTimeLabel release];
    [applyQuizLabel release];
    [super dealloc];
}

+ (StudentAttendStatCell *)createCellFromNib {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StudentAttendStatCell" owner:self options:nil];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    StudentAttendStatCell *customCell = nil;
    NSObject* nibItem = nil;
    
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[StudentAttendStatCell class]]) {
            customCell = (StudentAttendStatCell *)nibItem;
            break;
        }
    }
    return customCell;
}

@end
