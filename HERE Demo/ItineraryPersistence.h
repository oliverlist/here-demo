#import <Foundation/Foundation.h>

@class Itinerary;


@interface ItineraryPersistence : NSObject

+ (Itinerary *)load:(NSString *)fileName error:(NSError *__autoreleasing *)error;

+ (BOOL)saveItinerary:(Itinerary *)itinerary fileName:(NSString *)fileName error:(NSError *__autoreleasing *)error;

@end
