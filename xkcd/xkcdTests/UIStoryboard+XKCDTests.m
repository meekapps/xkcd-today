//
//  UIStoryboard+XKCDTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "UIStoryboard+XKCD.h"
#import <XCTest/XCTest.h>

@interface UIStoryboard_XKCDTests : XCTestCase

@end

@implementation UIStoryboard_XKCDTests

#pragma mark - Tests

- (void)testExplained {
    UINavigationController *explainedNavigationController = [UIStoryboard explainedRootNavigationController];
    XCTAssertNotNil(explainedNavigationController);
}

- (void)testFavorites {
    UINavigationController *favoritesNavigationController = [UIStoryboard favoritesRootNavigationController];
    XCTAssertNotNil(favoritesNavigationController);
}

@end
