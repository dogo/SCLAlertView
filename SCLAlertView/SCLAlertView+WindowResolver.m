//
//  SCLAlertView+WindowResolver.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 07/10/25.
//  Copyright (c) 2025 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertView+WindowResolver.h"
#import <UIKit/UIKit.h>

@implementation SCLAlertView (WindowResolver)

+ (UIWindow *)scl_currentKeyWindow {
    UIApplication *app = UIApplication.sharedApplication;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in app.connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                for (UIWindow *w in ws.windows) {
                    if (w.isKeyWindow) return w;
                }
                if (ws.windows.firstObject) return ws.windows.firstObject;
            }
        }
        for (UIScene *scene in app.connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                if (ws.windows.firstObject) return ws.windows.firstObject;
            }
        }
        return nil;
    } else {
        return app.keyWindow;
    }
}

+ (UIView *)scl_resolveAppViewWithFallback:(UIView *)fallback {
    UIWindow *key = [self scl_currentKeyWindow];
    if (key) return key;
    return fallback;
}

@end
