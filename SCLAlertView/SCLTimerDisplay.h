//
//  SCLTimerDisplay.h
//  SCLAlertView
//
//  Created by Taylor Ryan on 8/18/15.
//  Copyright (c) 2015-2025 AnyKey Entertainment. All rights reserved.
//
//  Taken from https://stackoverflow.com/questions/11783439/uibutton-with-timer

#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
#else
#import <UIKit/UIKit.h>
#endif
#import "SCLButton.h"

@interface SCLTimerDisplay : UIView {
    CGFloat currentAngle;
    CGFloat currentTime;
    CGFloat timerLimit;
    CGFloat radius;
    CGFloat lineWidth;
    NSTimer *timer;
    SCLActionBlock completedBlock;

    // Precision/state
    CFTimeInterval startTime;
    CFTimeInterval pausedElapsed;
    BOOL running;
}

/// Current angle (in degrees or radians depending on implementation).
@property CGFloat currentAngle;

/// Index of the button this timer is attached to.
@property NSInteger buttonIndex;

/// Stroke color for the circular timer.
@property (strong, nonatomic) UIColor *color;

/// If YES, timer runs in reverse (countdown).
@property (assign, nonatomic) BOOL reverse;

/**
 Initializes a circular timer view.

 @param origin The origin point for the view.
 @param r The radius of the circular timer.
 @return An initialized SCLTimerDisplay instance.
 */
- (instancetype)initWithOrigin:(CGPoint)origin radius:(CGFloat)r;

/**
 Initializes a circular timer view with custom line width.

 @param origin The origin point for the view.
 @param r The radius of the circular timer.
 @param width The stroke line width.
 @return An initialized SCLTimerDisplay instance.
 */
- (instancetype)initWithOrigin:(CGPoint)origin radius:(CGFloat)r lineWidth:(CGFloat)width;

/**
 Updates the frame/layout of the timer to fit a given size.

 @param size The new size to fit.
 */
- (void)updateFrame:(CGSize)size;

/**
 Cancels and removes the timer, preventing completion from firing.
 */
- (void)cancelTimer;

/**
 Stops the timer without removing the view.
 */
- (void)stopTimer;

/**
 Starts the timer with a time limit.

 @param tl The time limit in seconds.
 @param completed A block called when the timer completes.
 */
- (void)startTimerWithTimeLimit:(int)tl completed:(SCLActionBlock)completed;

/**
 Pauses the timer.

 @note Kept for API compatibility; optional usage.
 */
- (void)pauseTimer;

/**
 Resumes the timer after a pause.

 @note Kept for API compatibility; optional usage.
 */
- (void)resumeTimer;

@end
