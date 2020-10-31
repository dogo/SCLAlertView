//
//  UIViewController+Alert.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 31/10/20.
//  Copyright © 2020 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert)

typedef void (^ActionBlock)(void);

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message actionBlock:(nullable ActionBlock)actionBlock;

@end

NS_ASSUME_NONNULL_END
