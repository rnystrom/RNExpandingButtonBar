#import "SecondView.h"

@implementation SecondView

@synthesize bar = _bar;
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* ---------------------------------------------------------
     * Custom code to let us have a fixed view overtop the UITableView.
     * I'm no UITableView expert, just the way I decided to demo this.
     * ---------------------------------------------------------*/
    if ( ! _tableView &&
        [[self view] isKindOfClass:[UITableView class]]) {
        _tableView = (UITableView *)[self view];
    }
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self setView:view];
    [[self tableView] setFrame:[[self view] bounds]];
    [[self view] addSubview:[self tableView]];
    
    [self setTitle:@"UITableView"];
 
    /* ---------------------------------------------------------
     * Now we've changed [self view] to contain our tableView and our bar.
     * ---------------------------------------------------------*/
    UIImage *image = [UIImage imageNamed:@"red_plus_up.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"red_plus_down.png"];
    UIImage *toggledImage = [UIImage imageNamed:@"red_x_up.png"];
    UIImage *toggledSelectedImage = [UIImage imageNamed:@"red_x_down.png"];
    CGPoint center = CGPointMake(30.0f, 370.0f);
    
    CGRect buttonFrame = CGRectMake(0, 0, 50.0f, 50.0f);
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b1 setFrame:buttonFrame];
    [b1 setTitle:@"One" forState:UIControlStateNormal];
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b2 setTitle:@"Two" forState:UIControlStateNormal];
    [b2 setFrame:buttonFrame];
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b3 setTitle:@"Three" forState:UIControlStateNormal];
    [b3 setFrame:buttonFrame];
    NSArray *buttons = [NSArray arrayWithObjects:b1, b2, b3, nil];
    
    RNExpandingButtonBar *bar = [[RNExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
    [bar setHorizontal:YES];
    [bar setExplode:YES];
    [[self view] addSubview:bar];
    [self setBar:bar];
    
    [[self navigationController] setToolbarHidden:YES];
    [[self navigationController] setNavigationBarHidden:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:@"Testing Text"];
    
    return cell;
}

@end
