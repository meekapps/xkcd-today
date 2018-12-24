//
//  LaunchManagerTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "LaunchManager.h"
#import <XCTest/XCTest.h>

@interface LaunchManagerTests : XCTestCase
@property (nonatomic, strong) LaunchManager *launchManager;
@end

@implementation LaunchManagerTests

#pragma mark - Lifecycle

- (void)setUp {
    [super setUp];
    
    self.launchManager = [[LaunchManager alloc] init];
}

- (void)tearDown {
    self.launchManager = nil;
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testLaunchManager {
    XCTAssertFalse([self.launchManager handleLaunchObject:nil]);
    XCTAssertFalse([self.launchManager handleLaunchOptions:nil]);
}

@end
