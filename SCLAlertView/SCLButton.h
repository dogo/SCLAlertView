//
//  SCLButton.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLButton : UIButton

typedef void (^ActionBlock)(void);
typedef BOOL (^ValidationBlock)(void);
typedef NSDictionary* (^CompleteButtonFormatBlock)(void);

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
@property (nonatomic, copy) ActionBlock actionBlock;

/** TODO
 *
 * TODO
 */
@property (nonatomic, copy) ValidationBlock validationBlock;

/** Set button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, textColor
 */
@property (nonatomic, copy) CompleteButtonFormatBlock completeButtonFormatBlock;

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

@end
