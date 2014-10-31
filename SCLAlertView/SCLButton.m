//
//  SCLButton.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import "SCLButton.h"

@implementation SCLButton

- (id)init
{
    self = [super init];
    if (self) {
        // Do something
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        // Do something
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Do something
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{    
    if(highlighted)
    {
        self.backgroundColor = [self darkerColorForColor:_defaultBackgroundColor];
    }
    else
    {
        self.backgroundColor = _defaultBackgroundColor;
    }
    [super setHighlighted:highlighted];
}

- (void)setDefaultBackgroundColor:(UIColor *)defaultBackgroundColor
{
    self.backgroundColor = _defaultBackgroundColor = defaultBackgroundColor;
}

#pragma mark - Button Apperance

- (void)parseConfig:(NSDictionary *)buttonConfig
{
    if ([buttonConfig objectForKey:@"backgroundColor"])
    {
        self.defaultBackgroundColor = [buttonConfig objectForKey:@"backgroundColor"];
    }
    if ([buttonConfig objectForKey:@"borderColor"])
    {
        self.layer.borderColor = ((UIColor*)[buttonConfig objectForKey:@"borderColor"]).CGColor;
    }
    if ([buttonConfig objectForKey:@"textColor"])
    {
        [self setTitleColor:[buttonConfig objectForKey:@"textColor"] forState:UIControlStateNormal];
    }
}

#pragma mark - Helpers

- (UIColor *)darkerColorForColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2f, 0.0f)
                               green:MAX(g - 0.2f, 0.0f)
                                blue:MAX(b - 0.2f, 0.0f)
                               alpha:a];
    return nil;
}

- (UIColor *)lighterColorForColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2f, 1.0f)
                               green:MIN(g + 0.2f, 1.0f)
                                blue:MIN(b + 0.2f, 1.0f)
                               alpha:a];
    return nil;
}

@end
