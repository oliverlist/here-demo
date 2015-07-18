#import <UIKit/UIKit.h>

@class Itinerary;

@interface MapViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIImageView *mapView;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(nonatomic) Itinerary *itinerary;

- (IBAction)close:(id)sender;

@end
