#import "ItineraryEditor.h"

@interface ItineraryEditor ()

@end

@implementation ItineraryEditor

- (instancetype)initWithItinerary:(Itinerary *)itinerary
{
    self = [super init];
    if (self)
    {
        [self setItinerary:itinerary];
    }

    return self;
}

- (instancetype)init
{
    return [self initWithItinerary:nil];
}

- (void)setItinerary:(Itinerary *)itinerary
{
    NSAssert(itinerary, @"itinerary must not be nil");
    _itinerary = itinerary;
    _transportType = _itinerary.transportType;
}

- (void)addLocation:(Location *)location
{
    NSArray *source = self.itinerary.locations ?: @[];
    NSArray *locations = [source arrayByAddingObject:location];
    self.itinerary.locations = locations;
    self.itinerary.route = nil;
    self.itinerary.image = nil;
}

- (void)removeLocationAt:(NSUInteger)index
{
    NSAssert([self numberOfLocations] > index, @"index out of bounds [0..%lu]", (unsigned long) [self numberOfLocations]);
    NSMutableArray *locations = [self.itinerary.locations mutableCopy];
    [locations removeObjectAtIndex:index];
    self.itinerary.locations = [locations copy];
    self.itinerary.route = nil;
    self.itinerary.image = nil;
}

- (void)moveLocationFrom:(NSUInteger)from to:(NSUInteger)to
{
    if (from == to)
    {
        return;
    }
    NSAssert([self numberOfLocations] > from, @"from index out of bounds [0..%lu]", (unsigned long) [self numberOfLocations]);
    NSAssert([self numberOfLocations] > to, @"to index out of bounds [0..%lu]", (unsigned long) [self numberOfLocations]);
    NSMutableArray *locations = [self.itinerary.locations mutableCopy];
    Itinerary *toBeMoved = locations[from];
    [locations removeObjectAtIndex:from];
    [locations insertObject:toBeMoved atIndex:to];
    self.itinerary.locations = [locations copy];
    self.itinerary.route = nil;
    self.itinerary.image = nil;
}

- (void)clear
{
    self.itinerary.locations = @[];
    self.itinerary.route = nil;
    self.itinerary.image = nil;
};

- (NSUInteger)numberOfLocations
{
    return [self.itinerary.locations count];
}

- (Location *)locationAtIndex:(NSUInteger)index
{
    NSAssert([self numberOfLocations] > index, @"index out of bounds [0..%lu]", (unsigned long) [self numberOfLocations]);
    return self.itinerary.locations[index];
}

- (void)setTransportType:(TransportType)transportType
{
    _transportType = transportType;
    if (self.itinerary.transportType != transportType)
    {
        self.itinerary.transportType = _transportType;
        self.itinerary.route = nil;
        self.itinerary.image = nil;
    }
}


@end