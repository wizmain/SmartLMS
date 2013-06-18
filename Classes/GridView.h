//
//  WizGridView.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GridView : UIView {
	unsigned int _rows;
	unsigned int _columns;
	BOOL _horizontalLines;
	BOOL _verticalLines;
	BOOL _outerBorder;
	CGFloat _lineWidth;
	UIColor *_lineColor;
	CGFloat _cellWidth;
	CGFloat _cellHeight;
}

@property (readwrite,assign) unsigned int rows;
@property (readwrite,assign) unsigned int columns;
@property (readwrite,assign) BOOL horizontalLines;
@property (readwrite,assign) BOOL verticalLines;
@property (readwrite,assign) BOOL outerBorder;
@property (readwrite,assign) CGFloat lineWidth;
@property (nonatomic, retain) UIColor *lineColor;
@property (readonly) CGFloat cellWidth;
@property (readonly) CGFloat cellHeight;

@end
