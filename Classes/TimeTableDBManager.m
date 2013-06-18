//
//  TimeTableDBManager.m
//  SmartLMS
//
//  Created by 김 규완 on 11. 7. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "TimeTableDBManager.h"
#import "SmartLMSAppDelegate.h"

@implementation TimeTableDBManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (TimeTable *)timeTable:(NSInteger)dayOfWeek period:(NSInteger)period {
    
    NSError *error = nil;
    NSManagedObjectContext *context = [[SmartLMSAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeTable" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *predicateString = [NSString stringWithFormat:@"dayOfWeek = %d and period = %d", dayOfWeek, period];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    
    
    TimeTable *timeTable = [[context executeFetchRequest:fetchRequest error:&error] lastObject];
    [fetchRequest release];
    
    return timeTable;
}

+ (NSArray *)weekdayData:(NSInteger)dayOfWeek {
    NSError *error = nil;
    NSManagedObjectContext *context = [[SmartLMSAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeTable" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *predicateString = [NSString stringWithFormat:@"dayOfWeek = %d", dayOfWeek];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    
    
    NSArray *timeTableData = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    return timeTableData;
}

+ (Boolean)insertTimeTable:(TimeTable *)timeTable {
    NSError *error = nil;
    NSManagedObjectContext *context = [[SmartLMSAppDelegate sharedAppDelegate] managedObjectContext];
    
    TimeTable *newTimeTable = [NSEntityDescription insertNewObjectForEntityForName:@"TimeTable" inManagedObjectContext:context];
    newTimeTable.title = timeTable.title;
    newTimeTable.period = timeTable.period;
    newTimeTable.dayOfWeek = timeTable.dayOfWeek;
    newTimeTable.classRoom = timeTable.classRoom;
    newTimeTable.professor = timeTable.professor;
    newTimeTable.color = timeTable.color;
    
    if(![context save:&error]) {
        NSLog(@"얼라 저장 못했네 : %@", [error localizedDescription]);
        context = nil;
        return NO;
    } else {
        NSLog(@"저장 되었습니다");
        context = nil;
        return YES;
    }
}

+ (Boolean)updateTimeTable:(TimeTable *)timeTable {
    
    //TimeTable *updateTimeTable = [self timeTable:[timeTable.dayOfWeek intValue] period:[timeTable.period intValue]];

    NSError *error = nil;
    NSManagedObjectContext *context = [[SmartLMSAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeTable" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *predicateString = [NSString stringWithFormat:@"dayOfWeek = %d and period = %d", [timeTable.dayOfWeek intValue], [timeTable.period intValue] ];
    NSLog(@"predicateString = %@", predicateString);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    TimeTable *updateTimeTable = [[context executeFetchRequest:fetchRequest error:&error] lastObject];
    [fetchRequest release];
        
    updateTimeTable.title = timeTable.title;
    updateTimeTable.color = timeTable.color;
    updateTimeTable.professor = timeTable.professor;
    //[updateTimeTable setValue:@"산학협력관1" forKey:@"classRoom"];
    //updateTimeTable.classRoom = @"산학협력관ㅎ";
    NSLog(@"classRoom = %@", updateTimeTable.classRoom);
    
    if(![context save:&error]){
        NSLog(@"얼라 저장 못했네 : %@", [error localizedDescription]);
        context = nil;
        return NO;
    } else {
        context = nil;
        return YES;
    }
}

+ (Boolean)deleteTimeTable:(TimeTable *)timeTable {
    
    NSError *error = nil;
    NSManagedObjectContext *context = [[SmartLMSAppDelegate sharedAppDelegate] managedObjectContext];
    
    [context deleteObject:timeTable];
    
    if(![context save:&error]){
        NSLog(@"얼라 저장 못했네 : %@", [error localizedDescription]);
        context = nil;
        return NO;
    } else {
        return YES;
    }

}

@end
