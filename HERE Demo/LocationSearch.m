#import "LocationSearch.h"
#import "Types.h"
#import "Credentials.h"
#import <RestKit/RestKit.h>

@implementation LocationSearch

+ (void)searchFor:(NSString *)searchTerm done:(LocationSearchCallback)callback
{
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromDictionary:@{
            @"Location.DisplayPosition.Latitude" : @"latitude",
            @"Location.DisplayPosition.Longitude" : @"longitude",
            @"Location.Address.Label" : @"label"
    }];
    RKObjectMapping *viewMapping = [RKObjectMapping mappingForClass:[View class]];
    [viewMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Result" toKeyPath:@"results" withMapping:locationMapping]];

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:viewMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/6.2/geocode.json"
                                                                                           keyPath:@"Response.View"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    NSURLComponents *components = [[NSURLComponents alloc] init];
    [components setScheme:@"http"];
    [components setHost:@"geocoder.cit.api.here.com"];
    [components setPath:@"/6.2/geocode.json"];
    [components setQueryItems:@[
            [NSURLQueryItem queryItemWithName:@"searchText" value:searchTerm],
            [NSURLQueryItem queryItemWithName:@"app_id" value:APP_ID],
            [NSURLQueryItem queryItemWithName:@"app_code" value:APP_CODE],
    ]];


    NSURLRequest *request = [NSURLRequest requestWithURL:[components URL]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *op, RKMappingResult *result) {
        if ([op isCancelled])
        {
            return;
        }
        callback(((View *) [result firstObject]).results, searchTerm);
    }                                failure:^(RKObjectRequestOperation *op, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    [operation start];
}

@end
