//
//  SCLAlertViewButtonTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"

@interface SCLAlertViewButtonTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewButtonTests

- (void)testButtonActionBlockRunsWhenTapped
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    __block NSUInteger actionCount = 0;
    SCLButton *button = [alertView addButton:@"Run" actionBlock:^{
        actionCount += 1;
    }];

    [button sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(actionCount, 1U);
}

- (void)testValidationBlockCanPreventAction
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    __block NSUInteger validationCount = 0;
    __block NSUInteger actionCount = 0;
    SCLButton *button = [alertView addButton:@"Save" validationBlock:^BOOL{
        validationCount += 1;
        return NO;
    } actionBlock:^{
        actionCount += 1;
    }];

    [button sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(validationCount, 1U);
    XCTAssertEqual(actionCount, 0U);
}

- (void)testValidationBlockAllowsAction
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    __block NSUInteger actionCount = 0;
    SCLButton *button = [alertView addButton:@"Save" validationBlock:^BOOL{
        return YES;
    } actionBlock:^{
        actionCount += 1;
    }];

    [button sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(actionCount, 1U);
}

- (void)testSelectorButtonSendsActionToTarget
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    SCLAlertViewTestTarget *target = [[SCLAlertViewTestTarget alloc] init];
    SCLButton *button = [alertView addButton:@"Target" target:target selector:@selector(performAction)];

    [button sendActionsForControlEvents:UIControlEventTouchUpInside];

    XCTAssertEqual(target.actionCount, 1U);
}

- (void)testButtonParseConfigAppliesSupportedKeys
{
    SCLButton *button = [[SCLButton alloc] initWithWindowWidth:240.0f];
    UIFont *font = [UIFont systemFontOfSize:19.0f weight:UIFontWeightBold];

    [button parseConfig:@{
        @"backgroundColor": UIColor.blueColor,
        @"textColor": UIColor.whiteColor,
        @"cornerRadius": @7.0f,
        @"borderWidth": @2.0f,
        @"borderColor": UIColor.greenColor,
        @"font": font
    }];

    XCTAssertEqualObjects(button.defaultBackgroundColor, UIColor.blueColor);
    XCTAssertEqualObjects([button titleColorForState:UIControlStateNormal], UIColor.whiteColor);
    XCTAssertEqualWithAccuracy(button.layer.cornerRadius, 7.0f, 0.001f);
    XCTAssertEqualWithAccuracy(button.layer.borderWidth, 2.0f, 0.001f);
    XCTAssertEqual(button.layer.borderColor, UIColor.greenColor.CGColor);
    XCTAssertEqualObjects(button.titleLabel.font, font);
}

- (void)testButtonHighlightUsesDarkerDefaultBackgroundColor
{
    SCLButton *button = [[SCLButton alloc] initWithWindowWidth:240.0f];
    button.defaultBackgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];

    button.highlighted = YES;
    UIColor *highlightedColor = button.backgroundColor;
    button.highlighted = NO;

    XCTAssertNotEqualObjects(highlightedColor, button.defaultBackgroundColor);
    XCTAssertEqualObjects(button.backgroundColor, button.defaultBackgroundColor);
}

- (void)testButtonWidthAdjustmentHandlesZeroButtons
{
    SCLButton *button = [[SCLButton alloc] initWithWindowWidth:240.0f];

    XCTAssertNoThrow([button adjustWidthWithWindowWidth:240.0f numberOfButtons:0]);
    XCTAssertEqualWithAccuracy(button.frame.size.width, 216.0f, 0.001f);
    XCTAssertEqualWithAccuracy(button.frame.size.height, 35.0f, 0.001f);
}

@end
