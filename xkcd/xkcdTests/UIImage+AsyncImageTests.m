//
//  UIImage+AsyncImageTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "UIImage+AsyncImage.h"
#import <XCTest/XCTest.h>

static NSTimeInterval const kDefaultAsyncTestTimeout = 10;

@interface UIImage_AsyncImageTests : XCTestCase

@end

@implementation UIImage_AsyncImageTests

#pragma mark - Tests

- (void)testImageFromNilUrl {
    XCTestExpectation *emptyExpectation = [[XCTestExpectation alloc] initWithDescription:@"image should be nil"];
    [UIImage imageFromUrl:nil completion:^(UIImage *image) {
        XCTAssertNil(image);
        [emptyExpectation fulfill];
    }];
    
    [self waitForExpectations:@[emptyExpectation] timeout:kDefaultAsyncTestTimeout];
}

@end
