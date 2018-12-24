//
//  NSNumber+OperationsTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "NSNumber+Operations.h"
#import <XCTest/XCTest.h>

@interface NSNumber_OperationsTests : XCTestCase

@end

@implementation NSNumber_OperationsTests

#pragma mark - Tests

- (void) testAdd {
    NSNumber *sum = [@(5) add:3];
    XCTAssert([sum equals:@(8)]);
}

- (void) testEquals {
    NSNumber *five = @(5);
    NSNumber *anotherFive = @(5);
    NSNumber *six = @(6);
    XCTAssertTrue([five equals:anotherFive]);
    XCTAssertFalse([five equals:six]);
}

- (void) testGreaterThan {
    NSNumber *ten = @(10);
    NSNumber *five = @(5);
    XCTAssertTrue([ten greaterThan:five]);
    XCTAssertFalse([five greaterThan:ten]);
}

- (void) testLessThan {
    NSNumber *ten = @(10);
    NSNumber *five = @(5);
    XCTAssertTrue([five lessThan:ten]);
    XCTAssertFalse([ten lessThan:five]);
}

- (void) testSubtract {
    NSNumber *difference = [@(10) subtract:5];
    XCTAssert([difference equals:@(5)]);
}

- (void) testRandom {
    NSNumber *min = @(10);
    NSNumber *max = @(100);
    for (int i = 0; i < 10000; i++) {
        NSNumber *random = [NSNumber randomWithMinimum:min maximum:max];
        XCTAssert([random lessThan:[max add:1]]);
        XCTAssert([random greaterThan:[min subtract:1]]);
    }
}

@end
