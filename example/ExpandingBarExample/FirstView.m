#import "FirstView.h"

@implementation FirstView

@synthesize bar = _bar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"UIView"];
    
    /* ---------------------------------------------------------
     * Create images that are used for the main button
     * -------------------------------------------------------*/
    UIImage *image = [UIImage imageNamed:@"red_plus_up.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"red_plus_down.png"];
    UIImage *toggledImage = [UIImage imageNamed:@"red_x_up.png"];
    UIImage *toggledSelectedImage = [UIImage imageNamed:@"red_x_down.png"];
    
    /* ---------------------------------------------------------
     * Create the center for the main button and origin of animations
     * -------------------------------------------------------*/
    CGPoint center = CGPointMake(30.0f, 370.0f);
    
    /* ---------------------------------------------------------
     * Setup buttons
     * Note: I am setting the frame to the size of my images
     * -------------------------------------------------------*/
    CGRect buttonFrame = CGRectMake(0, 0, 32.0f, 32.0f);
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b1 setFrame:buttonFrame];
    [b1 setImage:[UIImage imageNamed:@"next_circle.png"] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b2 setImage:[UIImage imageNamed:@"lightbulb.png"] forState:UIControlStateNormal];
    [b2 setFrame:buttonFrame];
    [b2 addTarget:self action:@selector(onAlert) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b3 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [b3 setFrame:buttonFrame];
    [b3 addTarget:self action:@selector(onModal) forControlEvents:UIControlEventTouchUpInside];
    NSArray *buttons = [NSArray arrayWithObjects:b1, b2, b3, nil];
    
    /* ---------------------------------------------------------
     * Init method, passing everything the bar needs to work
     * -------------------------------------------------------*/
    ExpandingButtonBar *bar = [[ExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
    
    /* ---------------------------------------------------------
     * Settings
     * -------------------------------------------------------*/
    [bar setDelegate:self];
    [bar setSpin:YES];
    
    /* ---------------------------------------------------------
     * Set our property and add it to the view
     * -------------------------------------------------------*/
    [self setBar:bar];
    [[self view] addSubview:[self bar]];
    
    [[self navigationController] setToolbarHidden:YES];
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void) onNext
{
    /* ---------------------------------------------------------
     * Hide the buttons with an animation
     * -------------------------------------------------------*/
    [[self bar] hideButtonsAnimated:YES];
    
    SecondView *view = [[SecondView alloc] init];
    [[self navigationController] pushViewController:view animated:YES];
}

- (void) onAlert
{
    /* ---------------------------------------------------------
     * Hide the buttons without an animation
     * -------------------------------------------------------*/
    [[self bar] hideButtonsAnimated:NO];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"This is an alert message." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

- (void) onModal
{
    [[self bar] hideButtonsAnimated:YES];
}

/* ---------------------------------------------------------
 * Delegate methods of ExpandingButtonBarDelegate
 * -------------------------------------------------------*/
- (void) expandingBarDidAppear:(ExpandingButtonBar *)bar
{
    NSLog(@"did appear");
}

- (void) expandingBarWillAppear:(ExpandingButtonBar *)bar
{
    NSLog(@"will appear");
}

- (void) expandingBarDidDisappear:(ExpandingButtonBar *)bar
{
    NSLog(@"did disappear");
}

- (void) expandingBarWillDisappear:(ExpandingButtonBar *)bar
{
    NSLog(@"will disappear");
}

@end
