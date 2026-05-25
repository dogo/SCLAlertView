//
//  SCLAlertViewPresentationTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"
#import "SCLAlertViewResponder.h"

@interface SCLAlertViewPresentationTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewPresentationTests

- (void)testDefaultInitializerConfiguresVisibleDefaults
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];

    XCTAssertNotNil(alertView.labelTitle);
    XCTAssertNotNil(alertView.viewText);
    XCTAssertEqual(alertView.showAnimationType, SCLAlertViewShowAnimationSlideInFromTop);
    XCTAssertEqual(alertView.hideAnimationType, SCLAlertViewHideAnimationFadeOut);
    XCTAssertEqual(alertView.backgroundType, SCLAlertViewBackgroundShadow);
    XCTAssertTrue(alertView.tintTopCircle);
    XCTAssertFalse(alertView.shouldDismissOnTapOutside);
    XCTAssertNil(alertView.view.superview);
}

- (void)testCustomWidthControlsInitialButtonWidth
{
    SCLAlertView *alertView = [[SCLAlertView alloc] initWithWidth:300.0f];

    SCLButton *button = [alertView addButton:@"Continue" actionBlock:^{
    }];

    XCTAssertEqualWithAccuracy(button.frame.size.width, 276.0f, 0.001f);
}

- (void)testFontSettersApplyToExistingLabelsAndFutureButtons
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];

    [alertView setTitleFontFamily:@"HelveticaNeue-Bold" withSize:24.0f];
    [alertView setBodyTextFontFamily:@"HelveticaNeue-Italic" withSize:16.0f];
    [alertView setButtonsTextFontFamily:@"HelveticaNeue-Light" withSize:18.0f];
    SCLButton *button = [alertView addButton:@"OK" actionBlock:^{
    }];

    XCTAssertEqualWithAccuracy(alertView.labelTitle.font.pointSize, 24.0f, 0.001f);
    XCTAssertEqualObjects(alertView.labelTitle.font.fontName, @"HelveticaNeue-Bold");
    XCTAssertEqualWithAccuracy(alertView.viewText.font.pointSize, 16.0f, 0.001f);
    XCTAssertEqualObjects(alertView.viewText.font.fontName, @"HelveticaNeue-Italic");
    XCTAssertEqualWithAccuracy(button.titleLabel.font.pointSize, 18.0f, 0.001f);
}

- (void)testShowSuccessConfiguresTitleSubtitleVisibilityAndDismissCallback
{
    UIViewController *viewController = [self presentingViewController];
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    __block NSUInteger dismissCount = 0;
    [alertView alertIsDismissed:^{
        dismissCount += 1;
    }];

    [alertView showSuccess:viewController title:@"Saved" subTitle:@"Done" closeButtonTitle:@"OK" duration:0.0];

    XCTAssertTrue([alertView isVisible]);
    XCTAssertEqualObjects(alertView.labelTitle.text, @"Saved");
    XCTAssertEqualObjects(alertView.viewText.text, @"Done");
    XCTAssertEqual(alertView.parentViewController, viewController);
    XCTAssertEqual([self buttonsInView:alertView.view].count, 1U);

    [alertView hideView];

    XCTAssertEqual(dismissCount, 1U);
}

- (void)testShowWithoutTitleRemovesTitleLabel
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];

    [alertView showInfo:[self presentingViewController] title:@"  " subTitle:@"Body" closeButtonTitle:nil duration:0.0];

    XCTAssertNil(alertView.labelTitle);
    XCTAssertEqualObjects(alertView.viewText.text, @"Body");

    [alertView hideView];
}

- (void)testShowWithoutSubtitleRemovesBodyText
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];

    [alertView showWarning:[self presentingViewController] title:@"Warning" subTitle:@"\n" closeButtonTitle:nil duration:0.0];

    XCTAssertEqualObjects(alertView.labelTitle.text, @"Warning");
    XCTAssertNil(alertView.viewText);

    [alertView hideView];
}

- (void)testAttributedFormatBlockIsAppliedWhenShowingSubtitle
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    alertView.attributedFormatBlock = ^NSAttributedString *(NSString *value) {
        return [[NSAttributedString alloc] initWithString:value attributes:@{
            NSForegroundColorAttributeName: UIColor.redColor
        }];
    };

    [alertView showNotice:[self presentingViewController] title:@"Notice" subTitle:@"Body" closeButtonTitle:nil duration:0.0];

    UIColor *color = [alertView.viewText.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertEqualObjects(color, UIColor.redColor);

    [alertView hideView];
}

- (void)testButtonFormatBlockIsAppliedDuringShow
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    alertView.buttonFormatBlock = ^NSDictionary *{
        return @{
            @"backgroundColor": UIColor.blackColor,
            @"textColor": UIColor.yellowColor,
            @"borderWidth": @1.0f,
            @"borderColor": UIColor.redColor
        };
    };
    SCLButton *button = [alertView addButton:@"Custom" actionBlock:^{
    }];

    [alertView showQuestion:[self presentingViewController] title:@"Question" subTitle:@"Body" closeButtonTitle:nil duration:0.0];

    XCTAssertEqualObjects(button.defaultBackgroundColor, UIColor.blackColor);
    XCTAssertEqualObjects([button titleColorForState:UIControlStateNormal], UIColor.yellowColor);
    XCTAssertEqualWithAccuracy(button.layer.borderWidth, 1.0f, 0.001f);
    XCTAssertEqual(button.layer.borderColor, UIColor.redColor.CGColor);

    [alertView hideView];
}

- (void)testCompleteButtonFormatBlockIsAppliedToCloseButton
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    alertView.completeButtonFormatBlock = ^NSDictionary *{
        return @{
            @"backgroundColor": UIColor.grayColor,
            @"textColor": UIColor.whiteColor
        };
    };

    [alertView showError:[self presentingViewController] title:@"Error" subTitle:@"Body" closeButtonTitle:@"Close" duration:0.0];

    SCLButton *button = [self buttonsInView:alertView.view].firstObject;
    XCTAssertEqualObjects(button.defaultBackgroundColor, UIColor.grayColor);
    XCTAssertEqualObjects([button titleColorForState:UIControlStateNormal], UIColor.whiteColor);

    [alertView hideView];
}

- (void)testButtonTimerClampsOutOfRangeIndex
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    [alertView addButton:@"OK" actionBlock:^{
    }];
    [alertView addTimerToButtonIndex:NSIntegerMax reverse:YES];

    XCTAssertNoThrow([alertView showSuccess:[self presentingViewController]
                                      title:@"Saved"
                                   subTitle:@"Done"
                           closeButtonTitle:nil
                                   duration:1.0]);
    [alertView hideView];
}

- (void)testButtonTimerBeforeButtonsIsIgnored
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];

    XCTAssertNoThrow([alertView addTimerToButtonIndex:0 reverse:NO]);
    XCTAssertNoThrow([alertView showSuccess:[self presentingViewController]
                                      title:@"Saved"
                                   subTitle:@"Done"
                           closeButtonTitle:nil
                                   duration:1.0]);
    [alertView hideView];
}

- (void)testResponderUpdatesAlertAndClosesIt
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    [alertView showSuccess:[self presentingViewController] title:@"Old" subTitle:@"Old body" closeButtonTitle:nil duration:0.0];
    SCLAlertViewResponder *responder = [[SCLAlertViewResponder alloc] init:alertView];

    [responder setTitle:@"New"];
    [responder setSubTitle:@"New body"];

    XCTAssertEqualObjects(alertView.labelTitle.text, @"New");
    XCTAssertEqualObjects(alertView.viewText.text, @"New body");

    [responder close];
    XCTAssertFalse([alertView isVisible]);
}

@end
