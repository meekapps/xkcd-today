//
//  xkcdTests.m
//  xkcdTests
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "NSDate+ShortDate.h"
#import "NSError+Message.h"
#import "NSNumber+Operations.h"
#import <XCTest/XCTest.h>

@interface xkcdTests : XCTestCase

@end

@implementation xkcdTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

#pragma mark - NSDate+ShortDate

- (void)testShortDate {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
  NSString *shortDate = [date shortDate];
  XCTAssert([shortDate isEqualToString:@"12/31/69"]);
}

#pragma mark - NSError+Message
- (void) testErrorMessage {
  NSError *error = [NSError errorWithDomain:@"domain"
                                       code:42
                                    message:@"message"];
  
  XCTAssert([error.domain isEqualToString:@"domain"]);
  XCTAssert(error.code == 42);
  XCTAssert([error.userInfo[@"error"] isEqualToString:@"message"]);
}

#pragma mark - NSNumber+Operations
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
