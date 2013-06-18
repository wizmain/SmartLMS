//
//  UITabBarController+Rotation.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 8. 2..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "UITabBarController+Rotation.h"

@implementation UITabBarController (UITabBarController_Rotation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{   
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *rootController = [((UINavigationController *)self.selectedViewController).viewControllers objectAtIndex:0];
        return [rootController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
