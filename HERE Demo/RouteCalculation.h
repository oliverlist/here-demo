#import <Foundation/Foundation.h>

@class Itinerary;
@class Route;

typedef void(^RouteCalculationCallback)(Route *, Itinerary *);

@interface RouteCalculation : NSObject

+ (void)calculateRouteFor:(Itinerary *)itinerary
                     done:(RouteCalculationCallback)callback;

@end
