//
//  SCLAlertViewStyleKit.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCLAlertViewStyleKit : NSObject

// Images
+ (UIImage*)imageOfCheckmark;
+ (UIImage*)imageOfCross;
+ (UIImage*)imageOfNotice;
+ (UIImage*)imageOfWarning;
+ (UIImage*)imageOfInfo;
+ (UIImage*)imageOfEdit;


+ (void)drawCheckmark;
+ (void)drawCross;
+ (void)drawNotice;
+ (void)drawWarning;
+ (void)drawInfo;
+ (void)drawEdit;

@end
