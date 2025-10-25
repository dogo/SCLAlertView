//
//  SCLAlertViewResponder.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLAlertView.h"

@interface SCLAlertViewResponder : NSObject

/// Initializes the responder associated with an instance of SCLAlertView.
- (instancetype)init:(SCLAlertView *)alertview;

/// Updates the alert's title.
- (void)setTitle:(NSString *)title;

/// Updates the alert's subtitle / body text.
- (void)setSubTitle:(NSString *)subTitle;

/// Closes the alert.
- (void)close;

@end
