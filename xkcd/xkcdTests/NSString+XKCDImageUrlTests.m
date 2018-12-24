//
//  NSString+XKCDImageUrlTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "NSString+XKCDImageUrl.h"
#import <XCTest/XCTest.h>

@interface NSString_XKCDImageUrlTests : XCTestCase

@end

@implementation NSString_XKCDImageUrlTests

#pragma mark - Tests

- (void) testNoScheme {
    NSString *url = @"testurl";
    BOOL urlValid = [url isValidImageUrl];
    XCTAssertFalse(urlValid);
}

- (void) testNoImage {
    NSString *url = @"http://testurl";
    BOOL urlValid = [url isValidImageUrl];
    XCTAssertFalse(urlValid);
}

- (void) testNoExtension {
    NSString *url = @"http://testurl.com/image";
    BOOL urlValid = [url isValidImageUrl];
    XCTAssertFalse(urlValid);
}

- (void) testUnsupportedExtension {
    NSString *url = @"http://testurl.com/image.svg";
    BOOL urlValid = [url isValidImageUrl];
    XCTAssertFalse(urlValid);
}

- (void) testValidUrl {
    NSString *url = @"http://testurl.com/image.png";
    BOOL urlValid = [url isValidImageUrl];
    XCTAssertTrue(urlValid);
}

@end
