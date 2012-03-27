/* ---------------------------------------------------------
 * ExpandingButtonBar
 * Author: Ryan Nystrom
 * Copyright (C) 2012 Ryan Nystrom
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://www.opensource.org/licenses/MIT
 * -------------------------------------------------------*/
#import "RNExpandingButtonBar.h"

//@interface ExpandingButton : UIButton
//
//@property (nonatomic, strong) UIView *test;
//
//@end
//
//@implementation ExpandingButton
//
//@synthesize test;
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touches began");
//    [super touchesBegan:touches withEvent:event];
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touches ended");
//    [super touchesEnded:touches withEvent:event];
//}
//
//@end

@interface RNExpandingButtonBar ()
- (void) _expand:(NSDictionary*)properties;
- (void) _close:(NSDictionary*)properties;
@end

@implementation RNExpandingButtonBar

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
        
        for (int i = 0; i < [buttons count]; ++i) {
            UIButton *button = (UIButton*)[buttons objectAtIndex:i];
            [button addTarget:self action:@selector(explode:) forControlEvents:UIControlEventTouchUpInside];
            [button setCenter:buttonCenter];
            [button setAlpha:0.0f];
            [self addSubview:button];
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

- (void) explode:(id)sender
{
    if (! _explode) return;
    UIView *view = (UIView*)sender;
    CGAffineTransform scale = CGAffineTransformMakeScale(5.0f, 5.0f);
    CGAffineTransform unScale = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView animateWithDuration:0.3 animations:^{
        [view setAlpha:0.0f];
        [view setTransform:scale];
    } completion:^(BOOL finished){
        [view setAlpha:1.0f];
        [view setTransform:unScale];
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
                [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
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
    float endY = center.y;
    float endX = center.x;
    for (int i = 0; i < [[self buttons] count]; ++i) {
        UIButton *button = [[self buttons] objectAtIndex:i];
        if (animated) {
            NSMutableArray *animationOptions = [NSMutableArray array];
            if (_spin) {
                CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * -2], nil]];
                [rotateAnimation setDuration:_animationTime];
                [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
                [animationOptions addObject:rotateAnimation];
            }        
            
            CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            [opacityAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f], nil]];
            [opacityAnimation setDuration:_animationTime];
            [animationOptions addObject:opacityAnimation];
            
            float y = [button center].y;
            float x = [button center].x;            
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            [positionAnimation setDuration:_animationTime];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, x, y);
            CGPathAddLineToPoint(path, NULL, endX, endY); 
            [positionAnimation setPath: path];
            CGPathRelease(path);
            
            [animationOptions addObject:positionAnimation];
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            [animationGroup setAnimations: animationOptions];
            [animationGroup setDuration:_animationTime];
            [animationGroup setFillMode: kCAFillModeForwards];
            [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            
            NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"animation", nil]];
            [self performSelector:@selector(_close:) withObject:properties afterDelay:_delay * ([[self buttons] count] - i)];
        }
        else {
            [button setCenter:center];
            [button setAlpha:0.0f];            
        }
    }
    float delegateDelay = _animated ? [[self buttons] count] * _delay + _animationTime: 0.0f;
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

- (void) _close:(NSDictionary*)properties
{
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    CGPoint center = [[self button] center];
    [[view layer] addAnimation:animationGroup forKey:@"Collapse"];
    [view setAlpha:0.0f];
    [view setCenter:center];
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

- (void) setExplode:(BOOL)b
{
    _explode = b;
}

/* ----------------------------------------------
 * DO NOT CHANGE
 * The following is a hack to allow touches outside
 * of this view. Use caution when changing.
 * --------------------------------------------*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event 
{
    UIView *v = nil;
    v = [super hitTest:point withEvent:event];   
    return v;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
    BOOL isInside = [super pointInside:point withEvent:event];    
    if (YES == isInside) {
        return isInside;
    }
    for (UIButton *button in [self buttons]) {
        CGPoint inButtonSpace = [self convertPoint:point toView:button];    
        BOOL isInsideButton = [button pointInside:inButtonSpace withEvent:nil];
        if (YES == isInsideButton) {
            return isInsideButton;
        }
    }
    return isInside;
}

@end
