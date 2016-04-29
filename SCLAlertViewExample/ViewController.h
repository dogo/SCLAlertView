//
//  ViewController.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)showSuccess:(id)sender;
- (IBAction)showSuccessWithHorizontalButtons:(id)sender;
- (IBAction)showError:(id)sender;
- (IBAction)showNotice:(id)sender;
- (IBAction)showWarning:(id)sender;
- (IBAction)showInfo:(id)sender;
- (IBAction)showEdit:(id)sender;
- (IBAction)showEditWithHorizontalButtons:(id)sender;
- (IBAction)ShowAdvancedWithHorizontalButtons:(id)sender;
- (IBAction)showCustom:(id)sender;
- (IBAction)showValidation:(id)sender;
- (IBAction)showValidationWithHorizontalButtons:(id)sender;
- (IBAction)showWaiting:(id)sender;

@end

