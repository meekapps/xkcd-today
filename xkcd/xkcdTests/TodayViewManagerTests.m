//
//  TodayViewManagerTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "TodayViewManager.h"
#import <XCTest/XCTest.h>

@interface TodayViewManagerTests : XCTestCase
@property (nonatomic, strong) TodayViewManager *todayViewManager;
@end

@implementation TodayViewManagerTests

#pragma mark - Lifecycle

- (void)setUp {
    [super setUp];
    
    self.todayViewManager = [[TodayViewManager alloc] init];
}

- (void)tearDown {
    self.todayViewManager = nil;

    [super tearDown];
}

#pragma mark - Tests

- (void)testInvalid {
    XCTAssertNotNil(self.todayViewManager);
    XCTAssertNil([self.todayViewManager indexWithLaunchObject:@"not a url"]);
    XCTAssertNil([self.todayViewManager indexWithLaunchObject:nil]);
}

- (void)testValid {
    XCTAssertNotNil(self.todayViewManager);
    XCTAssertEqualObjects([self.todayViewManager indexWithLaunchObject:[NSURL URLWithString:@"xkcd-today://1234"]], @(1234));
}

@end
