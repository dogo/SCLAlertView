//
//  SCLAlertViewStyleKitTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"
#import "SCLAlertViewStyleKit.h"

@interface SCLAlertViewStyleKitTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewStyleKitTests

- (void)assertStyleImageIsRenderable:(UIImage *)image
{
    XCTAssertNotNil(image);
    XCTAssertGreaterThan(image.size.width, 0.0f);
    XCTAssertGreaterThan(image.size.height, 0.0f);
    XCTAssertTrue(image.CGImage != nil);
}

- (void)testAllStyleImagesAreRenderable
{
    [self assertStyleImageIsRenderable:SCLAlertViewStyleKit.imageOfCheckmark];
    [self assertStyleImageIsRenderable:SCLAlertViewStyleKit.imageOfCross];
    [self assertStyleImageIsRenderable:SCLAlertViewStyleKit.imageOfNotice];
    [self assertStyleImageIsRenderable:SCLAlertViewStyleKit.imageOfWarning];
    [self assertStyleImageIsRenderable:SCLAlertViewStyleKit.imageOfInfo];
    [self assertStyleImageIsRenderable:SCLAlertViewStyleKit.imageOfEdit];
    [self assertStyleImageIsRenderable:SCLAlertViewStyleKit.imageOfQuestion];
}

- (void)testDrawEditCanRenderInCurrentContext
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(80.0f, 80.0f), NO, 1.0f);

    XCTAssertNoThrow([SCLAlertViewStyleKit drawEdit]);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    XCTAssertNotNil(image);
}

@end
