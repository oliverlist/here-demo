#import "Types.h"

@implementation View
@end


@implementation Location

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self)
    {
        self.latitude = [coder decodeDoubleForKey:@"latitude"];
        self.longitude = [coder decodeDoubleForKey:@"longitude"];
        self.label = [coder decodeObjectForKey:@"label"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeDouble:self.latitude forKey:@"latitude"];
    [coder encodeDouble:self.longitude forKey:@"longitude"];
    [coder encodeObject:self.label forKey:@"label"];
}

@end

@implementation Itinerary

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self)
    {
        self.locations = [coder decodeObjectForKey:@"locations"];
        self.route = [coder decodeObjectForKey:@"route"];
        self.transportType = (TransportType) [coder decodeIntegerForKey:@"transportType"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.locations forKey:@"locations"];
    [coder encodeObject:self.route forKey:@"route"];
    [coder encodeInteger:self.transportType forKey:@"transportType"];
}

- (void)setTransportType:(TransportType)transportType
{
    _transportType = transportType;
}


@end

@implementation Routes
@end

@implementation Route

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self)
    {
        self.shapes = [coder decodeObjectForKey:@"shapes"];
        self.distance = [coder decodeIntegerForKey:@"distance"];
        self.travelTime = [coder decodeIntegerForKey:@"travelTime"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.shapes forKey:@"shapes"];
    [coder encodeInteger:self.distance forKey:@"distance"];
    [coder encodeInteger:self.travelTime forKey:@"travelTime"];
}

@end

@implementation Shape

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self)
    {
        self.latitude = [coder decodeDoubleForKey:@"latitude"];
        self.longitude = [coder decodeDoubleForKey:@"longitude"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeDouble:self.latitude forKey:@"latitude"];
    [coder encodeDouble:self.longitude forKey:@"longitude"];
}

- (void)__unused setCoordinatesTuple:(NSString *)coordinatesTuple
{
    NSArray *coordinates = [coordinatesTuple componentsSeparatedByString:@","];
    if ([coordinates count] == 2)
    {
        self.latitude = [((NSString *) coordinates[0]) doubleValue];
        self.longitude = [((NSString *) coordinates[1]) doubleValue];
    }
}

@end
