#import <UIKit/UIKit.h>

@class Route;

typedef double map_coordinate_t;
typedef NS_ENUM(uint8_t, TransportType)
{
    TransportTypeCar,
    TransportTypePedestrian
};

@interface View : NSObject

@property(nonatomic) NSArray *results;

@end

@interface Location : NSObject <NSCoding>

@property(nonatomic) map_coordinate_t latitude;
@property(nonatomic) map_coordinate_t longitude;
@property(nonatomic, copy) NSString *label;

@end

@interface Itinerary : NSObject <NSCoding>

@property(nonatomic) NSArray *locations;
@property(nonatomic) Route *route;
@property(nonatomic) UIImage *image;
@property(nonatomic) TransportType transportType;

@end

@interface Shape : NSObject <NSCoding>

@property(nonatomic) map_coordinate_t latitude;
@property(nonatomic) map_coordinate_t longitude;

- (void) __unused setCoordinatesTuple:(NSString *)tuple;

@end

@interface Routes : NSObject

@property(nonatomic) NSArray *routes;

@end

@interface Route : NSObject <NSCoding>

@property(nonatomic) NSArray *shapes;
@property(nonatomic) NSInteger distance;
@property(nonatomic) NSInteger travelTime;

@end