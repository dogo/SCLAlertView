//
//  SCLSwitchView.h
//  SCLAlertView
//
//  Created by André Felipe Santos on 27/01/16.
//  Copyright (c) 2016-2025 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A simple switch view with an optional label, configurable via UIAppearance.
 */
@interface SCLSwitchView : UIView

/// Tint color for the switch (UIAppearance).
@property (strong, nonatomic, nullable) UIColor *tintColor UI_APPEARANCE_SELECTOR;

/// Label color (UIAppearance).
@property (strong, nonatomic, nullable) UIColor *labelColor UI_APPEARANCE_SELECTOR;

/// Label font (UIAppearance).
@property (strong, nonatomic, nullable) UIFont *labelFont UI_APPEARANCE_SELECTOR;

/// Label text (UIAppearance).
@property (strong, nonatomic, nullable) NSString *labelText UI_APPEARANCE_SELECTOR;

/// Selection state.
@property (nonatomic, getter=isSelected) BOOL selected;

@end

NS_ASSUME_NONNULL_END
