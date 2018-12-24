//
//  UIColor+XKCDTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "UIColor+XKCD.h"
#import <XCTest/XCTest.h>

@interface UIColor_XKCDTests : XCTestCase

@end

@implementation UIColor_XKCDTests

#pragma mark - Tests

- (void) testThemeColor {
    UIColor *themeColor = [UIColor themeColor];
    XCTAssertNotNil(themeColor);
    
    CGFloat red = 0.0F;
    CGFloat green = 0.0F;
    CGFloat blue = 0.0F;
    CGFloat alpha = 0.0F;
    [themeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    XCTAssert(red == 151.0F/255.0F);
    XCTAssert(green == 169.0F/255.0F);
    XCTAssert(blue == 199.0F/255.0F);
    XCTAssert(alpha == 1.0F);
}

@end
