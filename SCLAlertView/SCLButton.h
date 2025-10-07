//
//  SCLButton.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2025 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SCLTimerDisplay;

@interface SCLButton : UIButton

typedef void (^SCLActionBlock)(void);
typedef BOOL (^SCLValidationBlock)(void);
typedef NSDictionary * _Nonnull (^CompleteButtonFormatBlock)(void);
typedef NSDictionary * _Nonnull (^ButtonFormatBlock)(void);

// Action Types
typedef NS_ENUM(NSInteger, SCLActionType)
{
    SCLNone,
    SCLSelector,
    SCLBlock
};

/**
 Button action type.

 Indicates how the button should handle taps (selector-based or block-based).
 */
@property SCLActionType actionType;

/**
 Action block executed when the button is tapped.

 @note Used when actionType == SCLBlock.
 */
@property (copy, nonatomic, nullable) SCLActionBlock actionBlock;

/**
 Validation block executed before the action.

 Return YES to allow dismissal and call the action block; NO to keep the alert visible.

 @note If provided and returns NO, the action is not executed and the alert remains visible.
 */
@property (copy, nonatomic, nullable) SCLValidationBlock validationBlock;

/**
 Complete button format block.

 Provides full button styling.

 Supported keys:
 - backgroundColor (UIColor)
 - borderWidth (NSNumber/CGFloat)
 - borderColor (UIColor)
 - textColor (UIColor)
 */
@property (copy, nonatomic, nullable) CompleteButtonFormatBlock completeButtonFormatBlock;

/**
 Button format block.

 Provides button styling.

 Supported keys:
 - backgroundColor (UIColor)
 - borderWidth (NSNumber/CGFloat)
 - borderColor (UIColor)
 - textColor (UIColor)
 */
@property (copy, nonatomic, nullable) ButtonFormatBlock buttonFormatBlock;

/**
 Default background color for the button.

 @note UI_APPEARANCE_SELECTOR is supported.
 */
@property (strong, nonatomic, nullable) UIColor *defaultBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 Target for selector-based actions.

 @note Used when actionType == SCLSelector.
 */
@property (nullable) id target;

/**
 Selector to invoke on the target for selector-based actions.

 @note Used when actionType == SCLSelector.
 */
@property (nullable) SEL selector;

/**
 Applies configuration returned by a format block.

 @param buttonConfig The configuration dictionary.
 @discussion Supported keys: backgroundColor, borderWidth, borderColor, textColor.
 */
- (void)parseConfig:(NSDictionary *)buttonConfig;

/**
 Button timer (if present).

 Used to show countdown/progress on the button.
 */
@property (strong, nonatomic, nullable) SCLTimerDisplay *timer;

/**
 Designated initializer for SCLButton.

 @param windowWidth The width of the alert window used to size the button.
 @return An initialized SCLButton instance.
 */
- (instancetype)initWithWindowWidth:(CGFloat)windowWidth;

/**
 Adjusts the button width based on alert width and number of buttons.

 Only used when buttons are horizontally aligned.

 @param windowWidth The alert window width.
 @param numberOfButtons Total number of buttons in the alert.
 */
- (void)adjustWidthWithWindowWidth:(CGFloat)windowWidth numberOfButtons:(NSUInteger)numberOfButtons;

@end

NS_ASSUME_NONNULL_END
