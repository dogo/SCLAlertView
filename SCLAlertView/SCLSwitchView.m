//
//  SCLSwitchView.m
//  SCLAlertView
//
//  Created by André Felipe Santos on 27/01/16.
//  Copyright (c) 2016-2017 AnyKey Entertainment. All rights reserved.
//

#import "SCLSwitchView.h"
#import "SCLMacros.h"

static const CGFloat kSpacing = 8.0f;

@interface SCLSwitchView ()

@property (strong, nonatomic) UISwitch *switchKnob;
@property (strong, nonatomic) UILabel *switchLabel;

@end

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
    self.backgroundColor = UIColor.clearColor;

    // Add switch knob
    self.switchKnob = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self addSubview:self.switchKnob];
    
    // Add switch label
    self.switchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.switchLabel.numberOfLines = 1;
    self.switchLabel.textAlignment = NSTextAlignmentLeft;
    self.switchLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.switchLabel.adjustsFontSizeToFitWidth = YES;
    self.switchLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.switchLabel.minimumScaleFactor = 0.5f;
    self.switchLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    self.switchLabel.textColor = UIColorFromHEX(0x4D4D4D);
    
    [self addSubview:self.switchLabel];
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize switchSize = self.switchKnob.intrinsicContentSize;
    CGFloat availableWidth = (size.width > 0 ? size.width : (switchSize.width + kSpacing + 120.0f)); // fallback width
    CGFloat labelWidth = MAX(0, availableWidth - switchSize.width - kSpacing);
    CGSize labelSize = [self.switchLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
    CGFloat height = MAX(labelSize.height, switchSize.height);
    return CGSizeMake(availableWidth, height);
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize boundsSize = self.bounds.size;
    CGSize switchSize = self.switchKnob.intrinsicContentSize;

    // Place switch at leading (x=0)
    CGFloat switchX = 0.0f;
    CGFloat switchY = (boundsSize.height - switchSize.height) / 2.0f;
    self.switchKnob.frame = CGRectMake(switchX, switchY, switchSize.width, switchSize.height);

    // Label fills remaining space after switch + spacing
    CGFloat labelX = CGRectGetMaxX(self.switchKnob.frame) + kSpacing;
    CGFloat labelWidth = MAX(0, boundsSize.width - labelX);
    CGSize labelFit = [self.switchLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
    CGFloat labelHeight = MIN(labelFit.height, boundsSize.height);
    CGFloat labelY = (boundsSize.height - labelHeight) / 2.0f;
    self.switchLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
}

#pragma mark - Getters

- (UIColor *)tintColor
{
    return self.switchKnob.onTintColor;
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
    [super setTintColor:tintColor];
    self.switchKnob.onTintColor = tintColor;
}

- (void)setLabelColor:(UIColor *)labelColor
{
    self.switchLabel.textColor = labelColor;
}

- (void)setLabelFont:(UIFont *)labelFont
{
    self.switchLabel.font = labelFont;
    [self setNeedsLayout];
}

- (void)setLabelText:(NSString *)labelText
{
    self.switchLabel.text = labelText;
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected
{
    self.switchKnob.on = selected;
}

@end
