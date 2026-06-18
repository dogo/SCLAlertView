//
//  SCLAlertViewImageEffectsTests.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"
#import "UIImage+ImageEffects.h"

@interface SCLAlertViewImageEffectsTests : SCLAlertViewTestCase
@end

@implementation SCLAlertViewImageEffectsTests

- (UIImage *)testImage
{
    CGSize size = CGSizeMake(8.0f, 8.0f);
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0f);
    [UIColor.redColor setFill];
    UIRectFill(CGRectMake(0.0f, 0.0f, 4.0f, 8.0f));
    [UIColor.blueColor setFill];
    UIRectFill(CGRectMake(4.0f, 0.0f, 4.0f, 8.0f));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)assertImage:(UIImage *)image matchesSize:(CGSize)size
{
    XCTAssertNotNil(image);
    XCTAssertEqualWithAccuracy(image.size.width, size.width, 0.001f);
    XCTAssertEqualWithAccuracy(image.size.height, size.height, 0.001f);
}

- (void)testImageWithColorCreatesOnePointImage
{
    UIImage *image = [UIImage imageWithColor:UIColor.greenColor];

    [self assertImage:image matchesSize:CGSizeMake(1.0f, 1.0f)];
}

- (void)testConvertViewToImageHandlesNilAndInvalidViews
{
    XCTAssertNil([UIImage convertViewToImage:nil]);

    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    XCTAssertNil([UIImage convertViewToImage:zeroSizeView]);
}

- (void)testConvertViewToImageCapturesValidView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 10.0f)];
    view.backgroundColor = UIColor.orangeColor;

    UIImage *image = [UIImage convertViewToImage:view];

    [self assertImage:image matchesSize:view.bounds.size];
}

- (void)testPresetEffectsReturnImages
{
    UIImage *image = [self testImage];

    [self assertImage:[image applyLightEffect] matchesSize:image.size];
    [self assertImage:[image applyExtraLightEffect] matchesSize:image.size];
    [self assertImage:[image applyDarkEffect] matchesSize:image.size];
}

- (void)testTintEffectSupportsRGBAndWhiteColors
{
    UIImage *image = [self testImage];

    [self assertImage:[image applyTintEffectWithColor:UIColor.purpleColor] matchesSize:image.size];
    [self assertImage:[image applyTintEffectWithColor:UIColor.whiteColor] matchesSize:image.size];
}

- (void)testBlurSupportsNoBlurTintOnlyAndMask
{
    UIImage *image = [self testImage];
    UIImage *mask = [UIImage imageWithColor:UIColor.blackColor];

    [self assertImage:[image applyBlurWithRadius:0.0f
                                      tintColor:UIColor.yellowColor
                          saturationDeltaFactor:1.0f
                                      maskImage:nil] matchesSize:image.size];
    [self assertImage:[image applyBlurWithRadius:2.0f
                                      tintColor:nil
                          saturationDeltaFactor:1.2f
                                      maskImage:mask] matchesSize:image.size];
}

@end
