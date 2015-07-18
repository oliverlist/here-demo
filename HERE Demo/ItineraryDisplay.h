#import <UIKit/UIKit.h>

@class Itinerary;

typedef void (^ItineraryDisplayCallback)(UIImage *, Itinerary *);

@interface ItineraryDisplay : NSObject

+ (void)requestDisplayFor:(Itinerary *)itinerary
                     done:(ItineraryDisplayCallback)callback;

@end
