//
//  SCLButton.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

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

/** TODO
 *
 * TODO
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

/** TODO
 *
 * TODO
 */
@property (nonatomic, strong) UIColor *defaultBackgroundColor;

/** TODO
 *
 * TODO
 */
@property id target;

/** TODO
 *
 * TODO
 */
@property SEL selector;

/** Parse button configuration
 *
 * Parse ButtonFormatBlock and CompleteButtonFormatBlock setting custom configuration.
 * Set keys : backgroundColor, borderColor, textColor
 */
- (void)parseConfig:(NSDictionary *)buttonConfig;

@end
