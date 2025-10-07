//
//  UIViewController+Alert.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 31/10/20.
//  Copyright © 2020-2025 AnyKey Entertainment. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

#pragma mark - Alerts

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message actionBlock:(nullable ActionBlock)actionBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        if (actionBlock) {
            actionBlock();
        }
    }];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

@end
