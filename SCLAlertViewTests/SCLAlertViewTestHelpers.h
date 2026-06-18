//
//  SCLAlertViewTestHelpers.h
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SCLAlertView.h"
#import "SCLButton.h"

@interface SCLAlertView (Tests) <UITextFieldDelegate>
- (instancetype)initWithWindowWidth:(CGFloat)windowWidth;
- (void)handleTap:(UITapGestureRecognizer *)gesture;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
@end

@interface SCLAlertViewTestCase : XCTestCase
- (UIViewController *)presentingViewController;
- (NSArray<SCLButton *> *)buttonsInView:(UIView *)view;
@end

@interface SCLAlertViewTestTarget : NSObject
@property (nonatomic) NSUInteger actionCount;
- (void)performAction;
@end

@interface SCLAlertViewTrackingTextField : UITextField
@property (nonatomic) NSUInteger becomeFirstResponderCount;
@property (nonatomic) NSUInteger resignFirstResponderCount;
@end
