#import <UIKit/UIKit.h>
#import "RNExpandingButtonBar.h"

@interface SecondView : UITableViewController
{
    RNExpandingButtonBar *_bar;
    UITableView *_tableView; // Let's us have our own custom fixed view overtop
}

@property (nonatomic, strong) RNExpandingButtonBar *bar;

@end
