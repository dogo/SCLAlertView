//
//  SCLAlertView.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertView.h"
#import "SCLButton.h"
#import "SCLAlertViewResponder.h"
#import "SCLAlertViewStyleKit.h"
#import <AVFoundation/AVFoundation.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define KEYBOARD_HEIGHT 80
#define PREDICTION_BAR_HEIGHT 40

@interface SCLAlertView ()  <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *inputs;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIImageView *circleIconImageView;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *circleViewBackground;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic) BOOL canAddObservers;

@end

@implementation SCLAlertView

CGFloat kDefaultShadowOpacity;
CGFloat kCircleHeight;
CGFloat kCircleTopPosition;
CGFloat kCircleBackgroundTopPosition;
CGFloat kCircleHeightBackground;
CGFloat kCircleIconHeight;
CGFloat kWindowWidth;
CGFloat kWindowHeight;
CGFloat kTextHeight;

// Font
NSString *kDefaultFont = @"HelveticaNeue";
NSString *kButtonFont = @"HelveticaNeue-Bold";

// Timer
NSTimer *durationTimer;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"NSCoding not supported"
                                 userInfo:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // Default values
        kDefaultShadowOpacity = 0.7f;
        kCircleHeight = 56.0f;
        kCircleTopPosition = -12.0f;
        kCircleBackgroundTopPosition = -15.0f;
        kCircleHeightBackground = 62.0f;
        kCircleIconHeight = 20.0f;
        kWindowWidth = 240.0f;
        kWindowHeight = 178.0f;
        kTextHeight = 90.0f;
        _shouldDismissOnTapOutside = NO;
        _canAddObservers = YES;
        _hideAnimationType = FadeOut;
        _showAnimationType = SlideInFromTop;
        
        // Init
        _labelTitle = [[UILabel alloc] init];
        _viewText = [[UITextView alloc] init];
        _shadowView = [[UIView alloc] init];
        _contentView = [[UIView alloc] init];
        _circleView = [[UIView alloc] init];
        _circleViewBackground = [[UIView alloc] init];
        _circleIconImageView = [[UIImageView alloc] init];
        _buttons = [[NSMutableArray alloc] init];
        _inputs = [[NSMutableArray alloc] init];
        
        // Add Subviews
        [self.view addSubview:_contentView];
        [self.view addSubview:_circleViewBackground];
        [self.view addSubview:_circleView];

        [self.circleView addSubview:self.circleIconImageView];
        [_contentView addSubview:_labelTitle];
        [_contentView addSubview:_viewText];
        
		// Content View
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderWidth = 0.5f;
        
		// Circle View Background
		_circleViewBackground.backgroundColor = [UIColor whiteColor];
        
        // Title
        _labelTitle.numberOfLines = 1;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont fontWithName:kDefaultFont size:20.0f];
        
        // View text
        _viewText.editable = NO;
        _viewText.allowsEditingTextAttributes = YES;
        _viewText.textAlignment = NSTextAlignmentCenter;
        _viewText.font = [UIFont fontWithName:kDefaultFont size:14.0f];
        
        // Shadow View
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.shadowView.backgroundColor = [UIColor blackColor];
        
        // Colors
        _contentView.backgroundColor = [UIColor whiteColor];
        _labelTitle.textColor = UIColorFromRGB(0x4D4D4D);
        _viewText.textColor = UIColorFromRGB(0x4D4D4D);
        _contentView.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObservers];
}

- (void)addObservers
{
    if(_canAddObservers)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        _canAddObservers = NO;
    }
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - View Cycle

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize sz = [UIScreen mainScreen].bounds.size;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] < 8.0f)
    {
        // iOS versions before 7.0 did not switch the width and height on device roration
        if UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
        {
            CGSize ssz = sz;
            sz = CGSizeMake(ssz.height, ssz.width);
        }
    }
    
    // Set background frame
    CGRect newFrame = self.shadowView.frame;
    newFrame.size = sz;
    self.shadowView.frame = newFrame;
    
    // Set frames
    CGRect r;
    if (self.view.superview != nil)
    {
        // View is showing, position at center of screen
        r = CGRectMake((sz.width-kWindowWidth)/2, (sz.height-kWindowHeight)/2, kWindowWidth, kWindowHeight);
    }
    else
    {
        // View is not visible, position outside screen bounds
        r = CGRectMake((sz.width-kWindowWidth)/2, -kWindowHeight, kWindowWidth, kWindowHeight);
    }
    
    self.view.frame = r;
    _contentView.frame = CGRectMake(0.0f, kCircleHeight / 4, kWindowWidth, kWindowHeight);
    _circleViewBackground.frame = CGRectMake(kWindowWidth / 2 - kCircleHeightBackground / 2, kCircleBackgroundTopPosition, kCircleHeightBackground, kCircleHeightBackground);
    _circleViewBackground.layer.cornerRadius = _circleViewBackground.frame.size.height / 2;
    _circleView.frame = CGRectMake(kWindowWidth / 2 - kCircleHeight / 2, kCircleTopPosition, kCircleHeight, kCircleHeight);
    _circleView.layer.cornerRadius = self.circleView.frame.size.height / 2;
    _circleIconImageView.frame = CGRectMake(kCircleHeight / 2 - kCircleIconHeight / 2, kCircleHeight / 2 - kCircleIconHeight / 2, kCircleIconHeight, kCircleIconHeight);
    _labelTitle.frame = CGRectMake(12.0f, kCircleHeight / 2 + 12.0f, kWindowWidth - 24.0f, 40.0f);
    _viewText.frame = CGRectMake(12.0f, 74.0f, kWindowWidth - 24.0f, kTextHeight);
    
    // Title is nil, we can move the body message to center
    if(_labelTitle.text == nil)
    {
        _viewText.frame = CGRectMake(12.0f, kCircleHeight, kWindowWidth - 24.0f, kTextHeight);
    }
        
    // Text fields
    CGFloat y = 74.0f + kTextHeight + 14.0f;
    for (UITextField *textField in _inputs)
    {
        textField.frame = CGRectMake(12.0f, y, kWindowWidth - 24.0f, 30.0f);
        textField.layer.cornerRadius = 3;
        y += 40.0f;
    }
    
    // Buttons
    for (SCLButton *btn in _buttons)
    {
        btn.frame = CGRectMake(12.0f, y, kWindowWidth - 24, 35.0f);
        btn.layer.cornerRadius = 3;
        y += 45.0;
    }
}

#pragma mark - Handle gesture

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (_shouldDismissOnTapOutside)
    {
        [self hideView];
    }
}

- (void)setShouldDismissOnTapOutside:(BOOL)shouldDismissOnTapOutside
{
    _shouldDismissOnTapOutside = shouldDismissOnTapOutside;
    
    if(_shouldDismissOnTapOutside)
    {
        self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.shadowView addGestureRecognizer:_gestureRecognizer];
    }
}

#pragma mark - Sound

- (void)setSoundURL:(NSURL *)soundURL
{
    NSError *error;
    _soundURL = soundURL;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_soundURL error:&error];
}

#pragma mark - TextField

- (UITextField *)addTextField:(NSString *)title
{
    [self addObservers];
    
    // Update view height
    kWindowHeight += 40.0;
    
    // Add text field
    UITextField *txt = [[UITextField alloc] init];
    txt.delegate = self;
    txt.returnKeyType = UIReturnKeyDone;
    txt.borderStyle = UITextBorderStyleRoundedRect;
    txt.font = [UIFont fontWithName:kDefaultFont size:14.0f];
    txt.autocapitalizationType = UITextAutocapitalizationTypeWords;
    txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt.layer.masksToBounds = YES;
    txt.layer.borderWidth = 1.0f;
    
    if (title != nil)
    {
        txt.placeholder = title;
    }
    
    [_contentView addSubview:txt];
    [_inputs addObject:txt];
    
    // If there are other fields in the inputs array, get the previous field and set the
    // return key type on that to next.
    if (_inputs.count > 1)
    {
        NSUInteger indexOfCurrentField = [_inputs indexOfObject:txt];
        UITextField *priorField = _inputs[indexOfCurrentField - 1];
        priorField.returnKeyType = UIReturnKeyNext;
    }
    return txt;
}

# pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // If this is the last object in the inputs array, resign first responder
    // as the form is at the end.
    if (textField == [_inputs lastObject])
    {
        [textField resignFirstResponder];
    }
    else // Otherwise find the next field and make it first responder.
    {
        NSUInteger indexOfCurrentField = [_inputs indexOfObject:textField];
        UITextField *nextField = _inputs[indexOfCurrentField + 1];
        [nextField becomeFirstResponder];
    }
    return NO;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.view.frame;
        f.origin.y -= KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT;
        self.view.frame = f;
    }];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.view.frame;
        f.origin.y += KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT;
        self.view.frame = f;
    }];
}

#pragma mark - Buttons

- (SCLButton *)addButton:(NSString *)title
{
    // Update view height
    kWindowHeight += 45.0;
    
    // Add button
    SCLButton *btn = [[SCLButton alloc] init];
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kButtonFont size:14.0f];

    [_contentView addSubview:btn];
    [_buttons addObject:btn];
    
    return btn;
}

- (SCLButton *)addDoneButtonWithTitle:(NSString *)title
{
    SCLButton *btn = [self addButton:title];
    
    if (_completeButtonFormatBlock != nil)
    {
        btn.completeButtonFormatBlock = _completeButtonFormatBlock;
    }
    
    [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title actionBlock:(ActionBlock)action
{
    SCLButton *btn = [self addButton:title];
    btn.actionType = Block;
    btn.actionBlock = action;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

- (SCLButton *)addButton:(NSString *)title validationBlock:(ValidationBlock)validationBlock actionBlock:(ActionBlock)action
{
    SCLButton *btn = [self addButton:title actionBlock:action];
    btn.validationBlock = validationBlock;
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector
{
    SCLButton *btn = [self addButton:title];
    btn.actionType = Selector;
    btn.target = target;
    btn.selector = selector;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)buttonTapped:(SCLButton *)btn
{
    // If the button has a validation block, and the validation block returns NO, validation
    // failed, so we should bail.
    if (btn.validationBlock && btn.validationBlock() == NO) {
        return;
    }
    if (btn.actionType == Block)
    {
        if (btn.actionBlock)
            btn.actionBlock();
    }
    else if (btn.actionType == Selector)
    {
        UIControl *ctrl = [[UIControl alloc] init];
        [ctrl sendAction:btn.selector to:btn.target forEvent:nil];
    }
    else
    {
        NSLog(@"Unknown action type for button");
    }
    if([self isVisible])
    {
        [self hideView];
    }
}

#pragma mark - Show Alert

-(SCLAlertViewResponder *)showTitle:(UIViewController *)vc image:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle duration:(NSTimeInterval)duration completeText:(NSString *)completeText style:(SCLAlertViewStyle)style
{
    self.view.alpha = 0;
    self.rootViewController = vc;
    
    // Add subviews
    [self.rootViewController addChildViewController:self];
    self.shadowView.frame = vc.view.bounds;
    [self.rootViewController.view addSubview:self.shadowView];
    [self.rootViewController.view addSubview:self.view];

    // Alert color/icon
    UIColor *viewColor;
    UIImage *iconImage;

    // Icon style
    switch (style)
    {
        case Success:
            viewColor = UIColorFromRGB(0x22B573);
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark;
            break;

        case Error:
            viewColor = UIColorFromRGB(0xC1272D);
            iconImage = SCLAlertViewStyleKit.imageOfCross;
            break;

        case Notice:
            viewColor = UIColorFromRGB(0x727375);
            iconImage = SCLAlertViewStyleKit.imageOfNotice;
            break;

        case Warning:
            viewColor = UIColorFromRGB(0xFFD110);
            iconImage = SCLAlertViewStyleKit.imageOfWarning;
            break;

        case Info:
            viewColor = UIColorFromRGB(0x2866BF);
            iconImage = SCLAlertViewStyleKit.imageOfInfo;
            break;

        case Edit:
            viewColor = UIColorFromRGB(0xA429FF);
            iconImage = SCLAlertViewStyleKit.imageOfEdit;
            break;
            
        case Custom:
            viewColor = color;
            iconImage = image;
            kCircleIconHeight = kCircleIconHeight * 2;
            break;
    }

    // Title
    if([title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
    {
        self.labelTitle.text = title;
    }

    // Subtitle
    if([subTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
    {
        // No custom text
        if (_attributedFormatBlock == nil)
        {
            _viewText.text = subTitle;
        }
        else
        {
            _viewText.attributedText = self.attributedFormatBlock(subTitle);
        }
        
        // Adjust text view size, if necessary
        CGSize sz = CGSizeMake(kWindowWidth - 24.0f, 90.0f);
        NSDictionary *attr = @{NSFontAttributeName:self.viewText.font};
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            NSString *str = subTitle;
            CGRect r = [str boundingRectWithSize:sz options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
            CGFloat ht = ceil(r.size.height) + 10;
            if (ht < kTextHeight)
            {
                kWindowHeight -= (kTextHeight - ht);
                kTextHeight = ht;
            }
        }
        else
        {
            NSAttributedString *str =[[NSAttributedString alloc] initWithString:subTitle];
            CGRect r = [str boundingRectWithSize:sz options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            CGFloat ht = ceil(r.size.height) + 10;
            if (ht < kTextHeight)
            {
                kWindowHeight -= (kTextHeight - ht);
                kTextHeight = ht;
            }
        }
    }
    
    // Play sound, if necessary
    if(_soundURL != nil)
    {
        if (_audioPlayer == nil)
        {
            NSLog(@"You need to set your sound file first");
        }
        else
        {
            [_audioPlayer play];
        }
    }

    // Add button, if necessary
    if(completeText != nil)
    {
        [self addDoneButtonWithTitle:completeText];
    }

    // Alert view colour and images
    self.circleView.backgroundColor = viewColor;
    self.circleIconImageView.image  = iconImage;
    
    for (UITextField *textField in _inputs)
    {
        textField.layer.borderColor = viewColor.CGColor;
    }
    
    for (SCLButton *btn in _buttons)
    {
        if (btn.completeButtonFormatBlock != nil)
        {
            [btn parseConfig:btn.completeButtonFormatBlock()];
        }
        else if (btn.buttonFormatBlock != nil)
        {
            [btn parseConfig:btn.buttonFormatBlock()];
        }
        else
        {
            btn.defaultBackgroundColor = viewColor;
        }
        if (style == Warning)
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    // Adding duration
    if (duration > 0)
    {
        [durationTimer invalidate];
        durationTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                          target:self
                                                        selector:@selector(hideView)
                                                        userInfo:nil
                                                         repeats:NO];
    }

    // Show the alert view
    [self showView];

    // Chainable objects
    return [[SCLAlertViewResponder alloc] init:self];
}

- (void)showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:Success];
}

- (void)showError:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:Error];
}

- (void)showNotice:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:Notice];
}

- (void)showWarning:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:Warning];
}

- (void)showInfo:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:Info];
}

- (void)showEdit:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:Edit];
}

- (void)showTitle:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:style];
}

- (void)showCustom:(UIViewController *)vc image:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:image color:color title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:Custom];
}

#pragma mark - Visibility

- (BOOL)isVisible
{
    return (self.shadowView.alpha && self.view.alpha);
}

- (void)alertIsDismissed:(DismissBlock)dismissBlock
{
    self.dismissBlock = dismissBlock;
}

#pragma mark - Show Alert

- (void)showView
{
    switch (_showAnimationType)
    {
        case FadeIn:
            [self fadeIn];
            break;
            
        case SlideInFromBottom:
            [self slideInFromBottom];
            break;
            
        case SlideInFromTop:
            [self slideInFromTop];
            break;
            
        case SlideInFromLeft:
            [self slideInFromLeft];
            break;
            
        case SlideInFromRight:
            [self slideInFromRight];
            break;
    }
}

#pragma mark - Hide Alert

- (void)hideView
{
    switch (_hideAnimationType)
    {
        case FadeOut:
            [self fadeOut];
            break;
            
        case SlideOutToBottom:
            [self slideOutToBottom];
            break;
            
        case SlideOutToTop:
            [self slideOutToTop];
            break;
            
        case SlideOutToLeft:
            [self slideOutToLeft];
            break;
            
        case SlideOutToRight:
            [self slideOutToRight];
            break;
    }
    if (self.dismissBlock)
    {
        self.dismissBlock();
    }
}

#pragma mark - Hide Animations

- (void)fadeOut
{
    [UIView animateWithDuration:0.3f animations:^{
        self.shadowView.alpha = 0.0f;
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self.shadowView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)slideOutToBottom
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y += self.shadowView.frame.size.height;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToTop
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= self.shadowView.frame.size.height;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToLeft
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x -= self.shadowView.frame.size.width;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToRight
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x += self.shadowView.frame.size.width;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

#pragma mark - Show Animations

- (void)fadeIn
{
    self.shadowView.alpha = 0.0f;
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.shadowView.alpha = kDefaultShadowOpacity;
                         self.view.alpha = 1.0f;
                     }
                     completion:nil];
}

- (void)slideInFromTop
{
    [UIView animateWithDuration:0.3f animations:^{
        self.shadowView.alpha = kDefaultShadowOpacity;
        
        //New Frame
        CGRect frame = self.view.frame;
        frame.origin.y = self.shadowView.frame.size.height;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = self.rootViewController.view.center;
        }];
    }];
}

- (void)slideInFromBottom
{
    [UIView animateWithDuration:0.3f animations:^{
        self.shadowView.alpha = kDefaultShadowOpacity;
        
        //New Frame
        CGRect frame = self.view.frame;
        frame.origin.y -= self.shadowView.frame.size.height;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = self.rootViewController.view.center;
        }];
    }];
}

- (void)slideInFromLeft
{
    [UIView animateWithDuration:0.3f animations:^{
        self.shadowView.alpha = kDefaultShadowOpacity;
        
        //New Frame
        CGRect frame = self.view.frame;
        frame.origin.x = self.shadowView.frame.size.width;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = self.rootViewController.view.center;
        }];
    }];
}

- (void)slideInFromRight
{
    [UIView animateWithDuration:0.3f animations:^{
        self.shadowView.alpha = kDefaultShadowOpacity;
        
        //New Frame
        CGRect frame = self.view.frame;
        frame.origin.x -= self.shadowView.frame.size.width;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = self.rootViewController.view.center;
        }];
    }];
}

@end
