#import "ItineraryDisplay.h"
#import "Types.h"
#import "Credentials.h"
#import <AFNetworking/AFNetworking.h>

@implementation ItineraryDisplay

+ (void)requestDisplayFor:(Itinerary *)itinerary
                     done:(ItineraryDisplayCallback)callback
{
    if (!itinerary.route)
    {
        return;
    }
    NSURLComponents *components = [[NSURLComponents alloc] init];
    [components setScheme:@"http"];
    [components setHost:@"image.maps.cit.api.here.com"];
    [components setPath:@"/mia/1.6/route"];
    NSMutableArray *queryItems = [[NSMutableArray alloc] init];
    NSMutableArray *waypointStrings = [[NSMutableArray alloc] init];
    [itinerary.route.shapes enumerateObjectsUsingBlock:^(Shape *shape, NSUInteger idx, BOOL *stop) {
        [waypointStrings addObject:[NSString stringWithFormat:@"%.5f,%.5f", shape.latitude, shape.longitude]];
    }];
    NSMutableArray *markerStrings = [[NSMutableArray alloc] init];
    [itinerary.locations enumerateObjectsUsingBlock:^(Location *location, NSUInteger idx, BOOL *stop) {
        [markerStrings addObject:[NSString stringWithFormat:@"%.5f,%.5f", location.latitude, location.longitude]];
    }];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"ppi" value:@"250"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"w" value:@"640"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"h" value:@"640"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"r" value:[waypointStrings componentsJoinedByString:@","]]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"m" value:[markerStrings componentsJoinedByString:@","]]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"f" value:@"0"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"app_id" value:APP_ID]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"app_code" value:APP_CODE]];
    [components setQueryItems:queryItems];
    NSURLRequest *request = [NSURLRequest requestWithURL:[components URL]];

    AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject, itinerary);
    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

@end