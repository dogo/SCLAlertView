//
//  SCLTextView.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/18/15.
//  Copyright (c) 2015-2017 AnyKey Entertainment. All rights reserved.
//

#import "SCLTextView.h"

static const CGFloat kSCLTextViewHeight = 35.0f;
static const CGFloat kSCLTextViewHorizontalPadding = 8.0f;

@implementation SCLTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = [UIColor darkTextColor];
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.returnKeyType = UIReturnKeyDone;

    // Internal padding via left/right views
    UIView *leftPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCLTextViewHorizontalPadding, 1)];
    UIView *rightPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCLTextViewHorizontalPadding, 1)];
    self.leftView = leftPad;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightView = rightPad;
    self.rightViewMode = UITextFieldViewModeAlways;

    // Default minimum height
    CGRect f = self.frame;
    if (CGRectIsEmpty(f)) {
        f = CGRectMake(0, 0, 0, kSCLTextViewHeight);
    } else {
        f.size.height = MAX(f.size.height, kSCLTextViewHeight);
    }
    self.frame = f;
}

- (CGSize)intrinsicContentSize {
    CGSize base = [super intrinsicContentSize];
    if (base.height <= 0) {
        base.height = kSCLTextViewHeight;
    } else {
        base.height = MAX(base.height, kSCLTextViewHeight);
    }
    return base;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fit = [super sizeThatFits:size];
    fit.height = MAX(fit.height, kSCLTextViewHeight);
    return fit;
}

@end
