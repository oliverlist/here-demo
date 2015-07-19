#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ItineraryEditor.h"

@interface ItineraryEditorTests : XCTestCase

@end

@implementation ItineraryEditorTests
{
    ItineraryEditor *_editor;
}

- (void)setUp {
    [super setUp];
    Itinerary *itinerary = [[Itinerary alloc] init];
    itinerary.locations = @[
            [self locationWithLabel:@"A"],
            [self locationWithLabel:@"B"],
            [self locationWithLabel:@"C"]
    ];
    _editor = [[ItineraryEditor alloc] initWithItinerary:itinerary];
}

- (void)tearDown {
    _editor = nil;
    [super tearDown];
}

- (void)testInitialState
{
    XCTAssert([_editor numberOfLocations] == 3, @"should contain 3 locations");
    XCTAssertEqual([_editor locationAtIndex:0].label, @"A", @"A should be at 1st position");
    XCTAssertEqual([_editor locationAtIndex:1].label, @"B", @"B should be at 2nd position");
    XCTAssertEqual([_editor locationAtIndex:2].label, @"C", @"C should be at 3rd position");
}

- (void)testAddLocation {
    [_editor addLocation:[self locationWithLabel:@"D"]];

    XCTAssert([_editor numberOfLocations] == 4, @"should contain 4 locations");
    XCTAssertEqual([_editor locationAtIndex:3].label, @"D", @"D should be at last position");
}

- (void)testRemoveLocation
{
    [_editor removeLocationAt:0];

    XCTAssert([_editor numberOfLocations] == 2, @"should contain 2 locations");
    XCTAssertEqual([_editor locationAtIndex:0].label, @"B", @"B should be at 1st position");
}

- (void)testChangeOrder_0_1
{
    [_editor moveLocationFrom:0 to:1];

    XCTAssertEqual([_editor locationAtIndex:0].label, @"B", @"B should be at 1st position");
    XCTAssertEqual([_editor locationAtIndex:1].label, @"A", @"A should be at 2nd position");
    XCTAssertEqual([_editor locationAtIndex:2].label, @"C", @"C should be at 3rd position");
}

- (void)testChangeOrder_0_2
{
    [_editor moveLocationFrom:0 to:2];

    XCTAssertEqual([_editor locationAtIndex:0].label, @"B", @"B should be at 1st position");
    XCTAssertEqual([_editor locationAtIndex:1].label, @"C", @"C should be at 2nd position");
    XCTAssertEqual([_editor locationAtIndex:2].label, @"A", @"A should be at 3rd position");

}

- (void)testChangeOrder_2_0
{
    [_editor moveLocationFrom:2 to:0];

    XCTAssertEqual([_editor locationAtIndex:0].label, @"C", @"C should be at 1st position");
    XCTAssertEqual([_editor locationAtIndex:1].label, @"A", @"A should be at 2nd position");
    XCTAssertEqual([_editor locationAtIndex:2].label, @"B", @"B should be at 3rd position");
}

- (void)testClear
{
    [_editor clear];

    XCTAssert([_editor numberOfLocations] == 0, @"should be empty");
}

#pragma mark - Helpers

- (Location *)locationWithLabel:(NSString *)label
{
    Location *loc = [[Location alloc] init];
    loc.label = label;
    return loc;
}

@end
