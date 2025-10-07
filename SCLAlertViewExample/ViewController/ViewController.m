//
//  ViewController.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2025 AnyKey Entertainment. All rights reserved.
//

#import "ViewController.h"
#import "SCLAlertView.h"
#import "UIViewController+Alert.h"

@interface ViewController ()
@end

// MARK: Constants
NSString *kSuccessTitle = @"Congratulations";
NSString *kErrorTitle = @"Connection error";
NSString *kNoticeTitle = @"Notice";
NSString *kWarningTitle = @"Warning";
NSString *kInfoTitle = @"Info";
NSString *kSubtitle = @"You've just displayed this awesome Pop Up View";
NSString *kButtonTitle = @"Done";
NSString *kAttributeTitle = @"Attributed string operation successfully completed.";

@implementation ViewController

#pragma mark - Success

- (IBAction)showSuccess:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    SCLButton *button = [alert addButton:@"First Button" target:self selector:@selector(firstButton)];
    
    button.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor whiteColor];
        buttonConfig[@"textColor"] = [UIColor blackColor];
        buttonConfig[@"borderWidth"] = @2.0f;
        buttonConfig[@"borderColor"] = [UIColor greenColor];
        return buttonConfig;
    };
    
    [alert addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];

    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [NSBundle mainBundle].resourcePath]];

    [alert showSuccess:kSuccessTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

- (IBAction)showSuccessWithHorizontalButtons:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert setHorizontalButtons:YES];
    
    SCLButton *button = [alert addButton:@"First Button" target:self selector:@selector(firstButton)];
    
    button.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor whiteColor];
        buttonConfig[@"textColor"] = [UIColor blackColor];
        buttonConfig[@"borderWidth"] = @2.0f;
        buttonConfig[@"borderColor"] = [UIColor greenColor];
        return buttonConfig;
    };
    
    [alert addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [NSBundle mainBundle].resourcePath]];
    
    [alert showSuccess:kSuccessTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

#pragma mark - Error

- (IBAction)showError:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showError:self
               title:@"An error with two title is presented ..."
            subTitle:@"You have not saved your Submission yet. Please save the Submission before accessing the Responses list. Blah de blah de blah, blah. Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, End."
    closeButtonTitle:@"OK"
           duration:0.0f];
}

#pragma mark - Notice

- (IBAction)showNotice:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    [alert showNotice:self
                title:kNoticeTitle
             subTitle:@"You've just displayed this awesome Pop Up View with blur effect"
     closeButtonTitle:kButtonTitle
             duration:0.0f];
}

#pragma mark - Warning

- (IBAction)showWarning:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showWarning:self title:kWarningTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

#pragma mark - Info

- (IBAction)showInfo:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    [alert alertIsDismissed:^{
        NSLog(@"SCLAlertView dismissed!");
    }];
    
    [alert showInfo:self title:kInfoTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

#pragma mark - Edit

- (IBAction)showEdit:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    SCLTextView *textField = [alert addTextField:@"Enter your name" setDefaultText:nil];
    [alert addButton:@"Show Name" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
    }];
    
    [alert showEdit:self title:kInfoTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

- (IBAction)showEditWithHorizontalButtons:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert setHorizontalButtons:YES];
    
    SCLTextView *textField = [alert addTextField:@"Enter your name" setDefaultText:nil];
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;
    [alert addButton:@"Show Name" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
    }];
    
    [alert showEdit:self title:kInfoTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

#pragma mark - Advanced

- (IBAction)showAdvanced:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.backgroundViewColor = [UIColor cyanColor];
    
    [alert setTitleFontFamily:@"Superclarendon" withSize:20.0f];
    [alert setBodyTextFontFamily:@"TrebuchetMS" withSize:14.0f];
    [alert setButtonsTextFontFamily:@"Baskerville" withSize:14.0f];
    
    [alert addButton:@"First Button" target:self selector:@selector(firstButton)];
    
    [alert addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    
    SCLTextView *textField = [alert addTextField:@"Enter your name" setDefaultText:nil];
    
    [alert addButton:@"Show Name" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
    }];
    
    alert.completeButtonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor greenColor];
        buttonConfig[@"borderColor"] = [UIColor blackColor];
        buttonConfig[@"borderWidth"] = @"1.0f";
        buttonConfig[@"textColor"] = [UIColor blackColor];
        return buttonConfig;
    };
    
    alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
    {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc] initWithString:value];
        
        NSRange redRange = [value rangeOfString:@"Attributed" options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        
        NSRange greenRange = [value rangeOfString:@"successfully" options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:greenRange];
        
        NSRange underline = [value rangeOfString:@"completed" options:NSCaseInsensitiveSearch];
        [subTitle addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:underline];
        
        return subTitle;
    };

    [alert showTitle:self title:@"Congratulations" subTitle:kAttributeTitle style:SCLAlertViewStyleSuccess closeButtonTitle:@"Done" duration:0.0f];
}

- (IBAction)ShowAdvancedWithHorizontalButtons:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert setHorizontalButtons:YES];
    
    alert.backgroundViewColor = [UIColor cyanColor];
    
    [alert setTitleFontFamily:@"Superclarendon" withSize:20.0f];
    [alert setBodyTextFontFamily:@"TrebuchetMS" withSize:14.0f];
    [alert setButtonsTextFontFamily:@"Baskerville" withSize:14.0f];
    
    [alert addButton:@"First Button" target:self selector:@selector(firstButton)];
    
    [alert addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    
    SCLTextView *textField = [alert addTextField:@"Enter your name" setDefaultText:nil];
    
    [alert addButton:@"Show Name" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
    }];
    
    alert.completeButtonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor greenColor];
        buttonConfig[@"borderColor"] = [UIColor blackColor];
        buttonConfig[@"borderWidth"] = @"1.0f";
        buttonConfig[@"textColor"] = [UIColor blackColor];
        return buttonConfig;
    };
    
    alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
    {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc] initWithString:value];
        
        NSRange redRange = [value rangeOfString:@"Attributed" options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        
        NSRange greenRange = [value rangeOfString:@"successfully" options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:greenRange];
        
        NSRange underline = [value rangeOfString:@"completed" options:NSCaseInsensitiveSearch];
        [subTitle addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:underline];
        
        return subTitle;
    };
    
    [alert showTitle:self title:@"Congratulations" subTitle:kAttributeTitle style:SCLAlertViewStyleSuccess closeButtonTitle:@"Done" duration:0.0f];
}

#pragma mark - Duration

- (IBAction)showWithDuration:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showNotice:self title:kNoticeTitle subTitle:@"You've just displayed this awesome Pop Up View with 5 seconds duration" closeButtonTitle:nil duration:5.0f];
}

#pragma mark - Custom

- (IBAction)showCustom:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
    [alert showCustom:self image:[UIImage imageNamed:@"git"] color:color title:@"Custom" subTitle:@"Add a custom icon and color for your own type of alert!" closeButtonTitle:@"OK" duration:0.0f];
}

#pragma mark - Validation

- (IBAction)showValidation:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    SCLTextView *evenField = [alert addTextField:@"Enter an even number" setDefaultText:nil];
    evenField.keyboardType = UIKeyboardTypeNumberPad;
    
    SCLTextView *oddField = [alert addTextField:@"Enter an odd number" setDefaultText:nil];
    oddField.keyboardType = UIKeyboardTypeNumberPad;

    __weak __typeof(self) weakSelf = self;

    [alert addButton:@"Test Validation" validationBlock:^BOOL{
        if (evenField.text.length == 0)
        {
            [weakSelf showAlertWithTitle:@"Whoops!" message:@"You forgot to add an even number." actionBlock:^{
                [evenField becomeFirstResponder];
            }];
            return NO;
        }
        
        if (oddField.text.length == 0)
        {
            [weakSelf showAlertWithTitle:@"Whoops!" message:@"You forgot to add an odd number." actionBlock:^{
                [oddField becomeFirstResponder];
            }];
            return NO;
        }
        
        NSInteger evenFieldEntry = (evenField.text).integerValue;
        BOOL evenFieldPassedValidation = evenFieldEntry % 2 == 0;
        
        if (!evenFieldPassedValidation)
        {
            [weakSelf showAlertWithTitle:@"Whoops!" message:@"That is not an even number." actionBlock:^{
                [evenField becomeFirstResponder];
            }];
            return NO;
        }
        
        NSInteger oddFieldEntry = (oddField.text).integerValue;
        BOOL oddFieldPassedValidation = oddFieldEntry % 2 == 1;
        
        if (!oddFieldPassedValidation)
        {
            [weakSelf showAlertWithTitle:@"Whoops!" message:@"That is not an odd number." actionBlock:^{
                [oddField becomeFirstResponder];
            }];
            return NO;
        }
        return YES;
    } actionBlock:^{
        [weakSelf showAlertWithTitle:@"Great Job!" message:@"Thanks for playing." actionBlock:nil];
    }];
    
    [alert showEdit:self title:@"Validation" subTitle:@"Ensure the data is correct before dismissing!" closeButtonTitle:@"Cancel" duration:0];
}

- (IBAction)showValidationWithHorizontalButtons:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert setHorizontalButtons:YES];
    
    SCLTextView *evenField = [alert addTextField:@"Enter an even number" setDefaultText:nil];
    evenField.keyboardType = UIKeyboardTypeNumberPad;
    
    SCLTextView *oddField = [alert addTextField:@"Enter an odd number" setDefaultText:nil];
    oddField.keyboardType = UIKeyboardTypeNumberPad;

    __weak __typeof(self) weakSelf = self;
    
    [alert addButton:@"Test Validation" validationBlock:^BOOL{
        if (evenField.text.length == 0)
        {
            [weakSelf showAlertWithTitle:@"Whoops!" message:@"You forgot to add an even number." actionBlock:^{
                [evenField becomeFirstResponder];
            }];
            return NO;
        }
        
        if (oddField.text.length == 0)
        {
            [weakSelf showAlertWithTitle:@"Whoops!" message:@"You forgot to add an odd number." actionBlock:^{
                [oddField becomeFirstResponder];
            }];
            return NO;
        }
        
        NSInteger evenFieldEntry = (evenField.text).integerValue;
        BOOL evenFieldPassedValidation = evenFieldEntry % 2 == 0;
        
        if (!evenFieldPassedValidation)
        {
            [weakSelf showAlertWithTitle:@"Whoops!" message:@"That is not an even number." actionBlock:^{
                [evenField becomeFirstResponder];
            }];
            return NO;
        }
        
        NSInteger oddFieldEntry = (oddField.text).integerValue;
        BOOL oddFieldPassedValidation = oddFieldEntry % 2 == 1;
        
        if (!oddFieldPassedValidation)
        {
            [weakSelf showAlertWithTitle:@"Whoops!" message:@"That is not an odd number." actionBlock:^{
                [oddField becomeFirstResponder];
            }];
            return NO;
        }
        return YES;
    } actionBlock:^{
        [weakSelf showAlertWithTitle:@"Great Job!" message:@"Thanks for playing." actionBlock:nil];
    }];
    
    [alert showEdit:self title:@"Validation" subTitle:@"Ensure the data is correct before dismissing!" closeButtonTitle:@"Cancel" duration:0];
}

#pragma mark - Waiting

- (IBAction)showWaiting:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutFromCenter;
    alert.backgroundType = SCLAlertViewBackgroundTransparent;
    
    [alert showWaiting:self
                 title:@"Waiting..."
               subTitle:@"You've just displayed this awesome Pop Up View with transparent background"
      closeButtonTitle:nil
              duration:5.0f];
}

#pragma mark - Timer

- (IBAction)showTimer:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addTimerToButtonIndex:0 reverse:YES];
    [alert showInfo:self
              title:@"Countdown Timer"
           subTitle:@"This alert has a duration set, and a countdown timer on the Dismiss button to show how long is left."
   closeButtonTitle:@"Dismiss"
           duration:10.0f];
}

#pragma mark - Question

- (IBAction)showQuestion:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showQuestion:self title:@"Question?" subTitle:kSubtitle closeButtonTitle:@"Dismiss" duration:0.0f];
}

#pragma mark - Switch

- (IBAction)showSwitch:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.tintTopCircle = NO;
    alert.iconTintColor = [UIColor brownColor];
    alert.useLargerIcon = YES;
    alert.cornerRadius = 13.0f;
    
    [alert addSwitchViewWithLabel:@"Don't show again".uppercaseString];
    [[SCLSwitchView appearance] setTintColor:[UIColor brownColor]];
    
    SCLButton *button = [alert addButton:@"Done" target:self selector:@selector(firstButton)];
    button.buttonFormatBlock = ^NSDictionary* (void) {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"cornerRadius"] = @"17.5f";
        return buttonConfig;
    };
    
    [alert showCustom:self image:[UIImage imageNamed:@"switch"] color:[UIColor brownColor] title:kInfoTitle subTitle:kSubtitle closeButtonTitle:nil duration:0.0f];
}

#pragma mark - Actions

- (void)firstButton
{
    NSLog(@"First button tapped");
}

#pragma mark - Custom Button

- (IBAction)showWithButtonCustom:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    SCLButton *button = [alert addButton:@"First Button" target:self selector:@selector(firstButton)];
    button.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor whiteColor];
        buttonConfig[@"textColor"] = [UIColor blackColor];
        buttonConfig[@"borderWidth"] = @2.0f;
        buttonConfig[@"borderColor"] = [UIColor greenColor];
        buttonConfig[@"font"] = [UIFont fontWithName:@"ComicSansMS" size:13];
        return buttonConfig;
    };
    
    [alert addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [NSBundle mainBundle].resourcePath]];
    
    [alert showSuccess:kSuccessTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

@end
