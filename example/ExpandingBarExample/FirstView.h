#import <UIKit/UIKit.h>
#import "ExpandingButtonBar.h"
#import "SecondView.h"

@interface FirstView : UIViewController
<ExpandingButtonBarDelegate>
{
    ExpandingButtonBar *_bar;
}

@property (nonatomic, strong) ExpandingButtonBar *bar;

- (void) onNext;
- (void) onAlert;
- (void) onModal;

@end
