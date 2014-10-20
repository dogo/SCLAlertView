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

// Action Types
typedef NS_ENUM(NSInteger, SCLActionType)
{
    None,
    Selector,
    Block
};


@property SCLActionType actionType;

@property (nonatomic, copy) ActionBlock actionBlock;
@property (nonatomic, copy) ValidationBlock validationBlock;
@property (nonatomic, strong) UIColor *defaultBackgroundColor;

@property id target;

@property SEL selector;

@end
