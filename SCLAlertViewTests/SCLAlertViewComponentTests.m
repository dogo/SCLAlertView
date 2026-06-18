//
//  SCLAlertViewComponentTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"
#import "SCLTextView.h"
#import "SCLSwitchView.h"

@interface SCLAlertViewComponentTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewComponentTests

- (void)testSwitchDefaultInitializerAndLayout
{
    SCLSwitchView *switchView = [[SCLSwitchView alloc] init];
    switchView.frame = CGRectMake(0.0f, 0.0f, 180.0f, 40.0f);
    switchView.labelText = @"Enabled";

    [switchView layoutSubviews];

    XCTAssertEqualObjects(switchView.backgroundColor, UIColor.clearColor);
    XCTAssertGreaterThan([switchView sizeThatFits:CGSizeMake(180.0f, 0.0f)].width, 0.0f);
}

- (void)testAddTextFieldConfiguresTextAndReturnKeys
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];

    SCLTextView *first = [alertView addTextField:@"Email" setDefaultText:@"a@example.com"];
    SCLTextView *second = [alertView addTextField:@"Password" setDefaultText:nil];

    XCTAssertEqualObjects(first.placeholder, @"Email");
    XCTAssertEqualObjects(first.text, @"a@example.com");
    XCTAssertEqual((id)first.delegate, alertView);
    XCTAssertEqual(first.returnKeyType, UIReturnKeyNext);
    XCTAssertEqualObjects(second.placeholder, @"Password");
    XCTAssertEqual(second.returnKeyType, UIReturnKeyDone);
}

- (void)testAddCustomTextFieldUpdatesPreviousReturnKey
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    UITextField *first = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 35.0f)];
    UITextField *second = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 35.0f)];

    [alertView addCustomTextField:first];
    [alertView addCustomTextField:second];

    XCTAssertEqual(first.returnKeyType, UIReturnKeyNext);
    XCTAssertNotNil(first.superview);
    XCTAssertNotNil(second.superview);
}

- (void)testTextFieldReturnMovesFocusAndResignsLastField
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    SCLAlertViewTrackingTextField *first = [[SCLAlertViewTrackingTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 35.0f)];
    SCLAlertViewTrackingTextField *second = [[SCLAlertViewTrackingTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 35.0f)];
    [alertView addCustomTextField:first];
    [alertView addCustomTextField:second];

    XCTAssertFalse([alertView textFieldShouldReturn:first]);
    XCTAssertEqual(second.becomeFirstResponderCount, 1U);

    XCTAssertFalse([alertView textFieldShouldReturn:second]);
    XCTAssertEqual(second.resignFirstResponderCount, 1U);
}

- (void)testAddSwitchViewReturnsConfiguredSwitch
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];

    SCLSwitchView *switchView = [alertView addSwitchViewWithLabel:@"Remember me"];
    switchView.selected = YES;
    switchView.tintColor = UIColor.redColor;

    XCTAssertEqualObjects(switchView.labelText, @"Remember me");
    XCTAssertTrue(switchView.isSelected);
    XCTAssertEqualObjects(switchView.tintColor, UIColor.redColor);
    XCTAssertNotNil(switchView.superview);
}

- (void)testAddCustomViewReturnsSameAttachedView
{
    SCLAlertView *alertView = [[SCLAlertView alloc] init];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 25.0f)];

    UIView *returnedView = [alertView addCustomView:customView];

    XCTAssertEqual(returnedView, customView);
    XCTAssertNotNil(customView.superview);
}

- (void)testTextViewDefaultsAndSizing
{
    SCLTextView *textView = [[SCLTextView alloc] init];

    XCTAssertEqual(textView.borderStyle, UITextBorderStyleRoundedRect);
    XCTAssertEqual(textView.clearButtonMode, UITextFieldViewModeWhileEditing);
    XCTAssertEqual(textView.returnKeyType, UIReturnKeyDone);
    XCTAssertGreaterThanOrEqual(textView.frame.size.height, 35.0f);
    XCTAssertGreaterThanOrEqual([textView intrinsicContentSize].height, 35.0f);
    XCTAssertGreaterThanOrEqual([textView sizeThatFits:CGSizeMake(120.0f, 1.0f)].height, 35.0f);
}

- (void)testSwitchViewPropertiesRoundTrip
{
    SCLSwitchView *switchView = [[SCLSwitchView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 40.0f)];
    UIFont *font = [UIFont systemFontOfSize:13.0f];

    switchView.labelText = @"Enabled";
    switchView.labelColor = UIColor.purpleColor;
    switchView.labelFont = font;
    switchView.tintColor = UIColor.orangeColor;
    switchView.selected = YES;

    XCTAssertEqualObjects(switchView.labelText, @"Enabled");
    XCTAssertEqualObjects(switchView.labelColor, UIColor.purpleColor);
    XCTAssertEqualObjects(switchView.labelFont, font);
    XCTAssertEqualObjects(switchView.tintColor, UIColor.orangeColor);
    XCTAssertTrue(switchView.isSelected);
    XCTAssertGreaterThan([switchView sizeThatFits:CGSizeMake(200.0f, 0.0f)].height, 0.0f);
}

@end
