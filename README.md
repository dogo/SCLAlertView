SCLAlertView-Objective-C
============

Animated Alert View written in Swift but ported to Objective-C, which can be used as a `UIAlertView` or `UIAlertController` replacement.

![BackgroundImage](https://raw.githubusercontent.com/dogo/SCLAlertView/master/ScreenShots/ScreenShot.png)_
![BackgroundImage](https://raw.githubusercontent.com/dogo/SCLAlertView/master/ScreenShots/ScreenShot.png) 

###Easy to use
```Objective-C
// Get started
SCLAlertView *alert = [[SCLAlertView alloc] init];

[alert showSuccess:self title:@"Hello World" subTitle:@"This is a more descriptive text." closeButtonTitle:nil duration:0.0f];

// Alternative alert types
[alert showError:self title:@"Hello Error" subTitle:@"This is a more descriptive error text." closeButtonTitle:@"OK" duration:0.0f]; // Error
[alert showNotice:self title:@"Hello Notice" subTitle:@"This is a more descriptive notice text." closeButtonTitle:nil duration:0.0f]; // Notice
[alert showWarning:self title:@"Hello Warning" subTitle:@"This is a more descriptive warning text." closeButtonTitle:nil duration:0.0f]; // Warning
[alert showInfo:self title:@"Hello Info" subTitle:@"This is a more descriptive info text." closeButtonTitle:nil duration:0.0f]; // Info
[alert showEdit:self title:@"Hello Edit" subTitle:@"This is a more descriptive info text with a edit textbox" closeButtonTitle:nil duration:0.0f]; // Edit

// Advanced
SCLAlertView *alert = [[SCLAlertView alloc] init];

[alert showTitle:self // Parent view controller
    title:@"Congratulations" // Title of view
    subTitle:@"Operation successfully completed.", // String of view
    duration:2.0f // Duration to show before closing automatically
    completeText:@"Done" // Optional button value, default: ""
    style:Success]; // Styles - see below.
)

// Add buttons
SCLAlertView *alert = [[SCLAlertView alloc] init];

//Using Selector
[alert addButton:@"First Button" target:self selector:@selector(firstButton)];

//Using Block
[alert addButton:@"Second Button" actionBlock:^(void) {
    NSLog(@"Second button tapped");
}];
[alert showSuccess:self title:@"Button View" subTitle:@"This alert view has buttons" closeButtonTitle:nil duration:0.0f];

// Add a text field
SCLAlertView *alert = [[SCLAlertView alloc] init];

UITextField *textField = [alert addTextField:@"Enter your name"];

[alert addButton:@"Show Name" actionBlock:^(void) {
    NSLog(@"Text value: %@", textField.text);
}];

[alert showEdit:self title:@"Edit View" subTitle:@"This alert view shows a text box" closeButtonTitle:nil duration:0.0f];
```

####Alert View Styles
```Objective-C
typedef NS_ENUM(NSInteger, SCLAlertViewStyle)
{
    Success,
    Error,
    Notice,
    Warning,
    Info,
    Edit
};
```

### Installation

SCLAlertView-Objective-C is available through [CocoaPods](http://cocoapods.org).

To install add the following line to your Podfile:

    pod 'SCLAlertView-Objective-C'

### Collaboration
I tried to build an easy to use API, while beeing flexible enough for multiple variations, but I'm sure there are ways of improving and adding more features, so feel free to collaborate with ideas, issues and/or pull requests.

###Incoming improvements
- More animations
- Performance tests
- Remove some hardcode values

### Thanks to the original team
- Design [@SherzodMx](https://twitter.com/SherzodMx) Sherzod Max
- Development [@hackua](https://twitter.com/hackua) Viktor Radchenko
- Improvements by [@bih](http://github.com/bih) Bilawal Hameed, [@rizjoj](http://github.com/rizjoj) Riz Joj 
