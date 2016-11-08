//
//  SCLSwitchView.m
//  SCLAlertView
//
//  Created by André Felipe Santos on 27/01/16.
//  Copyright (c) 2016-2016 AnyKey Entertainment. All rights reserved.
//

#import "SCLSwitchView.h"
#import "SCLMacros.h"

@interface SCLSwitchView ()

@property (strong, nonatomic) UISwitch *switchKnob;
@property (strong, nonatomic) UILabel *switchLabel;

@end

#pragma mark

@implementation SCLSwitchView

#pragma mark - Constructors

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - Initialization

- (void)setup
{
    // Add switch knob
    self.switchKnob = [[UISwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.f)];
    [self addSubview:self.switchKnob];
    
    // Add switch label
    CGFloat x, width, height;
    x = self.switchKnob.frame.size.width + 8.0f;
    width = self.frame.size.width - self.switchKnob.frame.size.width - 8.0f;
    height = self.switchKnob.frame.size.height;
    
    self.switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0.0f, width, height)];
    
    NSString *switchFontFamily = @"HelveticaNeue-Bold";
    CGFloat switchFontSize = 12.0f;
    
    self.switchLabel.numberOfLines = 1;
    self.switchLabel.textAlignment = NSTextAlignmentLeft;
    self.switchLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.switchLabel.adjustsFontSizeToFitWidth = YES;
    self.switchLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.switchLabel.minimumScaleFactor = 0.5f;
    self.switchLabel.font = [UIFont fontWithName:switchFontFamily size:switchFontSize];
    self.switchLabel.textColor = UIColorFromHEX(0x4D4D4D);
    
    [self addSubview:self.switchLabel];
}

#pragma mark - Getters

- (UIColor *)tintColor
{
    return self.switchKnob.tintColor;
}

- (UIColor *)labelColor
{
    return self.switchLabel.textColor;
}

- (UIFont *)labelFont
{
    return self.switchLabel.font;
}

- (NSString *)labelText
{
    return self.switchLabel.text;
}

- (BOOL)isSelected
{
    return self.switchKnob.isOn;
}

#pragma mark - Setters

- (void)setTintColor:(UIColor *)tintColor
{
    self.switchKnob.onTintColor = tintColor;
}

- (void)setLabelColor:(UIColor *)labelColor
{
    self.switchLabel.textColor = labelColor;
}

- (void)setLabelFont:(UIFont *)labelFont
{
    self.switchLabel.font = labelFont;
}

- (void)setLabelText:(NSString *)labelText
{
    self.switchLabel.text = labelText;
}

- (void)setSelected:(BOOL)selected
{
    self.switchKnob.on = selected;
}

@end
