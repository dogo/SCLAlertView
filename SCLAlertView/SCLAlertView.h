//
//  SCLAlertView.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//

#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
#else
#import <UIKit/UIKit.h>
#endif
#import "SCLButton.h"
#import "SCLTextView.h"
#import "SCLSwitchView.h"

typedef NSAttributedString* (^SCLAttributedFormatBlock)(NSString *value);
typedef void (^SCLDismissBlock)(void);
typedef void (^SCLDismissAnimationCompletionBlock)(void);
typedef void (^SCLShowAnimationCompletionBlock)(void);
typedef void (^SCLForceHideBlock)(void);

@interface SCLAlertView : UIViewController 

/** Alert Styles
 *
 * Set SCLAlertView Style
 */
typedef NS_ENUM(NSInteger, SCLAlertViewStyle)
{
    SCLAlertViewStyleSuccess,
    SCLAlertViewStyleError,
    SCLAlertViewStyleNotice,
    SCLAlertViewStyleWarning,
    SCLAlertViewStyleInfo,
    SCLAlertViewStyleEdit,
    SCLAlertViewStyleWaiting,
    SCLAlertViewStyleQuestion,
    SCLAlertViewStyleCustom
};

/** Alert hide animation styles
 *
 * Set SCLAlertView hide animation type.
 */
typedef NS_ENUM(NSInteger, SCLAlertViewHideAnimation)
{
    SCLAlertViewHideAnimationFadeOut,
    SCLAlertViewHideAnimationSlideOutToBottom,
    SCLAlertViewHideAnimationSlideOutToTop,
    SCLAlertViewHideAnimationSlideOutToLeft,
    SCLAlertViewHideAnimationSlideOutToRight,
    SCLAlertViewHideAnimationSlideOutToCenter,
    SCLAlertViewHideAnimationSlideOutFromCenter,
    SCLAlertViewHideAnimationSimplyDisappear
};

/** Alert show animation styles
 *
 * Set SCLAlertView show animation type.
 */
typedef NS_ENUM(NSInteger, SCLAlertViewShowAnimation)
{
    SCLAlertViewShowAnimationFadeIn,
    SCLAlertViewShowAnimationSlideInFromBottom,
    SCLAlertViewShowAnimationSlideInFromTop,
    SCLAlertViewShowAnimationSlideInFromLeft,
    SCLAlertViewShowAnimationSlideInFromRight,
    SCLAlertViewShowAnimationSlideInFromCenter,
    SCLAlertViewShowAnimationSlideInToCenter,
    SCLAlertViewShowAnimationSimplyAppear
};

/** Alert background styles
 *
 * Set SCLAlertView background type.
 */
typedef NS_ENUM(NSInteger, SCLAlertViewBackground)
{
    SCLAlertViewBackgroundShadow,
    SCLAlertViewBackgroundBlur,
    SCLAlertViewBackgroundTransparent
};

/** Content view corner radius
 *
 * A float value that replaces the standard content viuew corner radius.
 */
@property CGFloat cornerRadius;

/** Tint top circle
 *
 * A boolean value that determines whether to tint the SCLAlertView top circle.
 * (Default: YES)
 */
@property (assign, nonatomic) BOOL tintTopCircle;

/** Use larger icon
 *
 * A boolean value that determines whether to make the SCLAlertView top circle icon larger.
 * (Default: NO)
 */
@property (assign, nonatomic) BOOL useLargerIcon;
    
/** Title Label
 *
 * The text displayed as title.
 */
@property (strong, nonatomic) UILabel *labelTitle;

/** Text view with the body message
 *
 * Holds the textview.
 */
@property (strong, nonatomic) UITextView *viewText;

/** Activity Indicator
 *
 * Holds the activityIndicator.
 */
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

/** Dismiss on tap outside
 *
 * A boolean value that determines whether to dismiss when tapping outside the SCLAlertView.
 * (Default: NO)
 */
@property (assign, nonatomic) BOOL shouldDismissOnTapOutside;

/** Sound URL
 *
 * Holds the sound NSURL path.
 */
@property (strong, nonatomic) NSURL *soundURL;

/** Set text attributed format block
 *
 * Holds the attributed string.
 */
@property (copy, nonatomic) SCLAttributedFormatBlock attributedFormatBlock;

/** Set Complete button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, borderWidth, borderColor, textColor
 */
@property (copy, nonatomic) CompleteButtonFormatBlock completeButtonFormatBlock;

/** Set button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, borderWidth, borderColor, textColor
 */
@property (copy, nonatomic) ButtonFormatBlock buttonFormatBlock;

/** Set force hide block.
 *
 * When set force hideview method invocation.
 */
@property (copy, nonatomic) SCLForceHideBlock forceHideBlock;

/** Hide animation type
 *
 * Holds the hide animation type.
 * (Default: FadeOut)
 */
@property (nonatomic) SCLAlertViewHideAnimation hideAnimationType;

/** Show animation type
 *
 * Holds the show animation type.
 * (Default: SlideInFromTop)
 */
@property (nonatomic) SCLAlertViewShowAnimation showAnimationType;

/** Set SCLAlertView background type.
 *
 * SCLAlertView background type.
 * (Default: Shadow)
 */
@property (nonatomic) SCLAlertViewBackground backgroundType;

/** Set custom color to SCLAlertView.
 *
 * SCLAlertView custom color.
 * (Buttons, top circle and borders)
 */
@property (strong, nonatomic) UIColor *customViewColor;

/** Set custom color to SCLAlertView background.
 *
 * SCLAlertView background custom color.
 */
@property (strong, nonatomic) UIColor *backgroundViewColor;

/** Set custom tint color for icon image.
 *
 * SCLAlertView icon tint color
 */
@property (strong, nonatomic) UIColor *iconTintColor;

/** Set custom circle icon height.
 *
 * Circle icon height
 */
@property (nonatomic) CGFloat circleIconHeight;

/** Set SCLAlertView extension bounds.
 *
 * Set new bounds (EXTENSION ONLY)
 */
@property (nonatomic) CGRect extensionBounds;

/** Set status bar hidden.
 *
 * Status bar hidden
 */
@property (nonatomic) BOOL statusBarHidden;

/** Set status bar style.
 *
 * Status bar style
 */
@property (nonatomic) UIStatusBarStyle statusBarStyle;

/** Set horizontal alignment for buttons
 *
 * Horizontal aligment instead of vertically if YES
 */
@property (nonatomic) BOOL horizontalButtons;

/** Initialize SCLAlertView using a new window.
 *
 * Init with new window
 */
- (instancetype)initWithNewWindow;

/** Initialize SCLAlertView using a new window.
 *
 * Init with new window with custom width
 */
- (instancetype)initWithNewWindowWidth:(CGFloat)windowWidth;

/** Warns that alerts is gone
 *
 * Warns that alerts is gone using block
 */
- (void)alertIsDismissed:(SCLDismissBlock)dismissBlock;

/** Warns that alerts dismiss animation is completed
 *
 * Warns that alerts dismiss animation is completed
 */
- (void)alertDismissAnimationIsCompleted:(SCLDismissAnimationCompletionBlock)dismissAnimationCompletionBlock;

/** Warns that alerts show animation is completed
 *
 * Warns that alerts show animation is completed
 */
- (void)alertShowAnimationIsCompleted:(SCLShowAnimationCompletionBlock)showAnimationCompletionBlock;

/** Hide SCLAlertView
 *
 * Hide SCLAlertView using animation and removing from super view.
 */

- (void)hideView;

/** SCLAlertView visibility
 *
 * Returns if the alert is visible or not.
 */
- (BOOL)isVisible;

/** Remove Top Circle
 *
 * Remove top circle from SCLAlertView.
 */
- (void)removeTopCircle;

/** Add a custom UIView
 *
 * @param customView UIView object to be added above the first SCLButton.
 */
- (UIView *)addCustomView:(UIView *)customView;

/** Add Text Field
 *
 * @param title The text displayed on the textfield.
 */
- (SCLTextView *)addTextField:(NSString *)title;

/** Add a custom Text Field
 *
 * @param textField The custom textfield provided by the programmer.
 */
- (void)addCustomTextField:(UITextField *)textField;

/** Add a switch view
 *
 * @param label The label displayed for the switch.
 */
- (SCLSwitchView *)addSwitchViewWithLabel:(NSString *)label;

/** Add Timer Display
 *
 * @param buttonIndex The index of the button to add the timer display to.
 * @param reverse Convert timer to countdown.
 */
- (void)addTimerToButtonIndex:(NSInteger)buttonIndex reverse:(BOOL)reverse;

/** Set Title font family and size
 *
 * @param titleFontFamily The family name used to displayed the title.
 * @param size Font size.
 */
- (void)setTitleFontFamily:(NSString *)titleFontFamily withSize:(CGFloat)size;

/** Set Text field font family and size
 *
 * @param bodyTextFontFamily The family name used to displayed the text field.
 * @param size Font size.
 */
- (void)setBodyTextFontFamily:(NSString *)bodyTextFontFamily withSize:(CGFloat)size;

/** Set Buttons font family and size
 *
 * @param buttonsFontFamily The family name used to displayed the buttons.
 * @param size Font size.
 */
- (void)setButtonsTextFontFamily:(NSString *)buttonsFontFamily withSize:(CGFloat)size;

/** Add a Button with a title and a block to handle when the button is pressed.
 *
 * @param title The text displayed on the button.
 * @param action A block of code to be executed when the button is pressed.
 */
- (SCLButton *)addButton:(NSString *)title actionBlock:(SCLActionBlock)action;

/** Add a Button with a title, a block to handle validation, and a block to handle when the button is pressed and validation succeeds.
 *
 * @param title The text displayed on the button.
 * @param validationBlock A block of code that will allow you to validate fields or do any other logic you may want to do to determine if the alert should be dismissed or not. Inside of this block, return a BOOL indicating whether or not the action block should be called and the alert dismissed.
 * @param action A block of code to be executed when the button is pressed and validation passes.
 */
- (SCLButton *)addButton:(NSString *)title validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action;

/** Add a Button with a title, a target and a selector to handle when the button is pressed.
 *
 * @param title The text displayed on the button.
 * @param target Add target for particular event.
 * @param selector A method to be executed when the button is pressed.
 */
- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector;

/** Show Success SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showSuccess:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Error SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showError:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showError:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Notice SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showNotice:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showNotice:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Warning SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showWarning:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showWarning:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Info SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showInfo:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showInfo:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Edit SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showEdit:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showEdit:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Title SCLAlertView using a predefined type
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param style One of predefined SCLAlertView styles.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showTitle:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showTitle:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

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
- (void)showCustom:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Waiting SCLAlertView with UIActityIndicator.
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showWaiting:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showWaiting:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/** Show Question SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
- (void)showQuestion:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showQuestion:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

@end

@protocol SCLItemsBuilder__Protocol__Fluent <NSObject>
- (void)setupFluent;
@end

@interface SCLAlertViewBuilder__WithFluent: NSObject <SCLItemsBuilder__Protocol__Fluent> @end

@interface SCLAlertViewShowBuilder : SCLAlertViewBuilder__WithFluent

@property(weak, nonatomic, readonly) UIViewController *parameterViewController;
@property(copy, nonatomic, readonly) UIImage *parameterImage;
@property(copy, nonatomic, readonly) UIColor *parameterColor;
@property(copy, nonatomic, readonly) NSString *parameterTitle;
@property(copy, nonatomic, readonly) NSString *parameterSubTitle;
@property(copy, nonatomic, readonly) NSString *parameterCompleteText;
@property(copy, nonatomic, readonly) NSString *parameterCloseButtonTitle;
@property(assign, nonatomic, readonly) SCLAlertViewStyle parameterStyle;
@property(assign, nonatomic, readonly) NSTimeInterval parameterDuration;

#pragma mark - Setters
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^viewController)(UIViewController *viewController);
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^image)(UIImage *image);
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^color)(UIColor *color);
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^title)(NSString *title);
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^subTitle)(NSString *subTitle);
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^completeText)(NSString *completeText);
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^style)(SCLAlertViewStyle style);
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^closeButtonTitle)(NSString *closeButtonTitle);
@property(copy, nonatomic, readonly) SCLAlertViewShowBuilder *(^duration)(NSTimeInterval duration);

- (void)showAlertView:(SCLAlertView *)alertView;
- (void)showAlertView:(SCLAlertView *)alertView onViewController:(UIViewController *)controller;
@property(copy, nonatomic, readonly) void (^show)(SCLAlertView *view, UIViewController *controller);
@end

@interface SCLALertViewTextFieldBuilder : SCLAlertViewBuilder__WithFluent

#pragma mark - Available later after adding
@property(weak, nonatomic, readonly) SCLTextView *textField;

#pragma mark - Setters
@property(copy, nonatomic, readonly) SCLALertViewTextFieldBuilder *(^title) (NSString *title);

@end

@interface SCLALertViewButtonBuilder : SCLAlertViewBuilder__WithFluent

#pragma mark - Available later after adding
@property(weak, nonatomic, readonly) SCLButton *button;

#pragma mark - Setters
@property(copy, nonatomic, readonly) SCLALertViewButtonBuilder *(^title) (NSString *title);
@property(copy, nonatomic, readonly) SCLALertViewButtonBuilder *(^target) (id target);
@property(copy, nonatomic, readonly) SCLALertViewButtonBuilder *(^selector) (SEL selector);
@property(copy, nonatomic, readonly) SCLALertViewButtonBuilder *(^actionBlock) (void(^actionBlock)(void));
@property(copy, nonatomic, readonly) SCLALertViewButtonBuilder *(^validationBlock) (BOOL(^validationBlock)(void));

@end

@interface SCLAlertViewBuilder : SCLAlertViewBuilder__WithFluent

#pragma mark - Parameters
@property (strong, nonatomic, readonly) SCLAlertView *alertView;

#pragma mark - Init
- (instancetype)init;
- (instancetype)initWithNewWindow;
- (instancetype)initWithNewWindowWidth:(CGFloat)width;

#pragma mark - Properties
@property(copy, nonatomic) SCLAlertViewBuilder *(^cornerRadius) (CGFloat cornerRadius);
@property(copy, nonatomic) SCLAlertViewBuilder *(^tintTopCircle) (BOOL tintTopCircle);
@property(copy, nonatomic) SCLAlertViewBuilder *(^useLargerIcon) (BOOL useLargerIcon);
@property(copy, nonatomic) SCLAlertViewBuilder *(^labelTitle) (UILabel *labelTitle);
@property(copy, nonatomic) SCLAlertViewBuilder *(^viewText) (UITextView *viewText);
@property(copy, nonatomic) SCLAlertViewBuilder *(^activityIndicatorView) (UIActivityIndicatorView *activityIndicatorView);
@property(copy, nonatomic) SCLAlertViewBuilder *(^shouldDismissOnTapOutside) (BOOL shouldDismissOnTapOutside);
@property(copy, nonatomic) SCLAlertViewBuilder *(^soundURL) (NSURL *soundURL);
@property(copy, nonatomic) SCLAlertViewBuilder *(^attributedFormatBlock) (SCLAttributedFormatBlock attributedFormatBlock);
@property(copy, nonatomic) SCLAlertViewBuilder *(^completeButtonFormatBlock) (CompleteButtonFormatBlock completeButtonFormatBlock);
@property(copy, nonatomic) SCLAlertViewBuilder *(^buttonFormatBlock) (ButtonFormatBlock buttonFormatBlock);
@property(copy, nonatomic) SCLAlertViewBuilder *(^forceHideBlock) (SCLForceHideBlock forceHideBlock);
@property(copy, nonatomic) SCLAlertViewBuilder *(^hideAnimationType) (SCLAlertViewHideAnimation hideAnimationType);
@property(copy, nonatomic) SCLAlertViewBuilder *(^showAnimationType) (SCLAlertViewShowAnimation showAnimationType);
@property(copy, nonatomic) SCLAlertViewBuilder *(^backgroundType) (SCLAlertViewBackground backgroundType);
@property(copy, nonatomic) SCLAlertViewBuilder *(^customViewColor) (UIColor *customViewColor);
@property(copy, nonatomic) SCLAlertViewBuilder *(^backgroundViewColor) (UIColor *backgroundViewColor);
@property(copy, nonatomic) SCLAlertViewBuilder *(^iconTintColor) (UIColor *iconTintColor);
@property(copy, nonatomic) SCLAlertViewBuilder *(^circleIconHeight) (CGFloat circleIconHeight);
@property(copy, nonatomic) SCLAlertViewBuilder *(^extensionBounds) (CGRect extensionBounds);
@property(copy, nonatomic) SCLAlertViewBuilder *(^statusBarHidden) (BOOL statusBarHidden);
@property(copy, nonatomic) SCLAlertViewBuilder *(^statusBarStyle) (UIStatusBarStyle statusBarStyle);

#pragma mark - Custom Setters
@property(copy, nonatomic) SCLAlertViewBuilder *(^alertIsDismissed) (SCLDismissBlock dismissBlock);
@property(copy, nonatomic) SCLAlertViewBuilder *(^alertDismissAnimationIsCompleted) (SCLDismissAnimationCompletionBlock dismissAnimationCompletionBlock);
@property(copy, nonatomic) SCLAlertViewBuilder *(^alertShowAnimationIsCompleted) (SCLShowAnimationCompletionBlock showAnimationCompletionBlock);
@property(copy, nonatomic) SCLAlertViewBuilder *(^removeTopCircle)(void);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addCustomView)(UIView *view);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addTextField)(NSString *title);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addCustomTextField)(UITextField *textField);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addSwitchViewWithLabelTitle)(NSString *title);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addTimerToButtonIndex)(NSInteger buttonIndex, BOOL reverse);
@property(copy, nonatomic) SCLAlertViewBuilder *(^setTitleFontFamily)(NSString *titleFontFamily, CGFloat size);
@property(copy, nonatomic) SCLAlertViewBuilder *(^setBodyTextFontFamily)(NSString *bodyTextFontFamily, CGFloat size);
@property(copy, nonatomic) SCLAlertViewBuilder *(^setButtonsTextFontFamily)(NSString *buttonsFontFamily, CGFloat size);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addButtonWithActionBlock)(NSString *title, SCLActionBlock action);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addButtonWithValidationBlock)(NSString *title, SCLValidationBlock validationBlock, SCLActionBlock action);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addButtonWithTarget)(NSString *title, id target, SEL selector);

#pragma mark - Builders
@property(copy, nonatomic) SCLAlertViewBuilder *(^addButtonWithBuilder)(SCLALertViewButtonBuilder *builder);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addTextFieldWithBuilder)(SCLALertViewTextFieldBuilder *builder);

@end
