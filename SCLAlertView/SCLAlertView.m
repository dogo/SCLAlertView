//
//  SCLAlertView.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertView.h"
#import "SCLAlertViewResponder.h"
#import "SCLAlertViewStyleKit.h"
#import "UIImage+ImageEffects.h"
#import "SCLTimerDisplay.h"
#import "SCLMacros.h"

#if defined(__has_feature) && __has_feature(modules)
@import AVFoundation;
@import AudioToolbox;
#else
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#endif

#define KEYBOARD_HEIGHT 80
#define PREDICTION_BAR_HEIGHT 40
#define ADD_BUTTON_PADDING 10.0f
#define DEFAULT_WINDOW_WIDTH 240

@interface SCLAlertView ()  <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *inputs;
@property (strong, nonatomic) NSMutableArray *customViews;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIImageView *circleIconImageView;
@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UIView *circleViewBackground;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) NSString *titleFontFamily;
@property (strong, nonatomic) NSString *bodyTextFontFamily;
@property (strong, nonatomic) NSString *buttonsFontFamily;
@property (strong, nonatomic) UIWindow *previousWindow;
@property (strong, nonatomic) UIWindow *SCLAlertWindow;
@property (copy, nonatomic) SCLDismissBlock dismissBlock;
@property (copy, nonatomic) SCLDismissAnimationCompletionBlock dismissAnimationCompletionBlock;
@property (copy, nonatomic) SCLShowAnimationCompletionBlock showAnimationCompletionBlock;
@property (weak, nonatomic) UIViewController *rootViewController;
@property (weak, nonatomic) id<UIGestureRecognizerDelegate> restoreInteractivePopGestureDelegate;
@property (assign, nonatomic) SystemSoundID soundID;
@property (assign, nonatomic) BOOL canAddObservers;
@property (assign, nonatomic) BOOL keyboardIsVisible;
@property (assign, nonatomic) BOOL usingNewWindow;
@property (assign, nonatomic) BOOL restoreInteractivePopGestureEnabled;
@property (nonatomic) CGFloat backgroundOpacity;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGFloat bodyFontSize;
@property (nonatomic) CGFloat buttonsFontSize;
@property (nonatomic) CGFloat windowHeight;
@property (nonatomic) CGFloat windowWidth;
@property (nonatomic) CGFloat subTitleHeight;
@property (nonatomic) CGFloat subTitleY;

@end

@implementation SCLAlertView

CGFloat kCircleHeight;
CGFloat kCircleTopPosition;
CGFloat kCircleBackgroundTopPosition;
CGFloat kCircleHeightBackground;
CGFloat kActivityIndicatorHeight;
CGFloat kTitleTop;
CGFloat kTitleHeight;

// Timer
NSTimer *durationTimer;
SCLTimerDisplay *buttonTimer;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
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
        [self setupViewWindowWidth:DEFAULT_WINDOW_WIDTH];
    }
    return self;
}

- (instancetype)initWithWindowWidth:(CGFloat)windowWidth
{
    self = [super init];
    if (self)
    {
        [self setupViewWindowWidth:windowWidth];
    }
    return self;
}

- (instancetype)initWithNewWindow
{
    self = [self initWithWindowWidth:DEFAULT_WINDOW_WIDTH];
    if(self)
    {
        [self setupNewWindow];
    }
    return self;
}

- (instancetype)initWithNewWindowWidth:(CGFloat)windowWidth
{
    self = [self initWithWindowWidth:windowWidth];
    if(self)
    {
        [self setupNewWindow];
    }
    return self;
}

- (void)dealloc
{
    [self removeObservers];
    [self restoreInteractivePopGesture];
}

- (void)addObservers
{
    if(_canAddObservers)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        _canAddObservers = NO;
    }
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Setup view

- (void)setupViewWindowWidth:(CGFloat)windowWidth
{
    // Default values
    kCircleBackgroundTopPosition = -15.0f;
    kCircleHeight = 56.0f;
    kCircleHeightBackground = 62.0f;
    kActivityIndicatorHeight = 40.0f;
    kTitleTop = 30.0f;
    kTitleHeight = 40.0f;
    self.subTitleY = 70.0f;
    self.subTitleHeight = 90.0f;
    self.circleIconHeight = 20.0f;
    self.windowWidth = windowWidth;
    self.windowHeight = 178.0f;
    self.shouldDismissOnTapOutside = NO;
    self.usingNewWindow = NO;
    self.canAddObservers = YES;
    self.keyboardIsVisible = NO;
    self.hideAnimationType =  SCLAlertViewHideAnimationFadeOut;
    self.showAnimationType = SCLAlertViewShowAnimationSlideInFromTop;
    self.backgroundType = SCLAlertViewBackgroundShadow;
    self.tintTopCircle = YES;
    
    // Font
    _titleFontFamily = @"HelveticaNeue";
    _bodyTextFontFamily = @"HelveticaNeue";
    _buttonsFontFamily = @"HelveticaNeue-Bold";
    _titleFontSize = 20.0f;
    _bodyFontSize = 14.0f;
    _buttonsFontSize = 14.0f;
    
    // Init
    _labelTitle = [[UILabel alloc] init];
    _viewText = [[UITextView alloc] init];
    _viewText.accessibilityTraits = UIAccessibilityTraitStaticText;
    _contentView = [[UIView alloc] init];
    _circleView = [[UIView alloc] init];
    _circleViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kCircleHeightBackground, kCircleHeightBackground)];
    _circleIconImageView = [[UIImageView alloc] init];
    _backgroundView = [[UIImageView alloc] initWithFrame:[self mainScreenFrame]];
    _buttons = [[NSMutableArray alloc] init];
    _inputs = [[NSMutableArray alloc] init];
    _customViews = [[NSMutableArray alloc] init];
    self.view.accessibilityViewIsModal = YES;
    
    // Add Subviews
    [self.view addSubview:_contentView];
    [self.view addSubview:_circleViewBackground];
    
    // Circle View
    CGFloat x = (kCircleHeightBackground - kCircleHeight) / 2;
    _circleView.frame = CGRectMake(x, x, kCircleHeight, kCircleHeight);
    _circleView.layer.cornerRadius = _circleView.frame.size.height / 2;
    
    // Circle Background View
    _circleViewBackground.backgroundColor = [UIColor whiteColor];
    _circleViewBackground.layer.cornerRadius = _circleViewBackground.frame.size.height / 2;
    x = (kCircleHeight - _circleIconHeight) / 2;
    
    // Circle Image View
    _circleIconImageView.frame = CGRectMake(x, x, _circleIconHeight, _circleIconHeight);
    _circleIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_circleViewBackground addSubview:_circleView];
    [_circleView addSubview:_circleIconImageView];
    
    // Background View
    _backgroundView.userInteractionEnabled = YES;
    
    // Title
    _labelTitle.numberOfLines = 1;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.font = [UIFont fontWithName:_titleFontFamily size:_titleFontSize];
    _labelTitle.frame = CGRectMake(12.0f, kTitleTop, _windowWidth - 24.0f, kTitleHeight);
    
    // View text
    _viewText.editable = NO;
    _viewText.allowsEditingTextAttributes = YES;
    _viewText.textAlignment = NSTextAlignmentCenter;
    _viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
    _viewText.frame = CGRectMake(12.0f, _subTitleY, _windowWidth - 24.0f, _subTitleHeight);
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        _viewText.textContainerInset = UIEdgeInsetsZero;
        _viewText.textContainer.lineFragmentPadding = 0;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Content View
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5.0f;
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.borderWidth = 0.5f;
    [_contentView addSubview:_viewText];    
    [_contentView addSubview:_labelTitle];
    
    // Colors
    self.backgroundViewColor = [UIColor whiteColor];
    _labelTitle.textColor = UIColorFromHEX(0x4D4D4D); //Dark Grey
    _viewText.textColor = UIColorFromHEX(0x4D4D4D); //Dark Grey
    _contentView.layer.borderColor = UIColorFromHEX(0xCCCCCC).CGColor; //Light Grey
}

- (void)setupNewWindow
{
    // Create a new one to show the alert
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[self mainScreenFrame]];
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.backgroundColor = [UIColor clearColor];
    alertWindow.rootViewController = self;
    alertWindow.accessibilityViewIsModal = YES;
    self.SCLAlertWindow = alertWindow;
    
    self.usingNewWindow = YES;
}

#pragma mark - Modal Validation

- (BOOL)isModal
{
    return (_rootViewController != nil && _rootViewController.presentingViewController);
}

#pragma mark - View Cycle

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize sz = [self mainScreenFrame].size;
    
    // Check for larger top circle icon flag
    if (_useLargerIcon) {
        // Adjust icon
        _circleIconHeight = 70.0f;
        
        // Adjust coordinate variables for larger sized top circle
        kCircleBackgroundTopPosition = -61.0f;
        kCircleHeight = 106.0f;
        kCircleHeightBackground = 122.0f;
        
        // Reposition inner circle appropriately
        CGFloat x = (kCircleHeightBackground - kCircleHeight) / 2;
        _circleView.frame = CGRectMake(x, x, kCircleHeight, kCircleHeight);
        if (_labelTitle.text == nil)
        {
            kTitleTop = kCircleHeightBackground / 2;
        }
    } else {
        kCircleBackgroundTopPosition = -(kCircleHeightBackground / 2);
    }
    
    // Check if the rootViewController is modal, if so we need to get the modal size not the main screen size
    if([self isModal] && !_usingNewWindow)
    {
        sz = _rootViewController.view.frame.size;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        // iOS versions before 7.0 did not switch the width and height on device roration
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            CGSize ssz = sz;
            sz = CGSizeMake(ssz.height, ssz.width);
        }
    }
    
    // Set new background frame
    CGRect newBackgroundFrame = self.backgroundView.frame;
    newBackgroundFrame.size = sz;
    self.backgroundView.frame = newBackgroundFrame;
    
    // Set new main frame
    CGRect r;
    if (self.view.superview != nil)
    {
        // View is showing, position at center of screen
        r = CGRectMake((sz.width-_windowWidth)/2, (sz.height-_windowHeight)/2, _windowWidth, _windowHeight);
    }
    else
    {
        // View is not visible, position outside screen bounds
        r = CGRectMake((sz.width-_windowWidth)/2, -_windowHeight, _windowWidth, _windowHeight);
    }
    
    // Set frames
    self.view.frame = r;
    _contentView.frame = CGRectMake(0.0f, 0.0f, _windowWidth, _windowHeight);
    _circleViewBackground.frame = CGRectMake(_windowWidth / 2 - kCircleHeightBackground / 2, kCircleBackgroundTopPosition, kCircleHeightBackground, kCircleHeightBackground);
    _circleViewBackground.layer.cornerRadius = _circleViewBackground.frame.size.height / 2;
    _circleView.layer.cornerRadius = _circleView.frame.size.height / 2;
    _circleIconImageView.frame = CGRectMake(kCircleHeight / 2 - _circleIconHeight / 2, kCircleHeight / 2 - _circleIconHeight / 2, _circleIconHeight, _circleIconHeight);
    _labelTitle.frame = CGRectMake(12.0f, kTitleTop, _windowWidth - 24.0f, kTitleHeight);
    
    // Text fields
    CGFloat y = (_labelTitle.text == nil) ? kTitleTop : kTitleTop + _labelTitle.frame.size.height;
    _viewText.frame = CGRectMake(12.0f, y, _windowWidth - 24.0f, _subTitleHeight);
    
    if (!_labelTitle && !_viewText) {
        y = 0.0f;
    }

    y += _subTitleHeight + 14.0f;
    for (SCLTextView *textField in _inputs)
    {
        textField.frame = CGRectMake(12.0f, y, _windowWidth - 24.0f, textField.frame.size.height);
        textField.layer.cornerRadius = 3.0f;
        y += textField.frame.size.height + 10.0f;
    }
    
    // Custom views
    for (UIView *view in _customViews)
    {
        view.frame = CGRectMake(12.0f, y, view.frame.size.width, view.frame.size.height);
        y += view.frame.size.height + 10.0f;
    }
    
    // Buttons
    CGFloat x = 12.0f;
    for (SCLButton *btn in _buttons)
    {
        btn.frame = CGRectMake(x, y, btn.frame.size.width, btn.frame.size.height);
        
        // Add horizontal or vertical offset acording on _horizontalButtons parameter
        if (_horizontalButtons) {
            x += btn.frame.size.width + 10.0f;
        } else {
            y += btn.frame.size.height + 10.0f;
        }
    }
    
    // Adapt window height according to icon size
    self.windowHeight = _useLargerIcon ? y : self.windowHeight;
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _windowWidth, _windowHeight);
    
    // Adjust corner radius, if a value has been passed
    _contentView.layer.cornerRadius = self.cornerRadius ? self.cornerRadius : 5.0f;
}

#pragma mark - UIViewController

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

#pragma mark - Handle gesture

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (_shouldDismissOnTapOutside)
    {
        BOOL hide = _shouldDismissOnTapOutside;
        
        for(SCLTextView *txt in _inputs)
        {
            // Check if there is any keyboard on screen and dismiss
            if (txt.editing)
            {
                [txt resignFirstResponder];
                hide = NO;
            }
        }
        if(hide)
        {
            [self hideView];
        }
    }
}

- (void)setShouldDismissOnTapOutside:(BOOL)shouldDismissOnTapOutside
{
    _shouldDismissOnTapOutside = shouldDismissOnTapOutside;
    
    if(_shouldDismissOnTapOutside)
    {
        self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_backgroundView addGestureRecognizer:_gestureRecognizer];
    }
}

- (void)disableInteractivePopGesture
{
    UINavigationController *navigationController;
    
    if([_rootViewController isKindOfClass:[UINavigationController class]])
    {
        navigationController = ((UINavigationController*)_rootViewController);
    }
    else
    {
        navigationController = _rootViewController.navigationController;
    }
    
    // Disable iOS 7 back gesture
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        _restoreInteractivePopGestureEnabled = navigationController.interactivePopGestureRecognizer.enabled;
        _restoreInteractivePopGestureDelegate = navigationController.interactivePopGestureRecognizer.delegate;
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)restoreInteractivePopGesture
{
    UINavigationController *navigationController;
    
    if([_rootViewController isKindOfClass:[UINavigationController class]])
    {
        navigationController = ((UINavigationController*)_rootViewController);
    }
    else
    {
        navigationController = _rootViewController.navigationController;
    }
    
    // Restore iOS 7 back gesture
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = _restoreInteractivePopGestureEnabled;
        navigationController.interactivePopGestureRecognizer.delegate = _restoreInteractivePopGestureDelegate;
    }
}

#pragma mark - Custom Fonts

- (void)setTitleFontFamily:(NSString *)titleFontFamily withSize:(CGFloat)size
{
    self.titleFontFamily = titleFontFamily;
    self.titleFontSize = size;
    self.labelTitle.font = [UIFont fontWithName:_titleFontFamily size:_titleFontSize];
}

- (void)setBodyTextFontFamily:(NSString *)bodyTextFontFamily withSize:(CGFloat)size
{
    self.bodyTextFontFamily = bodyTextFontFamily;
    self.bodyFontSize = size;
    self.viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
}

- (void)setButtonsTextFontFamily:(NSString *)buttonsFontFamily withSize:(CGFloat)size
{
    self.buttonsFontFamily = buttonsFontFamily;
    self.buttonsFontSize = size;
}

#pragma mark - Background Color

- (void)setBackgroundViewColor:(UIColor *)backgroundViewColor
{
    _backgroundViewColor = backgroundViewColor;
    _circleViewBackground.backgroundColor = _backgroundViewColor;
    _contentView.backgroundColor = _backgroundViewColor;
    _viewText.backgroundColor = _backgroundViewColor;
}

#pragma mark - Sound

- (void)setSoundURL:(NSURL *)soundURL
{
    _soundURL = soundURL;
    
    //DisposeSound
    AudioServicesDisposeSystemSoundID(_soundID);
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)_soundURL, &_soundID);
    
    //PlaySound
    AudioServicesPlaySystemSound(_soundID);
}

#pragma mark - Subtitle Height

- (void)setSubTitleHeight:(CGFloat)value
{
    _subTitleHeight = value;
}

#pragma mark - ActivityIndicator

- (void)addActivityIndicatorView
{
    // Add UIActivityIndicatorView
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.frame = CGRectMake(kCircleHeight / 2 - kActivityIndicatorHeight / 2, kCircleHeight / 2 - kActivityIndicatorHeight / 2, kActivityIndicatorHeight, kActivityIndicatorHeight);
    [_circleView addSubview:_activityIndicatorView];
}

#pragma mark - UICustomView

- (UIView *)addCustomView:(UIView *)customView
{
    // Update view height
    self.windowHeight += customView.bounds.size.height + 10.0f;
    
    [_contentView addSubview:customView];
    [_customViews addObject:customView];
    
    return customView;
}

#pragma mark - SwitchView

- (SCLSwitchView *)addSwitchViewWithLabel:(NSString *)label
{
    // Add switch view
    SCLSwitchView *switchView = [[SCLSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.windowWidth, 31.0f)];
    
    // Update view height
    self.windowHeight += switchView.bounds.size.height + 10.0f;
    
    if (label != nil)
    {
        switchView.labelText = label;
    }
    
    [_contentView addSubview:switchView];
    [_inputs addObject:switchView];
    
    return switchView;
}

#pragma mark - TextField

- (SCLTextView *)addTextField:(NSString *)title
{
    [self addObservers];
    
    // Add text field
    SCLTextView *txt = [[SCLTextView alloc] init];
    txt.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
    txt.delegate = self;
    
    // Update view height
    self.windowHeight += txt.bounds.size.height + 10.0f;
    
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
        SCLTextView *priorField = _inputs[indexOfCurrentField - 1];
        priorField.returnKeyType = UIReturnKeyNext;
    }
    return txt;
}

- (void)addCustomTextField:(UITextField *)textField
{
    // Update view height
    self.windowHeight += textField.bounds.size.height + 10.0f;
    
    [_contentView addSubview:textField];
    [_inputs addObject:textField];
    
    // If there are other fields in the inputs array, get the previous field and set the
    // return key type on that to next.
    if (_inputs.count > 1)
    {
        NSUInteger indexOfCurrentField = [_inputs indexOfObject:textField];
        UITextField *priorField = _inputs[indexOfCurrentField - 1];
        priorField.returnKeyType = UIReturnKeyNext;
    }
}

# pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // If this is the last object in the inputs array, resign first responder
    // as the form is at the end.
    if (textField == _inputs.lastObject)
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(_keyboardIsVisible) return;
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.view.frame;
        f.origin.y -= KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT;
        self.view.frame = f;
    }];
    _keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if(!_keyboardIsVisible) return;
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.view.frame;
        f.origin.y += KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT;
        self.view.frame = f;
    }];
    _keyboardIsVisible = NO;
}

#pragma mark - Buttons

- (SCLButton *)addButton:(NSString *)title
{
    // Add button
    SCLButton *btn = [[SCLButton alloc] initWithWindowWidth:self.windowWidth];
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:_buttonsFontFamily size:_buttonsFontSize];
    
    [_contentView addSubview:btn];
    [_buttons addObject:btn];
    
    if (_horizontalButtons) {
        // Update buttons width according to the number of buttons
        for (SCLButton *bttn in _buttons) {
            [bttn adjustWidthWithWindowWidth:self.windowWidth numberOfButtons:[_buttons count]];
        }
        
        // Update view height
        if (!([_buttons count] > 1)) {
            self.windowHeight += (btn.frame.size.height + ADD_BUTTON_PADDING);
        }
    } else {
        // Update view height
        self.windowHeight += (btn.frame.size.height + ADD_BUTTON_PADDING);
    }
    
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

- (SCLButton *)addButton:(NSString *)title actionBlock:(SCLActionBlock)action
{
    SCLButton *btn = [self addButton:title];
    
    if (_buttonFormatBlock != nil)
    {
        btn.buttonFormatBlock = _buttonFormatBlock;
    }
    
    btn.actionType = SCLBlock;
    btn.actionBlock = action;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action
{
    SCLButton *btn = [self addButton:title actionBlock:action];
    btn.validationBlock = validationBlock;
    
    return btn;
}

- (SCLButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector
{
    SCLButton *btn = [self addButton:title];
    btn.actionType = SCLSelector;
    btn.target = target;
    btn.selector = selector;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)buttonTapped:(SCLButton *)btn
{
    // Cancel Countdown timer
    [buttonTimer cancelTimer];
    
    // If the button has a validation block, and the validation block returns NO, validation
    // failed, so we should bail.
    if (btn.validationBlock && !btn.validationBlock()) {
        return;
    }
    
    if (btn.actionType == SCLBlock)
    {
        if (btn.actionBlock)
            btn.actionBlock();
    }
    else if (btn.actionType == SCLSelector)
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

#pragma mark - Button Timer

- (void)addTimerToButtonIndex:(NSInteger)buttonIndex reverse:(BOOL)reverse
{
    buttonIndex = MAX(buttonIndex, 0);
    buttonIndex = MIN(buttonIndex, [_buttons count]);
    
    buttonTimer = [[SCLTimerDisplay alloc] initWithOrigin:CGPointMake(5, 5) radius:13 lineWidth:4];
    buttonTimer.buttonIndex = buttonIndex;
    buttonTimer.reverse = reverse;
}

#pragma mark - Show Alert

- (SCLAlertViewResponder *)showTitle:(UIViewController *)vc image:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle duration:(NSTimeInterval)duration completeText:(NSString *)completeText style:(SCLAlertViewStyle)style
{
    if(_usingNewWindow)
    {
        // Save previous window
        self.previousWindow = [UIApplication sharedApplication].keyWindow;
        self.backgroundView.frame = _SCLAlertWindow.bounds;
        
        // Add window subview
        [_SCLAlertWindow addSubview:_backgroundView];
    }
    else
    {
        _rootViewController = vc;
        
        [self disableInteractivePopGesture];
        
        self.backgroundView.frame = vc.view.bounds;
        
        // Add view controller subviews
        [_rootViewController addChildViewController:self];
        [_rootViewController.view addSubview:_backgroundView];
        [_rootViewController.view addSubview:self.view];
    }
    
    self.view.alpha = 0.0f;
    [self setBackground];
    
    // Alert color/icon
    UIColor *viewColor;
    UIImage *iconImage;
    
    // Icon style
    switch (style)
    {
        case SCLAlertViewStyleSuccess:
            viewColor = UIColorFromHEX(0x22B573);
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark;
            break;
            
        case SCLAlertViewStyleError:
            viewColor = UIColorFromHEX(0xC1272D);
            iconImage = SCLAlertViewStyleKit.imageOfCross;
            break;
            
        case SCLAlertViewStyleNotice:
            viewColor = UIColorFromHEX(0x727375);
            iconImage = SCLAlertViewStyleKit.imageOfNotice;
            break;
            
        case SCLAlertViewStyleWarning:
            viewColor = UIColorFromHEX(0xFFD110);
            iconImage = SCLAlertViewStyleKit.imageOfWarning;
            break;
            
        case SCLAlertViewStyleInfo:
            viewColor = UIColorFromHEX(0x2866BF);
            iconImage = SCLAlertViewStyleKit.imageOfInfo;
            break;
            
        case SCLAlertViewStyleEdit:
            viewColor = UIColorFromHEX(0xA429FF);
            iconImage = SCLAlertViewStyleKit.imageOfEdit;
            break;
            
        case SCLAlertViewStyleWaiting:
            viewColor = UIColorFromHEX(0x6c125d);
            break;
            
        case SCLAlertViewStyleQuestion:
            viewColor = UIColorFromHEX(0x727375);
            iconImage = SCLAlertViewStyleKit.imageOfQuestion;
            break;
            
        case SCLAlertViewStyleCustom:
            viewColor = color;
            iconImage = image;
            self.circleIconHeight *= 2.0f;
            break;
    }
    
    // Custom Alert color
    if(_customViewColor)
    {
        viewColor = _customViewColor;
    }
    
    // Title
    if([title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
    {
        self.labelTitle.text = title;
    }
    else
    {
        // Title is nil, we can move the body message to center and remove it from superView
        self.windowHeight -= _labelTitle.frame.size.height;
        [_labelTitle removeFromSuperview];
        _labelTitle = nil;
        
        _subTitleY = kCircleHeight - 20;
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
            self.viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
            _viewText.attributedText = self.attributedFormatBlock(subTitle);
        }
        
        // Adjust text view size, if necessary
        CGSize sz = CGSizeMake(_windowWidth - 24.0f, CGFLOAT_MAX);
        
        CGSize size = [_viewText sizeThatFits:sz];
        
        CGFloat ht = ceilf(size.height);
        if (ht < _subTitleHeight)
        {
            self.windowHeight -= (_subTitleHeight - ht);
            self.subTitleHeight = ht;
        }
        else
        {
            self.windowHeight += (ht - _subTitleHeight);
            self.subTitleHeight = ht;
        }
        _viewText.frame = CGRectMake(12.0f, _subTitleY, _windowWidth - 24.0f, _subTitleHeight);
    }
    else
    {
        // Subtitle is nil, we can move the title to center and remove it from superView
        self.subTitleHeight = 0.0f;
        self.windowHeight -= _viewText.frame.size.height;
        [_viewText removeFromSuperview];
        _viewText = nil;
        
        // Move up
        _labelTitle.frame = CGRectMake(12.0f, 37.0f, _windowWidth - 24.0f, kTitleHeight);
    }
    
    if (!_labelTitle && !_viewText) {
        self.windowHeight -= kTitleTop;
    }
    
    // Add button, if necessary
    if(completeText != nil)
    {
        [self addDoneButtonWithTitle:completeText];
    }
    
    // Alert view color and images
    self.circleView.backgroundColor = self.tintTopCircle ? viewColor : _backgroundViewColor;
    
    if (style == SCLAlertViewStyleWaiting)
    {
        [self.activityIndicatorView startAnimating];
    }
    else
    {
        if (self.iconTintColor) {
            self.circleIconImageView.tintColor = self.iconTintColor;
            iconImage  = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        self.circleIconImageView.image = iconImage;
    }
    
    for (SCLTextView *textField in _inputs)
    {
        textField.layer.borderColor = viewColor.CGColor;
    }
    
    for (SCLButton *btn in _buttons)
    {
        if (style == SCLAlertViewStyleWarning)
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        if (!btn.defaultBackgroundColor) {
            btn.defaultBackgroundColor = viewColor;
        }
        
        if (btn.completeButtonFormatBlock != nil)
        {
            [btn parseConfig:btn.completeButtonFormatBlock()];
        }
        else if (btn.buttonFormatBlock != nil)
        {
            [btn parseConfig:btn.buttonFormatBlock()];
        }
    }
    
    // Adding duration
    if (duration > 0)
    {
        [durationTimer invalidate];
        
        if (buttonTimer && _buttons.count > 0)
        {
            SCLButton *btn = _buttons[buttonTimer.buttonIndex];
            btn.timer = buttonTimer;
            [buttonTimer startTimerWithTimeLimit:duration completed:^{
                [self buttonTapped:btn];
            }];
        }
        else
        {
            durationTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                             target:self
                                                           selector:@selector(hideView)
                                                           userInfo:nil
                                                            repeats:NO];
        }
    }
    
    if(_usingNewWindow)
    {
        [_SCLAlertWindow makeKeyAndVisible];
    }
    
    // Show the alert view
    [self showView];
    
    // Chainable objects
    return [[SCLAlertViewResponder alloc] init:self];
}

#pragma mark - Show using UIViewController

- (void)showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleSuccess];
}

- (void)showError:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleError];
}

- (void)showNotice:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleNotice];
}

- (void)showWarning:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleWarning];
}

- (void)showInfo:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleInfo];
}

- (void)showEdit:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleEdit];
}

- (void)showTitle:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:style];
}

- (void)showCustom:(UIViewController *)vc image:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:image color:color title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleCustom];
}

- (void)showWaiting:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self addActivityIndicatorView];
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleWaiting];
}

- (void)showQuestion:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleQuestion];
}


#pragma mark - Show using new window

- (void)showSuccess:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleSuccess];
}

- (void)showError:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleError];
}

- (void)showNotice:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleNotice];
}

- (void)showWarning:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleWarning];
}

- (void)showInfo:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleInfo];
}

- (void)showEdit:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleEdit];
}

- (void)showTitle:(NSString *)title subTitle:(NSString *)subTitle style:(SCLAlertViewStyle)style closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:style];
}

- (void)showCustom:(UIImage *)image color:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:image color:color title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleCustom];
}

- (void)showWaiting:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self addActivityIndicatorView];
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleWaiting];
}

- (void)showQuestion:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self showTitle:nil image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:SCLAlertViewStyleQuestion];
}

#pragma mark - Visibility

- (void)removeTopCircle
{
    [_circleViewBackground removeFromSuperview];
    [_circleView removeFromSuperview];
}

- (BOOL)isVisible
{
    return (self.view.alpha);
}

- (void)alertIsDismissed:(SCLDismissBlock)dismissBlock
{
    self.dismissBlock = dismissBlock;
}

- (void)alertDismissAnimationIsCompleted:(SCLDismissAnimationCompletionBlock)dismissAnimationCompletionBlock{
    self.dismissAnimationCompletionBlock = dismissAnimationCompletionBlock;
}

- (void)alertShowAnimationIsCompleted:(SCLShowAnimationCompletionBlock)showAnimationCompletionBlock{
    self.showAnimationCompletionBlock = showAnimationCompletionBlock;
}

- (SCLForceHideBlock)forceHideBlock:(SCLForceHideBlock)forceHideBlock
{
    _forceHideBlock = forceHideBlock;
    
    if (_forceHideBlock)
    {
        [self hideView];
    }
    return _forceHideBlock;
}

- (CGRect)mainScreenFrame
{
    return [self isAppExtension] ? _extensionBounds : [UIApplication sharedApplication].keyWindow.bounds;
}

- (BOOL)isAppExtension
{
    return [[NSBundle mainBundle].executablePath rangeOfString:@".appex/"].location != NSNotFound;
}

#pragma mark - Background Effects

- (void)makeShadowBackground
{
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.7f;
    _backgroundOpacity = 0.7f;
}

- (void)makeBlurBackground
{
    UIView *appView = (_usingNewWindow) ? [UIApplication sharedApplication].keyWindow.subviews.lastObject : _rootViewController.view;
    UIImage *image = [UIImage convertViewToImage:appView];
    UIImage *blurSnapshotImage = [image applyBlurWithRadius:5.0f
                                                  tintColor:[UIColor colorWithWhite:0.2f
                                                                              alpha:0.7f]
                                      saturationDeltaFactor:1.8f
                                                  maskImage:nil];
    
    _backgroundView.image = blurSnapshotImage;
    _backgroundView.alpha = 0.0f;
    _backgroundOpacity = 1.0f;
}

- (void)makeTransparentBackground
{
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.alpha = 0.0f;
    _backgroundOpacity = 1.0f;
}

- (void)setBackground
{
    switch (_backgroundType)
    {
        case SCLAlertViewBackgroundShadow:
            [self makeShadowBackground];
            break;
            
        case SCLAlertViewBackgroundBlur:
            [self makeBlurBackground];
            break;
            
        case SCLAlertViewBackgroundTransparent:
            [self makeTransparentBackground];
            break;
    }
}

#pragma mark - Show Alert

- (void)showView
{
    switch (_showAnimationType)
    {
        case SCLAlertViewShowAnimationFadeIn:
            [self fadeIn];
            break;
            
        case SCLAlertViewShowAnimationSlideInFromBottom:
            [self slideInFromBottom];
            break;
            
        case SCLAlertViewShowAnimationSlideInFromTop:
            [self slideInFromTop];
            break;
            
        case SCLAlertViewShowAnimationSlideInFromLeft:
            [self slideInFromLeft];
            break;
            
        case SCLAlertViewShowAnimationSlideInFromRight:
            [self slideInFromRight];
            break;
            
        case SCLAlertViewShowAnimationSlideInFromCenter:
            [self slideInFromCenter];
            break;
            
        case SCLAlertViewShowAnimationSlideInToCenter:
            [self slideInToCenter];
            break;
            
        case SCLAlertViewShowAnimationSimplyAppear:
            [self simplyAppear];
            break;
    }
}

#pragma mark - Hide Alert

- (void)hideView
{
    switch (_hideAnimationType)
    {
        case SCLAlertViewHideAnimationFadeOut:
            [self fadeOut];
            break;
            
        case SCLAlertViewHideAnimationSlideOutToBottom:
            [self slideOutToBottom];
            break;
            
        case SCLAlertViewHideAnimationSlideOutToTop:
            [self slideOutToTop];
            break;
            
        case SCLAlertViewHideAnimationSlideOutToLeft:
            [self slideOutToLeft];
            break;
            
        case SCLAlertViewHideAnimationSlideOutToRight:
            [self slideOutToRight];
            break;
            
        case SCLAlertViewHideAnimationSlideOutToCenter:
            [self slideOutToCenter];
            break;
            
        case SCLAlertViewHideAnimationSlideOutFromCenter:
            [self slideOutFromCenter];
            break;
        
        case SCLAlertViewHideAnimationSimplyDisappear:
            [self simplyDisappear];
            break;
    }
    
    if (_activityIndicatorView)
    {
        [_activityIndicatorView stopAnimating];
    }
    
    if (durationTimer)
    {
        [durationTimer invalidate];
    }
    
    if (self.dismissBlock)
    {
        self.dismissBlock();
    }
    
    if (_usingNewWindow)
    {
        // Restore previous window
        [self.previousWindow makeKeyAndVisible];
        self.previousWindow = nil;
    }
    
    for (SCLButton *btn in _buttons)
    {
        btn.actionBlock = nil;
        btn.target = nil;
        btn.selector = nil;
    }
}

#pragma mark - Hide Animations

- (void)fadeOut
{
    [self fadeOutWithDuration:0.3f];
}

- (void)fadeOutWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.backgroundView.alpha = 0.0f;
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self.backgroundView removeFromSuperview];
        if (_usingNewWindow)
        {
            // Remove current window
            [self.SCLAlertWindow setHidden:YES];
            self.SCLAlertWindow = nil;
        }
        else
        {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
        if ( _dismissAnimationCompletionBlock ){
            self.dismissAnimationCompletionBlock();
        }
    }];
}

- (void)slideOutToBottom
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y += self.backgroundView.frame.size.height;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToTop
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= self.backgroundView.frame.size.height;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToLeft
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x -= self.backgroundView.frame.size.width;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToRight
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x += self.backgroundView.frame.size.width;
        self.view.frame = frame;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutToCenter
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform =
        CGAffineTransformConcat(CGAffineTransformIdentity,
                                CGAffineTransformMakeScale(0.1f, 0.1f));
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)slideOutFromCenter
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform =
        CGAffineTransformConcat(CGAffineTransformIdentity,
                                CGAffineTransformMakeScale(3.0f, 3.0f));
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self fadeOut];
    }];
}

- (void)simplyDisappear
{
    self.backgroundView.alpha = _backgroundOpacity;
    self.view.alpha = 1.0f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fadeOutWithDuration:0];
    });
}


#pragma mark - Show Animations

- (void)fadeIn
{
    self.backgroundView.alpha = 0.0f;
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundView.alpha = _backgroundOpacity;
                         self.view.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         if ( _showAnimationCompletionBlock ){
                             self.showAnimationCompletionBlock();
                         }
                     }];
}

- (void)slideInFromTop
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        //From Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = -self.backgroundView.frame.size.height;
        self.view.frame = frame;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundView.alpha = _backgroundOpacity;
            
            //To Frame
            CGRect frame = self.backgroundView.frame;
            frame.origin.y = 0.0f;
            self.view.frame = frame;
            
            self.view.alpha = 1.0f;
        } completion:^(BOOL completed) {
            [UIView animateWithDuration:0.2f animations:^{
                self.view.center = _backgroundView.center;
            } completion:^(BOOL finished) {
                if ( _showAnimationCompletionBlock ){
                    self.showAnimationCompletionBlock();
                }
            }];
        }];
    }
    else {
        //From Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = -self.backgroundView.frame.size.height;
        self.view.frame = frame;
        
        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.5f options:0 animations:^{
            self.backgroundView.alpha = _backgroundOpacity;
            
            //To Frame
            CGRect frame = self.backgroundView.frame;
            frame.origin.y = 0.0f;
            self.view.frame = frame;
            
            self.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if ( _showAnimationCompletionBlock ){
                self.showAnimationCompletionBlock();
            }
        }];
    }
}

- (void)slideInFromBottom
{
    //From Frame
    CGRect frame = self.backgroundView.frame;
    frame.origin.y = self.backgroundView.frame.size.height;
    self.view.frame = frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = 0.0f;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        } completion:^(BOOL finished) {
            if ( _showAnimationCompletionBlock ){
                self.showAnimationCompletionBlock();
            }
        }];
    }];
}

- (void)slideInFromLeft
{
    //From Frame
    CGRect frame = self.backgroundView.frame;
    frame.origin.x = -self.backgroundView.frame.size.width;
    self.view.frame = frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.x = 0.0f;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        } completion:^(BOOL finished) {
            if ( _showAnimationCompletionBlock ){
                self.showAnimationCompletionBlock();
            }
        }];
    }];
}

- (void)slideInFromRight
{
    //From Frame
    CGRect frame = self.backgroundView.frame;
    frame.origin.x = self.backgroundView.frame.size.width;
    self.view.frame = frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        CGRect frame = self.backgroundView.frame;
        frame.origin.x = 0.0f;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        } completion:^(BOOL finished) {
            if ( _showAnimationCompletionBlock ){
                self.showAnimationCompletionBlock();
            }
        }];
    }];
}

- (void)slideInFromCenter
{
    //From Frame
    self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                  CGAffineTransformMakeScale(3.0f, 3.0f));
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        } completion:^(BOOL finished) {
            if ( _showAnimationCompletionBlock ){
                self.showAnimationCompletionBlock();
            }
        }];
    }];
}

- (void)slideInToCenter
{
    //From Frame
    self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                  CGAffineTransformMakeScale(0.1f, 0.1f));
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To Frame
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        } completion:^(BOOL finished) {
            if ( _showAnimationCompletionBlock ){
                self.showAnimationCompletionBlock();
            }
        }];
    }];
}

- (void)simplyAppear
{
    self.backgroundView.alpha = 0.0f;
    self.view.alpha = 0.0f;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backgroundView.alpha = _backgroundOpacity;
        self.view.alpha = 1.0f;
        if ( _showAnimationCompletionBlock ){
            self.showAnimationCompletionBlock();
        }
    });
}


@end

@interface SCLALertViewTextFieldBuilder()
#pragma mark - Parameters
@property(copy, nonatomic) NSString *parameterTitle;

#pragma mark - Available later after adding
@property(weak, nonatomic) SCLTextView *textField;

#pragma mark - Setters
@property(copy, nonatomic) SCLALertViewTextFieldBuilder *(^title) (NSString *title);
@end

@implementation SCLALertViewTextFieldBuilder
- (SCLALertViewTextFieldBuilder *(^) (NSString *title))title {
    if (!_title) {
        __weak typeof(self) weakSelf = self;
        _title = ^(NSString *title){
            weakSelf.parameterTitle = title;
            return weakSelf;
        };
    }
    return _title;
}
@end

@interface SCLALertViewButtonBuilder()

#pragma mark - Parameters
@property(copy, nonatomic) NSString *parameterTitle;
@property(weak, nonatomic) id parameterTarget;
@property(assign, nonatomic) SEL parameterSelector;
@property(copy, nonatomic) void(^parameterActionBlock)(void);
@property(copy, nonatomic) BOOL(^parameterValidationBlock)(void);

#pragma mark - Available later after adding
@property(weak, nonatomic) SCLButton *button;

#pragma mark - Setters
@property(copy, nonatomic) SCLALertViewButtonBuilder *(^title) (NSString *title);
@property(copy, nonatomic) SCLALertViewButtonBuilder *(^target) (id target);
@property(copy, nonatomic) SCLALertViewButtonBuilder *(^selector) (SEL selector);
@property(copy, nonatomic) SCLALertViewButtonBuilder *(^actionBlock) (void(^actionBlock)(void));
@property(copy, nonatomic) SCLALertViewButtonBuilder *(^validationBlock) (BOOL(^validationBlock)(void));

@end

@implementation SCLALertViewButtonBuilder
- (SCLALertViewButtonBuilder *(^) (NSString *title))title {
    if (!_title) {
        __weak typeof(self) weakSelf = self;
        _title = ^(NSString *title){
            weakSelf.parameterTitle = title;
            return weakSelf;
        };
    }
    return _title;
}
- (SCLALertViewButtonBuilder *(^) (id target))target {
    if (!_target) {
        __weak typeof(self) weakSelf = self;
        _target = ^(id target){
            weakSelf.parameterTarget = target;
            return weakSelf;
        };
    }
    return _target;
}
- (SCLALertViewButtonBuilder *(^) (SEL selector))selector {
    if (!_selector) {
        __weak typeof(self) weakSelf = self;
        _selector = ^(SEL selector){
            weakSelf.parameterSelector = selector;
            return weakSelf;
        };
    }
    return _selector;
}
- (SCLALertViewButtonBuilder *(^) (void(^actionBlock)(void)))actionBlock {
    if (!_actionBlock) {
        __weak typeof(self) weakSelf = self;
        _actionBlock = ^(void(^actionBlock)(void)){
            weakSelf.parameterActionBlock = actionBlock;
            return weakSelf;
        };
    }
    return _actionBlock;
}
- (SCLALertViewButtonBuilder *(^) (BOOL(^validationBlock)(void)))validationBlock {
    if (!_validationBlock) {
        __weak typeof(self) weakSelf = self;
        _validationBlock = ^(BOOL(^validationBlock)(void)){
            weakSelf.parameterValidationBlock = validationBlock;
            return weakSelf;
        };
    }
    return _validationBlock;
}
@end


@interface SCLAlertViewBuilder()

@property (strong, nonatomic) SCLAlertView *alertView;

@end

@implementation SCLAlertViewBuilder

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.alertView = [[SCLAlertView alloc] init];
    }
    return self;
}
- (instancetype)initWithNewWindow {
    self = [super init];
    if (self) {
        self.alertView = [[SCLAlertView alloc] initWithNewWindow];
    }
    return self;
}

- (instancetype)initWithNewWindowWidth:(CGFloat)width {
    self = [super init];
    if (self) {
        self.alertView = [[SCLAlertView alloc] initWithNewWindowWidth:width];
    }
    return self;
}

#pragma mark - Properties
- (SCLAlertViewBuilder *(^) (CGFloat cornerRadius))cornerRadius {
    if (!_cornerRadius) {
        __weak typeof(self) weakSelf = self;
        _cornerRadius = ^(CGFloat cornerRadius) {
            weakSelf.alertView.cornerRadius = cornerRadius;
            return weakSelf;
        };
    }
    return _cornerRadius;
}

- (SCLAlertViewBuilder *(^) (BOOL tintTopCircle))tintTopCircle {
    if (!_tintTopCircle) {
        __weak typeof(self) weakSelf = self;
        _tintTopCircle = ^(BOOL tintTopCircle) {
            weakSelf.alertView.tintTopCircle = tintTopCircle;
            return weakSelf;
        };
    }
    return _tintTopCircle;
}
- (SCLAlertViewBuilder *(^) (BOOL useLargerIcon))useLargerIcon {
    if (!_useLargerIcon) {
        __weak typeof(self) weakSelf = self;
        _useLargerIcon = ^(BOOL useLargerIcon) {
            weakSelf.alertView.useLargerIcon = useLargerIcon;
            return weakSelf;
        };
    }
    return _useLargerIcon;
}
- (SCLAlertViewBuilder *(^) (UILabel *labelTitle))labelTitle {
    if (!_labelTitle) {
        __weak typeof(self) weakSelf = self;
        _labelTitle = ^(UILabel *labelTitle) {
            weakSelf.alertView.labelTitle = labelTitle;
            return weakSelf;
        };
    }
    return _labelTitle;
}
- (SCLAlertViewBuilder *(^) (UITextView *viewText))viewText {
    if (!_viewText) {
        __weak typeof(self) weakSelf = self;
        _viewText = ^(UITextView *viewText) {
            weakSelf.alertView.viewText = viewText;
            return weakSelf;
        };
    }
    return _viewText;
}
- (SCLAlertViewBuilder *(^) (UIActivityIndicatorView *activityIndicatorView))activityIndicatorView {
    if (!_activityIndicatorView) {
        __weak typeof(self) weakSelf = self;
        _activityIndicatorView = ^(UIActivityIndicatorView *activityIndicatorView) {
            weakSelf.alertView.activityIndicatorView = activityIndicatorView;
            return weakSelf;
        };
    }
    return _activityIndicatorView;
}
- (SCLAlertViewBuilder *(^) (BOOL shouldDismissOnTapOutside))shouldDismissOnTapOutside {
    if (!_shouldDismissOnTapOutside) {
        __weak typeof(self) weakSelf = self;
        _shouldDismissOnTapOutside = ^(BOOL shouldDismissOnTapOutside) {
            weakSelf.alertView.shouldDismissOnTapOutside = shouldDismissOnTapOutside;
            return weakSelf;
        };
    }
    return _shouldDismissOnTapOutside;
}
- (SCLAlertViewBuilder *(^) (NSURL *soundURL))soundURL {
    if (!_soundURL) {
        __weak typeof(self) weakSelf = self;
        _soundURL = ^(NSURL *soundURL) {
            weakSelf.alertView.soundURL = soundURL;
            return weakSelf;
        };
    }
    return _soundURL;
}
- (SCLAlertViewBuilder *(^) (SCLAttributedFormatBlock attributedFormatBlock))attributedFormatBlock {
    if (!_attributedFormatBlock) {
        __weak typeof(self) weakSelf = self;
        _attributedFormatBlock = ^(SCLAttributedFormatBlock attributedFormatBlock) {
            weakSelf.alertView.attributedFormatBlock = attributedFormatBlock;
            return weakSelf;
        };
    }
    return _attributedFormatBlock;
}
- (SCLAlertViewBuilder *(^) (CompleteButtonFormatBlock completeButtonFormatBlock))completeButtonFormatBlock {
    if (!_completeButtonFormatBlock) {
        __weak typeof(self) weakSelf = self;
        _completeButtonFormatBlock = ^(CompleteButtonFormatBlock completeButtonFormatBlock) {
            weakSelf.alertView.completeButtonFormatBlock = completeButtonFormatBlock;
            return weakSelf;
        };
    }
    return _completeButtonFormatBlock;
}
- (SCLAlertViewBuilder *(^) (ButtonFormatBlock buttonFormatBlock))buttonFormatBlock {
    if (!_buttonFormatBlock) {
        __weak typeof(self) weakSelf = self;
        _buttonFormatBlock = ^(ButtonFormatBlock buttonFormatBlock) {
            weakSelf.alertView.buttonFormatBlock = buttonFormatBlock;
            return weakSelf;
        };
    }
    return _buttonFormatBlock;
}
- (SCLAlertViewBuilder *(^) (SCLForceHideBlock forceHideBlock))forceHideBlock {
    if (!_forceHideBlock) {
        __weak typeof(self) weakSelf = self;
        _forceHideBlock = ^(SCLForceHideBlock forceHideBlock) {
            weakSelf.alertView.forceHideBlock = forceHideBlock;
            return weakSelf;
        };
    }
    return _forceHideBlock;
}
- (SCLAlertViewBuilder *(^) (SCLAlertViewHideAnimation hideAnimationType))hideAnimationType {
    if (!_hideAnimationType) {
        __weak typeof(self) weakSelf = self;
        _hideAnimationType = ^(SCLAlertViewHideAnimation hideAnimationType) {
            weakSelf.alertView.hideAnimationType = hideAnimationType;
            return weakSelf;
        };
    }
    return _hideAnimationType;
}
- (SCLAlertViewBuilder *(^) (SCLAlertViewShowAnimation showAnimationType))showAnimationType {
    if (!_showAnimationType) {
        __weak typeof(self) weakSelf = self;
        _showAnimationType = ^(SCLAlertViewShowAnimation showAnimationType) {
            weakSelf.alertView.showAnimationType = showAnimationType;
            return weakSelf;
        };
    }
    return _showAnimationType;
}
- (SCLAlertViewBuilder *(^) (SCLAlertViewBackground backgroundType))backgroundType {
    if (!_backgroundType) {
        __weak typeof(self) weakSelf = self;
        _backgroundType = ^(SCLAlertViewBackground backgroundType) {
            weakSelf.alertView.backgroundType = backgroundType;
            return weakSelf;
        };
    }
    return _backgroundType;
}
- (SCLAlertViewBuilder *(^) (UIColor *customViewColor))customViewColor {
    if (!_customViewColor) {
        __weak typeof(self) weakSelf = self;
        _customViewColor = ^(UIColor *customViewColor) {
            weakSelf.alertView.customViewColor = customViewColor;
            return weakSelf;
        };
    }
    return _customViewColor;
}
- (SCLAlertViewBuilder *(^) (UIColor *backgroundViewColor))backgroundViewColor {
    if (!_backgroundViewColor) {
        __weak typeof(self) weakSelf = self;
        _backgroundViewColor = ^(UIColor *backgroundViewColor) {
            weakSelf.alertView.backgroundViewColor = backgroundViewColor;
            return weakSelf;
        };
    }
    return _backgroundViewColor;
}
- (SCLAlertViewBuilder *(^) (UIColor *iconTintColor))iconTintColor {
    if (!_iconTintColor) {
        __weak typeof(self) weakSelf = self;
        _iconTintColor = ^(UIColor *iconTintColor) {
            weakSelf.alertView.iconTintColor = iconTintColor;
            return weakSelf;
        };
    }
    return _iconTintColor;
}
- (SCLAlertViewBuilder *(^) (CGFloat circleIconHeight))circleIconHeight {
    if (!_circleIconHeight) {
        __weak typeof(self) weakSelf = self;
        _circleIconHeight = ^(CGFloat circleIconHeight) {
            weakSelf.alertView.circleIconHeight = circleIconHeight;
            return weakSelf;
        };
    }
    return _circleIconHeight;
}
- (SCLAlertViewBuilder *(^) (CGRect extensionBounds))extensionBounds {
    if (!_extensionBounds) {
        __weak typeof(self) weakSelf = self;
        _extensionBounds = ^(CGRect extensionBounds) {
            weakSelf.alertView.extensionBounds = extensionBounds;
            return weakSelf;
        };
    }
    return _extensionBounds;
}
- (SCLAlertViewBuilder *(^) (BOOL statusBarHidden))statusBarHidden {
    if (!_statusBarHidden) {
        __weak typeof(self) weakSelf = self;
        _statusBarHidden = ^(BOOL statusBarHidden) {
            weakSelf.alertView.statusBarHidden = statusBarHidden;
            return weakSelf;
        };
    }
    return _statusBarHidden;
}
- (SCLAlertViewBuilder *(^) (UIStatusBarStyle statusBarStyle))statusBarStyle {
    if (!_statusBarStyle) {
        __weak typeof(self) weakSelf = self;
        _statusBarStyle = ^(UIStatusBarStyle statusBarStyle) {
            weakSelf.alertView.statusBarStyle = statusBarStyle;
            return weakSelf;
        };
    }
    return _statusBarStyle;
}

#pragma mark - Custom Setters
- (SCLAlertViewBuilder *(^) (SCLDismissBlock dismissBlock))alertIsDismissed {
    if (!_alertIsDismissed) {
        __weak typeof(self) weakSelf = self;
        _alertIsDismissed = ^(SCLDismissBlock dismissBlock) {
            [weakSelf.alertView alertIsDismissed:dismissBlock];
            return weakSelf;
        };
    }
    return _alertIsDismissed;
}
-(SCLAlertViewBuilder *(^)(SCLDismissAnimationCompletionBlock))alertDismissAnimationIsCompleted{
    if (!_alertDismissAnimationIsCompleted) {
        __weak typeof(self) weakSelf = self;
        _alertDismissAnimationIsCompleted = ^(SCLDismissAnimationCompletionBlock dismissAnimationCompletionBlock) {
            [weakSelf.alertView alertDismissAnimationIsCompleted:dismissAnimationCompletionBlock];
            return weakSelf;
        };
    }
    return _alertDismissAnimationIsCompleted;
}
-(SCLAlertViewBuilder *(^)(SCLShowAnimationCompletionBlock))alertShowAnimationIsCompleted{
    if (!_alertShowAnimationIsCompleted) {
        __weak typeof(self) weakSelf = self;
        _alertShowAnimationIsCompleted = ^(SCLShowAnimationCompletionBlock showAnimationCompletionBlock) {
            [weakSelf.alertView alertShowAnimationIsCompleted:showAnimationCompletionBlock];
            return weakSelf;
        };
    }
    return _alertShowAnimationIsCompleted;
}
- (SCLAlertViewBuilder *(^) (void))removeTopCircle {
    if (!_removeTopCircle) {
        __weak typeof(self) weakSelf = self;
        _removeTopCircle = ^(void) {
            [weakSelf.alertView removeTopCircle];
            return weakSelf;
        };
    }
    return _removeTopCircle;
}
- (SCLAlertViewBuilder *(^) (UIView *view))addCustomView {
    if (!_addCustomView) {
        __weak typeof(self) weakSelf = self;
        _addCustomView = ^(UIView *view) {
            [weakSelf.alertView addCustomView:view];
            return weakSelf;
        };
    }
    return _addCustomView;
}
- (SCLAlertViewBuilder *(^) (NSString *title))addTextField {
    if (!_addTextField) {
        __weak typeof(self) weakSelf = self;
        _addTextField = ^(NSString *title) {
            [weakSelf.alertView addTextField:title];
            return weakSelf;
        };
    }
    return _addTextField;
}
- (SCLAlertViewBuilder *(^) (UITextField *textField))addCustomTextField {
    if (!_addCustomTextField) {
        __weak typeof(self) weakSelf = self;
        _addCustomTextField = ^(UITextField *textField) {
            [weakSelf.alertView addCustomTextField:textField];
            return weakSelf;
        };
    }
    return _addCustomTextField;
}
- (SCLAlertViewBuilder *(^) (NSString *title))addSwitchViewWithLabelTitle {
    if (!_addSwitchViewWithLabelTitle) {
        __weak typeof(self) weakSelf = self;
        _addSwitchViewWithLabelTitle = ^(NSString *title) {
            [weakSelf.alertView addSwitchViewWithLabel:title];
            return weakSelf;
        };
    }
    return _addSwitchViewWithLabelTitle;
}
- (SCLAlertViewBuilder *(^) (NSInteger buttonIndex, BOOL reverse))addTimerToButtonIndex {
    if (!_addTimerToButtonIndex) {
        __weak typeof(self) weakSelf = self;
        _addTimerToButtonIndex = ^(NSInteger buttonIndex, BOOL reverse) {
            [weakSelf.alertView addTimerToButtonIndex:buttonIndex reverse:reverse];
            return weakSelf;
        };
    }
    return _addTimerToButtonIndex;
}
- (SCLAlertViewBuilder *(^) (NSString *titleFontFamily, CGFloat size))setTitleFontFamily {
    if (!_setTitleFontFamily) {
        __weak typeof(self) weakSelf = self;
        _setTitleFontFamily = ^(NSString *titleFontFamily, CGFloat size) {
            [weakSelf.alertView setTitleFontFamily:titleFontFamily withSize:size];
            return weakSelf;
        };
    }
    return _setTitleFontFamily;
}
- (SCLAlertViewBuilder *(^) (NSString *bodyTextFontFamily, CGFloat size))setBodyTextFontFamily {
    if (!_setBodyTextFontFamily) {
        __weak typeof(self) weakSelf = self;
        _setBodyTextFontFamily = ^(NSString *bodyTextFontFamily, CGFloat size) {
            [weakSelf.alertView setBodyTextFontFamily:bodyTextFontFamily withSize:size];
            return weakSelf;
        };
    }
    return _setBodyTextFontFamily;
}
- (SCLAlertViewBuilder *(^) (NSString *buttonsFontFamily, CGFloat size))setButtonsTextFontFamily {
    if (!_setButtonsTextFontFamily) {
        __weak typeof(self) weakSelf = self;
        _setButtonsTextFontFamily = ^(NSString *buttonsFontFamily, CGFloat size) {
            [weakSelf.alertView setButtonsTextFontFamily:buttonsFontFamily withSize:size];
            return weakSelf;
        };
    }
    return _setButtonsTextFontFamily;
}
- (SCLAlertViewBuilder *(^) (NSString *title, SCLActionBlock action))addButtonWithActionBlock {
    if (!_addButtonWithActionBlock) {
        __weak typeof(self) weakSelf = self;
        _addButtonWithActionBlock = ^(NSString *title, SCLActionBlock action) {
            [weakSelf.alertView addButton:title actionBlock:action];
            return weakSelf;
        };
    }
    return _addButtonWithActionBlock;
}
- (SCLAlertViewBuilder *(^) (NSString *title, SCLValidationBlock validationBlock, SCLActionBlock action))addButtonWithValidationBlock {
    if (!_addButtonWithValidationBlock) {
        __weak typeof(self) weakSelf = self;
        _addButtonWithValidationBlock = ^(NSString *title, SCLValidationBlock validationBlock, SCLActionBlock action) {
            [weakSelf.alertView addButton:title validationBlock:validationBlock actionBlock:action];
            return weakSelf;
        };
    }
    return _addButtonWithValidationBlock;
}
- (SCLAlertViewBuilder *(^) (NSString *title, id target, SEL selector))addButtonWithTarget {
    if (!_addButtonWithTarget) {
        __weak typeof(self) weakSelf = self;
        _addButtonWithTarget = ^(NSString *title, id target, SEL selector) {
            [weakSelf.alertView addButton:title target:target selector:selector];
            return weakSelf;
        };
    }
    return _addButtonWithTarget;
}

#pragma mark - Builders
- (SCLAlertViewBuilder *(^)(SCLALertViewButtonBuilder *builder))addButtonWithBuilder {
    if (!_addButtonWithBuilder) {
        __weak typeof(self) weakSelf = self;
        _addButtonWithBuilder = ^(SCLALertViewButtonBuilder *builder){
            SCLButton *button = nil;
            if (builder.parameterTarget && builder.parameterSelector) {
                button = [weakSelf.alertView addButton:builder.parameterTitle target:builder.parameterTarget selector:builder.parameterSelector];
            }
            else if (builder.parameterValidationBlock && builder.parameterActionBlock) {
                button = [weakSelf.alertView addButton:builder.parameterTitle validationBlock:builder.parameterValidationBlock actionBlock:builder.parameterActionBlock];
            }
            else if (builder.parameterActionBlock) {
                button = [weakSelf.alertView addButton:builder.parameterTitle actionBlock:builder.parameterActionBlock];
            }
            builder.button = button;
            return weakSelf; 
        };
    }
    return _addButtonWithBuilder;
}
- (SCLAlertViewBuilder *(^)(SCLALertViewTextFieldBuilder *builder))addTextFieldWithBuilder {
    if (!_addTextFieldWithBuilder) {
        __weak typeof(self) weakSelf = self;
        _addTextFieldWithBuilder = ^(SCLALertViewTextFieldBuilder *builder){
            builder.textField = [weakSelf.alertView addTextField:builder.parameterTitle];
            return weakSelf;
        };
    }
    return _addTextFieldWithBuilder;
}
@end

@interface SCLAlertViewShowBuilder()

@property(weak, nonatomic) UIViewController *parameterViewController;
@property(copy, nonatomic) UIImage *parameterImage;
@property(copy, nonatomic) UIColor *parameterColor;
@property(copy, nonatomic) NSString *parameterTitle;
@property(copy, nonatomic) NSString *parameterSubTitle;
@property(copy, nonatomic) NSString *parameterCompleteText;
@property(copy, nonatomic) NSString *parameterCloseButtonTitle;
@property(assign, nonatomic) SCLAlertViewStyle parameterStyle;
@property(assign, nonatomic) NSTimeInterval parameterDuration;

#pragma mark - Setters
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^viewController)(UIViewController *viewController);
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^image)(UIImage *image);
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^color)(UIColor *color);
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^title)(NSString *title);
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^subTitle)(NSString *subTitle);
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^completeText)(NSString *completeText);
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^style)(SCLAlertViewStyle style);
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^closeButtonTitle)(NSString *closeButtonTitle);
@property(copy, nonatomic) SCLAlertViewShowBuilder *(^duration)(NSTimeInterval duration);

#pragma mark - Show
@property(copy, nonatomic) void (^show)(SCLAlertView *view, UIViewController *controller);
@end

@implementation SCLAlertViewShowBuilder


#pragma mark - Setters
- (SCLAlertViewShowBuilder *(^)(UIViewController *viewController))viewController {
    if (!_viewController) {
        __weak typeof(self) weakSelf = self;
        _viewController = ^(UIViewController *viewController){
            weakSelf.parameterViewController = viewController;
            return weakSelf;
        };
    }
    return _viewController;
}
- (SCLAlertViewShowBuilder *(^)(UIImage *image))image {
    if (!_image) {
        __weak typeof(self) weakSelf = self;
        _image = ^(UIImage *image) {
            weakSelf.parameterImage = image;
            return weakSelf;
        };
    }
    return _image;
}
- (SCLAlertViewShowBuilder *(^)(UIColor *color))color {
    if (!_color) {
        __weak typeof(self) weakSelf = self;
        _color = ^(UIColor *color) {
            weakSelf.parameterColor = color;
            return weakSelf;
        };
    }
    return _color;
}
- (SCLAlertViewShowBuilder *(^)(NSString *title))title {
    if (!_title) {
        __weak typeof(self) weakSelf = self;
        _title = ^(NSString *title){
            weakSelf.parameterTitle = title;
            return weakSelf;
        };
    }
    return _title;
}
- (SCLAlertViewShowBuilder *(^)(NSString *subTitle))subTitle {
    if (!_subTitle) {
        __weak typeof(self) weakSelf = self;
        _subTitle = ^(NSString *subTitle){
            weakSelf.parameterSubTitle = subTitle;
            return weakSelf;
        };
    }
    return _subTitle;
}
- (SCLAlertViewShowBuilder *(^)(NSString *completeText))completeText {
    if (!_completeText) {
        __weak typeof(self) weakSelf = self;
        _completeText = ^(NSString *completeText){
            weakSelf.parameterCompleteText = completeText;
            return weakSelf;
        };
    }
    return _completeText;
}

- (SCLAlertViewShowBuilder *(^)(SCLAlertViewStyle style))style {
    if (!_style) {
        __weak typeof(self) weakSelf = self;
        _style = ^(SCLAlertViewStyle style){
            weakSelf.parameterStyle = style;
            return weakSelf;
        };
    }
    return _style;
}
- (SCLAlertViewShowBuilder *(^)(NSString *closeButtonTitle))closeButtonTitle {
    if (!_closeButtonTitle) {
        __weak typeof(self) weakSelf = self;
        _closeButtonTitle = ^(NSString *closeButtonTitle){
            weakSelf.parameterCloseButtonTitle = closeButtonTitle;
            return weakSelf;
        };
    }
    return _closeButtonTitle;
}
- (SCLAlertViewShowBuilder *(^)(NSTimeInterval duration))duration {
    if (!_duration) {
        __weak typeof(self) weakSelf = self;
        _duration = ^(NSTimeInterval duration){
            weakSelf.parameterDuration = duration;
            return weakSelf;
        };
    }
    return _duration;
}

- (void)showAlertView:(SCLAlertView *)alertView {
    [self showAlertView:alertView onViewController:self.parameterViewController];
}

- (void)showAlertView:(SCLAlertView *)alertView onViewController:(UIViewController *)controller {
    UIViewController *targetController = controller ? controller : self.parameterViewController;
    
    if (self.parameterImage || self.parameterColor) {
        [alertView showTitle:targetController image:self.parameterImage color:self.parameterColor title:self.parameterTitle subTitle:self.parameterSubTitle duration:self.parameterDuration completeText:self.parameterCloseButtonTitle style:self.parameterStyle];
    }
    else {
        [alertView showTitle:targetController title:self.parameterTitle subTitle:self.parameterSubTitle style:self.parameterStyle closeButtonTitle:self.parameterCloseButtonTitle duration:self.parameterDuration];
    }
}

- (void (^)(SCLAlertView *view, UIViewController *controller))show {
    if (!_show) {
        __weak typeof(self) weakSelf = self;
        _show = ^(SCLAlertView *view, UIViewController *controller) {
            [weakSelf showAlertView:view onViewController:controller];
        };
    }
    return _show;
}

@end
