//
//  SCLAlertView.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

#import "SCLAlertView.h"
#import "SCLAlertViewResponder.h"
#import "SCLAlertViewStyleKit.h"
#import "UIImage+ImageEffects.h"
@import AVFoundation;

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define KEYBOARD_HEIGHT 80
#define PREDICTION_BAR_HEIGHT 40

//列表高度
#define TABLECELLHEIGHT 40

@interface SCLAlertView ()  <UITextFieldDelegate, UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *inputs;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIImageView *circleIconImageView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *circleViewBackground;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) NSString *titleFontFamily;
@property (nonatomic, strong) NSString *bodyTextFontFamily;
@property (nonatomic, strong) NSString *buttonsFontFamily;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic) BOOL canAddObservers;
@property (nonatomic) BOOL keyboardIsVisible;
@property (nonatomic) CGFloat backgroundOpacity;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGFloat bodyFontSize;
@property (nonatomic) CGFloat buttonsFontSize;
@property (nonatomic) CGFloat windowHeight;
@property (nonatomic) CGFloat windowWidth;
@property (nonatomic) CGFloat circleIconHeight;
@property (nonatomic) CGFloat subTitleHeight;
@property (nonatomic) CGFloat subTitleY;

@end

@implementation SCLAlertView

CGFloat kCircleHeight;
CGFloat kCircleTopPosition;
CGFloat kCircleBackgroundTopPosition;
CGFloat kCircleHeightBackground;
CGFloat kActivityIndicatorHeight;

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
        kCircleHeight = 56.0f;
        kCircleTopPosition = -12.0f;
        kCircleBackgroundTopPosition = -15.0f;
        kCircleHeightBackground = 62.0f;
        kActivityIndicatorHeight = 40.0f;
        self.subTitleY = 70.0f;
        self.subTitleHeight = 90.0f;
        self.circleIconHeight = 20.0f;
        self.windowWidth = 240.0f;
        self.windowHeight = 178.0f;
        self.shouldDismissOnTapOutside = NO;
        self.canAddObservers = YES;
        self.keyboardIsVisible = NO;
        self.hideAnimationType = FadeOut;
        self.showAnimationType = SlideInFromTop;
        self.backgroundType = Shadow;
        
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
        _contentView = [[UIView alloc] init];
        _circleView = [[UIView alloc] init];
        _circleViewBackground = [[UIView alloc] init];
        _circleIconImageView = [[UIImageView alloc] init];
        _backgroundView = [[UIImageView alloc]initWithFrame:[self mainScreenFrame]];
        _buttons = [[NSMutableArray alloc] init];
        _inputs = [[NSMutableArray alloc] init];
        
        // Add Subviews
        [self.view addSubview:_contentView];
        [self.view addSubview:_circleViewBackground];
        [self.view addSubview:_circleView];

        [_circleView addSubview:_circleIconImageView];
        [_contentView addSubview:_labelTitle];
        [_contentView addSubview:_viewText];
        
		// Content View
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderWidth = 0.5f;
        
        // Background View
        _backgroundView.userInteractionEnabled = YES;
        
        // Title
        _labelTitle.numberOfLines = 1;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont fontWithName:_titleFontFamily size:_titleFontSize];
        _labelTitle.frame = CGRectMake(12.0f, (kCircleHeight / 2) + 4.0f, _windowWidth - 24.0f, 40.0f);
        
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
        }
    
        // Colors
        self.backgroundViewColor = [UIColor whiteColor];
        _labelTitle.textColor = UIColorFromRGB(0x4D4D4D); //Dark Grey
        _viewText.textColor = UIColorFromRGB(0x4D4D4D); //Dark Grey
        _contentView.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor; //Light Grey
        
        

    }
    return self;
}

- (void)dealloc
{
    [self removeObservers];
    [self enableInteractivePopGesture];
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
    
    // Check if the rootViewController is modal, if so we need to get the modal size not the main screen size
    if([self isModal])
    {
        sz = _rootViewController.view.frame.size;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        // iOS versions before 7.0 did not switch the width and height on device roration
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            CGSize ssz = sz;
            sz = CGSizeMake(ssz.height, ssz.width);
        }
    }
    
    // Set background frame
    CGRect newFrame = self.backgroundView.frame;
    newFrame.size = sz;
    self.backgroundView.frame = newFrame;
    
    // Set frames
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
    
    self.view.frame = r;
    _contentView.frame = CGRectMake(0.0f, kCircleHeight / 4, _windowWidth, _windowHeight);
    _circleViewBackground.frame = CGRectMake(_windowWidth / 2 - kCircleHeightBackground / 2, kCircleBackgroundTopPosition, kCircleHeightBackground, kCircleHeightBackground);
    _circleViewBackground.layer.cornerRadius = _circleViewBackground.frame.size.height / 2;
    _circleView.frame = CGRectMake(_windowWidth / 2 - kCircleHeight / 2, kCircleTopPosition, kCircleHeight, kCircleHeight);
    _circleView.layer.cornerRadius = self.circleView.frame.size.height / 2;
    _circleIconImageView.frame = CGRectMake(kCircleHeight / 2 - _circleIconHeight / 2, kCircleHeight / 2 - _circleIconHeight / 2, _circleIconHeight, _circleIconHeight);
    
    // Text fields
    CGFloat y = (_labelTitle.text == nil) ? (kCircleHeight - 20.0f) : 74.0f;
    y += _subTitleHeight + 14.0f;
    for (UITextField *textField in _inputs)
    {
        textField.frame = CGRectMake(12.0f, y, _windowWidth - 24.0f, 30.0f);
        textField.layer.cornerRadius = 3.0f;
        y += 40.0f;
    }
    
    // Buttons
    for (SCLButton *btn in _buttons)
    {
        btn.frame = CGRectMake(12.0f, y, _windowWidth - 24.0f, 35.0f);
        btn.layer.cornerRadius = 3.0f;
        y += 45.0f;
    }
}

#pragma mark - Handle gesture

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (_shouldDismissOnTapOutside)
    {
        BOOL hide = _shouldDismissOnTapOutside;

        for(UITextField *txt in _inputs)
        {
            // Check if there is any keyboard on screen and dismiss
            if ([txt isEditing])
            {
                [txt resignFirstResponder];
                hide = NO;
            }
        }
        if(hide)[self hideView];
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
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)enableInteractivePopGesture
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
        navigationController.interactivePopGestureRecognizer.enabled = YES;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
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
    NSError *error;
    _soundURL = soundURL;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_soundURL error:&error];
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
#pragma mark - add TableView
-(UITableView *)addTableView{
    _tableview = [[UITableView alloc] init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    // Update view height
    self.windowHeight += (TABLECELLHEIGHT*4);
    _tableview.frame = CGRectMake(_viewText.frame.origin.x, _viewText.frame.origin.y+_viewText.frame.size.height, _windowWidth - 24.0f, TABLECELLHEIGHT*4);
    [_contentView addSubview:_tableview];
    return _tableview;
}
#pragma mark - TextField

- (UITextField *)addTextField:(NSString *)title
{
    [self addObservers];
    
    // Update view height
    self.windowHeight += 40.0f;
    
    // Add text field
    UITextField *txt = [[UITextField alloc] init];
    txt.delegate = self;
    txt.returnKeyType = UIReturnKeyDone;
    txt.borderStyle = UITextBorderStyleRoundedRect;
    txt.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
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

- (void)addCustomTextField:(UITextField *)textField
{
    // Update view height
    self.windowHeight += 40.0f;
    
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

-(void)keyboardWillHide:(NSNotification *)notification
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
    // Update view height
    self.windowHeight += 45.0f;
    
    // Add button
    SCLButton *btn = [[SCLButton alloc] init];
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:_buttonsFontFamily size:_buttonsFontSize];

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

- (SCLButton *)addButton:(NSString *)title actionBlock:(SCLActionBlock)action
{
    SCLButton *btn = [self addButton:title];
    
    if (_buttonFormatBlock != nil)
    {
        btn.buttonFormatBlock = _buttonFormatBlock;
    }
    
    btn.actionType = Block;
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
    if (btn.validationBlock && !btn.validationBlock()) {
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
    _rootViewController = vc;
    
    [self disableInteractivePopGesture];
    
    self.view.alpha = 0.0f;
    
    [self setBackground];
    
    self.backgroundView.frame = vc.view.bounds;
    
    // Add subviews
    [_rootViewController addChildViewController:self];
    [_rootViewController.view addSubview:_backgroundView];
    [_rootViewController.view addSubview:self.view];

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
            
        case Waiting:
            viewColor = UIColorFromRGB(0x6c125d);
            break;
        case Searching:
            viewColor = UIColorFromRGB(0x6c125d);
            break;
        case Custom:
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
            _viewText.attributedText = self.attributedFormatBlock(subTitle);
            self.viewText.font = [UIFont fontWithName:_bodyTextFontFamily size:_bodyFontSize];
        }
        
        // Adjust text view size, if necessary
        CGSize sz = CGSizeMake(_windowWidth - 24.0f, CGFLOAT_MAX);
        NSDictionary *attr = @{NSFontAttributeName:self.viewText.font};
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            NSString *str = subTitle;
            CGRect r = [str boundingRectWithSize:sz options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
            CGFloat ht = ceil(r.size.height);
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
        }
        else
        {
            NSAttributedString *str =[[NSAttributedString alloc] initWithString:subTitle attributes:attr];
            CGRect r = [str boundingRectWithSize:sz options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            CGFloat ht = ceil(r.size.height) + 10.0f;
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
        }
        _viewText.frame = CGRectMake(12.0f, _subTitleY, _windowWidth - 24.0f, _subTitleHeight);
        if (style == Searching) {
            [self.activityIndicatorView startAnimating];
            //添加tableview
            [self addTableView];
            
        }
    }
    else
    {
        // Subtitle is nil, we can move the title to center and remove it from superView
        self.subTitleHeight = 0.0f;
        self.windowHeight -= _viewText.frame.size.height;
        [_viewText removeFromSuperview];
        
        // Move up
        _labelTitle.frame = CGRectMake(12.0f, 37.0f, _windowWidth - 24.0f, 40.0f);
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

    // Alert view color and images
    self.circleView.backgroundColor = viewColor;
    
  
    if (style == Waiting)
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
    
    
    
    for (UITextField *textField in _inputs)
    {
        textField.layer.borderColor = viewColor.CGColor;
    }
    
    for (SCLButton *btn in _buttons)
    {
        if (style == Warning)
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        btn.defaultBackgroundColor = viewColor;
        
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

- (void)showWaiting:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self addActivityIndicatorView];
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:closeButtonTitle style:Waiting];
}
- (void)showSearching:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration
{
    [self addActivityIndicatorView];
    [self showTitle:vc image:nil color:nil title:title subTitle:subTitle duration:duration completeText:nil style:Searching];
}
#pragma mark - TableView Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5; // or self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Step 1: Check to see if we can reuse a cell from a row that has just rolled off the screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Step 2: If there are no cells to reuse, create a new one
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    // Add a detail view accessory
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // Step 3: Set the cell text
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    // Step 4: Return the cell
    return cell;
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

- (void)alertIsDismissed:(DismissBlock)dismissBlock
{
    self.dismissBlock = dismissBlock;
}

- (CGRect)mainScreenFrame
{
    return [UIScreen mainScreen].bounds;
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
    UIImage *image = ([self isModal]) ? [UIImage convertViewToImage:_rootViewController.view] : [UIImage convertViewToImage];
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
        case Shadow:
            [self makeShadowBackground];
            break;
            
        case Blur:
            [self makeBlurBackground];
            break;
            
        case Transparent:
            [self makeTransparentBackground];
            break;
    }
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
            
        case SlideInFromCenter:
            [self slideInFromCenter];
            break;
            
        case SlideInToCenter:
            [self slideInToCenter];
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
            
        case SlideOutToCenter:
            [self slideOutToCenter];
            break;
            
        case SlideOutFromCenter:
            [self slideOutFromCenter];
            break;
    }
    
    if(_activityIndicatorView)
    {
        [_activityIndicatorView stopAnimating];
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
        self.backgroundView.alpha = 0.0f;
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self.backgroundView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
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
                     completion:nil];
}

- (void)slideInFromTop
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
        }];
    }];
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
        }];
    }];
}

- (void)slideInFromCenter
{
    //From
    self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                CGAffineTransformMakeScale(3.0f, 3.0f));
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        }];
    }];
}

- (void)slideInToCenter
{
    //From
    self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                  CGAffineTransformMakeScale(0.1f, 0.1f));
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = _backgroundOpacity;
        
        //To
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = _backgroundView.center;
        }];
    }];
}

@end
