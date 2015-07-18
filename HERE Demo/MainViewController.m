#import "MainViewController.h"
#import "ItineraryEditor.h"
#import "ItineraryPersistence.h"
#import "Types.h"
#import "RouteCalculation.h"
#import "MapViewController.h"

@interface MainViewController ()

@property(nonatomic) ItineraryEditor *editor;

@end

@implementation MainViewController

static NSString *kItinerayFileName = @"itinerary";

- (void)viewDidLoad
{
    [super viewDidLoad];

    Itinerary *itinerary = [ItineraryPersistence load:kItinerayFileName error:NULL];
    self.editor = [[ItineraryEditor alloc] initWithItinerary:itinerary ?: [[Itinerary alloc] init]];
    self.doneButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.transportTypeSwitch setOn:self.editor.transportType == TransportTypeCar];
    [self updateSummary];
    [self updateRoute];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MapViewController class]])
    {
        MapViewController *mapViewController = (MapViewController *) segue.destinationViewController;
        mapViewController.itinerary = self.editor.itinerary;
    }
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - IBActions

- (IBAction)enteredSearchField:(id)sender
{
    [self showSearchResultViewController];
}

- (IBAction)leftSearchField:(id)sender
{
    [self dismissSearchView];
}

- (IBAction)pressedDone:(id)sender
{
    [self.searchField resignFirstResponder];
}

- (IBAction)pressedEdit:(UIBarButtonItem *)button
{
    BOOL wasEditing = self.itineraryTableView.editing;
    [self.itineraryTableView setEditing:!wasEditing animated:YES];
    button.title = wasEditing ? @"Edit" : @"Done";
}

- (IBAction)pressedClear:(UIBarButtonItem *)button
{
    [self.editor clear];
    [self updateSummary];
    [self updateRoute];
    [self.itineraryTableView reloadData];
}

- (IBAction)changedTransportType:(UISwitch *)transportTypeSwitch
{
    self.editor.transportType = [transportTypeSwitch isOn] ? TransportTypeCar : TransportTypePedestrian;
    [self updateSummary];
    [self updateRoute];
    [ItineraryPersistence saveItinerary:self.editor.itinerary fileName:kItinerayFileName error:NULL];
}

- (void)didSelectLocation:(Location *)location
{
    [self.searchField resignFirstResponder];
    [self.editor addLocation:location];
    [self updateSummary];
    [self updateRoute];
    [self.itineraryTableView reloadData];
    [ItineraryPersistence saveItinerary:self.editor.itinerary fileName:kItinerayFileName error:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.editor numberOfLocations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *location = [self.editor locationAtIndex:(NSUInteger) indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    cell.textLabel.text = location.label;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.editor removeLocationAt:(NSUInteger) indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.editor numberOfLocations] == 0)
        {
            [tableView setEditing:NO animated:NO];
        }
    }
    [self updateSummary];
    [self updateRoute];
    [ItineraryPersistence saveItinerary:self.editor.itinerary fileName:kItinerayFileName error:NULL];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.editor moveLocationFrom:(NSUInteger) fromIndexPath.row to:(NSUInteger) toIndexPath.row];
    [tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    [self updateSummary];
    [self updateRoute];
    [ItineraryPersistence saveItinerary:self.editor.itinerary fileName:kItinerayFileName error:NULL];
}

#pragma mark - Private

- (void)updateSummary
{
    if ([self.editor numberOfLocations] < 2)
    {
        NSString *transportTypeString = self.editor.transportType == TransportTypeCar ? @"You go by car." : @"You walk.";
        self.summaryLabel.text = [NSString stringWithFormat:@"Add waypoints to your itinerary by searching for locations. %@", transportTypeString];
    }
    else
    {
        if (self.editor.itinerary.route)
        {
            NSString *transportTypeString = self.editor.transportType == TransportTypeCar ? @"travel time by car" : @"walking time";
            self.summaryLabel.text = [NSString stringWithFormat:@"Your route contains %lu locations. Total distance: %@, %@: %@",
                                                                (unsigned long) [self.editor numberOfLocations],
                                                                [self formatDistance:self.editor.itinerary.route.distance],
                                                                transportTypeString,
                                                                [self formatTime:self.editor.itinerary.route.travelTime]
            ];
        }
        else
        {
            NSString *transportTypeString = self.editor.transportType == TransportTypeCar ? @"for pedestrians" : @"for cars";
            self.summaryLabel.text = [NSString stringWithFormat:@"Your route contains %lu locations. Calculating the route %@ ...",
                                                                (unsigned long) [self.editor numberOfLocations],
                                                                transportTypeString
            ];
        }
    }
}

- (void)showSearchResultViewController
{
    CGRect frame = self.itineraryTableView.frame;
    frame.size.height += self.summaryView.bounds.size.height;
    frame.size.height += self.toolbar.bounds.size.height;
    frame.origin.y -= self.summaryView.bounds.size.height;

    SearchResultViewController *searchResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResults"];
    searchResultViewController.view.frame = frame;
    [self.view addSubview:searchResultViewController.view];
    searchResultViewController.view.alpha = 0;
    self.doneButton.alpha = 0;
    self.doneButton.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        searchResultViewController.view.alpha = 1;
        self.doneButton.alpha = 1;
    }];

    [self.searchField addTarget:searchResultViewController action:@selector(searchFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    searchResultViewController.delegate = self;
    [self addChildViewController:searchResultViewController];
}

- (void)dismissSearchView
{
    SearchResultViewController *searchResultViewController = [self.childViewControllers firstObject];
    if (!searchResultViewController)
    {
        return;
    }
    [searchResultViewController removeFromParentViewController];
    [UIView animateWithDuration:0.3 animations:^{
        searchResultViewController.view.alpha = 0;
        self.doneButton.alpha = 0;
    }                completion:^(BOOL finished) {
        [searchResultViewController.view removeFromSuperview];
        [self.searchField removeTarget:searchResultViewController action:@selector(searchFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        self.doneButton.hidden = YES;
    }];
}

- (NSString *)formatTime:(NSInteger)seconds
{
    NSNumberFormatter *numberFormatter;
    numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfEven;
    if (seconds < 3600)
    {
        numberFormatter.maximumFractionDigits = 0;
        NSString *minutesString = [numberFormatter stringFromNumber:@(seconds / 60.0)];
        return [NSString stringWithFormat:@"%@ min", minutesString];
    }
    numberFormatter.maximumFractionDigits = 1;
    NSString *hoursString = [numberFormatter stringFromNumber:@(seconds / 3600.0)];
    return [NSString stringWithFormat:@"%@ h", hoursString];
}

- (NSString *)formatDistance:(NSInteger)meters
{
    NSNumberFormatter *numberFormatter;
    numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfEven;
    if (meters < 1000)
    {
        numberFormatter.maximumFractionDigits = 0;
        NSString *metersString = [numberFormatter stringFromNumber:@(meters)];
        return [NSString stringWithFormat:@"%@ m", metersString];
    }
    numberFormatter.maximumFractionDigits = 1;
    NSString *kmString = [numberFormatter stringFromNumber:@(meters / 1000.0)];
    return [NSString stringWithFormat:@"%@ km", kmString];
}

- (void)updateRoute
{
    Itinerary *itinerary = self.editor.itinerary;
    if (!itinerary)
    {
        return;
    }
    if ([self.editor numberOfLocations] < 2)
    {
        return;
    }
    if (!itinerary.route)
    {
        __weak __typeof(self) weakSelf = self;
        [RouteCalculation calculateRouteFor:itinerary done:^(Route *route, Itinerary *it) {
            if (!weakSelf)
            {
                return;
            }
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (it == strongSelf.editor.itinerary)
            {
                it.route = route;
                [strongSelf updateSummary];
                [ItineraryPersistence saveItinerary:it fileName:kItinerayFileName error:NULL];
            }
        }];
    }
}

@end
