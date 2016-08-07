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
  XCTAssert([sum compare:@(8)] == NSOrderedSame);
}

@end
