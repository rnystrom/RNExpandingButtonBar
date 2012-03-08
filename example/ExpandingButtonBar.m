#import "ExpandingButtonBar.h"

@interface ExpandingButtonBar ()
- (void) _expand:(NSDictionary*)properties;
- (void) _close: (UIView*)view center:(CGPoint)center;
@end

@implementation ExpandingButtonBar

@synthesize buttons = _buttons;
@synthesize button = _button;
@synthesize toggledButton = _toggledButton;
@synthesize delegate = _delegate;

- (id) initWithImage:(UIImage*)image selectedImage:(UIImage*)selectedImage toggledImage:(UIImage*)toggledImage toggledSelectedImage:(UIImage*)toggledSelectedImage buttons:(NSArray*)buttons center:(CGPoint)center;
{
    if (self = [super init]) {
        [self setDefaults];
        
        // Reverse buttons so it makes since for top/bottom
        NSArray *reversedButtons = [[buttons reverseObjectEnumerator] allObjects];
        [self setButtons:reversedButtons];
        
        // Button location/size settings
        CGRect buttonFrame = CGRectMake(0, 0, [image size].width, [image size].height);
        CGPoint buttonCenter = CGPointMake([image size].width / 2.0f, [image size].height / 2.0f);
        
        UIButton *defaultButton = [[UIButton alloc] initWithFrame:buttonFrame];
        [defaultButton setCenter:buttonCenter];
        [defaultButton setImage:image forState:UIControlStateNormal];
        [defaultButton setImage:selectedImage forState:UIControlEventTouchDown];
        [defaultButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self setButton:defaultButton];
        
        UIButton *toggledButton = [[UIButton alloc] initWithFrame:buttonFrame];
        [toggledButton setCenter:buttonCenter];
        [toggledButton setImage:toggledImage forState:UIControlStateNormal];
        [toggledButton setImage:toggledSelectedImage forState:UIControlEventTouchDown];
        [toggledButton addTarget:self action:@selector(onToggledButton:) forControlEvents:UIControlEventTouchUpInside];
        // Init invisible
        [toggledButton setAlpha:0.0f];
        [self setToggledButton:toggledButton];
        
        _viewMaxHeight = 0;
        for (UIButton *button in [self buttons]) {
            [button setCenter:buttonCenter];
            [button setAlpha:0.0f];
            [self addSubview:button];
            _viewMaxHeight += [button frame].size.height + _padding;            
        }
        
        // Container view settings
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:buttonFrame];
        [self setCenter:center];
                
        [self addSubview:[self button]];
        [self addSubview:[self toggledButton]];
    }
    return self;
}

- (void) setDefaults
{
    _fadeTime = 0.2f;
    _animationTime = 0.4f;
    _padding = 15.0f;
    _far = 15.0f;
    _near = 7.0f;
    _delay = 0.1f;
    
    _toggled = NO;
    _spin = NO;
    _horizontal = NO;
    _animated = YES;
}

- (void) onButton:(id)sender
{    
    [self showButtonsAnimated:_animated];
}

- (void) onToggledButton:(id)sender
{
    [self hideButtonsAnimated:_animated];
}

- (void) showButtons
{
    [self showButtonsAnimated:NO];
}

- (void) hideButtons
{
    [self hideButtonsAnimated:NO];
}

- (void) toggleMainButton
{
    UIButton *animateTo;
    UIButton *animateFrom;
    if (_toggled) {
        animateTo = [self button];
        animateFrom = [self toggledButton];
    }
    else {
        animateTo = [self toggledButton];
        animateFrom = [self button];        
    }
    [UIView animateWithDuration:_fadeTime animations:^{
        [animateTo setAlpha:1.0f];
        [animateFrom setAlpha:0.0f];
    }];
}

    
- (void) showButtonsAnimated:(BOOL)animated
{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(expandingBarWillAppear:)]) {
        [[self delegate] expandingBarWillAppear:self];
    }
    float y = [[self button] center].y;
    float x = [[self button] center].x;
    float endY = y;
    float endX = x;
    float spinStep2 = 1.0f;
    for (int i = 0; i < [[self buttons] count]; ++i) {
        UIButton *button = [[self buttons] objectAtIndex:i];
        endY -= [self getYoffset:button];
        endX += [self getXoffset:button];
        float farY = endY - ( ! _horizontal ? _far : 0.0f);
        float farX = endX - (_horizontal ? _far : 0.0f);
        float nearY = endY + ( ! _horizontal ? _near : 0.0f);
        float nearX = endX + (_horizontal ? _near : 0.0f);
        if (animated) {
            NSMutableArray *animationOptions = [NSMutableArray array];
            if (_spin) {
                CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2], nil]];
                [rotateAnimation setDuration:_animationTime];
                [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:spinStep2], nil]];
                [animationOptions addObject:rotateAnimation];
            }        
            
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            [positionAnimation setDuration:_animationTime];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, x, y);
            CGPathAddLineToPoint(path, NULL, farX, farY);
            CGPathAddLineToPoint(path, NULL, nearX, nearY); 
            CGPathAddLineToPoint(path, NULL, endX, endY); 
            [positionAnimation setPath: path];
            CGPathRelease(path);
            
            [animationOptions addObject:positionAnimation];
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            [animationGroup setAnimations: animationOptions];
            [animationGroup setDuration:_animationTime];
            [animationGroup setFillMode: kCAFillModeForwards];
            [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];

            NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, [NSValue valueWithCGPoint:CGPointMake(endX, endY)], animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"center", @"animation", nil]];
            [self performSelector:@selector(_expand:) withObject:properties afterDelay:_delay * ([[self buttons] count] - i)];
        }
        else {
            [button setCenter:CGPointMake(x, y)];
            [button setAlpha:1.0f];
        }
    }
    _toggled = NO;
    [self toggleMainButton];
    float delegateDelay = _animated ? [[self buttons] count] * _delay + _animationTime : 0.0f;
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(expandingBarDidAppear:)]) {
        [[self delegate] performSelector:@selector(expandingBarDidAppear:) withObject:self afterDelay:delegateDelay];
    }
}

- (void) hideButtonsAnimated:(BOOL)animated
{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(expandingBarWillDisappear:)]) {
        [[self delegate] performSelector:@selector(expandingBarWillDisappear:) withObject:self];
    }
    CGPoint center = [[self button] center];
    for (UIButton *button in [self buttons]) {
        if (animated) {
            [self _close:button center:center];
        }
        else {
            [button setCenter:center];
            [button setAlpha:0.0f];            
        }
    }
    float delegateDelay = _animated ? [[self buttons] count] * _delay : 0.0f;
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(expandingBarDidDisappear:)]) {
        [[self delegate] performSelector:@selector(expandingBarDidDisappear:) withObject:self afterDelay:delegateDelay];
    }
    _toggled = YES;
    [self toggleMainButton];
}

- (void) _expand:(NSDictionary*)properties
{
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    NSValue *val = [properties objectForKey:@"center"];
    CGPoint center = [val CGPointValue];
    
    [[view layer] addAnimation:animationGroup forKey:@"Expand"];
    
    [view setCenter:center];
    [view setAlpha:1.0f];
}

- (void) _close: (UIView*)view center:(CGPoint)center
{
    [UIView animateWithDuration:_animationTime animations:^{
        [view setCenter:center];
        [view setAlpha:0.0f];
    }];
}

- (int) getXoffset:(UIView*)view
{
    if (_horizontal) {
        return [view frame].size.height + _padding;
    }
    return 0;
}

- (int) getYoffset:(UIView*)view
{
    if ( ! _horizontal) {
        return [view frame].size.height + _padding;
    }
    return 0;
}

/* ----------------------------------------------
 * You probably do not want to edit anything under here
 * --------------------------------------------*/
- (void) setAnimationTime:(float)time
{
    if (time > 0) {
        _animationTime = time;
    }
}

- (void) setFadeTime:(float)time
{
    if (time > 0) {
        _fadeTime = time;
    }
}

- (void) setPadding:(float)padding
{
    if (padding > 0) {
        _padding = padding;
    }
}

- (void) setSpin:(BOOL)b
{
    _spin = b;
}

- (void) setHorizontal:(BOOL)b
{
    NSArray *reversedButtons = [[[self buttons] reverseObjectEnumerator] allObjects];
    [self setButtons:reversedButtons];
    
    _horizontal = b;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event 
{
    UIView *v = nil;
    v = [super hitTest:point withEvent:event];   
    return v;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
    BOOL isInside = [super pointInside:point withEvent:event];    
    for (UIButton *button in [self buttons]) {
        CGPoint inButtonSpace = [self convertPoint:point toView:button];    
        BOOL isInsideButton = [button pointInside:inButtonSpace withEvent:nil];
        if (YES == isInsideButton) {
            return isInsideButton;
        }
    }
    return isInside;
}

- (void) setFar:(float)num
{
    _far = num;
}

- (void) setNear:(float)num
{
    _near = num;
}

- (void) setDelay:(float)num
{
    _delay = num;
}

@end
