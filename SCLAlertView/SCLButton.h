//
//  SCLButton.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLButton : UIButton

// Action Types
typedef NS_ENUM(NSInteger, SCLActionType)
{
    None,
    Selector,
    Closure
};


@property SCLActionType actionType;

@property SEL action;

@property id target;

@property SEL selector;

@end
