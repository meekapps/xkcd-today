//
//  NSError+MessageTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "NSError+Message.h"
#import <XCTest/XCTest.h>

@interface NSError_MessageTests : XCTestCase

@end

@implementation NSError_MessageTests

#pragma mark - Tests

- (void) testErrorMessage {
    NSError *error = [NSError errorWithDomain:@"domain"
                                         code:42
                                      message:@"message"];
    
    XCTAssert([error.domain isEqualToString:@"domain"]);
    XCTAssert(error.code == 42);
    XCTAssert([error.userInfo[@"error"] isEqualToString:@"message"]);
}

@end
