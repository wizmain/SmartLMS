//
//  SubIndexViewController.h
//  SmartLMS
//
//  Created by 김 규완 on 11. 9. 16..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubIndexViewController : UIViewController {
    
    UIButton *menu01Button;
    UIButton *menu02Button;
    UIButton *menu03Button;
    UIButton *menu04Button;
}

@property (nonatomic, retain) IBOutlet UIButton *menu01Button;
@property (nonatomic, retain) IBOutlet UIButton *menu02Button;
@property (nonatomic, retain) IBOutlet UIButton *menu03Button;
@property (nonatomic, retain) IBOutlet UIButton *menu04Button;

- (IBAction)menu01ButtonClick:(id)sender;
- (IBAction)menu02ButtonClick:(id)sender;
- (IBAction)menu03ButtonClick:(id)sender;
- (IBAction)menu04ButtonClick:(id)sender;

@end
