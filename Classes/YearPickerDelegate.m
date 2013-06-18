//
//  YearPickerDelegate.m
//  mClass
//
//  Created by 김규완 on 10. 12. 9..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YearPickerDelegate.h"


@implementation YearPickerDelegate

@synthesize pData;

- (id)init {
	self = [super init];
	if (self) {
		NSArray *viewArray = [[NSArray alloc] initWithObjects:@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",nil];
		self.pData = viewArray;
		[viewArray release];
	}
	
	return self;
}

- (void)dealloc
{
	[pData release];
	[super dealloc];
}

- (int)selectedYearIndex {
	NSLog(@"selectedYearIndex");
	int result = 0;
	
	int index = 0;
	for(NSString *item in pData) {
		if([item isEqualToString:@"2010"]) {
			result = index;
			break;
		}
		index++;
	}
	
	return result;
}


#pragma mark -
#pragma mark UIPickerView DataSource
/*
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return [CustomView viewWidth];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return [CustomView viewHeight];
}
*/

///
/// 각 컴포넌트(필드)에 로우 갯수

///
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [pData count];
}

///
/// 피커뷰 컴포넌트갯수 필드갯수.
///
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	NSLog(@"numberOfComponentsInPickerView");
	return 1;
}

#pragma mark -
#pragma mark UIPickerView delegate
///
/// viewForRow가 정의 되어 있다면 구현할 필요가 없다. 각 필드의 로우에 출력될 텍스트를 리턴한다.
///
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSLog(@"pickerView:pickerView titleForRow: forComponent:");
	return [pData objectAtIndex:row];
	
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	//[appDelegate.currentBlog setValue:[recentItems objectAtIndex:row] forKey:kPostsDownloadCount];
	NSLog(@"didSelectedRow");
}


@end
