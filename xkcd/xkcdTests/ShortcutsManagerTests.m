//
//  ShortcutsManagerTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "ShortcutsManager.h"
#import "XKCD.h"
#import <XCTest/XCTest.h>

@interface ShortcutsManagerTests : XCTestCase
@property (nonatomic, strong) ShortcutsManager *shortcutsManager;
@end

@implementation ShortcutsManagerTests

#pragma mark - Lifecycle

- (void)setUp {
    [super setUp];
    
    self.shortcutsManager = [[ShortcutsManager alloc] init];
}

- (void)tearDown {
    self.shortcutsManager = nil;
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testInitializer {
    XCTAssertNotNil(self.shortcutsManager);
    
    XCTAssertNil([self.shortcutsManager indexWithLaunchObject:@"not a UIApplicationShortcutItem"]);
    XCTAssertNil([self.shortcutsManager indexWithLaunchObject:nil]);
}

- (void)testUnsupported {
    UIApplicationShortcutItem *unsupportedShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"unsupported" localizedTitle:@"unsupported"];
    XCTAssertNil([self.shortcutsManager indexWithLaunchObject:unsupportedShortcutItem]);
}

- (void)testLatest {
    UIApplicationShortcutItem *latestShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"latest" localizedTitle:@"latest"];
    XCTAssertNil([self.shortcutsManager indexWithLaunchObject:latestShortcutItem]);
}

- (void)testRandom {
    UIApplicationShortcutItem *randomShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"random" localizedTitle:@"random"];
    if (XKCD.sharedInstance.latestComicIndex) {
        XCTAssertNotNil([self.shortcutsManager indexWithLaunchObject:randomShortcutItem]);
    } else {
        XCTAssertNil([self.shortcutsManager indexWithLaunchObject:randomShortcutItem]);
    }
}

- (void)testLaunchOptions {
    XCTAssertNil([self.shortcutsManager launchObjectFromLaunchOptions:nil]);
    XCTAssertNil([self.shortcutsManager launchObjectFromLaunchOptions:@{}]);
    XCTAssertNotNil([self.shortcutsManager launchObjectFromLaunchOptions:@{UIApplicationLaunchOptionsShortcutItemKey:@{}}]);
}

@end
