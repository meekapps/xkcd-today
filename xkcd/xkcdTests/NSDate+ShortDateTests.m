//
//  NSDate+ShortDateTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "NSDate+ShortDate.h"
#import <XCTest/XCTest.h>

@interface NSDate_ShortDateTests : XCTestCase

@end

@implementation NSDate_ShortDateTests

#pragma mark - Tests

- (void)testShortDate {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *shortDate = [date shortDateWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    XCTAssert([shortDate isEqualToString:@"1/1/70"]);
    
    XCTAssertNotNil([date shortDate]);
}
@end
