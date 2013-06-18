//
//  ReportProgressCell.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 24..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportProgressCell : UITableViewCell {
    UILabel *titleLabel;
    UILabel *percentLabel;
    UIProgressView *progress;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *percentLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progress;

+ (ReportProgressCell *)createCellFromNib;

@end
