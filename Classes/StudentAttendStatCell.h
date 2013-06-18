//
//  StudentAttendStatCell.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentAttendStatCell : UITableViewCell {
    UILabel *studentNameLabel;
    UILabel *attendTimeLabel;
    UILabel *applyQuizLabel;
    UIProgressView *attendProgress;
}

@property (nonatomic, retain) IBOutlet UILabel *studentNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *attendTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *applyQuizLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *attendProgress;

+ (StudentAttendStatCell *)createCellFromNib;

@end
