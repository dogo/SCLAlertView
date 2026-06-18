//
//  SCLAlertViewLifecycleTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"
#import "SCLAlertView+WindowResolver.h"

@interface SCLAlertViewLifecycleTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewLifecycleTests

- (void)testUnsupportedCoderInitializerThrows
{
    NSCoder *coder = (NSCoder *)[NSNull null];
    XCTAssertThrows([[SCLAlertView alloc] initWithCoder:coder]);
}

- (void)testInitializersAndStatusBarAccessors
{
    SCLAlertView *widthAlert = [[SCLAlertView alloc] initWithWindowWidth:280.0f];
    SCLAlertView *newWindowAlert = [[SCLAlertView alloc] initWithNewWindowWidth:260.0f];

    widthAlert.statusBarHidden = YES;
    widthAlert.statusBarStyle = UIStatusBarStyleLightContent;

    XCTAssertNotNil(widthAlert.view);
    XCTAssertNotNil(newWindowAlert.view);
    XCTAssertTrue(widthAlert.prefersStatusBarHidden);
    XCTAssertEqual(widthAlert.preferredStatusBarStyle, UIStatusBarStyleLightContent);
    XCTAssertNotNil([SCLAlertView alertWithNewWindow]);
}

- (void)testWindowResolverReturnsResolvedViewOrFallback
{
    UIView *fallback = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    UIView *resolved = [SCLAlertView scl_resolveAppViewWithFallback:fallback];

    XCTAssertNotNil(resolved);
}

@end
