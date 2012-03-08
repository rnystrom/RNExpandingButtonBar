#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ExpandingButtonBarDelegate;

@interface ExpandingButtonBar : UIView
{
    NSArray *_buttons;
    
    UIButton *_button;
    UIButton *_toggledButton;

    int _viewMaxHeight;
    float _animationTime;
    float _fadeTime;
    float _padding;
    float _far;
    float _near;
    float _delay;
    
    BOOL _toggled;
    BOOL _spin;
    BOOL _horizontal;
    BOOL _animated;
    
    NSObject <ExpandingButtonBarDelegate> *_delegate;
}

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *toggledButton;
@property (nonatomic, strong) NSObject <ExpandingButtonBarDelegate> *delegate;

- (id) initWithImage:(UIImage*)image 
       selectedImage:(UIImage*)selectedImage 
        toggledImage:(UIImage*)toggledImage 
toggledSelectedImage:(UIImage*)toggledSelectedImage 
             buttons:(NSArray*)buttons 
              center:(CGPoint)center;

- (void) setDefaults;

- (void) showButtons;
- (void) hideButtons;
- (void) showButtonsAnimated:(BOOL)animated;
- (void) hideButtonsAnimated:(BOOL)animated;

- (void) toggleMainButton;
- (void) onButton:(id)sender;
- (void) onToggledButton:(id)sender;

- (int) getXoffset:(UIView*)view;
- (int) getYoffset:(UIView*)view;

- (void) setAnimationTime:(float)time;
- (void) setFadeTime:(float)time;
- (void) setPadding:(float)padding;
- (void) setSpin:(BOOL)b;
- (void) setHorizontal:(BOOL)b;
- (void) setFar:(float)num;
- (void) setNear:(float)num;
- (void) setDelay:(float)num;

@end

@protocol ExpandingButtonBarDelegate <NSObject>

- (void) expandingBarWillAppear:(ExpandingButtonBar*)bar;
- (void) expandingBarDidAppear:(ExpandingButtonBar *)bar;
- (void) expandingBarWillDisappear:(ExpandingButtonBar *)bar;
- (void) expandingBarDidDisappear:(ExpandingButtonBar *)bar;

@end