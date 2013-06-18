//
//  TimeTableView.m
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeTableView.h"
#import "GridEvent.h"
#import <QuartzCore/QuartzCore.h>
#import "GridView.h"
#import "TapDetectingView.h"

static const unsigned int HOURS_IN_DAY                   = 9;
static const unsigned int DAYS_IN_WEEK                   = 7;
static const unsigned int MINUTES_IN_HOUR                = 60;
static const unsigned int SPACE_BETWEEN_HOUR_LABELS      = 3;
static const unsigned int DEFAULT_LABEL_FONT_SIZE        = 10;
static const unsigned int VIEW_EMPTY_SPACE               = 10;
static NSString *TEXT_WHICH_MUST_FIT                     = @"Noon123";

static NSString *TOP_BACKGROUND_IMAGE                    = @"ma_topBackground.png";
static NSString *LEFT_ARROW_IMAGE                        = @"ma_leftArrow.png";
static NSString *RIGHT_ARROW_IMAGE                       = @"ma_rightArrow.png";
static const unsigned int ARROW_LEFT                     = 0;
static const unsigned int ARROW_RIGHT                    = 1;
static const unsigned int ARROW_WIDTH                    = 48;
static const unsigned int ARROW_HEIGHT                   = 38;
static const unsigned int TOP_BACKGROUND_HEIGHT          = 35;

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#pragma mark -
#pragma mark HourView
@interface HourView : UIView {
	TimeTableView *_timeTableView;
	UIColor *_textColor;
	UIFont *_textFont;
}

- (BOOL)timeIs24HourFormat;

@property (nonatomic, retain) TimeTableView *timeTableView;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *textFont;

@end

static NSString const * const HOURS_AM_PM[] = {
	@" 12 교시", @" 1 교시", @" 2 교시", @" 3 교시", @" 4 교시", @" 5 교시", @" 6 교시", @" 7 교시", @" 8 교시", @" 9 교시", @" 10 교시", @" 11 교시",
	@" Noon", @" 1 PM", @" 2 PM", @" 3 PM", @" 4 PM", @" 5 PM", @" 6 PM", @" 7 PM", @" 8 PM", @" 9 PM", @" 10 PM", @" 11 PM", @" 12 PM"
};

static NSString const * const HOURS_24[] = {
	@" 0:00", @" 1:00", @" 2:00", @" 3:00", @" 4:00", @" 5:00", @" 6:00", @" 7:00", @" 8:00", @" 9:00", @" 10:00", @" 11:00",
	@" 12:00", @" 13:00", @" 14:00", @" 15:00", @" 16:00", @" 17:00", @" 18:00", @" 19:00", @" 20:00", @" 21:00", @" 22:00", @" 23:00", @" 24:00"
};

static NSString const * const TIMETABLE_PERIOD[] = {
	@" 0 교시", @" 1 교시", @" 2 교시", @" 3 교시", @" 4 교시", @" 5 교시", @" 6 교시", @" 7 교시", @" 8 교시", @" 9 교시"
};

@implementation HourView

@synthesize timeTableView=_timeTableView;
@synthesize textColor=_textColor;
@synthesize textFont=_textFont;

- (BOOL)timeIs24HourFormat {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [formatter stringFromDate:[NSDate date]];
	NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
	NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
	BOOL is24Hour = amRange.location == NSNotFound && pmRange.location == NSNotFound;
	[formatter release];
	return is24Hour;
}

- (void)drawRect:(CGRect)rect {
	register unsigned int i;
	const CGFloat cellHeight = self.timeTableView.gridView.cellHeight;
	
	NSString **HOURS = ([self timeIs24HourFormat] ? HOURS_24 : HOURS_AM_PM);
	//NSString **HOURS = TIMETABLE_PERIOD;
	
	[self.textColor set];
	
	for (i=1; i < HOURS_IN_DAY; i++) {
		CGSize sizeNecessary = [HOURS[i] sizeWithFont:self.textFont];
		CGRect rect = CGRectMake(CGRectGetMinX(self.bounds),
								 (cellHeight * i) - (sizeNecessary.height*2),
								 sizeNecessary.width,
								 sizeNecessary.height);
		
		[HOURS[i] drawInRect: rect
					withFont:self.textFont
			   lineBreakMode:UILineBreakModeTailTruncation
				   alignment:UITextAlignmentLeft];
	}
}

- (void)dealloc {
	self.timeTableView = nil;
	self.textColor = nil;
	self.textFont = nil;
	[super dealloc];
}

@end


#pragma mark -
#pragma mark EventView
@interface EventView : TapDetectingView <TapDetectingViewDelegate> {
	NSString *_title;
	UIColor *_textColor;
	UIFont *_textFont;
	TimeTableView *_timeTableView;
	GridEvent *_event;
	CGRect _textRect;
}

- (void)setupCustomInitialisation;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, retain) TimeTableView *timeTableView;
@property (nonatomic, retain) GridEvent *event;

@end

static const CGFloat kAlpha        = 0.8;
static const CGFloat kCornerRadius = 10.0;
static const CGFloat kCorner       = 5.0;

@implementation EventView

@synthesize textColor=_textColor;
@synthesize textFont=_textFont;
@synthesize title=_title;
@synthesize timeTableView=_timeTableView;
@synthesize event=_event;

- (void)dealloc {
	self.textColor = nil;
	self.textFont = nil;
	self.title = nil;
	self.timeTableView = nil;
	self.event = nil;
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setupCustomInitialisation];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
		[self setupCustomInitialisation];
	}
	return self;
}

- (void)setupCustomInitialisation {
	twoFingerTapIsPossible = NO;
	multipleTouches = NO;
	delegate = self;
	
	self.alpha = kAlpha;
	CALayer *layer = [self layer];
	layer.masksToBounds = YES;
	[layer setCornerRadius:kCornerRadius];
}

- (void)layoutSubviews {
	_textRect = CGRectMake(CGRectGetMinX(self.bounds) + kCorner,
						   CGRectGetMinY(self.bounds) + kCorner,
						   CGRectGetWidth(self.bounds) - 2*kCorner,
						   CGRectGetHeight(self.bounds) - 2*kCorner);
}

- (void)drawRect:(CGRect)rect {
	[self.textColor set];
	
	[self.title drawInRect:_textRect
				  withFont:self.textFont
			 lineBreakMode:UILineBreakModeTailTruncation
				 alignment:UITextAlignmentLeft];
}

- (void)tapDetectingView:(TapDetectingView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
	if ([self.timeTableView.delegate respondsToSelector:@selector(timeTableView:eventTapped:)]) {
        [self.timeTableView.delegate timeTableView:self.timeTableView eventTapped:self.event];
	}
}

@end

#pragma mark -
#pragma mark GridView Addtions
@interface GridView (TimeTableViewAdditions)
- (void)addEventToOffset:(unsigned int)offset event:(GridEvent *)event timeTableView:(TimeTableView *)timeTableView;
@end

@implementation GridView (TimeTableViewAdditions)

- (void)addEventToOffset:(unsigned int)offset event:(GridEvent *)event timeTableView:(TimeTableView *)timeTableView {
	EventView *eventView = [[EventView alloc] initWithFrame:CGRectMake(self.cellWidth * offset,
																	   self.cellHeight * [event period],
																	   self.cellWidth,
																	   self.cellHeight)];
	eventView.timeTableView = timeTableView;
	eventView.event = event;
	eventView.backgroundColor = event.backgroundColor;
	eventView.title = event.title;
	eventView.textFont = timeTableView.regularFont;
	eventView.textColor = event.textColor;
	
	[self addSubview:eventView], [eventView release];
}

@end

#pragma mark -
#pragma mark TimeTableView
@interface TimeTableView (PrivateMethods)
- (void)setupCustomInitialisation;
- (void)changeWeek:(UIButton *)sender;
- (NSDate *)firstDayOfWeekFromDate:(NSDate *)date;
- (NSDate *)nextWeekFromDate:(NSDate *)date;
- (NSDate *)previousWeekFromDate:(NSDate *)date;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;

@property (readonly) UIImageView *topBackground;
@property (readonly) UIButton *leftArrow;
@property (readonly) UIButton *rightArrow;
@property (readonly) UILabel *dateLabel;
@property (readonly) UIFont *boldFont;
@property (readonly) WeekdayView *weekdayView;
@property (readonly) NSString *titleText;
@property (readonly) UIScrollView *scrollView;
@property (readonly) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (readonly) UISwipeGestureRecognizer *swipeRightRecognizer;

@end



#pragma mark -
#pragma mark WeekdayView
@interface WeekdayView : UIView {
	TimeTableView *_timeTableView;
	NSDate *_week;
	UIColor *_textColor, *_sundayColor, *_todayColor;
	UIFont *_textFont;
	NSDateFormatter *_dateFormatter;
	NSMutableArray *_weekdays;
}

@property (nonatomic, retain) TimeTableView *timeTableView;
@property (nonatomic,copy) NSDate *week;
@property (nonatomic, retain) UIColor *textColor, *sundayColor, *todayColor;
@property (nonatomic, retain) UIFont *textFont;
@property (readonly) NSDateFormatter *dateFormatter;
@property (readonly) NSArray *weekdays;

- (NSString *)weekdayShortSymbolToKor:(NSString *)symbol;

@end


@implementation WeekdayView

@synthesize timeTableView=_timeTableView;
@synthesize textColor=_textColor, sundayColor=_sundayColor, todayColor=_todayColor;
@synthesize textFont=_textFont;
@synthesize weekdays=_weekdays;

- (NSString *)weekdayShortSymbolToKor:(NSString *)symbol {
	
	if ([symbol isEqualToString:@"M"]) {
		return @"월";
	} else if ([symbol isEqualToString:@"T"]) {
		return @"화";
	} else if ([symbol isEqualToString:@"W"]) {
		return @"화";
	} else if ([symbol isEqualToString:@"T"]) {
		return @"목";
	} else if ([symbol isEqualToString:@"F"]) {
		return @"금";
	} else if ([symbol isEqualToString:@"S"]) {
		return @"토";
	} else if ([symbol isEqualToString:@"S"]) {
		return @"일";
	} else {
		return @"";
	}
}

- (void)setWeek:(NSDate *)week {
	[_week release], _week = [week retain];
	
	NSDate *date = _week;
	NSLog(@"setWeek %@", date);
	NSDateComponents *components;
	NSDateComponents *components2 = [[NSDateComponents alloc] init];
	[components2 setDay:1];
	
	[_weekdays release], _weekdays = [[NSMutableArray alloc] init];
	
	for (register unsigned int i=0; i < DAYS_IN_WEEK; i++) {
		[_weekdays addObject:date];
		NSLog(@"_weekdays %@", date);
		components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
		[components setDay:1];
		date = [CURRENT_CALENDAR dateByAddingComponents:components2 toDate:date options:0];
	}
	
	[components2 release];
}

- (NSDate *)week {
	return _week;
}

- (void)drawRect:(CGRect)rect {
	
	register unsigned int i = 0;
	
	const CGFloat cellWidth = self.timeTableView.gridView.cellWidth;
	
	NSDateComponents *todayComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	
	NSArray *weekdaySymbols = [self.dateFormatter veryShortWeekdaySymbols];
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	int d = CFCalendarGetFirstWeekday(currentCalendar) - 1;
	CFRelease(currentCalendar);
	
	for (NSDate *date in _weekdays) {
		NSLog(@"date = %@", date );
		NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
		NSString *displayText = [NSString stringWithFormat:@"%@ %i", [weekdaySymbols objectAtIndex:d], [components day]];
		NSLog(@"displayText = %@", displayText);
		CGSize sizeNecessary = [displayText sizeWithFont:self.textFont];
		CGRect rect = CGRectMake(cellWidth * i + ((cellWidth - sizeNecessary.width) / 2.f),
								 CGRectGetMinY(self.bounds),
								 sizeNecessary.width,
								 sizeNecessary.height);
		
		if ([todayComponents day] == [components day] &&
			[todayComponents month] == [components month] &&
			[todayComponents year] == [components year]) {
			[self.todayColor set];
		} else if ([components weekday] == 1) {
			[self.sundayColor set];
		} else {
			[self.textColor set];
		}
		
		[displayText drawInRect: rect
					   withFont:self.textFont
				  lineBreakMode:UILineBreakModeTailTruncation
					  alignment:UITextAlignmentLeft];
		
		d = (d+1) % 7;
		i++;
	}
	
}

- (NSDateFormatter *)dateFormatter {
	if (!_dateFormatter) {
		_dateFormatter = [[NSDateFormatter alloc] init];
	}
	return _dateFormatter;
}

- (void)dealloc {
	self.timeTableView = nil;
	self.week = nil;
	self.textColor = nil;
	self.sundayColor = nil;
	self.todayColor = nil;
	self.textFont = nil;
	[_dateFormatter release], _dateFormatter = nil;
	[_weekdays release], _weekdays = nil;
	[super dealloc];
}

@end






@implementation TimeTableView

@synthesize labelFontSize=_labelFontSize;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setupCustomInitialisation];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
		[self setupCustomInitialisation];
	}
	return self;
}

- (void)setupCustomInitialisation {
	
	self.labelFontSize = DEFAULT_LABEL_FONT_SIZE;
	self.week = [NSDate date];
	
	[self addSubview:self.topBackground], [self.topBackground release];
	[self addSubview:self.leftArrow], [self.leftArrow release];
	[self addSubview:self.rightArrow], [self.rightArrow release];
	[self addSubview:self.dateLabel], [self.dateLabel release];
	[self addSubview:self.weekdayView], [self.weekdayView release];
	
	[self addSubview:self.scrollView], [self.scrollView release];
	[self.scrollView addSubview:self.hourView], [self.hourView release];
	[self.scrollView addSubview:self.gridView], [self.gridView release];
	
	[self.gridView addGestureRecognizer:self.swipeLeftRecognizer], [self.swipeLeftRecognizer release];
	[self.gridView addGestureRecognizer:self.swipeRightRecognizer], [self.swipeRightRecognizer release];
}

- (void)dealloc {
	[_topBackground release], _topBackground = nil;
	[_leftArrow release], _leftArrow = nil;
	[_rightArrow release], _rightArrow = nil;
	[_dateLabel release], _dateLabel = nil;
	
	[_scrollView release], _scrollView = nil;
	[_gridView release], _gridView = nil;
	
	[_regularFont release], _regularFont = nil;
	[_boldFont release], _boldFont = nil;
	
	[_swipeLeftRecognizer release], _swipeLeftRecognizer = nil;
	[_swipeRightRecognizer release], _swipeRightRecognizer = nil;
	
	[_week release], _week = nil;
	
	[super dealloc];
}

- (UIImageView *)topBackground {
	if (!_topBackground) {
		_topBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TOP_BACKGROUND_IMAGE]];
		_leftArrow.frame = CGRectMake(CGRectGetMinX(self.bounds),
									  CGRectGetMinY(self.bounds),
									  CGRectGetWidth(self.bounds), TOP_BACKGROUND_HEIGHT);
	}
	return _topBackground;
}

- (UIButton *)leftArrow {
	if (!_leftArrow) {
		_leftArrow = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_leftArrow.tag = ARROW_LEFT;
		_leftArrow.frame = CGRectMake(CGRectGetMinX(self.topBackground.bounds),
									  CGRectGetMinY(self.topBackground.bounds),
									  ARROW_WIDTH, ARROW_HEIGHT);
		[_leftArrow setImage:[UIImage imageNamed:LEFT_ARROW_IMAGE] forState:0];
		[_leftArrow addTarget:self action:@selector(changeWeek:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _leftArrow;
}

- (UIButton *)rightArrow {
	if (!_rightArrow) {
		_rightArrow = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_rightArrow.tag = ARROW_RIGHT;
		_rightArrow.frame = CGRectMake(CGRectGetWidth(self.topBackground.bounds) - ARROW_WIDTH,
									   CGRectGetMinY(self.topBackground.bounds),
									   ARROW_WIDTH, ARROW_HEIGHT);
		[_rightArrow setImage:[UIImage imageNamed:RIGHT_ARROW_IMAGE] forState:0];
		[_rightArrow addTarget:self action:@selector(changeWeek:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _rightArrow;
}

- (UILabel *)dateLabel {
	if (!_dateLabel) {
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftArrow.bounds),
															   CGRectGetMinY(self.topBackground.bounds),
															   CGRectGetWidth(self.topBackground.bounds) - CGRectGetWidth(self.leftArrow.bounds) - CGRectGetWidth(self.rightArrow.bounds),
															   ARROW_HEIGHT)];
		_dateLabel.textAlignment = UITextAlignmentCenter;
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.font = [UIFont boldSystemFontOfSize:18];
		_dateLabel.textColor = [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1];
	}
	return _dateLabel;
}

- (HourView *)hourView {
	if (!_hourView) {
		CGSize sizeNecessary = [TEXT_WHICH_MUST_FIT sizeWithFont:self.regularFont];
		
		_hourView = [[HourView alloc] initWithFrame:CGRectMake(0,0, sizeNecessary.width, sizeNecessary.height * HOURS_IN_DAY * SPACE_BETWEEN_HOUR_LABELS)];
		_hourView.timeTableView        = self;
		_hourView.backgroundColor = [UIColor whiteColor];
		_hourView.textColor       = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.f];
		_hourView.textFont        = self.boldFont;
	}
	return _hourView;
}

- (WeekdayView *)weekdayView {
	if (!_weekdayView) {
		CGSize sizeNecessary = [TEXT_WHICH_MUST_FIT sizeWithFont:self.boldFont];
		
		_weekdayView = [[WeekdayView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hourView.bounds),
																	   CGRectGetMaxY(self.topBackground.bounds) - sizeNecessary.height, 
																	   CGRectGetWidth(self.topBackground.bounds) - CGRectGetWidth(self.hourView.bounds),
																	   sizeNecessary.height)];
		_weekdayView.timeTableView        = self;
		_weekdayView.backgroundColor = [UIColor clearColor];
		_weekdayView.textColor       = [UIColor blackColor];
		_weekdayView.sundayColor     = [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1.f];
		_weekdayView.todayColor      = [UIColor colorWithRed:0.1 green:0.5 blue:0.9 alpha:1.f];
		_weekdayView.textFont        = self.regularFont;
	}
	return _weekdayView;
}

- (GridView *)gridView {
	if (!_gridView){
		_gridView = [[GridView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hourView.bounds),
															     0,
															     CGRectGetWidth(self.bounds) - CGRectGetWidth(self.hourView.bounds),
																 CGRectGetHeight(self.hourView.bounds))];
		_gridView.backgroundColor = [UIColor whiteColor];
		_gridView.rows            = HOURS_IN_DAY;
		_gridView.columns         = DAYS_IN_WEEK;
		_gridView.outerBorder     = YES;
		_gridView.verticalLines   = YES;
		_gridView.horizontalLines = YES;
		_gridView.lineColor       = [UIColor lightGrayColor];
		_gridView.lineWidth       = 1;
	}
	return _gridView;
}

- (UIScrollView *)scrollView {
	if (!_scrollView) {
		CGRect rect = CGRectMake(CGRectGetMinX(self.bounds),CGRectGetMaxY(self.topBackground.bounds),
								 CGRectGetWidth(self.bounds),
								 CGRectGetHeight(self.bounds) - CGRectGetHeight(self.topBackground.bounds));
		
		_scrollView = [[UIScrollView alloc] initWithFrame:rect];
		_scrollView.backgroundColor      = [UIColor whiteColor];
		_scrollView.contentSize          = CGSizeMake(CGRectGetWidth(self.bounds),
													  0 + CGRectGetHeight(self.hourView.bounds) + VIEW_EMPTY_SPACE);
		_scrollView.scrollEnabled        = TRUE;
		_scrollView.alwaysBounceVertical = TRUE;
	}
	return _scrollView;
}

- (UIFont *)regularFont {
	if (!_regularFont) {
		_regularFont = [[UIFont systemFontOfSize:_labelFontSize] retain];
	}
	return _regularFont;
}

- (UIFont *)boldFont {
	if (!_boldFont) {
		_boldFont = [[UIFont boldSystemFontOfSize:_labelFontSize] retain];
	}
	return _boldFont;
}

- (UISwipeGestureRecognizer *)swipeLeftRecognizer {
	if (!_swipeLeftRecognizer) {
		_swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
		_swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	}
	return _swipeLeftRecognizer;
}

- (UISwipeGestureRecognizer *)swipeRightRecognizer {
	if (!_swipeRightRecognizer) {
		_swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
		_swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	}
	return _swipeRightRecognizer;
}

- (void)setDataSource:(id <TimeTableViewDataSource>)dataSource {
	[_dataSource release], _dataSource = dataSource;
	[self reloadData];
}

- (id <TimeTableViewDataSource>)dataSource {
	return _dataSource;
}

- (void)setWeek:(NSDate *)date {
	NSLog(@"setWeek %@",date);
	NSDate *firstOfWeek = [self firstDayOfWeekFromDate:date];
	NSLog(@"firstOfWeek = %@", firstOfWeek);
	[_week release], _week = [firstOfWeek retain];
	self.weekdayView.week = _week;
	[self.weekdayView setNeedsDisplay];
	
	self.dateLabel.text = [self titleText];
	
	[self reloadData];
}

- (NSDate *)week {
	NSDate *date = [_week copy]; // alloc
	return [date autorelease];
}

- (void)reloadData {
	
	
	for (id view in self.gridView.subviews) {
		if ([NSStringFromClass([view class])isEqualToString:@"EventView"]) {
			[view removeFromSuperview];
		}
	}
	
	unsigned int d = 0;
	for (NSDate *weekdayDate in self.weekdayView.weekdays) {
		
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:weekdayDate];
		//NSInteger day = [weekdayComponents day];
		NSInteger weekday = [weekdayComponents weekday];
		
		NSArray *events = [self.dataSource timeTableView:self eventsForWeekday:weekday];
		
		for (id e in events) {
			GridEvent *event = e;
			event.displayDate = weekdayDate;
		}
		
		for (id e in [events sortedArrayUsingFunction:GridEvent_sortByStartTime context:NULL]) {
			GridEvent *event = e;
			
			[self.gridView addEventToOffset:d event:event timeTableView:self];
		}
		d++;
	}
}

- (void)changeWeek:(UIButton *)sender {
	if (ARROW_LEFT == sender.tag) {
		self.week = [self previousWeekFromDate:_week];
	} else if (ARROW_RIGHT == sender.tag) {
		self.week = [self nextWeekFromDate:_week];
	}
}


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
	if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		[self changeWeek:self.rightArrow];
	} else  if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		[self changeWeek:self.leftArrow];
	}
}
- (NSDate *)firstDayOfWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
	[components setDay:([components day] - ([components weekday] - CFCalendarGetFirstWeekday(currentCalendar)))];//월요일부터 so (+2)
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	CFRelease(currentCalendar);
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)nextWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
	[components setDay:([components day] - ([components weekday] - CFCalendarGetFirstWeekday(currentCalendar) - 7))];////월요일부터 so (+2)
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)previousWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
	[components setDay:([components day] - ([components weekday] - CFCalendarGetFirstWeekday(currentCalendar) + 7))];//월요일부터 so (+2)
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSString *)titleText {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:_week];
	
	NSArray *monthSymbols = [formatter shortMonthSymbols];
	
	return [NSString stringWithFormat:@"%@, week %i",
			[monthSymbols objectAtIndex:[components month] - 1],
			[components week]];
}

@end


#pragma mark -
#pragma mark EventGridView
@interface EventGridView : UIView {
	TimeTableView *_timeTableView;
	int _eventsInOffset[7];
	unsigned int _maxEvents;
	NSDate *_week;
	UIFont *_textFont;
}

@property (nonatomic, retain) TimeTableView *timeTableView;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic,copy) NSDate *week;

- (void)addEventToOffset:(unsigned int)offset event:(GridEvent *)event;
- (void)resetCachedData;

@end

@implementation EventGridView

@synthesize timeTableView=_timeTableView;
@synthesize textFont=_textFont;

- (void)dealloc {
	[_week release], _week = nil;
	self.timeTableView = nil;
	self.textFont = nil;
	[super dealloc];
}

#define ARR_SET(X) _eventsInOffset[X] = 0;

- (void)resetCachedData {
	_maxEvents = 0;
	ARR_SET(0)
	ARR_SET(1)
	ARR_SET(2)
	ARR_SET(3)
	ARR_SET(4)
	ARR_SET(5)
	ARR_SET(6)
}

#undef ARR_SET

- (void)setWeek:(NSDate *)week {
	[self resetCachedData];
	
	[_week release], _week = [week copy];
	
	[self setNeedsLayout];
}

- (NSDate *)week {
	return _week;
}

- (void)layoutSubviews {
	const CGFloat eventHeight = self.timeTableView.gridView.cellWidth;
	
	self.frame = CGRectMake(self.frame.origin.x,
							self.frame.origin.y,
							self.frame.size.width,
							0 + (0 + eventHeight) * _maxEvents);
	
	
	self.timeTableView.hourView.frame =  CGRectMake(self.timeTableView.hourView.frame.origin.x, self.frame.size.height,
													self.timeTableView.hourView.frame.size.width, self.timeTableView.hourView.frame.size.height);
	
	self.timeTableView.gridView.frame =  CGRectMake(self.timeTableView.gridView.frame.origin.x, self.frame.size.height,
													self.timeTableView.gridView.frame.size.width, self.timeTableView.gridView.frame.size.height);
	self.timeTableView.scrollView.contentSize = CGSizeMake(self.timeTableView.scrollView.contentSize.width,
														   CGRectGetHeight(self.bounds) + CGRectGetHeight(self.timeTableView.hourView.bounds));
}

- (void)addEventToOffset:(unsigned int)offset event:(GridEvent *)event {
	const CGFloat eventWidth = self.timeTableView.gridView.cellWidth * 0.95;
	const CGFloat eventHeight = self.timeTableView.gridView.cellHeight;
	
	EventView *eventView = [[EventView alloc] initWithFrame:CGRectMake(self.timeTableView.gridView.cellWidth * offset,
																	   0 + (0 + eventHeight) * _eventsInOffset[offset],
																	   eventWidth, eventHeight)];
	eventView.timeTableView = self.timeTableView;
	eventView.event = event;
	eventView.backgroundColor = event.backgroundColor;
	eventView.title = event.title;
	eventView.textFont = self.textFont;
	eventView.textColor = event.textColor;
	
	[self addSubview:eventView], [eventView release];
	
	_eventsInOffset[offset]++;
	
	if (_eventsInOffset[offset] > _maxEvents) {
		_maxEvents = _eventsInOffset[offset];
		[self setNeedsLayout];
	}
}

@end
