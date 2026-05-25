//
//  SCLAlertViewBuilderTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"

@interface SCLAlertViewBuilderTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewBuilderTests

- (void)testBuilderAppliesPropertiesAndAddsContent
{
    SCLAlertViewBuilder *builder = [[SCLAlertViewBuilder alloc] init];
    builder.cornerRadius(9.0f)
           .tintTopCircle(NO)
           .statusBarHidden(YES)
           .statusBarStyle(UIStatusBarStyleLightContent)
           .addTextField(@"Name", @"Diogo")
           .addSwitchViewWithLabelTitle(@"Enabled")
           .addButtonWithActionBlock(@"OK", ^{
           });

    XCTAssertEqualWithAccuracy(builder.alertView.cornerRadius, 9.0f, 0.001f);
    XCTAssertFalse(builder.alertView.tintTopCircle);
    XCTAssertTrue(builder.alertView.statusBarHidden);
    XCTAssertEqual(builder.alertView.statusBarStyle, UIStatusBarStyleLightContent);
    XCTAssertEqual([self buttonsInView:builder.alertView.view].count, 1U);
}

- (void)testButtonBuilderCreatesButtonAndExposesIt
{
    SCLAlertViewBuilder *alertBuilder = [[SCLAlertViewBuilder alloc] init];
    SCLALertViewButtonBuilder *buttonBuilder = [[SCLALertViewButtonBuilder alloc] init];
    __block NSUInteger actionCount = 0;

    buttonBuilder.title(@"Save").actionBlock(^{
        actionCount += 1;
    });
    alertBuilder.addButtonWithBuilder(buttonBuilder);

    XCTAssertNotNil(buttonBuilder.button);
    [buttonBuilder.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqual(actionCount, 1U);
}

- (void)testTextFieldBuilderCreatesTextFieldAndExposesIt
{
    SCLAlertViewBuilder *alertBuilder = [[SCLAlertViewBuilder alloc] init];
    SCLALertViewTextFieldBuilder *textFieldBuilder = [[SCLALertViewTextFieldBuilder alloc] init];

    textFieldBuilder.title(@"Email");
    alertBuilder.addTextFieldWithBuilder(textFieldBuilder);

    XCTAssertNotNil(textFieldBuilder.textField);
    XCTAssertEqualObjects(textFieldBuilder.textField.placeholder, @"Email");
}

- (void)testShowBuilderStoresParametersAndCanShowAlert
{
    SCLAlertViewShowBuilder *showBuilder = [[SCLAlertViewShowBuilder alloc] init];
    UIViewController *viewController = [self presentingViewController];
    SCLAlertView *alertView = [[SCLAlertView alloc] init];

    showBuilder.viewController(viewController)
               .title(@"Hello")
               .subTitle(@"World")
               .style(SCLAlertViewStyleSuccess)
               .closeButtonTitle(@"OK")
               .duration(0.0);
    [showBuilder showAlertView:alertView];

    XCTAssertEqual(showBuilder.parameterViewController, viewController);
    XCTAssertEqualObjects(showBuilder.parameterTitle, @"Hello");
    XCTAssertEqualObjects(alertView.labelTitle.text, @"Hello");
    XCTAssertEqualObjects(alertView.viewText.text, @"World");
    XCTAssertTrue([alertView isVisible]);

    [alertView hideView];
}

@end
