//
//  ProgressCell.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 23..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressCell : UITableViewCell {
    UILabel *seqLabel;
    UILabel *statLabel;
    UIProgressView *progress;
}

@property (nonatomic, retain) IBOutlet UILabel *seqLabel;
@property (nonatomic, retain) IBOutlet UILabel *statLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progress;

+ (ProgressCell *)createCellFromNib;

@end
