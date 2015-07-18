#import "ItineraryPersistence.h"
#import "Types.h"

@implementation ItineraryPersistence

+ (Itinerary *)load:(NSString *)fileName error:(NSError *__autoreleasing *)error
{
    NSURL *documentsPath = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    documentsPath = [documentsPath URLByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsPath path]])
    {
        Itinerary *itinerary = [NSKeyedUnarchiver unarchiveObjectWithFile:[documentsPath path]];
        return itinerary;
    }

    // TODO populate error
    return nil;
}

+ (BOOL)saveItinerary:(Itinerary *)itinerary fileName:(NSString *)fileName error:(NSError *__autoreleasing *)error
{
    NSURL *documentsPath = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    documentsPath = [documentsPath URLByAppendingPathComponent:fileName];

    if ([NSKeyedArchiver archiveRootObject:itinerary toFile:[documentsPath path]])
    {
        return YES;
    }
    // TODO populate error
    return NO;
}

@end
