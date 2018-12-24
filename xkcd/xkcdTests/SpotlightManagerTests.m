//
//  SpotlightManagerTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "SpotlightManager.h"
#import <XCTest/XCTest.h>

@import CoreSpotlight;

@interface SpotlightManagerTests : XCTestCase
@property (nonatomic, strong) SpotlightManager *spotlightManager;
@end

@implementation SpotlightManagerTests

#pragma mark - Lifecycle

- (void)setUp {
    [super setUp];
    
    self.spotlightManager = [[SpotlightManager alloc] init];
}

- (void)tearDown {
    self.spotlightManager = nil;
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testInitializer {
    SpotlightManager *spotlightManager = [SpotlightManager sharedManager];
    XCTAssertNotNil(spotlightManager);
    
    XCTAssertNil([spotlightManager indexWithLaunchObject:@"not an NSUserActivity"]);
    XCTAssertNil([spotlightManager indexWithLaunchObject:nil]);
}

- (void)testUnsupported {
    NSUserActivity *unsupportedActivity = [[NSUserActivity alloc] initWithActivityType:@"unsupported"];
    XCTAssertNil([self.spotlightManager indexWithLaunchObject:unsupportedActivity]);
}

- (void)testSearchable {
    NSUserActivity *searchableActivity = [[NSUserActivity alloc] initWithActivityType:CSSearchableItemActionType];
    searchableActivity.userInfo = @{CSSearchableItemActivityIdentifier:@1234};
    XCTAssertEqualObjects([self.spotlightManager indexWithLaunchObject:searchableActivity], @1234);

    XCTAssertNil([self.spotlightManager launchObjectFromLaunchOptions:nil]);
    XCTAssertNil([self.spotlightManager launchObjectFromLaunchOptions:@{}]);
    XCTAssertNotNil([self.spotlightManager launchObjectFromLaunchOptions:@{UIApplicationLaunchOptionsUserActivityDictionaryKey:@{@"activity": searchableActivity}}]);
}

@end
