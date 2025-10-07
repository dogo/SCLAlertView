//
//  SCLAlertView+WindowResolver.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 07/10/25.
//  Copyright (c) 2025 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCLAlertView (WindowResolver)

/// Active window (iOS 13+ compatible with UIScene)
+ (nullable UIWindow *)scl_currentKeyWindow;

/// Resolves the best app view for snapshot/blur.
/// If there is no valid window, returns the provided `fallback`.
+ (nullable UIView *)scl_resolveAppViewWithFallback:(nullable UIView *)fallback;

@end

NS_ASSUME_NONNULL_END
