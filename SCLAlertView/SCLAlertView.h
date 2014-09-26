//
//  SCLAlertView.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLButton.h"

@interface SCLAlertView : UIViewController

// Pop Up Styles
typedef NS_ENUM(NSInteger, SCLAlertViewStyle)
{
    Success,
    Error,
    Notice,
    Warning,
    Info,
    Edit
};


@property UILabel *labelTitle;
@property UITextView *viewText;


- (void)hideView;

- (UITextField *)addTextField:(NSString *)title;

- (SCLButton *)addButton:(NSString *)title action:(SEL)action;
- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector;

- (void)showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)showError:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)showNotice:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)showWarning:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)showInfo:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)showEdit:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)showTitle:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;


@end
