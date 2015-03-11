//
//  SCLButton.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

@import UIKit;

@interface SCLButton : UIButton

typedef void (^SCLActionBlock)(void);
typedef BOOL (^SCLValidationBlock)(void);
typedef NSDictionary* (^CompleteButtonFormatBlock)(void);
typedef NSDictionary* (^ButtonFormatBlock)(void);

// Action Types
typedef NS_ENUM(NSInteger, SCLActionType)
{
    None,
    Selector,
    Block
};

/** Set button action type.
 *
 * Holds the button action type.
 */
@property SCLActionType actionType;

/** TODO
 *
 * TODO
 */
@property (nonatomic, copy) SCLActionBlock actionBlock;

/** TODO
 *
 * TODO
 */
@property (nonatomic, copy) SCLValidationBlock validationBlock;

/** Set Complete button format block.
 *
 * Holds the complete button format block.
 * Support keys : backgroundColor, borderColor, textColor
 */
@property (nonatomic, copy) CompleteButtonFormatBlock completeButtonFormatBlock;

/** Set button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, borderColor, textColor
 */
@property (nonatomic, copy) ButtonFormatBlock buttonFormatBlock;

/** Set SCLButton color.
 *
 * Set SCLButton color.
 */
@property (nonatomic, strong) UIColor *defaultBackgroundColor;

/** Set Target object.
 *
 * Target is an object that holds the information necessary to send a message to another object when an event occurs.
 */
@property id target;

/** Set selector id.
 *
 * A selector is the name used to select a method to execute for an object, 
 * or the unique identifier that replaces the name when the source code is compiled.
 */
@property SEL selector;

/** Parse button configuration
 *
 * Parse ButtonFormatBlock and CompleteButtonFormatBlock setting custom configuration.
 * Set keys : backgroundColor, borderColor, textColor
 */
- (void)parseConfig:(NSDictionary *)buttonConfig;

@end
