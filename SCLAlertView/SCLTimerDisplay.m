//
//  SCLTimerDisplay.m
//  SCLAlertView
//
//  Created by Taylor Ryan on 8/18/15.
//  Copyright (c) 2015-2017 AnyKey Entertainment. All rights reserved.
//

#import "SCLTimerDisplay.h"
#import "SCLMacros.h"

@interface SCLTimerDisplay ()

// Centered numeric readout for elapsed/remaining seconds.
// Kept as a subview to benefit from UILabel accessibility and text rendering.
@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation SCLTimerDisplay

@synthesize currentAngle;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        currentAngle = 0.0f;
        _color = [UIColor whiteColor];
        running = NO;
        pausedElapsed = 0;
    }
    return self;
}

- (instancetype)initWithOrigin:(CGPoint)origin radius:(CGFloat)r
{
    return [self initWithOrigin:(CGPoint)origin radius:r lineWidth:5.0f];
}

- (instancetype)initWithOrigin:(CGPoint)origin radius:(CGFloat)r lineWidth:(CGFloat)width
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, r*2, r*2)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        currentAngle = START_DEGREE_OFFSET;
        // Draw from the center of the stroke; subtract half line width from the radius to avoid clipping
        radius = r-(width/2);
        lineWidth = width;
        self.color = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
        
        // Lightweight numeric HUD in the middle of the ring
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.font = [UIFont fontWithName: @"HelveticaNeue-Bold" size:12.0f];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _countLabel.isAccessibilityElement = YES;
        _countLabel.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
        [self addSubview:_countLabel];
    }
    return self;
}

- (void)dealloc
{
    [self cancelTimer];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        // Prevent orphaned timers when the view leaves the hierarchy
        [self cancelTimer];
    }
    [super willMoveToSuperview:newSuperview];
}

- (void)setColor:(UIColor *)color
{
    _color = color ?: [UIColor whiteColor];
    _countLabel.textColor = _color;
    [self setNeedsDisplay];
}

- (void)updateFrame:(CGSize)size
{
    // Position the ring in the trailing edge with a small inset; keep label centered
    CGFloat r = radius+(lineWidth/2);
    
    CGFloat originX = size.width - (2*r) - 5;
    CGFloat originY = (size.height - (2*r))/2;
    
    self.frame = CGRectMake(originX, originY, r*2, r*2);
    self.countLabel.frame = CGRectMake(0, 0, r*2, r*2);
}

- (void)drawRect:(CGRect)rect
{
    // Draw progress ring from START_DEGREE_OFFSET to currentAngle
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius+(lineWidth/2), radius+(lineWidth/2))
                                                         radius:radius
                                                     startAngle:DEGREES_TO_RADIANS(START_DEGREE_OFFSET)
                                                       endAngle:DEGREES_TO_RADIANS(currentAngle)
                                                      clockwise:YES];
    [self.color setStroke];
    aPath.lineWidth = lineWidth;
    [aPath stroke];
    
    // Keep the numeric text aligned with the mode:
    // - reverse: countdown shows remaining seconds
    // - forward: count-up shows elapsed seconds
    if (_reverse) {
        int remaining = MAX((int)ceil(timerLimit - currentTime), 0);
        _countLabel.text = [NSString stringWithFormat:@"%d", remaining];
        _countLabel.accessibilityLabel = [NSString stringWithFormat:@"%d seconds remaining", remaining];
    } else {
        int elapsed = MIN((int)floor(currentTime), (int)ceil(timerLimit));
        _countLabel.text = [NSString stringWithFormat:@"%d", elapsed];
        _countLabel.accessibilityLabel = [NSString stringWithFormat:@"%d seconds elapsed", elapsed];
    }
}

- (void)startTimerWithTimeLimit:(int)tl completed:(SCLActionBlock)completed
{
    [self cancelTimer]; // Reset prior state and invalidate any running NSTimer

    timerLimit = MAX(0, tl);
    // Use a single notion of time for simplicity: currentTime is "elapsed" regardless of mode
    currentTime = 0.0;
    currentAngle = START_DEGREE_OFFSET;
    completedBlock = [completed copy];
    _countLabel.textColor = _color;

    pausedElapsed = 0;
    startTime = CACurrentMediaTime();
    running = YES;

    __weak typeof(self) weakSelf = self;
    // Block-based NSTimer avoids needing a selector and reduces boilerplate; weakSelf prevents retain cycles
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_STEP repeats:YES block:^(NSTimer * _Nonnull t) {
        [weakSelf updateTimerTick];
    }];
    // Common run loop modes keep the ring responsive while the UI is interacting (e.g., scrolling)
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    [self setNeedsDisplay];
}

- (void)updateTimerTick
{
    if (!running) { return; }

    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval elapsedSinceStart = now - startTime + pausedElapsed;

    // Clamp elapsed to the limit to stabilize the label at the end boundary
    currentTime = MIN(elapsedSinceStart, timerLimit);

    if (_reverse) {
        // Countdown visualization: arc shrinks from full circle to zero
        CGFloat timeRemaining = MAX(timerLimit - elapsedSinceStart, 0.0);
        CGFloat fractionRemaining = (timerLimit <= 0.0) ? 0.0 : (timeRemaining / timerLimit);
        fractionRemaining = MIN(MAX(fractionRemaining, 0.0), 1.0);
        // Map remaining fraction to end angle so the visible arc length is proportional to remaining time
        currentAngle = (fractionRemaining * 360.0) + START_DEGREE_OFFSET;
    } else {
        // Count-up visualization: arc grows from zero to full circle
        CGFloat fractionDone = (timerLimit <= 0.0) ? 1.0 : (elapsedSinceStart / timerLimit);
        fractionDone = MIN(MAX(fractionDone, 0.0), 1.0);
        currentAngle = (fractionDone * 360.0) + START_DEGREE_OFFSET;
    }

    // Stop precisely at the limit to avoid overshooting due to timer granularity
    BOOL finished = (elapsedSinceStart >= timerLimit);
    if (finished) {
        [self stopTimer];
        return;
    }
    [self setNeedsDisplay];
}

- (void)cancelTimer
{
    running = NO;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)stopTimer
{
    [self cancelTimer];
    if (completedBlock != nil) {
        // Copy to local before clearing to avoid re-entrancy surprises in user code
        SCLActionBlock block = completedBlock;
        completedBlock = nil;
        block();
    }
}

- (void)pauseTimer
{
    if (!running) return;
    running = NO;
    CFTimeInterval now = CACurrentMediaTime();
    // Accumulate elapsed time so resume continues from the correct point
    pausedElapsed += (now - startTime);
    if (timer) {
        [timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)resumeTimer
{
    if (running || timerLimit <= 0) return;
    running = YES;
    // Restart time base; pausedElapsed carries the previous progress
    startTime = CACurrentMediaTime();
    if (timer) {
        [timer setFireDate:[NSDate date]];
    } else {
        __weak typeof(self) weakSelf = self;
        timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_STEP repeats:YES block:^(NSTimer * _Nonnull t) {
            [weakSelf updateTimerTick];
        }];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

@end
