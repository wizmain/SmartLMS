//
//  CustomLectureCell.h
//  mClass
//
//  Created by 김규완 on 11. 4. 6..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  UITableViewCell 을 강좌목록테이블의 Custom Cell

#import <UIKit/UIKit.h>
#define CellIdentifier    @"CustomLectureCell"


@interface CustomLectureCell : UITableViewCell {
    UILabel *lectureTitle;          //강좌타이틀
    UILabel *lectureDetail;         //강좌상세
    UIImageView *lectureTitleImage; //강좌 대표 이미지
}


@property (nonatomic, retain) IBOutlet UILabel *lectureTitle;
@property (nonatomic, retain) IBOutlet UILabel *lectureDetail;
@property (nonatomic, retain) IBOutlet UIImageView *lectureTitleImage;

+ (id)cellWithNib;
@end
