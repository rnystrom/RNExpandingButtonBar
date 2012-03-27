#import <UIKit/UIKit.h>
#import "RNExpandingButtonBar.h"
#import "SecondView.h"

@interface FirstView : UIViewController
<RNExpandingButtonBarDelegate>
{
    RNExpandingButtonBar *_bar;
}

@property (nonatomic, strong) RNExpandingButtonBar *bar;

- (void) onNext;
- (void) onAlert;
- (void) onModal;

@end
