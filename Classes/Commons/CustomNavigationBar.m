//
//  CustomNavigationBar.m
//  SmartLMS
//
//  Created by 김규완 on 11. 12. 12..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationBar.h"

@interface CustomNavigationBar ()


@property (nonatomic, retain) UIImage *bgImg;


@end


@implementation CustomNavigationBar


@synthesize bgImg = _bgImg;


- (void)drawRect:( CGRect )rect
{
	if(_bgImg) 
        [_bgImg drawInRect:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    else 
        [super drawRect:rect];
}


-(void)dealloc
{
    [_bgImg release];
    [super dealloc];
}


- (void)setBgImage:(UIImage *)img
{
    self.bgImg = img;
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:self.bgImg forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self setNeedsDisplay];
    }
}

@end
