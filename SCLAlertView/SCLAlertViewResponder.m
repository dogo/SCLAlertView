//
//  SCLAlertViewResponder.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertViewResponder.h"

@interface SCLAlertViewResponder ()

// Weak reference to the alert to avoid retain cycles. Valid while the alert is alive.
@property (weak, nonatomic) SCLAlertView *alertview;

@end

@implementation SCLAlertViewResponder

// Binds the responder to a presented alert, enabling title/subtitle updates and dismissal.
- (instancetype)init:(SCLAlertView *)alertview
{
    self = [super init];
    if (self) {
        self.alertview = alertview;
    }
    return self;
}

// Updates the alert title (useful for async state changes).
- (void)setTitle:(NSString *)title
{
    self.alertview.labelTitle.text = title;
}

// Updates the alert subtitle/body text.
- (void)setSubTitle:(NSString *)subTitle
{
    self.alertview.viewText.text = subTitle;
}

// Dismisses the alert using its configured animation.
- (void)close
{
    [self.alertview hideView];
}

@end
