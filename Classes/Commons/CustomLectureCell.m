//
//  CustomLectureCell.m
//  mClass
//
//  Created by 김규완 on 11. 4. 6..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomLectureCell.h"


@implementation CustomLectureCell

@synthesize lectureTitle, lectureDetail, lectureTitleImage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)cellWithNib
{
    
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"CustomLectureCell" bundle:nil];
    CustomLectureCell *cell = (CustomLectureCell *)controller.view;
    [controller release];
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)dealloc
{
    [lectureTitle release];
    [lectureDetail release];
    [lectureTitleImage release];
    [super dealloc];
}





@end
