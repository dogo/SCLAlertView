//
//  SCLTimerDisplayTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"
#import "SCLTimerDisplay.h"

@interface SCLTimerDisplayTests : SCLAlertViewTestCase
@end

@implementation SCLTimerDisplayTests

- (void)testInitializersConfigureTimerView
{
    SCLTimerDisplay *frameTimer = [[SCLTimerDisplay alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    SCLTimerDisplay *originTimer = [[SCLTimerDisplay alloc] initWithOrigin:CGPointMake(2.0f, 3.0f) radius:10.0f];

    XCTAssertEqualObjects(frameTimer.backgroundColor, UIColor.clearColor);
    XCTAssertEqualWithAccuracy(originTimer.frame.origin.x, 2.0f, 0.001f);
    XCTAssertEqualWithAccuracy(originTimer.frame.origin.y, 3.0f, 0.001f);
    XCTAssertEqualWithAccuracy(originTimer.frame.size.width, 20.0f, 0.001f);
    XCTAssertEqualObjects(originTimer.color, UIColor.whiteColor);
}

- (void)testUpdateFramePositionsTimerAtTrailingEdge
{
    SCLTimerDisplay *timer = [[SCLTimerDisplay alloc] initWithOrigin:CGPointZero radius:13.0f lineWidth:4.0f];

    [timer updateFrame:CGSizeMake(120.0f, 40.0f)];

    XCTAssertEqualWithAccuracy(timer.frame.origin.x, 89.0f, 0.001f);
    XCTAssertEqualWithAccuracy(timer.frame.origin.y, 7.0f, 0.001f);
}

- (void)testDrawRectHandlesForwardAndReverseModes
{
    SCLTimerDisplay *timer = [[SCLTimerDisplay alloc] initWithOrigin:CGPointZero radius:13.0f lineWidth:4.0f];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(32.0f, 32.0f), NO, 1.0f);
    XCTAssertNoThrow([timer drawRect:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)]);
    timer.reverse = YES;
    XCTAssertNoThrow([timer drawRect:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)]);
    UIGraphicsEndImageContext();
}

- (void)testStopTimerInvokesCompletionOnce
{
    SCLTimerDisplay *timer = [[SCLTimerDisplay alloc] initWithOrigin:CGPointZero radius:13.0f lineWidth:4.0f];
    __block NSUInteger completionCount = 0;

    [timer startTimerWithTimeLimit:10 completed:^{
        completionCount += 1;
    }];
    [timer stopTimer];
    [timer stopTimer];

    XCTAssertEqual(completionCount, 1U);
}

- (void)testPauseResumeAndCancelAreSafe
{
    SCLTimerDisplay *timer = [[SCLTimerDisplay alloc] initWithOrigin:CGPointZero radius:13.0f lineWidth:4.0f];

    [timer pauseTimer];
    [timer resumeTimer];
    [timer startTimerWithTimeLimit:10 completed:^{
    }];
    [timer pauseTimer];
    [timer resumeTimer];
    [timer cancelTimer];

    XCTAssertNotNil(timer);
}

@end
