#import <UIKit/UIKit.h>

@class ItineraryEditor;
@class Location;

@protocol LocationSelectionDelegate

- (void)didSelectLocation:(Location *)location;

@end

@interface SearchResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *resultsTable;
@property(nonatomic, weak) id <LocationSelectionDelegate> delegate;

- (IBAction)searchFieldChanged:(id)sender;

@end
