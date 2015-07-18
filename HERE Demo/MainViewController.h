#import <UIKit/UIKit.h>
#import "SearchResultViewController.h"

@interface MainViewController : UIViewController <UITableViewDataSource, LocationSelectionDelegate>

@property(nonatomic, weak) IBOutlet UILabel *summaryLabel;
@property(nonatomic, weak) IBOutlet UITableView *itineraryTableView;
@property(nonatomic, weak) IBOutlet UIView *summaryView;
@property(nonatomic, weak) IBOutlet UIButton *doneButton;
@property(nonatomic, weak) IBOutlet UITextField *searchField;
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UISwitch *transportTypeSwitch;

- (IBAction)enteredSearchField:(id)sender;

- (IBAction)leftSearchField:(id)sender;

- (IBAction)pressedDone:(id)sender;

- (IBAction)pressedEdit:(UIBarButtonItem *)button;

- (IBAction)pressedClear:(UIBarButtonItem *)button;

- (IBAction)changedTransportType:(UISwitch *)transportTypeSwitch;

@end
