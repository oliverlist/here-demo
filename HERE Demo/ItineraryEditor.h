#import <Foundation/Foundation.h>
#import "Types.h"

@class Location;
@class Itinerary;

@interface ItineraryEditor : NSObject

@property(nonatomic) Itinerary *itinerary;
@property(nonatomic) TransportType transportType;

- (instancetype)initWithItinerary:(Itinerary *)itinerary;

- (void)addLocation:(Location *)location;

- (void)removeLocationAt:(NSUInteger)index;

- (void)moveLocationFrom:(NSUInteger)from to:(NSUInteger)to;

- (void)clear;

- (NSUInteger)numberOfLocations;

- (Location *)locationAtIndex:(NSUInteger)index;

@end
