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
 * Set SCLAlertView Style
 */
typedef NS_ENUM(NSInteger, SCLAlertViewStyle)
{
    Success,
    Error,
    Notice,
    Warning,
    Info,
    Edit,
    Custom
};

/** Alert hide animation styles
 *
 * Set SCLAlertView hide animation type.
 */
typedef NS_ENUM(NSInteger, SCLAlertViewAnimation)
{
    NoAnimation,
    FadeOut
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
 * (Default: NO)
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

/** Hide animation type
 *
 * Holds the hide animation type.
 * (Default: NoAnimation)
 */
@property (nonatomic) SCLAlertViewAnimation hideAnimationType;

/** Hide SCLAlertView
 *
 * Hide SCLAlertView removing from super view.
 */
- (void)hideView;

/** Hide SCLAlertView
 *
 * Hide SCLAlertView using animation.
 */
- (void)hideViewWithAnimation:(SCLAlertViewAnimation)animation;

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

/** Shows a custom SCLAlertView without using a predefined type, allowing for a custom image and color to be specified.
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param image A UIImage object to be used as the icon for the alert view.
 * @param color A UIColor object to be used to tint the background of the icon circle and the buttons.
 * @param title The title text of the alert view.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showCustom:(UIViewController *)vc image:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;


@end
