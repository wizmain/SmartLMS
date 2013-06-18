//
//  TimeTable.h
//  SmartLMS
//
//  Created by 김규완 on 11. 7. 7..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeTable : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * rowId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * classRoom;
@property (nonatomic, retain) NSString * professor;
@property (nonatomic, retain) NSNumber * dayOfWeek;
@property (nonatomic, retain) NSNumber * period;
@property (nonatomic, retain) NSNumber * color;

@end
