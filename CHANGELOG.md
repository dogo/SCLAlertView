# Changelog

## [1.3.0](https://github.com/dogo/SCLAlertView/tree/1.3.0) (2023-12-20)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.2.0...1.3.0)

**Closed issues:**

- Android system can use it even better [\#307](https://github.com/dogo/SCLAlertView/issues/307)
- showCustom 的时候如何自定义 closeButton样式 [\#302](https://github.com/dogo/SCLAlertView/issues/302)
- Cannot find ChangesLog for version 1.2.0 [\#299](https://github.com/dogo/SCLAlertView/issues/299)
- Is this an SCLAlertView bug, or an Apple bug? [\#296](https://github.com/dogo/SCLAlertView/issues/296)
- SCLAlertView \*alert = \[\[SCLAlertView alloc\] initWithNewWindowWidth:300.0f\];  self.username = @"zaxo"; self.password = @"pass";   UITextField \*usernameTextField = \[alert addTextField:@"username"\];  UITextField \*passwordTextField = \[alert addTextField:@"password"\]; passwordTextField.secureTextEntry = YES;     \[alert addButton:@"Login" actionBlock: ^\(void\){  BOOL isUsersEqual = \[self.username isEqualToString:\[self.usernameTextField text\]\];  BOOL isPasswordsEqual = \[self.password isEqualToString:\[self.passwordTextField text\]\];  if\(isUsersEqual && isPasswordsEqual\){  NSLog\(@"Successful"\); }       else {      NSLog\(@"frailer"\);      }                  @@@@@@@@        Why I can't compile it I even have set the @Property \(nonatomic, strong\) NSString \*username; in SCLALertView.m but I still errors   do im doing anthing  please   can you help Tweak.xm:350:1: error: use of undeclared identifier 'self'   self.username = @"zaxo";   [\#293](https://github.com/dogo/SCLAlertView/issues/293)

**Merged pull requests:**

- Add initWithWidth method for setting the width of the object. [\#310](https://github.com/dogo/SCLAlertView/pull/310) ([FernandoReynoso](https://github.com/FernandoReynoso))
- Bump activesupport from 6.1.5 to 6.1.7.3 [\#308](https://github.com/dogo/SCLAlertView/pull/308) ([dependabot[bot]](https://github.com/apps/dependabot))
- default value for a textfield [\#295](https://github.com/dogo/SCLAlertView/pull/295) ([syto203](https://github.com/syto203))

## [1.2.0](https://github.com/dogo/SCLAlertView/tree/1.2.0) (2020-10-31)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.1.6...1.2.0)

**Closed issues:**

- alertView with textfield moves up twice\(too much\) when textfield become first responder and the keyboard shows [\#291](https://github.com/dogo/SCLAlertView/issues/291)
- 设置富文本后不居中显示了 变成了居左。 [\#288](https://github.com/dogo/SCLAlertView/issues/288)
- Good day, as you can implement the verification key which is located on the website .txt document? Roughly speaking to make check on a key if the key is correct, then there is a start. [\#286](https://github.com/dogo/SCLAlertView/issues/286)
- How to hidden top image with OC? [\#285](https://github.com/dogo/SCLAlertView/issues/285)

**Merged pull requests:**

- Fix: break a strong reference cycle [\#290](https://github.com/dogo/SCLAlertView/pull/290) ([kingste](https://github.com/kingste))
- Merge [\#279](https://github.com/dogo/SCLAlertView/pull/279) ([dogo](https://github.com/dogo))
- Add Stale config [\#275](https://github.com/dogo/SCLAlertView/pull/275) ([dogo](https://github.com/dogo))

## [1.1.6](https://github.com/dogo/SCLAlertView/tree/1.1.6) (2018-10-14)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.1.5...1.1.6)

**Implemented enhancements:**

- ButtonTimer: Enable button once timer elapsed [\#181](https://github.com/dogo/SCLAlertView/issues/181)

**Fixed bugs:**

- UIStatusBarStyle always appears as 'UIStatusBarStyleDefault' [\#274](https://github.com/dogo/SCLAlertView/issues/274)
- Alert view height problem when using it with long text in body [\#127](https://github.com/dogo/SCLAlertView/issues/127)

**Closed issues:**

- handleNavigationTransition Bug [\#276](https://github.com/dogo/SCLAlertView/issues/276)
- Could you release fixed version? [\#273](https://github.com/dogo/SCLAlertView/issues/273)
- Accessibility: implement - \(BOOL\)accessibilityPerformEscape [\#271](https://github.com/dogo/SCLAlertView/issues/271)
- How to solve the problem of overlapping multiple calls in a controller?（如何解决在一个控制器中，连续多次调用，会出现重叠的情况？） [\#267](https://github.com/dogo/SCLAlertView/issues/267)
- TextView height problem when text entered with the long body \(it need to expend it's height \) [\#258](https://github.com/dogo/SCLAlertView/issues/258)
- i need to add on the preloaded text in the text field before textfield Alert pop up [\#254](https://github.com/dogo/SCLAlertView/issues/254)
- Problem in increasing height of TextField & customize the Alert view colour & image & button [\#253](https://github.com/dogo/SCLAlertView/issues/253)
- Custom TextField not adding Keyboard Observers [\#250](https://github.com/dogo/SCLAlertView/issues/250)
- Portrait or Landscape fixed  [\#201](https://github.com/dogo/SCLAlertView/issues/201)
- \[Bug\] when changing keyboard... [\#200](https://github.com/dogo/SCLAlertView/issues/200)
- If new alert is displayed before 1st waiting alert is closed by duration, then 1st alert will never automatically close [\#178](https://github.com/dogo/SCLAlertView/issues/178)
- Add support to show only one alert view at the same time. [\#141](https://github.com/dogo/SCLAlertView/issues/141)
- UITextField Return/Done Action \(UIControlEventEditingDidEndOnExit\) [\#123](https://github.com/dogo/SCLAlertView/issues/123)

## [1.1.5](https://github.com/dogo/SCLAlertView/tree/1.1.5) (2018-06-22)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.1.4...1.1.5)

**Merged pull requests:**

- core: base builder with fluent has been added. [\#272](https://github.com/dogo/SCLAlertView/pull/272) ([lolgear](https://github.com/lolgear))

## [1.1.4](https://github.com/dogo/SCLAlertView/tree/1.1.4) (2018-06-19)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.1.3...1.1.4)

**Closed issues:**

- Eliminate warnings [\#270](https://github.com/dogo/SCLAlertView/issues/270)
- How to add in multiple subtitle in an alert view? [\#266](https://github.com/dogo/SCLAlertView/issues/266)
- SCLAlertViewHideAnimation wrong animations [\#262](https://github.com/dogo/SCLAlertView/issues/262)
- Title truncated [\#259](https://github.com/dogo/SCLAlertView/issues/259)
- Use the builder pattern to build a SCLAlertView? [\#256](https://github.com/dogo/SCLAlertView/issues/256)
- Carthage Support [\#255](https://github.com/dogo/SCLAlertView/issues/255)

**Merged pull requests:**

- Fluent style project cleanup. [\#269](https://github.com/dogo/SCLAlertView/pull/269) ([lolgear](https://github.com/lolgear))
- Create CONTRIBUTING.md [\#265](https://github.com/dogo/SCLAlertView/pull/265) ([dogo](https://github.com/dogo))
- Create CODE\_OF\_CONDUCT.md [\#264](https://github.com/dogo/SCLAlertView/pull/264) ([dogo](https://github.com/dogo))

## [1.1.3](https://github.com/dogo/SCLAlertView/tree/1.1.3) (2018-01-17)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.1.2...1.1.3)

**Fixed bugs:**

- Tap inside the alert will dismiss the alert when using new window and shouldDissmissOnTapOutside=YES [\#211](https://github.com/dogo/SCLAlertView/issues/211)
- crash on - \(void\)disableInteractivePopGesture [\#137](https://github.com/dogo/SCLAlertView/issues/137)

**Closed issues:**

- is it possible to change the text colour of title and subtitle of the alert??? [\#260](https://github.com/dogo/SCLAlertView/issues/260)
-  not supporting for Swift 4.0 [\#257](https://github.com/dogo/SCLAlertView/issues/257)
- How to replace the latest SCLAlertView? [\#187](https://github.com/dogo/SCLAlertView/issues/187)
- UIWindow is not removed when alert showed and hided using new window [\#185](https://github.com/dogo/SCLAlertView/issues/185)
- Some issues with combination of device rotations. [\#182](https://github.com/dogo/SCLAlertView/issues/182)
- buttons from previous alertViews being displayed  [\#167](https://github.com/dogo/SCLAlertView/issues/167)
- pop-up from pop-up enhancement [\#162](https://github.com/dogo/SCLAlertView/issues/162)

**Merged pull requests:**

- Fix VoiceOver accessibility [\#261](https://github.com/dogo/SCLAlertView/pull/261) ([tmm1](https://github.com/tmm1))
- Fix for using as a carthage framework. [\#251](https://github.com/dogo/SCLAlertView/pull/251) ([hankinsoft](https://github.com/hankinsoft))
- clerical error [\#249](https://github.com/dogo/SCLAlertView/pull/249) ([amisare](https://github.com/amisare))

## [1.1.2](https://github.com/dogo/SCLAlertView/tree/1.1.2) (2017-04-11)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.1.1...1.1.2)

**Closed issues:**

- support NSMutableAttributedString? [\#247](https://github.com/dogo/SCLAlertView/issues/247)
- SCLAlertview in a new window. \(No UIViewController\) : The window cannot be closed [\#246](https://github.com/dogo/SCLAlertView/issues/246)
- help add SCLAlertView in theos ??? [\#245](https://github.com/dogo/SCLAlertView/issues/245)
- SCLAlertView should build without warnings [\#243](https://github.com/dogo/SCLAlertView/issues/243)
- Access a Button [\#242](https://github.com/dogo/SCLAlertView/issues/242)
- window does not disappear when use hideView on first app run [\#237](https://github.com/dogo/SCLAlertView/issues/237)
- Command failed due to signal: Segmentation fault: 11 swift 3 [\#221](https://github.com/dogo/SCLAlertView/issues/221)

## [1.1.1](https://github.com/dogo/SCLAlertView/tree/1.1.1) (2017-02-16)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.1.0...1.1.1)

**Closed issues:**

- delegate 应该使用weak修饰，否则会造成循环引用  SCLAlertView.swift    Line 76 [\#240](https://github.com/dogo/SCLAlertView/issues/240)
- amazing ,but if we can custom button corlor not only custom main corlor [\#236](https://github.com/dogo/SCLAlertView/issues/236)
- XCode 8.2 language error [\#235](https://github.com/dogo/SCLAlertView/issues/235)
- Update CocoaPods [\#233](https://github.com/dogo/SCLAlertView/issues/233)
- Orientation issue in landscape when UIViewcontroller lock orientation in Portrait [\#168](https://github.com/dogo/SCLAlertView/issues/168)

**Merged pull requests:**

- added show animation completion block [\#241](https://github.com/dogo/SCLAlertView/pull/241) ([hydr93](https://github.com/hydr93))
- Dismiss Animation Completion Block [\#239](https://github.com/dogo/SCLAlertView/pull/239) ([hydr93](https://github.com/hydr93))

## [1.1.0](https://github.com/dogo/SCLAlertView/tree/1.1.0) (2016-12-07)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.0.6...1.1.0)

**Closed issues:**

- Not centered vertically when presented in navigation controller [\#231](https://github.com/dogo/SCLAlertView/issues/231)
- Differentiate color of close/cancel button [\#228](https://github.com/dogo/SCLAlertView/issues/228)
- \[Request\] initial text and 'x' button in text entry [\#227](https://github.com/dogo/SCLAlertView/issues/227)
- One of the two will be used. Which one is undefined. [\#225](https://github.com/dogo/SCLAlertView/issues/225)

**Merged pull requests:**

- Add button custom font support when use buttonConfig block [\#232](https://github.com/dogo/SCLAlertView/pull/232) ([maclacerda](https://github.com/maclacerda))
- fix the bug: dismiss SCLAlertViewHideAnimationSimplyDisappear hideAni… [\#230](https://github.com/dogo/SCLAlertView/pull/230) ([JoakimLiu](https://github.com/JoakimLiu))
- Change auto-capitalisation to sentence only [\#229](https://github.com/dogo/SCLAlertView/pull/229) ([idrougge](https://github.com/idrougge))

## [1.0.6](https://github.com/dogo/SCLAlertView/tree/1.0.6) (2016-10-27)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.0.5...1.0.6)

**Fixed bugs:**

- Table title overlay of SCLAlertView [\#206](https://github.com/dogo/SCLAlertView/issues/206)

**Closed issues:**

- Keyboard pushes up the SCAlertView with IQKeyboardManager [\#223](https://github.com/dogo/SCLAlertView/issues/223)
- Space, when no Title, SubTitle and Image. [\#218](https://github.com/dogo/SCLAlertView/issues/218)
- carthage update fail for special platform [\#217](https://github.com/dogo/SCLAlertView/issues/217)
- Border color [\#216](https://github.com/dogo/SCLAlertView/issues/216)
-  Conflict with the IQKeyboardManager [\#215](https://github.com/dogo/SCLAlertView/issues/215)
- Can't set selected on SCLSwitchView [\#214](https://github.com/dogo/SCLAlertView/issues/214)
- is it possible to change subtitle text while alert is showing? [\#213](https://github.com/dogo/SCLAlertView/issues/213)
- Execute block while 'showWaiting' running [\#197](https://github.com/dogo/SCLAlertView/issues/197)
- UIAppearance [\#72](https://github.com/dogo/SCLAlertView/issues/72)

**Merged pull requests:**

- Added missing setter in SCLSwitchView [\#226](https://github.com/dogo/SCLAlertView/pull/226) ([acerbetti](https://github.com/acerbetti))
- Changed constants names to avoid name collision [\#224](https://github.com/dogo/SCLAlertView/pull/224) ([damarte](https://github.com/damarte))

## [1.0.5](https://github.com/dogo/SCLAlertView/tree/1.0.5) (2016-09-13)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.0.4...1.0.5)

**Closed issues:**

- SCLAlert view not covering Navigation or TabBar [\#219](https://github.com/dogo/SCLAlertView/issues/219)
- Button height support [\#212](https://github.com/dogo/SCLAlertView/issues/212)
- Statusbar Visible when showing the SCLAlertView [\#208](https://github.com/dogo/SCLAlertView/issues/208)
- Custom button height [\#207](https://github.com/dogo/SCLAlertView/issues/207)

**Merged pull requests:**

- Add umbrella header to exclude warnings during framework building [\#220](https://github.com/dogo/SCLAlertView/pull/220) ([goncharik](https://github.com/goncharik))
- Add Carthage support [\#210](https://github.com/dogo/SCLAlertView/pull/210) ([goncharik](https://github.com/goncharik))
- docs: nativescript integration mention [\#209](https://github.com/dogo/SCLAlertView/pull/209) ([NathanWalker](https://github.com/NathanWalker))

## [1.0.4](https://github.com/dogo/SCLAlertView/tree/1.0.4) (2016-06-21)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.0.3...1.0.4)

**Closed issues:**

- alert view not work [\#205](https://github.com/dogo/SCLAlertView/issues/205)
- Custom Button Color? [\#204](https://github.com/dogo/SCLAlertView/issues/204)
- ShowWaiting timer error [\#202](https://github.com/dogo/SCLAlertView/issues/202)

## [1.0.3](https://github.com/dogo/SCLAlertView/tree/1.0.3) (2016-05-03)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.0.2...1.0.3)

**Closed issues:**

- Alerts all placed on top of the nav bar [\#196](https://github.com/dogo/SCLAlertView/issues/196)
- View Hangs after SCLAlert is dismissed when alert is initiated from an action sheet button. [\#173](https://github.com/dogo/SCLAlertView/issues/173)
- After scrolling uitabelview SCLAlertView not working & multiple alert window show [\#169](https://github.com/dogo/SCLAlertView/issues/169)

**Merged pull requests:**

- New Feature: Horizontal alignment for buttons. [\#203](https://github.com/dogo/SCLAlertView/pull/203) ([jaespinmora](https://github.com/jaespinmora))
- Adds show/hide AnimationTypes 'SimplyAppear' and 'SimplyDisappear' i.e., 'None' [\#198](https://github.com/dogo/SCLAlertView/pull/198) ([AmitaiB](https://github.com/AmitaiB))

## [1.0.2](https://github.com/dogo/SCLAlertView/tree/1.0.2) (2016-03-16)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.0.1...1.0.2)

## [1.0.1](https://github.com/dogo/SCLAlertView/tree/1.0.1) (2016-03-08)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/dogo/SCLAlertView/tree/1.0.0) (2016-03-07)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.9.3...1.0.0)

**Closed issues:**

- Is SCLAlertView version indicated? [\#188](https://github.com/dogo/SCLAlertView/issues/188)
- Add DSL for simple setup [\#186](https://github.com/dogo/SCLAlertView/issues/186)
- second button no working [\#184](https://github.com/dogo/SCLAlertView/issues/184)
- when I pop multi-SCLAlertViews at the same time,then the window will become entirely black. [\#159](https://github.com/dogo/SCLAlertView/issues/159)

**Merged pull requests:**

- fluent: show block added [\#195](https://github.com/dogo/SCLAlertView/pull/195) ([lolgear](https://github.com/lolgear))
- Fluent style support extension [\#194](https://github.com/dogo/SCLAlertView/pull/194) ([lolgear](https://github.com/lolgear))
- Devlop [\#190](https://github.com/dogo/SCLAlertView/pull/190) ([changcode](https://github.com/changcode))
- Fluent style support [\#189](https://github.com/dogo/SCLAlertView/pull/189) ([lolgear](https://github.com/lolgear))

## [0.9.3](https://github.com/dogo/SCLAlertView/tree/0.9.3) (2016-03-03)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.9.2...0.9.3)

**Implemented enhancements:**

- Add bounce animation to all slides  [\#116](https://github.com/dogo/SCLAlertView/issues/116)

## [0.9.2](https://github.com/dogo/SCLAlertView/tree/0.9.2) (2016-03-03)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.9.1...0.9.2)

**Closed issues:**

- Vertical spacing broken on 0.9.0 [\#183](https://github.com/dogo/SCLAlertView/issues/183)

## [0.9.1](https://github.com/dogo/SCLAlertView/tree/0.9.1) (2016-02-15)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.9.0...0.9.1)

## [0.9.0](https://github.com/dogo/SCLAlertView/tree/0.9.0) (2016-02-10)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.8.2...0.9.0)

**Implemented enhancements:**

- Tickbox enhancement [\#40](https://github.com/dogo/SCLAlertView/issues/40)
- Switch Alert feature [\#177](https://github.com/dogo/SCLAlertView/pull/177) ([andre-felipe](https://github.com/andre-felipe))

**Closed issues:**

- Anyway to set the popup position? Like height to top? [\#180](https://github.com/dogo/SCLAlertView/issues/180)
- Show alert while running a block [\#176](https://github.com/dogo/SCLAlertView/issues/176)
- Button actionBlocks not working [\#175](https://github.com/dogo/SCLAlertView/issues/175)
- Lag when showing view for first time [\#174](https://github.com/dogo/SCLAlertView/issues/174)
- title width enhancement? [\#166](https://github.com/dogo/SCLAlertView/issues/166)
- Dismiss method? [\#157](https://github.com/dogo/SCLAlertView/issues/157)

**Merged pull requests:**

- Change play sound class [\#171](https://github.com/dogo/SCLAlertView/pull/171) ([Liqiankun](https://github.com/Liqiankun))

## [0.8.2](https://github.com/dogo/SCLAlertView/tree/0.8.2) (2016-01-22)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.8.1...0.8.2)

**Closed issues:**

- Memory leak using new window way to display [\#142](https://github.com/dogo/SCLAlertView/issues/142)

## [0.8.1](https://github.com/dogo/SCLAlertView/tree/0.8.1) (2016-01-21)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.8.0...0.8.1)

**Fixed bugs:**

- Subtitle does not appear if title is set to nil or empty [\#99](https://github.com/dogo/SCLAlertView/issues/99)

**Closed issues:**

- when iOS8，use  [\#172](https://github.com/dogo/SCLAlertView/issues/172)
- No Subtitle visible with iOS8.1 [\#164](https://github.com/dogo/SCLAlertView/issues/164)
- Multitasking Split Screen Bug [\#158](https://github.com/dogo/SCLAlertView/issues/158)

## [0.8.0](https://github.com/dogo/SCLAlertView/tree/0.8.0) (2015-12-29)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.9...0.8.0)

**Fixed bugs:**

- iPad pro split screen support [\#149](https://github.com/dogo/SCLAlertView/issues/149)

**Closed issues:**

- Adding a new SCLAlertViewStyle: Question [\#161](https://github.com/dogo/SCLAlertView/issues/161)
- alignment of BodyText.. [\#160](https://github.com/dogo/SCLAlertView/issues/160)
- Is this compatible with retina displays? [\#156](https://github.com/dogo/SCLAlertView/issues/156)
- keyboard bug [\#155](https://github.com/dogo/SCLAlertView/issues/155)
- How do I add SCLAlertView to TheOs project? [\#151](https://github.com/dogo/SCLAlertView/issues/151)
- Make the bounce animation a separate animation [\#150](https://github.com/dogo/SCLAlertView/issues/150)
- SCLAlertView is not working!!!!!!! [\#148](https://github.com/dogo/SCLAlertView/issues/148)
- background does not update if rotate device [\#145](https://github.com/dogo/SCLAlertView/issues/145)

**Merged pull requests:**

- Fix for \#164 no Subtitles with iOS8 [\#165](https://github.com/dogo/SCLAlertView/pull/165) ([jusefjames](https://github.com/jusefjames))
- Develop [\#163](https://github.com/dogo/SCLAlertView/pull/163) ([jusefjames](https://github.com/jusefjames))
- Prevent viewText scrollable [\#154](https://github.com/dogo/SCLAlertView/pull/154) ([AzulesM](https://github.com/AzulesM))
- Fixing centering problem when used in iPad split view [\#153](https://github.com/dogo/SCLAlertView/pull/153) ([abbasmousavi](https://github.com/abbasmousavi))

## [0.7.9](https://github.com/dogo/SCLAlertView/tree/0.7.9) (2015-10-20)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.7...0.7.9)

**Fixed bugs:**

- Keyboard & rotation [\#52](https://github.com/dogo/SCLAlertView/issues/52)

**Closed issues:**

- Get rid of the icon [\#147](https://github.com/dogo/SCLAlertView/issues/147)
- Strong reference [\#126](https://github.com/dogo/SCLAlertView/issues/126)

**Merged pull requests:**

- Added status bar customization [\#146](https://github.com/dogo/SCLAlertView/pull/146) ([D-32](https://github.com/D-32))
- Namespace SCLActionTypes to avoid conflicts [\#144](https://github.com/dogo/SCLAlertView/pull/144) ([mbelkin](https://github.com/mbelkin))

## [0.7.7](https://github.com/dogo/SCLAlertView/tree/0.7.7) (2015-09-17)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.6...0.7.7)

**Closed issues:**

- AlertView created by initWithNewWindow does not dismiss when touch outside [\#143](https://github.com/dogo/SCLAlertView/issues/143)
- Prepopulate alertview [\#138](https://github.com/dogo/SCLAlertView/issues/138)
- Modules enabled but still getting disabled error [\#136](https://github.com/dogo/SCLAlertView/issues/136)

## [0.7.6](https://github.com/dogo/SCLAlertView/tree/0.7.6) (2015-09-15)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.5...0.7.6)

## [0.7.5](https://github.com/dogo/SCLAlertView/tree/0.7.5) (2015-09-02)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.4...0.7.5)

**Closed issues:**

- Adding a countdown to a default button [\#113](https://github.com/dogo/SCLAlertView/issues/113)

**Merged pull requests:**

- Feature/countdown timer [\#140](https://github.com/dogo/SCLAlertView/pull/140) ([yatryan](https://github.com/yatryan))
- Dynamically set button height to allow for multiple lines of text. [\#139](https://github.com/dogo/SCLAlertView/pull/139) ([yatryan](https://github.com/yatryan))

## [0.7.4](https://github.com/dogo/SCLAlertView/tree/0.7.4) (2015-07-29)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.3...0.7.4)

**Closed issues:**

- Parenthesis missing in SCLAlertView.m [\#133](https://github.com/dogo/SCLAlertView/issues/133)
- I can't see the added button [\#132](https://github.com/dogo/SCLAlertView/issues/132)
- Subtitle issue not showing properly - urgent [\#131](https://github.com/dogo/SCLAlertView/issues/131)
- adding more control method [\#130](https://github.com/dogo/SCLAlertView/issues/130)
- Swift use [\#129](https://github.com/dogo/SCLAlertView/issues/129)
- How to change default button label? [\#128](https://github.com/dogo/SCLAlertView/issues/128)
- Alertview without the round circle above. [\#125](https://github.com/dogo/SCLAlertView/issues/125)
- previous alert won't go away if new 1 appears [\#124](https://github.com/dogo/SCLAlertView/issues/124)
- when i rename AppDelegate.m to app AppDelegate.mm build error  [\#121](https://github.com/dogo/SCLAlertView/issues/121)
- Unable to move alertView so keyboard covers the fields on the alert. [\#118](https://github.com/dogo/SCLAlertView/issues/118)
- with textfield  how to set ok button status to disable when the textfiled input not valid [\#115](https://github.com/dogo/SCLAlertView/issues/115)

**Merged pull requests:**

- fix bug [\#135](https://github.com/dogo/SCLAlertView/pull/135) ([HuylensHu](https://github.com/HuylensHu))
- fix bug [\#134](https://github.com/dogo/SCLAlertView/pull/134) ([HuylensHu](https://github.com/HuylensHu))

## [0.7.3](https://github.com/dogo/SCLAlertView/tree/0.7.3) (2015-06-10)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.2...0.7.3)

**Closed issues:**

- check TextField.text is empty.   [\#122](https://github.com/dogo/SCLAlertView/issues/122)

## [0.7.2](https://github.com/dogo/SCLAlertView/tree/0.7.2) (2015-05-29)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.1...0.7.2)

**Fixed bugs:**

- Long texts truncated when using custom font [\#84](https://github.com/dogo/SCLAlertView/issues/84)

**Closed issues:**

- Pod Install [\#114](https://github.com/dogo/SCLAlertView/issues/114)
- Using SCLAlertView with Swift [\#110](https://github.com/dogo/SCLAlertView/issues/110)
- XCode 6.3 Warning: roperty access is using 'setSubTitleHeight:' method which is deprecated [\#105](https://github.com/dogo/SCLAlertView/issues/105)
- Enhancement: Support iOS 8 Widget frame position [\#102](https://github.com/dogo/SCLAlertView/issues/102)

**Merged pull requests:**

- restore interactivePopGesture to previous state \#2 [\#120](https://github.com/dogo/SCLAlertView/pull/120) ([crowriot](https://github.com/crowriot))
- If defaultBackgroundColor is preconfigured for button its not changed to... [\#109](https://github.com/dogo/SCLAlertView/pull/109) ([alex1704](https://github.com/alex1704))

## [0.7.1](https://github.com/dogo/SCLAlertView/tree/0.7.1) (2015-05-04)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.7.0...0.7.1)

**Fixed bugs:**

- SlideInFromCenter show animation with blur UI issue [\#92](https://github.com/dogo/SCLAlertView/issues/92)

**Closed issues:**

- When presenting with textField and 2 buttons keyboard cuts off bottom bottom. [\#108](https://github.com/dogo/SCLAlertView/issues/108)
- Using SCLAlert as HUD [\#106](https://github.com/dogo/SCLAlertView/issues/106)
- Does not work on iOS 8 App Extension - 2 Errors [\#101](https://github.com/dogo/SCLAlertView/issues/101)
- EXC\_BAD\_ACCESS [\#100](https://github.com/dogo/SCLAlertView/issues/100)
- Navigation bar not hiding [\#95](https://github.com/dogo/SCLAlertView/issues/95)
- Alert is behind the keyboard [\#80](https://github.com/dogo/SCLAlertView/issues/80)

**Merged pull requests:**

- Fix Crash for iOS 7 [\#104](https://github.com/dogo/SCLAlertView/pull/104) ([imkevinxu](https://github.com/imkevinxu))
- ignore depreceted inside SCLAlertView [\#103](https://github.com/dogo/SCLAlertView/pull/103) ([jcavar](https://github.com/jcavar))

## [0.7.0](https://github.com/dogo/SCLAlertView/tree/0.7.0) (2015-04-01)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.6.1...0.7.0)

**Fixed bugs:**

- shouldDismissOnTapOutside not working [\#87](https://github.com/dogo/SCLAlertView/issues/87)
- Custom Icon Image's size is too small [\#86](https://github.com/dogo/SCLAlertView/issues/86)
- Rotate - rotate on Ipad [\#82](https://github.com/dogo/SCLAlertView/issues/82)
- SCLAlertView's button does not show up on iOS 7 [\#81](https://github.com/dogo/SCLAlertView/issues/81)

**Closed issues:**

- "use of @import when modules are disabled error" [\#77](https://github.com/dogo/SCLAlertView/issues/77)

**Merged pull requests:**

- fix screen stutter glitch with blur background [\#96](https://github.com/dogo/SCLAlertView/pull/96) ([felix-dumit](https://github.com/felix-dumit))
- Fixes a bug where you could not set Font attributes on the attributed st... [\#88](https://github.com/dogo/SCLAlertView/pull/88) ([n1mda](https://github.com/n1mda))
- Automatically add a borderWidth to the button if borderColor is defined [\#85](https://github.com/dogo/SCLAlertView/pull/85) ([jeremygrenier](https://github.com/jeremygrenier))

## [0.6.1](https://github.com/dogo/SCLAlertView/tree/0.6.1) (2015-03-23)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.6.0...0.6.1)

## [0.6.0](https://github.com/dogo/SCLAlertView/tree/0.6.0) (2015-03-22)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.9...0.6.0)

**Closed issues:**

- new alert flick [\#83](https://github.com/dogo/SCLAlertView/issues/83)

## [0.5.9](https://github.com/dogo/SCLAlertView/tree/0.5.9) (2015-03-18)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.8...0.5.9)

## [0.5.8](https://github.com/dogo/SCLAlertView/tree/0.5.8) (2015-03-17)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.7...0.5.8)

**Implemented enhancements:**

- Custom button height feature request [\#71](https://github.com/dogo/SCLAlertView/issues/71)

## [0.5.7](https://github.com/dogo/SCLAlertView/tree/0.5.7) (2015-03-16)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.6...0.5.7)

**Closed issues:**

- Crash in background thread [\#76](https://github.com/dogo/SCLAlertView/issues/76)
- Add button feature - button type [\#75](https://github.com/dogo/SCLAlertView/issues/75)
- BOOL visibility of alert needed [\#73](https://github.com/dogo/SCLAlertView/issues/73)

## [0.5.6](https://github.com/dogo/SCLAlertView/tree/0.5.6) (2015-03-05)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.5...0.5.6)

**Fixed bugs:**

- Latest Version Fails To Build [\#74](https://github.com/dogo/SCLAlertView/issues/74)

## [0.5.5](https://github.com/dogo/SCLAlertView/tree/0.5.5) (2015-02-22)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.4...0.5.5)

**Closed issues:**

- Execute block on dismissal [\#69](https://github.com/dogo/SCLAlertView/issues/69)

**Merged pull requests:**

- Minor icon and button customization fixes [\#70](https://github.com/dogo/SCLAlertView/pull/70) ([wzs](https://github.com/wzs))

## [0.5.4](https://github.com/dogo/SCLAlertView/tree/0.5.4) (2015-02-13)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.3...0.5.4)

**Implemented enhancements:**

- AlertView does not disable Interactive Pop Gesture [\#66](https://github.com/dogo/SCLAlertView/issues/66)
- Blur background is wrong when shown from "UIModalPresentationFormSheet" [\#65](https://github.com/dogo/SCLAlertView/issues/65)
- Add custom view [\#62](https://github.com/dogo/SCLAlertView/issues/62)
- SCLAlertView color [\#57](https://github.com/dogo/SCLAlertView/issues/57)
- Long texts truncated [\#38](https://github.com/dogo/SCLAlertView/issues/38)

**Fixed bugs:**

- The white background view is too long [\#53](https://github.com/dogo/SCLAlertView/issues/53)

## [0.5.3](https://github.com/dogo/SCLAlertView/tree/0.5.3) (2015-02-02)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.2...0.5.3)

**Fixed bugs:**

- Alert Moves Upwards When Switching Keyboards [\#45](https://github.com/dogo/SCLAlertView/issues/45)

**Closed issues:**

- textarea in alert [\#61](https://github.com/dogo/SCLAlertView/issues/61)

## [0.5.2](https://github.com/dogo/SCLAlertView/tree/0.5.2) (2015-01-27)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.1...0.5.2)

**Implemented enhancements:**

- background none [\#54](https://github.com/dogo/SCLAlertView/issues/54)

**Closed issues:**

- ability to only show one alert [\#56](https://github.com/dogo/SCLAlertView/issues/56)

## [0.5.1](https://github.com/dogo/SCLAlertView/tree/0.5.1) (2015-01-26)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.5.0...0.5.1)

**Implemented enhancements:**

- Without SubTitle? [\#18](https://github.com/dogo/SCLAlertView/issues/18)

**Fixed bugs:**

- Device rotations support [\#51](https://github.com/dogo/SCLAlertView/issues/51)

**Closed issues:**

- how to customize buttons separately? [\#55](https://github.com/dogo/SCLAlertView/issues/55)
- Rotating with keyboard [\#36](https://github.com/dogo/SCLAlertView/issues/36)

## [0.5.0](https://github.com/dogo/SCLAlertView/tree/0.5.0) (2015-01-21)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.4.3...0.5.0)

**Fixed bugs:**

- Display in formsheet [\#50](https://github.com/dogo/SCLAlertView/issues/50)

## [0.4.3](https://github.com/dogo/SCLAlertView/tree/0.4.3) (2015-01-20)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.4.2...0.4.3)

**Closed issues:**

- Change Title Size [\#42](https://github.com/dogo/SCLAlertView/issues/42)

## [0.4.2](https://github.com/dogo/SCLAlertView/tree/0.4.2) (2015-01-20)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.4.1...0.4.2)

**Closed issues:**

- iPad vs iPhone NavigationBar [\#46](https://github.com/dogo/SCLAlertView/issues/46)
- does not work with UIPIckview [\#26](https://github.com/dogo/SCLAlertView/issues/26)

## [0.4.1](https://github.com/dogo/SCLAlertView/tree/0.4.1) (2015-01-19)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.4.0...0.4.1)

**Closed issues:**

- Can i write the code anywhere? [\#49](https://github.com/dogo/SCLAlertView/issues/49)
- Landscape not working on iPad [\#48](https://github.com/dogo/SCLAlertView/issues/48)

## [0.4.0](https://github.com/dogo/SCLAlertView/tree/0.4.0) (2015-01-19)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.9...0.4.0)

**Fixed bugs:**

- iPad landscape orientation for iOS \< 8 is not supported [\#41](https://github.com/dogo/SCLAlertView/issues/41)

**Closed issues:**

- Alert Moves After Keyboard Dismisses [\#44](https://github.com/dogo/SCLAlertView/issues/44)
- Change Edit Alert Color [\#43](https://github.com/dogo/SCLAlertView/issues/43)

**Merged pull requests:**

- fix \#44 [\#47](https://github.com/dogo/SCLAlertView/pull/47) ([portwatcher](https://github.com/portwatcher))

## [0.3.9](https://github.com/dogo/SCLAlertView/tree/0.3.9) (2015-01-15)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.8...0.3.9)

## [0.3.8](https://github.com/dogo/SCLAlertView/tree/0.3.8) (2015-01-12)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.7...0.3.8)

**Implemented enhancements:**

- Improvement: progress dialog [\#15](https://github.com/dogo/SCLAlertView/issues/15)

**Closed issues:**

- alertview position issue [\#39](https://github.com/dogo/SCLAlertView/issues/39)

## [0.3.7](https://github.com/dogo/SCLAlertView/tree/0.3.7) (2014-12-13)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.6...0.3.7)

**Closed issues:**

- Auto window height by subtitle height [\#29](https://github.com/dogo/SCLAlertView/issues/29)

**Merged pull requests:**

- New features [\#37](https://github.com/dogo/SCLAlertView/pull/37) ([michalciolek](https://github.com/michalciolek))
- Last fix [\#35](https://github.com/dogo/SCLAlertView/pull/35) ([ancloid](https://github.com/ancloid))
- Subtitle Height Setting [\#34](https://github.com/dogo/SCLAlertView/pull/34) ([ancloid](https://github.com/ancloid))

## [0.3.6](https://github.com/dogo/SCLAlertView/tree/0.3.6) (2014-12-09)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.5...0.3.6)

**Closed issues:**

- Alert Positioning in TableView [\#32](https://github.com/dogo/SCLAlertView/issues/32)
- slow [\#31](https://github.com/dogo/SCLAlertView/issues/31)
- Backbutton while SCLAlertView is shown causes zombie views [\#25](https://github.com/dogo/SCLAlertView/issues/25)

**Merged pull requests:**

- modified podspec file to support iOS6 [\#33](https://github.com/dogo/SCLAlertView/pull/33) ([shannonchou](https://github.com/shannonchou))

## [0.3.5](https://github.com/dogo/SCLAlertView/tree/0.3.5) (2014-11-28)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.4...0.3.5)

**Implemented enhancements:**

- typedef ValidationBlock name conflicting [\#27](https://github.com/dogo/SCLAlertView/issues/27)

**Closed issues:**

- Now broken on iOS6 [\#30](https://github.com/dogo/SCLAlertView/issues/30)
- EXC\_BAD\_ACCESS \(code=1\) [\#28](https://github.com/dogo/SCLAlertView/issues/28)

## [0.3.4](https://github.com/dogo/SCLAlertView/tree/0.3.4) (2014-11-14)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.3...0.3.4)

**Closed issues:**

- Any way to show this from a UIView? [\#11](https://github.com/dogo/SCLAlertView/issues/11)

## [0.3.3](https://github.com/dogo/SCLAlertView/tree/0.3.3) (2014-11-11)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.2...0.3.3)

## [0.3.2](https://github.com/dogo/SCLAlertView/tree/0.3.2) (2014-11-05)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.1...0.3.2)

**Fixed bugs:**

- Alert view keep on moving upwards on different UIKeyboardType [\#23](https://github.com/dogo/SCLAlertView/issues/23)

**Closed issues:**

- Any of the showAnimationType not working [\#22](https://github.com/dogo/SCLAlertView/issues/22)

## [0.3.1](https://github.com/dogo/SCLAlertView/tree/0.3.1) (2014-11-04)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.3.0...0.3.1)

## [0.3.0](https://github.com/dogo/SCLAlertView/tree/0.3.0) (2014-11-04)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.2.6...0.3.0)

**Implemented enhancements:**

- Is possible to bind action on default button? [\#4](https://github.com/dogo/SCLAlertView/issues/4)

**Fixed bugs:**

- typedef ActionBlock name confliction [\#16](https://github.com/dogo/SCLAlertView/issues/16)
- crash on ios6.1 [\#13](https://github.com/dogo/SCLAlertView/issues/13)

**Closed issues:**

- hi, a suggestion of one line about subTitle's height [\#24](https://github.com/dogo/SCLAlertView/issues/24)
- Add image to Alertview? [\#21](https://github.com/dogo/SCLAlertView/issues/21)
- Position not always correct [\#20](https://github.com/dogo/SCLAlertView/issues/20)
- Issue when displaying alert view in landscape [\#14](https://github.com/dogo/SCLAlertView/issues/14)

**Merged pull requests:**

- fix showAnimation bug [\#19](https://github.com/dogo/SCLAlertView/pull/19) ([sanshanchuns](https://github.com/sanshanchuns))

## [0.2.6](https://github.com/dogo/SCLAlertView/tree/0.2.6) (2014-10-23)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.2.5...0.2.6)

## [0.2.5](https://github.com/dogo/SCLAlertView/tree/0.2.5) (2014-10-23)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.2.4...0.2.5)

## [0.2.4](https://github.com/dogo/SCLAlertView/tree/0.2.4) (2014-10-22)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.2.3...0.2.4)

## [0.2.3](https://github.com/dogo/SCLAlertView/tree/0.2.3) (2014-10-21)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.2.2...0.2.3)

## [0.2.2](https://github.com/dogo/SCLAlertView/tree/0.2.2) (2014-10-21)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.2.1...0.2.2)

**Implemented enhancements:**

- is possible button show touch down or touch up display? [\#10](https://github.com/dogo/SCLAlertView/issues/10)

## [0.2.1](https://github.com/dogo/SCLAlertView/tree/0.2.1) (2014-10-20)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.2.0...0.2.1)

**Closed issues:**

- Podfile update? [\#12](https://github.com/dogo/SCLAlertView/issues/12)
- is possible to move top when keyboard show? [\#5](https://github.com/dogo/SCLAlertView/issues/5)

**Merged pull requests:**

- Add validation block [\#9](https://github.com/dogo/SCLAlertView/pull/9) ([mamaral](https://github.com/mamaral))

## [0.2.0](https://github.com/dogo/SCLAlertView/tree/0.2.0) (2014-10-18)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.1.2...0.2.0)

**Implemented enhancements:**

- Fade animation for 'Done' button... [\#3](https://github.com/dogo/SCLAlertView/issues/3)

**Merged pull requests:**

- Button dismiss fade bug [\#8](https://github.com/dogo/SCLAlertView/pull/8) ([mamaral](https://github.com/mamaral))
- Easier form navigation [\#7](https://github.com/dogo/SCLAlertView/pull/7) ([mamaral](https://github.com/mamaral))
- Custom icon and color [\#6](https://github.com/dogo/SCLAlertView/pull/6) ([mamaral](https://github.com/mamaral))

## [0.1.2](https://github.com/dogo/SCLAlertView/tree/0.1.2) (2014-10-13)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.1.1...0.1.2)

**Closed issues:**

- Within UINavigationController [\#2](https://github.com/dogo/SCLAlertView/issues/2)
- Issues with a side menu controller [\#1](https://github.com/dogo/SCLAlertView/issues/1)

## [0.1.1](https://github.com/dogo/SCLAlertView/tree/0.1.1) (2014-10-09)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.1.0...0.1.1)

## [0.1.0](https://github.com/dogo/SCLAlertView/tree/0.1.0) (2014-10-08)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.0.3...0.1.0)

## [0.0.3](https://github.com/dogo/SCLAlertView/tree/0.0.3) (2014-10-03)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.0.2...0.0.3)

## [0.0.2](https://github.com/dogo/SCLAlertView/tree/0.0.2) (2014-09-29)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/dogo/SCLAlertView/tree/0.0.1) (2014-09-29)

[Full Changelog](https://github.com/dogo/SCLAlertView/compare/49477fbc62f611ec0dd04590afa3d29972b60d22...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
