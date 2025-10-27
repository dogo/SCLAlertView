//
//  SCLMacros.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 10/03/15.
//  Copyright (c) 2015-2025 AnyKey Entertainment. All rights reserved.
//

#ifndef SCL_MACROS_H
#define SCL_MACROS_H

// Create a UIColor from a 0xRRGGBB hex value (alpha is 1.0)
#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// Convert degrees to radians
#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

// Timer granularity (seconds) used by internal animations/timers
#define TIMER_STEP .01

// Starting angle offset (degrees) for circular drawings (e.g., timers)
#define START_DEGREE_OFFSET -90

// iOS version comparison helpers (string-based, e.g., @"14.0")
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

#endif
