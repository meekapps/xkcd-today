//
//  UIApplication+SessionsTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "NSUserDefaultsTestCase.h"
#import "UIApplication+Sessions.h"
#import <XCTest/XCTest.h>


@interface UIApplication_SessionsTests : NSUserDefaultsTestCase
@end

@implementation UIApplication_SessionsTests

#pragma mark - Tests

- (void)testStartingNumberOfSessions {
    NSInteger numberOfSessions = [UIApplication numberOfLoggedSessionsWithUserDefaults:self.userDefaults];
    XCTAssertEqual(0, numberOfSessions);
    
    [UIApplication logSessionWithUserDefaults:self.userDefaults];
}
- (void)testNumberOfSessions {
    [UIApplication logSessionWithUserDefaults:self.userDefaults];
    [UIApplication logSessionWithUserDefaults:self.userDefaults];
    
    NSInteger numberOfSessions = [UIApplication numberOfLoggedSessionsWithUserDefaults:self.userDefaults];
    XCTAssertEqual(2, numberOfSessions);
}

@end
