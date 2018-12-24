//
//  UIImage+XKCDTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "UIImage+XKCD.h"
#import <XCTest/XCTest.h>

@interface UIImage_XKCDTests : XCTestCase

@end

@implementation UIImage_XKCDTests

#pragma mark - Tests

- (void)testHeartFilledLandscape {
    UIImage *filledLandscapeImage = [UIImage heartImageFilled:YES
                                                    landscape:YES];
    XCTAssertNotNil(filledLandscapeImage);
}

- (void)testHeartFilledPortrait {
    UIImage *filledPortraitImage = [UIImage heartImageFilled:YES
                                                   landscape:NO];
    XCTAssertNotNil(filledPortraitImage);
}

- (void)testHeartUnfilledLandscape {
    UIImage *unfilledLandscapeImage = [UIImage heartImageFilled:NO
                                                      landscape:YES];
    XCTAssertNotNil(unfilledLandscapeImage);
}

- (void)testHeartUnfilledPortrait {
    UIImage *unfilledPortraitImage = [UIImage heartImageFilled:NO
                                                     landscape:NO];
    XCTAssertNotNil(unfilledPortraitImage);
}

@end
