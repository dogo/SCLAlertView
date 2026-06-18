//
//  SCLAlertViewPresentationWrapperTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"
#import "SCLAlertViewStyleKit.h"

@interface SCLAlertViewPresentationWrapperTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewPresentationWrapperTests

- (void)testEditCustomAndWaitingShowWrappers
{
    UIViewController *viewController = [self presentingViewController];

    SCLAlertView *editAlert = [[SCLAlertView alloc] init];
    [editAlert showEdit:viewController title:@"Edit" subTitle:@"Body" closeButtonTitle:nil duration:0.0];
    XCTAssertEqualObjects(editAlert.labelTitle.text, @"Edit");
    [editAlert hideView];

    SCLAlertView *customAlert = [[SCLAlertView alloc] init];
    [customAlert showCustom:viewController
                      image:SCLAlertViewStyleKit.imageOfEdit
                      color:UIColor.magentaColor
                      title:@"Custom"
                   subTitle:@"Body"
           closeButtonTitle:nil
                   duration:0.0];
    XCTAssertEqualObjects(customAlert.labelTitle.text, @"Custom");
    [customAlert hideView];

    SCLAlertView *waitingAlert = [[SCLAlertView alloc] init];
    [waitingAlert showWaiting:viewController title:@"Wait" subTitle:@"Body" closeButtonTitle:nil duration:0.0];
    XCTAssertNotNil(waitingAlert.activityIndicatorView);
    [waitingAlert hideView];
}

- (void)testTransparentBackgroundAndTapOutsideDismissalConfiguration
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    alertView.backgroundViewColor = UIColor.cyanColor;
    alertView.backgroundType = SCLAlertViewBackgroundTransparent;
    alertView.shouldDismissOnTapOutside = YES;

    [alertView showSuccess:[self presentingViewController] title:@"Title" subTitle:@"Body" closeButtonTitle:nil duration:0.0];

    XCTAssertTrue(alertView.shouldDismissOnTapOutside);
    XCTAssertNoThrow([alertView handleTap:[[UITapGestureRecognizer alloc] init]]);
    [alertView hideView];
}

@end
