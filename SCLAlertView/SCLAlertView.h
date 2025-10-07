//
//  SCLAlertView.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2025 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLButton.h"
#import "SCLTextView.h"
#import "SCLSwitchView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSAttributedString* _Nonnull (^SCLAttributedFormatBlock)(NSString *value);
typedef void (^SCLDismissBlock)(void);
typedef void (^SCLDismissAnimationCompletionBlock)(void);
typedef void (^SCLShowAnimationCompletionBlock)(void);
typedef void (^SCLForceHideBlock)(void);

@interface SCLAlertView : UIViewController

/** Predefined alert styles. */
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

/** Hide animation styles. */
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

/** Show animation styles. */
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

/** Background styles. */
typedef NS_ENUM(NSInteger, SCLAlertViewBackground)
{
    SCLAlertViewBackgroundShadow,
    SCLAlertViewBackgroundBlur,
    SCLAlertViewBackgroundTransparent
};

/// Overrides the content view corner radius.
@property CGFloat cornerRadius;

/// Whether the top circle is tinted with the alert color. (Default: YES)
@property (assign, nonatomic) BOOL tintTopCircle;

/// Whether to use a larger icon in the top circle. (Default: NO)
@property (assign, nonatomic) BOOL useLargerIcon;

/// Title label displayed at the top of the alert.
@property (strong, nonatomic, nullable) UILabel *labelTitle;

/// Text view containing the message body.
@property (strong, nonatomic, nullable) UITextView *viewText;

/// Activity indicator used for Waiting style.
@property (strong, nonatomic, nullable) UIActivityIndicatorView *activityIndicatorView;

/// If YES, tapping outside the alert dismisses it. (Default: NO)
@property (assign, nonatomic) BOOL shouldDismissOnTapOutside;

/// URL of the sound to play.
@property (strong, nonatomic, nullable) NSURL *soundURL;

/// Provides an attributed string for the body text.
@property (copy, nonatomic, nullable) SCLAttributedFormatBlock attributedFormatBlock;

/// Provides full button styling (backgroundColor, borderWidth, borderColor, textColor).
@property (copy, nonatomic, nullable) CompleteButtonFormatBlock completeButtonFormatBlock;

/// Provides button styling (backgroundColor, borderWidth, borderColor, textColor).
@property (copy, nonatomic, nullable) ButtonFormatBlock buttonFormatBlock;

/// If set, calling this property triggers hideView.
@property (copy, nonatomic, nullable) SCLForceHideBlock forceHideBlock;

/// Hide animation type. (Default: FadeOut)
@property (nonatomic) SCLAlertViewHideAnimation hideAnimationType;

/// Show animation type. (Default: SlideInFromTop)
@property (nonatomic) SCLAlertViewShowAnimation showAnimationType;

/// Background effect behind the alert. (Default: Shadow)
@property (nonatomic) SCLAlertViewBackground backgroundType;

/// Custom alert color (buttons, top circle, borders).
@property (strong, nonatomic, nullable) UIColor *customViewColor;

/// Custom background view color.
@property (strong, nonatomic, nullable) UIColor *backgroundViewColor;

/// Tint color for the icon image.
@property (strong, nonatomic, nullable) UIColor *iconTintColor;

/// Custom size for the icon inside the top circle.
@property (nonatomic) CGFloat circleIconHeight;

/// New bounds to use when running as an app extension only.
@property (nonatomic) CGRect extensionBounds;

/// Status bar hidden state.
@property (nonatomic) BOOL statusBarHidden;

/// Status bar style.
@property (nonatomic) UIStatusBarStyle statusBarStyle;

/// If YES, buttons are laid out horizontally instead of vertically.
@property (nonatomic) BOOL horizontalButtons;

#pragma mark - Initializers

/**
 Initializes an alert with a specific width.

 @param width The desired alert width.
 @return An initialized SCLAlertView instance.
 */
- (instancetype)initWithWidth:(CGFloat)width;

/**
 Initializes an alert presented in a new UIWindow.

 @return An initialized SCLAlertView instance.
 */
- (instancetype)initWithNewWindow;

/**
 Initializes an alert presented in a new UIWindow with custom width.

 @param windowWidth The desired alert width.
 @return An initialized SCLAlertView instance.
 */
- (instancetype)initWithNewWindowWidth:(CGFloat)windowWidth;

#pragma mark - Callbacks

/**
 Sets a block to be called when the alert is dismissed.

 @param dismissBlock The block executed upon dismissal.
 */
- (void)alertIsDismissed:(SCLDismissBlock)dismissBlock;

/**
 Sets a block to be called when the dismiss animation completes.

 @param dismissAnimationCompletionBlock The completion block.
 */
- (void)alertDismissAnimationIsCompleted:(SCLDismissAnimationCompletionBlock)dismissAnimationCompletionBlock;

/**
 Sets a block to be called when the show animation completes.

 @param showAnimationCompletionBlock The completion block.
 */
- (void)alertShowAnimationIsCompleted:(SCLShowAnimationCompletionBlock)showAnimationCompletionBlock;

#pragma mark - Visibility

/**
 Hides the alert with animation and removes it from the view hierarchy.
 */
- (void)hideView;

/**
 Returns whether the alert is visible.

 @return YES if visible; otherwise NO.
 */
- (BOOL)isVisible;

/**
 Removes the top circle from the alert.
 */
- (void)removeTopCircle;

#pragma mark - Content

/**
 Adds a custom view above the first button.

 @param customView The UIView to add.
 @return The same customView for chaining.
 */
- (UIView *)addCustomView:(UIView *)customView;

/**
 Adds a text field with optional default text.

 @param title The placeholder text for the text field.
 @param defaultText Optional default text.
 @return The created SCLTextView.
 */
- (SCLTextView *)addTextField:(NSString *)title setDefaultText:(nullable NSString *)defaultText;

/**
 Adds a custom text field.

 @param textField The custom UITextField instance.
 */
- (void)addCustomTextField:(UITextField *)textField;

/**
 Adds a switch view with an optional label.

 @param label The label text for the switch.
 @return The created SCLSwitchView.
 */
- (SCLSwitchView *)addSwitchViewWithLabel:(nullable NSString *)label;

#pragma mark - Timer

/**
 Adds a circular timer to a button.

 @param buttonIndex Index of the button to attach the timer to.
 @param reverse If YES, shows a countdown.
 */
- (void)addTimerToButtonIndex:(NSInteger)buttonIndex reverse:(BOOL)reverse;

#pragma mark - Fonts

/**
 Sets the title font family and size.

 @param titleFontFamily The font family name.
 @param size The font size.
 */
- (void)setTitleFontFamily:(NSString *)titleFontFamily withSize:(CGFloat)size;

/**
 Sets the body text font family and size.

 @param bodyTextFontFamily The font family name.
 @param size The font size.
 */
- (void)setBodyTextFontFamily:(NSString *)bodyTextFontFamily withSize:(CGFloat)size;

/**
 Sets the buttons font family and size.

 @param buttonsFontFamily The font family name.
 @param size The font size.
 */
- (void)setButtonsTextFontFamily:(NSString *)buttonsFontFamily withSize:(CGFloat)size;

#pragma mark - Buttons

/**
 Adds a button with a title and action block.

 @param title The button title.
 @param action The block executed when the button is tapped.
 @return The created SCLButton.
 */
- (SCLButton *)addButton:(NSString *)title actionBlock:(SCLActionBlock)action;

/**
 Adds a button with validation and action blocks.

 @param title The button title.
 @param validationBlock A block returning YES to proceed and dismiss, NO to keep the alert.
 @param action The block executed when validation passes and the button is tapped.
 @return The created SCLButton.
 */
- (SCLButton *)addButton:(NSString *)title validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action;

/**
 Adds a button with a target and selector.

 @param title The button title.
 @param target The target object for the selector.
 @param selector The selector to invoke on tap.
 @return The created SCLButton.
 */
- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector;

#pragma mark - Show (predefined styles)

/**
 Shows a Success alert.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showSuccess:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/**
 Shows an Error alert.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showError:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showError:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/**
 Shows a Notice alert.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showNotice:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showNotice:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/**
 Shows a Warning alert.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showWarning:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showWarning:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/**
 Shows an Info alert.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showInfo:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showInfo:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/**
 Shows an Edit alert.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showEdit:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showEdit:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

#pragma mark - Show (custom)

/**
 Shows a predefined style alert.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param style The predefined style.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showTitle:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showTitle:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/**
 Shows a custom alert with custom image and color.

 @param vc The presenting view controller.
 @param image The icon image.
 @param color The primary color (buttons, top circle, borders).
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showCustom:(UIViewController *)vc image:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showCustom:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/**
 Shows a Waiting alert with UIActivityIndicator.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showWaiting:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showWaiting:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

/**
 Shows a Question alert.

 @param vc The presenting view controller.
 @param title The alert title.
 @param subTitle The alert subtitle.
 @param closeButtonTitle The close button title (optional).
 @param duration Automatic dismissal after this duration; set 0 to disable.
 */
- (void)showQuestion:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
- (void)showQuestion:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(nullable NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

@end

@protocol SCLItemsBuilder__Protocol__Fluent <NSObject>
- (void)setupFluent;
@end

@interface SCLAlertViewBuilder__WithFluent: NSObject <SCLItemsBuilder__Protocol__Fluent> @end

@interface SCLAlertViewShowBuilder : SCLAlertViewBuilder__WithFluent

@property(weak, nonatomic, readonly, nullable) UIViewController *parameterViewController;
@property(copy, nonatomic, readonly, nullable) UIImage *parameterImage;
@property(copy, nonatomic, readonly, nullable) UIColor *parameterColor;
@property(copy, nonatomic, readonly, nullable) NSString *parameterTitle;
@property(copy, nonatomic, readonly, nullable) NSString *parameterSubTitle;
@property(copy, nonatomic, readonly, nullable) NSString *parameterCompleteText;
@property(copy, nonatomic, readonly, nullable) NSString *parameterCloseButtonTitle;
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
- (void)showAlertView:(SCLAlertView *)alertView onViewController:(UIViewController * _Nullable)controller;
@property(copy, nonatomic, readonly) void (^show)(SCLAlertView *view, UIViewController * _Nullable controller);
@end

@interface SCLALertViewTextFieldBuilder : SCLAlertViewBuilder__WithFluent

#pragma mark - Available later after adding
@property(weak, nonatomic, readonly, nullable) SCLTextView *textField;

#pragma mark - Setters
@property(copy, nonatomic, readonly) SCLALertViewTextFieldBuilder *(^title) (NSString *title);

@end

@interface SCLALertViewButtonBuilder : SCLAlertViewBuilder__WithFluent

#pragma mark - Available later after adding
@property(weak, nonatomic, readonly, nullable) SCLButton *button;

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
@property(copy, nonatomic) SCLAlertViewBuilder *(^addTextField)(NSString *title, NSString * _Nullable defaultText);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addCustomTextField)(UITextField *textField);
@property(copy, nonatomic) SCLAlertViewBuilder *(^addSwitchViewWithLabelTitle)(NSString * _Nullable title);
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

NS_ASSUME_NONNULL_END
