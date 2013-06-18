//
//  SettingProperties.h
//  SmartLMS
//
//  Created by 김규완 on 11. 2. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kTermYearKey	@"termYear"
#define kTermCodeKey	@"termCode"

@interface SettingProperties : NSObject<NSCoding, NSCopying> {

}

@property (nonatomic, retain) NSString *termYear;
@property (nonatomic, retain) NSString *termCode;

@end
