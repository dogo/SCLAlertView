//
//  SCLAlertView.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLButton.h"

typedef NSAttributedString* (^SCLAttributedFormatBlock)(NSString *value);

@interface SCLAlertView : UIViewController

/** Alert Styles
 *
 * TODO
 */
typedef NS_ENUM(NSInteger, SCLAlertViewStyle)
{
    Success,
    Error,
    Notice,
    Warning,
    Info,
    Edit
};

/** Title Label
 *
 * TODO
 */
@property UILabel *labelTitle;

/** Text view with the body message
 *
 * TODO
 */
@property UITextView *viewText;

/** Dismiss on tap outside
 *
 * A boolean value that determines whether to dismiss when tapping outside the SCLAlertView.
 * (Default = NO)
 */
@property (nonatomic, assign) BOOL shouldDismissOnTapOutside;

/** Sound URL
 *
 * Holds the sound NSURL path.
 */
@property (nonatomic, strong) NSURL *soundURL;

/** Set text attributed format block
 *
 * Holds the attributed string.
 */
@property (nonatomic, copy) SCLAttributedFormatBlock attributedFormatBlock;

/** Hide SCLAlertView
 *
 * TODO
 */
- (void)hideView;

/** Add Text Field
 *
 * TODO
 */
- (UITextField *)addTextField:(NSString *)title;

/** Add Button
 *
 * TODO
 */
- (SCLButton *)addButton:(NSString *)title actionBlock:(ActionBlock)action;

/** Add Button
 *
 * TODO
 */
- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector;

/** Show Success SCLAlertView
 *
 * TODO
 */
- (void)showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Error SCLAlertView
 *
 * TODO
 */
- (void)showError:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Notice SCLAlertView
 *
 * TODO
 */
- (void)showNotice:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Warning SCLAlertView
 *
 * TODO
 */
- (void)showWarning:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Info SCLAlertView
 *
 * TODO
 */
- (void)showInfo:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Edit SCLAlertView
 *
 * TODO
 */
- (void)showEdit:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Title SCLAlertView
 *
 * TODO
 */
- (void)showTitle:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;


@end
