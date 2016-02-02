//
//  SCLSwitchView.h
//  SCLAlertView
//
//  Created by André Felipe Santos on 27/01/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
#else
#import <UIKit/UIKit.h>
#endif

@interface SCLSwitchView : UIView

@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) UIColor *labelColor;
@property (strong, nonatomic) UIFont *labelFont;
@property (strong, nonatomic) NSString *labelText;
@property (nonatomic, getter=isSelected) BOOL selected;

@end
