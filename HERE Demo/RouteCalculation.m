#import <RestKit/RestKit.h>
#import "RouteCalculation.h"
#import "Types.h"
#import "Credentials.h"

@implementation RouteCalculation

+ (void)calculateRouteFor:(Itinerary *)itinerary
                     done:(RouteCalculationCallback)callback
{
    RKObjectMapping *shapeMapping = [RKObjectMapping mappingForClass:[Shape class]];
    [shapeMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"coordinatesTuple"]];

    RKObjectMapping *routeMapping = [RKObjectMapping mappingForClass:[Route class]];
    [routeMapping addAttributeMappingsFromDictionary:@{
            @"summary.distance" : @"distance",
            @"summary.travelTime" : @"travelTime"
    }];
    [routeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"shape" toKeyPath:@"shapes" withMapping:shapeMapping]];

    RKObjectMapping *routesMapping = [RKObjectMapping mappingForClass:[Routes class]];
    [routesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"route" toKeyPath:@"routes" withMapping:routeMapping]];

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:routesMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/routing/7.2/calculateroute.json"
                                                                                           keyPath:@"response"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    NSURLComponents *components = [[NSURLComponents alloc] init];
    [components setScheme:@"http"];
    [components setHost:@"route.cit.api.here.com"];
    [components setPath:@"/routing/7.2/calculateroute.json"];
    NSMutableArray *queryItems = [[NSMutableArray alloc] init];
    [itinerary.locations enumerateObjectsUsingBlock:^(Location *location, NSUInteger idx, BOOL *stop) {
        NSString *key = [NSString stringWithFormat:@"waypoint%lu", (unsigned long) idx];
        NSURLQueryItem *waypoint = [NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"geo!%.2f,%.2f", location.latitude, location.longitude]];
        [queryItems addObject:waypoint];
    }];
    NSString *modeString;
    switch (itinerary.transportType)
    {
        case TransportTypeCar:
            modeString = @"fastest;car;traffic:disabled";
            break;

        case TransportTypePedestrian:
            modeString = @"shortest;pedestrian";
            break;
    }
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"mode" value:modeString]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"resolution" value:@"50"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"representation" value:@"display"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"routeAttributes" value:@"summary,shape"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"app_id" value:APP_ID]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"app_code" value:APP_CODE]];
    [components setQueryItems:queryItems];


    NSURLRequest *request = [NSURLRequest requestWithURL:[components URL]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *op, RKMappingResult *result) {
        if ([op isCancelled])
        {
            return;
        }

        Routes *routes = [result firstObject];
        callback([routes.routes firstObject], itinerary);

    }                                failure:^(RKObjectRequestOperation *op, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    [operation start];
}

@end
