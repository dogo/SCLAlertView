//
//  SCLAlertViewTestHelpers.m
//  SCLAlertViewTests
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewTestHelpers.h"

@implementation SCLAlertViewTestCase
{
    BOOL _animationsWereEnabled;
}

- (void)setUp
{
    [super setUp];
    _animationsWereEnabled = UIView.areAnimationsEnabled;
    [UIView setAnimationsEnabled:NO];
}

- (void)tearDown
{
    [UIView setAnimationsEnabled:_animationsWereEnabled];
    [super tearDown];
}

- (UIViewController *)presentingViewController
{
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    return viewController;
}

- (NSArray<SCLButton *> *)buttonsInView:(UIView *)view
{
    NSMutableArray<SCLButton *> *buttons = [NSMutableArray array];
    if ([view isKindOfClass:SCLButton.class]) {
        [buttons addObject:(SCLButton *)view];
    }
    for (UIView *subview in view.subviews) {
        [buttons addObjectsFromArray:[self buttonsInView:subview]];
    }
    return buttons;
}

@end

@implementation SCLAlertViewTestTarget

- (void)performAction
{
    self.actionCount += 1;
}

@end

@implementation SCLAlertViewTrackingTextField

- (BOOL)becomeFirstResponder
{
    self.becomeFirstResponderCount += 1;
    return YES;
}

- (BOOL)resignFirstResponder
{
    self.resignFirstResponderCount += 1;
    return YES;
}

@end
