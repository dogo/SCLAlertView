//
//  SCLAlertViewLayoutAndKeyboardTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"

@interface SCLAlertViewLayoutAndKeyboardTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewLayoutAndKeyboardTests

- (void)testLargerIconLayoutWithHorizontalButtons
{
    SCLAlertView *alertView = [[SCLAlertView alloc] initWithWidth:280.0f];
    alertView.useLargerIcon = YES;
    alertView.horizontalButtons = YES;
    [alertView addButton:@"One" actionBlock:^{
    }];
    [alertView addButton:@"Two" actionBlock:^{
    }];

    [alertView showSuccess:[self presentingViewController] title:@"Title" subTitle:@"Body" closeButtonTitle:nil duration:0.0];
    [alertView viewWillLayoutSubviews];

    NSArray<SCLButton *> *buttons = [self buttonsInView:alertView.view];
    XCTAssertEqual(buttons.count, 2U);
    XCTAssertLessThan(buttons.firstObject.frame.origin.x, buttons.lastObject.frame.origin.x);

    [alertView hideView];
}

- (void)testKeyboardNotificationsMoveAndRestoreAlertContent
{
    UIViewController *viewController = [self presentingViewController];
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    [alertView addTextField:@"Name" setDefaultText:nil];
    [alertView showSuccess:viewController title:@"Title" subTitle:@"Body" closeButtonTitle:nil duration:0.0];
    [alertView viewWillLayoutSubviews];

    NSDictionary *showUserInfo = @{
        UIKeyboardAnimationDurationUserInfoKey: @0.0,
        UIKeyboardAnimationCurveUserInfoKey: @(UIViewAnimationCurveLinear),
        UIKeyboardFrameEndUserInfoKey: [NSValue valueWithCGRect:CGRectMake(0.0f, 120.0f, 320.0f, 360.0f)]
    };
    NSNotification *showNotification = [NSNotification notificationWithName:UIKeyboardWillShowNotification
                                                                     object:nil
                                                                   userInfo:showUserInfo];
    NSNotification *hideNotification = [NSNotification notificationWithName:UIKeyboardWillHideNotification
                                                                     object:nil
                                                                   userInfo:showUserInfo];

    XCTAssertNoThrow([alertView keyboardWillShow:showNotification]);
    XCTAssertNoThrow([alertView keyboardWillHide:hideNotification]);

    [alertView hideView];
}

@end
