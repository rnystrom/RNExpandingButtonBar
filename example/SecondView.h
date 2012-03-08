#import <UIKit/UIKit.h>
#import "ExpandingButtonBar.h"

@interface SecondView : UITableViewController
{
    ExpandingButtonBar *_bar;
    UITableView *_tableView; // Let's us have our own custom fixed view overtop
}

@property (nonatomic, strong) ExpandingButtonBar *bar;

@end
