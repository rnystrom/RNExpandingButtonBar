#import "FirstView.h"

@implementation FirstView

@synthesize bar = _bar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"UIView"];
    
    UIImage *image = [UIImage imageNamed:@"red_plus_up.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"red_plus_down.png"];
    UIImage *toggledImage = [UIImage imageNamed:@"red_x_up.png"];
    UIImage *toggledSelectedImage = [UIImage imageNamed:@"red_x_down.png"];
    CGPoint center = CGPointMake(30.0f, 370.0f);
    
    CGRect buttonFrame = CGRectMake(0, 0, 32.0f, 32.0f);
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b1 setFrame:buttonFrame];
    [b1 setTitle:@"Next" forState:UIControlStateNormal];
    [b1 setImage:[UIImage imageNamed:@"next_circle.png"] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b2 setTitle:@"Alert" forState:UIControlStateNormal];
    [b2 setImage:[UIImage imageNamed:@"lightbulb.png"] forState:UIControlStateNormal];
    [b2 setFrame:buttonFrame];
    [b2 addTarget:self action:@selector(onAlert) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b3 setTitle:@"Blank" forState:UIControlStateNormal];
    [b3 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [b3 setFrame:buttonFrame];
    [b3 addTarget:self action:@selector(onModal) forControlEvents:UIControlEventTouchUpInside];
    NSArray *buttons = [NSArray arrayWithObjects:b1, b2, b3, nil];
    
    ExpandingButtonBar *bar = [[ExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
    [bar setDelegate:self];
    [bar setSpin:YES];
    [self setBar:bar];
    [[self view] addSubview:[self bar]];
    
    [[self navigationController] setToolbarHidden:YES];
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void) onNext
{
    [[self bar] hideButtonsAnimated:YES];
    SecondView *view = [[SecondView alloc] init];
    [[self navigationController] pushViewController:view animated:YES];
}

- (void) onAlert
{
    [[self bar] hideButtonsAnimated:NO];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"This is an alert message." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

- (void) onModal
{
    [[self bar] hideButtonsAnimated:YES];
}

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
