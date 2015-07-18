#import "MapViewController.h"
#import "Types.h"
#import "ItineraryDisplay.h"

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateMapImage];
}

#pragma mark - IBActions

- (IBAction)close:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)updateMapImage
{
    if (!self.itinerary.route)
    {
        return;
    }
    if (!self.itinerary.image)
    {
        __weak __typeof(self) weakSelf = self;
        [ItineraryDisplay requestDisplayFor:self.itinerary done:^(UIImage *image, Itinerary *it) {
            if (!weakSelf)
            {
                return;
            }
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            it.image = image;
            [strongSelf displayMapImage:image];
        }];
    }
    else
    {
        [self displayMapImage:self.itinerary.image];
    }
}

- (void)displayMapImage:(UIImage *)image
{
    self.mapView.image = image;
    self.mapView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.mapView.alpha = 1;
        [self.loadingIndicator stopAnimating];
    }];
}

@end
