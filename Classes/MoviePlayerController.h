//
//  MoviePlayerController.h
//  mClass
//
//  Created by 김규완 on 10. 12. 15..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class ApplyQuiz;

@interface MoviePlayerController : UIViewController {
	NSTimer *attendTimer;
	NSInteger lectureNo;
	NSInteger itemNo;
	MPMoviePlayerController *player;
    MPMoviePlayerViewController *playerView;
	BOOL isForceStoped;
	ApplyQuiz *applyQuiz;
    UIStatusBarStyle oldStatusBarStyle;
    NSString *subjID;
    NSInteger weekSeq;
    NSInteger orderSeq;
}

@property (nonatomic, retain) NSTimer *attendTimer;
@property (nonatomic, assign) NSInteger lectureNo;
@property (nonatomic, assign) NSInteger itemNo;
@property (nonatomic, retain) MPMoviePlayerController *player;
@property (nonatomic, retain) MPMoviePlayerViewController *playerView;
@property (nonatomic, assign) NSInteger weekSeq;
@property (nonatomic, assign) NSInteger orderSeq;
@property (nonatomic, retain) NSString *subjID;


- (void)attendLog;
- (void)startAttendTimer;
- (void)stopAttendTimer;


@end
