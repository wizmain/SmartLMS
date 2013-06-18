//
//  TimeTableCell.h
//  SmartLMS
//
//  Created by 김규완 on 11. 7. 8..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TimeTableCell : UITableViewCell {
    IBOutlet UILabel *periodLabel;
    IBOutlet UILabel *subjectLabel;
    IBOutlet UILabel *infoLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *periodLabel;
@property (nonatomic, retain) IBOutlet UILabel *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;

+ (TimeTableCell *)createCellFromNib;

@end
