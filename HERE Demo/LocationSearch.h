#import <Foundation/Foundation.h>

@class Location;

typedef void (^LocationSearchCallback)(NSArray *, NSString *);

@interface LocationSearch : NSObject

+ (void)searchFor:(NSString *)searchTerm
             done:(LocationSearchCallback)callback;

@end