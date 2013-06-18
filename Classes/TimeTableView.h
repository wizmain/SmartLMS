//
//  TimeTableView.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridView;
@class GridEvent;
@class EventGridView;
@class WeekdayView;
@class HourView;

@protocol TimeTableViewDataSource, TimeTableViewDelegate;


@interface TimeTableView : UIView {
	
	UIImageView *_topBackground;
	UIButton *_leftArrow, *_rightArrow;
	UILabel *_dateLabel;
	
	GridView *_gridView;
	HourView *_hourView;
	WeekdayView *_weekdayView;
	UIScrollView *_scrollView;
	
	unsigned int _labelFontSize;
	UIFont *_regularFont;
	UIFont *_boldFont;
	
	NSDate *_week;
	
	UISwipeGestureRecognizer *_swipeLeftRecognizer, *_swipeRightRecognizer;
	
	id<TimeTableViewDataSource> _dataSource;
	id<TimeTableViewDelegate> _delegate;
}


@property (readwrite,assign) unsigned int labelFontSize;
@property (nonatomic,copy) NSDate *week;
@property (nonatomic,assign) IBOutlet id<TimeTableViewDataSource> dataSource;
@property (nonatomic,assign) IBOutlet id<TimeTableViewDelegate> delegate;
@property (readonly) GridView *gridView;
@property (readonly) HourView *hourView;

@property (readonly) UIFont *regularFont;

- (void)reloadData;

@end

@protocol TimeTableViewDataSource <NSObject>

- (NSArray *)timeTableView:(TimeTableView *)timeTableView eventsForWeekday:(NSInteger)weekday;

@end

@protocol TimeTableViewDelegate <NSObject>

@optional
- (void)timeTableView:(TimeTableView *)timeTableView eventTapped:(GridEvent *)event;


@end
