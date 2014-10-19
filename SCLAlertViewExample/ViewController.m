//
//  ViewController.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import "ViewController.h"
#import "SCLAlertView.h"

@interface ViewController ()

@end

NSString *kSuccessTitle = @"Congratulations";
NSString *kErrorTitle = @"Connection error";
NSString *kNoticeTitle = @"Notice";
NSString *kWarningTitle = @"Warning";
NSString *kInfoTitle = @"Info";
NSString *kSubtitle = @"You've just displayed this awesome Pop Up View";
NSString *kButtonTitle = @"Done";
NSString *kAttributeTitle = @"Attributed string operation successfully completed.";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showSuccess:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert addButton:@"First Button" target:self selector:@selector(firstButton)];
    
    [alert addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];

    [alert showSuccess:self title:kSuccessTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

- (IBAction)showError:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showError:self title:@"Hold On..."
            subTitle:@"You have not saved your Submission yet. Please save the Submission before accessing the Responses list. Blah de blah de blah, blah. Blah de blah de"
    closeButtonTitle:@"OK" duration:0.0f];
}

- (IBAction)showNotice:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showNotice:self title:kNoticeTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

- (IBAction)showWarning:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showWarning:self title:kWarningTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

- (IBAction)showInfo:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:self title:kInfoTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

- (IBAction)showEdit:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UITextField *textField = [alert addTextField:@"Enter your name"];
    
    [alert addButton:@"Show Name" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
    }];
    
    [alert showEdit:self title:kInfoTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

- (IBAction)showAdvanced:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert addButton:@"First Button" target:self selector:@selector(firstButton)];
    
    [alert addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    
    UITextField *textField = [alert addTextField:@"Enter your name"];
    
    [alert addButton:@"Show Name" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
    }];
    
    alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
    {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc]initWithString:value];
        
        NSRange redRange = [value rangeOfString:@"Attributed" options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        
        NSRange greenRange = [value rangeOfString:@"successfully" options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:greenRange];
        
        NSRange underline = [value rangeOfString:@"completed" options:NSCaseInsensitiveSearch];
        [subTitle addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:underline];
        
        return subTitle;
    };

    [alert showTitle:self title:@"Congratulations" subTitle:kAttributeTitle style:Success closeButtonTitle:@"Done" duration:0.0f];
}

- (IBAction)showWithDuration:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showNotice:self title:kNoticeTitle subTitle:@"You've just displayed this awesome Pop Up View with 5 seconds duration" closeButtonTitle:nil duration:5.0f];
}

- (IBAction)showCustom:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
    [alert showCustom:self image:[UIImage imageNamed:@"git"] color:color title:@"Custom" subTitle:@"Add a custom icon and color for your own type of alert!" closeButtonTitle:@"OK" duration:0.0f];
}

- (IBAction)showValidation:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UITextField *evenField = [alert addTextField:@"Enter an even number"];
    evenField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITextField *oddField = [alert addTextField:@"Enter an odd number"];
    oddField.keyboardType = UIKeyboardTypeNumberPad;
    
    [alert addButton:@"Test Validation" validationBlock:^BOOL{
        if (evenField.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You forgot to add an even number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [evenField becomeFirstResponder];
            return NO;
        }
        
        if (oddField.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You forgot to add an odd number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [oddField becomeFirstResponder];
            return NO;
        }
        
        NSInteger evenFieldEntry = [evenField.text integerValue];
        BOOL evenFieldPassedValidation = evenFieldEntry % 2 == 0;
        
        if (!evenFieldPassedValidation) {
            [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"That is not an even number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [evenField becomeFirstResponder];
            return NO;
        }
        
        NSInteger oddFieldEntry = [oddField.text integerValue];
        BOOL oddFieldPassedValidation = oddFieldEntry % 2 == 1;
        
        if (!oddFieldPassedValidation) {
            [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"That is not an odd number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [oddField becomeFirstResponder];
            return NO;
        }
        
        return YES;
        
    } actionBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"Great Job!" message:@"Thanks for playing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
    [alert showEdit:self title:@"Validation" subTitle:@"Ensure the data is correct before dismissing!" closeButtonTitle:@"Cancel" duration:0];
}

- (void)firstButton
{
    NSLog(@"First button tapped");
}
@end
